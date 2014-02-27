
Reverb1 {
	*ar  {| in |
		var out = in;
		out = AllpassN.ar ( out,0.05, 0.05.rand, 1 );
		^out;
	}
}
