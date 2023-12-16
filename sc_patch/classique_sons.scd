(
SynthDef(\k, {
	arg out=0, amp=(-5);
	var sig, env;
	sig = SinOsc.ar(Env.perc(0.001, 0.3, curve:-8).ar.linexp(0,1,60,500));
	sig = sig + (SinOsc.ar(Env.perc(0.00,0.01).ar.linexp(0,1,1000,8000),0,1) * Env.perc(0.001,0.01).ar);
	sig = sig *(1 + Env.perc(0.01,0.3).ar);
	sig = sig.tanh;
	env = Env.perc(0.001, 1).ar(Done.freeSelf);
	sig = sig *env *amp.dbamp.lag(3);
	sig = Pan2.ar(sig);
	Out.ar(out,sig);
}).add;
)

Synth(\k);

// faire des patterns
