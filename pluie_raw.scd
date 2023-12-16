(
~r.stop;
~r = Routine{
	inf.do{
		{(SinOsc.ar(XLine.kr(Rand(1000,6000),10,0.2), mul:0.4)!2)*Env.perc(0.001,0.01,curve:(-4)).ar(Done.freeSelf)}.play;
		rrand(0.01,0.2).wait;
	};
};
~r.play;
)

// c'est la pluie !
{(SinOsc.ar(XLine.kr(Rand(1000,5000),10,0.4), mul:0.4)!2)*Env.perc(0.001,0.01,curve:(-4)).ar(Done.freeSelf)}.play
