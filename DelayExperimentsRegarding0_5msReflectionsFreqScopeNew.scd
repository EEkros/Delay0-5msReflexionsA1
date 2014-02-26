{ Blip.ar(XLine.kr(20000,200,6),100,0.2) }.scope(1);
{ Blip.ar(XLine.kr(100,15000,6),100,0.2) }.scope(1); // no aliasing
// modulate number of harmonics
{ Blip.ar(200,Line.kr(1,100,20),0.2) }.scope(1);

FreqScope.new;

Window.new

	Server.default = Server.internal;
	s = Server.default;
	s.boot;


(
  SynthDef ( "dreyblattcord", { arg freq = 440;
	var osc;
	osc = SinOsc.ar ( freq, 0, 0.1 ); // 800 Hz sine oscillator
	Out.ar ( 0, osc ); // send output to audio bus zero.
}).add;
)

	s.scope; // scope so you can see the effect
	x = Synth.new("dreyblattcord");
	x.set("freq", 660);
	x.set("freq", 880, "out", 1);
	x.free;
(
SynthDef ( "example8", { arg out = 0, freq = 440, amp, dur, pan = 0;
	var pm, modulator, env, panner;

	modulator = SinOsc.ar ( 50, 0, 0.2 );
	pm = SinOsc.ar ( freq, modulator );
	env = EnvGen.kr ( Env.perc ( 0.01, dur, amp ),doneAction:2 );
	panner = Pan2.ar ( pm, pan, env );
	Out.ar ( out, panner );
	//Out.ar ( out, pm );

}).add;
)

	x = Synth.new ( "example8");
	x.set ("freq", 660 );


~decoder = FoaDecoderKernel.newSpherical;


(
// use input amplitude to control SinOsc frequency - use headphones to prevent feedback.
z = SynthDef("help-AmplitudeMod",{ arg out=0, attack=0.01, release=0.01;
    Out.ar(out,
        SinOsc.ar(
            AmplitudeMod.kr(
                    SoundIn.ar,
                    attack,
                    release,
                    1200,
                    400)
            , 0, 0.3)
    )
}).play;

)
z.set(\attack, 0.050)
z.set(\release, 0.125)

z.free

(
// use input amplitude to control Pulse amplitude - use headphones to prevent feedback.
SynthDef("help-AmplitudeMod",{ arg out=0;
    Out.ar(out,
        Pulse.ar(90, 0.3, Amplitude.kr(SoundIn.ar))
    )
}).play;

)

{ CombN.ar(WhiteNoise.ar(0.01), 0.01, XLine.kr(0.0001, 0.01, 20), 0.2) }.play;

{ CombL.ar(WhiteNoise.ar(0.01), 0.01, XLine.kr(0.0001, 0.01, 20), 0.2) }.play;

{ CombC.ar(WhiteNoise.ar(0.01), 0.01, XLine.kr(0.0001, 0.01, 20), 0.2) }.play;

// with negative feedback:
{ CombN.ar(WhiteNoise.ar(0.01), 0.01, XLine.kr(0.0001, 0.01, 20), -0.2) }.play;

{ CombL.ar(WhiteNoise.ar(0.01), 0.01, XLine.kr(0.0001, 0.01, 20), -0.2) }.play;

{ CombC.ar(WhiteNoise.ar(0.01), 0.01, XLine.kr(0.0001, 0.01, 20), -0.2) }.play;

{ CombC.ar(Decay.ar(Dust.ar(1,0.5), 0.2, WhiteNoise.ar), 0.2, 0.2, 3) }.play;

(
{
var signal;
var phase = MouseX.kr(0.000022675,0.01); // from a sample to 10 ms delay line
var ph;

signal = WhiteNoise.ar(0.1);
// signal = SinOsc.ar(444,0,0.5);
//signal = PlayBuf.ar(1, e.bufnum, BufRateScale.kr(e.bufnum), loop:1);
ph = AllpassL.ar ( WhiteNoise.ar(0.1) , 4, phase, 0);

 (signal + ph).dup

}.play
)

(
{
var signal;
var phase = MouseX.kr(0.000022675,0.01); // from a sample to 10 ms delay line
var ph;

signal = WhiteNoise.ar(0.1);
// signal = SinOsc.ar(444,0,0.5);
//signal = PlayBuf.ar(1, e.bufnum, BufRateScale.kr(e.bufnum), loop:1);
ph = AllpassL.ar ( WhiteNoise.ar(0.1) , 4, phase, 0);

 (signal + ph).dup

}.play
)



(
{
var signal;
var ph;
e = Buffer.read(s, "sounds/a11wlk01.wav");
// base signal
signal = PlayBuf.ar(1, e.bufnum, BufRateScale.kr(e.bufnum), loop:1);
// phased signal
ph = AllpassC.ar(
		PlayBuf.ar(1, e.bufnum, BufRateScale.kr(e.bufnum), loop:1),
		4,
		LFPar.kr(0.1, 0, 1).range(0.000022675,0.01), // a circle every 10 seconds
		0); // experiment with what happens if you increase the decay length

 (signal + ph).dup // we add them together and route to two speakers
}.play
)

(
d = Buffer.read(s,"sounds/digireedoo.aif");
e = Buffer.read(s,"sounds/holeMONO.aif");
e = Buffer.read(s, "sounds/a11wlk01.wav"); // this one is in SC sounds folder
)

(
{
var signal;
var delaytime = MouseX.kr(0.001,0.2, 1);
signal = Impulse.ar(1); // the sound source

d =  DelayL.ar(signal, 0.6, delaytime);

[d, signal]
}.play
)

// now what happens if we add two signals where one has a short delay ( < 10 ms)
// - we get a lowpass filter.
// NOTE: 0.000022675 is roughly the same as 1/44100 or 44100.reciprocal
(
{
var signal;
var delaytime = MouseX.kr(0.000022675, 0.01); // from a sample to 10 ms

signal = PlayBuf.ar(1, e.bufnum, BufRateScale.kr(e.bufnum), loop:1);
d =  DelayN.ar(signal, 0.6, delaytime); // try replacing with CombN (with 0 decayTime)

// (signal + d).dup
[d, signal]
}.play
)

// We have replaced DelayN with CombN and use mouseY for decayTime ( < 10 ms)
(
{
var signal;
var delaytime = MouseX.kr(0.00022675,0.01, 1); // NOTE: sample is too short here - it explodes!

signal = PlayBuf.ar(1, e.bufnum, BufRateScale.kr(e.bufnum), loop:1);
d =  CombC.ar(signal, 0.6, delaytime, MouseY.kr(0.001,1, 1));

(signal + d).dup
}.play
)

(
{
var signal;
var delaytime = MouseX.kr(0.1,0.4, 1);
signal = Impulse.ar(1);

// delaying the impulse with 4 delays
d =  DelayL.ar(signal, 0.6, delaytime);
e =  DelayL.ar(signal, 0.6, delaytime*1.1);
f =  DelayL.ar(signal, 0.6, delaytime*1.2);
g =  DelayL.ar(signal, 0.6, delaytime*1.3);

(d+e+f+g).dup
}.play
)

// karplus gone really wrong - no decay, just a line of 10 delays
(
{
var signal;
var delaytime = MouseX.kr(0.01,2, 1);
signal = Impulse.ar(MouseY.kr(0.5, 2));

a = Mix.fill(10, {arg i; DelayL.ar(signal, 2, delaytime*(i/10+1));});
a.dup

}.play
)

// Comb and Allpass have decaytime arguments
// the old Karplus-Strong
(
{
var signal;
var delaytime = MouseX.kr(0.001,0.2, 1);
var decaytime = MouseY.kr(0.1,2, 1);

signal = Impulse.ar(1);

d =  CombL.ar(signal, 0.6, delaytime, decaytime);

d!2
}.play(s)
)

// compare the Comb and the Allpass

(
{ // use the mouse !!!
var signal;
var delaytime = MouseX.kr(0.001,0.2, 1);
var decaytime = MouseY.kr(0.1,2, 1);

signal = Impulse.ar(1);

d =  AllpassC.ar(signal, 0.6, delaytime, decaytime);

d!2
}.play
)
// and we add the good old Decay with WhiteNoise as the source
(
{ // use the mouse !!!
var signal;
var delaytime = MouseX.kr(0.001,0.2, 1);
var decaytime = MouseY.kr(0.1,2, 1);

signal = Decay.ar(Impulse.ar(1), 0.3, WhiteNoise.ar * 0.3, 0);

d =  CombL.ar(signal, 0.6, delaytime, decaytime);

d!2
}.play(s)
)


f = Buffer.read(s, "sounds/a11wlk01.wav");

// try out the following different delays (uncomment)
// the signals are not added (the dry and wet)
(
{
var signal;
var delaytime = MouseX.kr(0.01,0.05); // between 10 and 50 ms.
signal = PlayBuf.ar(1, f.bufnum, BufRateScale.kr(f.bufnum), loop:1);

// compare DelayL, CombL and AllpassL

//d =  DelayL.ar(signal, 0.6, delaytime);
//d = CombL.ar(signal, 0.6, delaytime, MouseY.kr(1,4));
d =  AllpassL.ar(signal, 0.6, delaytime, MouseY.kr(1,4));

[signal, d] // dry signal in left channel, delay in the right
}.play(s)
)

(
{
var signal;
var delaytime = MouseX.kr(0.01,0.05); // between 10 and 50 ms.
signal = PlayBuf.ar(1, f.bufnum, BufRateScale.kr(f.bufnum), loop:1);

// compare DelayL, CombL and AllpassL

//d =  DelayL.ar(signal, 0.6, delaytime);
//d = CombL.ar(signal, 0.6, delaytime, MouseY.kr(0.001,4));
d =  AllpassL.ar(signal, 0.6, delaytime, MouseY.kr(0.001,4));

(signal+d).dup
}.play(s)
)

//
Server.default = s = Server.internal
FreqScope.new;
{CombL.ar(Impulse.ar(10), 6, 1, 1)}.play(s)



(
{
var signal;
var delaytime = MouseX.kr(0.01,6, 1);
var decaytime = MouseY.kr(1,2, 1);

signal = Impulse.ar(1);

d =  CombL.ar(signal, 6, delaytime, decaytime);

d!2
}.play(s)
)

// we can see the Comb effect by plotting the signal.

(
{
a = Impulse.ar(1);
d =  CombL.ar(a, 1, 0.001, 0.9);
d
}.plot(0.1)
)
//-------------------------------------------
FreqScope.new;
e = Buffer.read(s, "sounds/a11wlk01.wav");
(
{
var signal;
var delaytime = MouseX.kr(0.000022675, 0.01); // from a sample to 10 ms

signal = PlayBuf.ar(1, e.bufnum, BufRateScale.kr(e.bufnum), loop:1);
d =  DelayN.ar(signal, 0.6, delaytime); // try replacing with CombN (with 0 decayTime)

(signal + d).dup
}.play
)

------------------------------------------
------------------------------------------
FreqScope.new;
(
{
var signal;
// var delaytime = MouseX.kr(0.000022675, 0.01); // from a sample to 10 ms
var delaytime = MouseX.kr(0.0000, 0.01); // from a sample to 10 ms

signal = WhiteNoise.ar ( 0.05 );
d =  DelayC.ar(signal, 0.6, delaytime); // try replacing with CombN (with 0 decayTime)

(signal + d).dup
}.play
)
-----------------------------------------
(
{
var signal;
// var delaytime = MouseX.kr(0.000022675, 0.01); // from a sample to 10 ms
var delaytime = MouseX.kr(0.0000, 0.004); // from a sample to 10 ms

signal = WhiteNoise.ar ( 0.05 );
d =  DelayC.ar(signal, 0.6, delaytime); // try replacing with CombN (with 0 decayTime)

	[signal, d]
}.play
)


---------------------------------------------
---------------------------------------------
(
{
var signal;
// var delaytime = MouseX.kr(0.000022675, 0.05); // from a sample to 10 ms
var delaytime = MouseX.kr(0.0000, 0.09); // from a sample to 10 ms

signal = PlayBuf.ar(1, e.bufnum, BufRateScale.kr(e.bufnum), loop:1);
d =  DelayN.ar(signal, 0.6, delaytime); // try replacing with CombN (with 0 decayTime)

(signal + d).dup
}.play
)
-------------------
(
{
var signal;
// var delaytime = MouseX.kr(0.000022675, 0.05); // from a sample to 10 ms
var delaytime = MouseX.kr(0.0000, 0.01); // from a sample to 10 ms

signal = PlayBuf.ar(1, e.bufnum, BufRateScale.kr(e.bufnum), loop:1);
d =  DelayN.ar(signal, 0.6, delaytime); // try replacing with CombN (with 0 decayTime)

(signal + d).dup
}.play
)

--------------------------------------------


(
{
var signal,dd;
// var delaytime = MouseX.kr(0.000022675, 0.05); // from a sample to 10 ms
var delaytime = MouseX.kr(0.0000, 0.09); // from a sample to 10 ms

signal = PlayBuf.ar(1, e.bufnum, BufRateScale.kr(e.bufnum), loop:1);
d =  DelayN.ar(signal, 0.6, delaytime); // try replacing with CombN (with 0 decayTime)
dd = d + DelayN.ar ( dd, 0.6, delaytime);

	[signal,  d ]
}.play
)

(
{
var signal,dd,
	signal2, d2;
// var delaytime = MouseX.kr(0.000022675, 0.05); // from a sample to 10 ms
var delaytime = MouseX.kr(0.0000, 0.09); // from a sample to 10 ms

signal = PlayBuf.ar(1, e.bufnum, BufRateScale.kr(e.bufnum), loop:1);
d =  DelayC.ar(signal, 0.6, delaytime); // try replacing with CombN (with 0 decayTime)
dd = DelayC.ar ( d, 0.6, delaytime);
 signal2 = signal+d;
 d2 = d+dd;
    (signal + signal2  + d2).dup
//	[signal2 ,  d2 ]
}.play
)

// titta jag kan cyckla utan huvud
// titta jag kan cyckla utan huvud



(
{
var signal,dd,
	signal2, d2;
// var delaytime = MouseX.kr(0.000022675, 0.05); // from a sample to 10 ms
var delaytime = MouseX.kr(0.0000, 0.09); // from a sample to 10 ms

signal = PlayBuf.ar(1, e.bufnum, BufRateScale.kr(e.bufnum), loop:1);
d =  DelayC.ar(signal, 0.6, delaytime); // try replacing with CombN (with 0 decayTime)
dd = DelayC.ar ( d, 0.6, delaytime);
 signal2 = signal+d;
 d2 = d+dd;

	[signal2 ,  d2 ]
}.play
)







	