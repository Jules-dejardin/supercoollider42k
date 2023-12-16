(
SynthDef(\hh, {
	arg amp=(-10), out=0, freq=500, tone=7000, rel=0.5, rq=0.3;
	var sig, env;
	env = Env.perc(0.001,rel, curve:[8,-4]).ar(Done.freeSelf);

	sig = Saw.ar([123,150,180,219,240,261]).sum;
	sig = HPF.ar(sig, 400);
	sig = LPF.ar(sig, XLine.ar(10000,410, rel/2));
	sig = BPF.ar(sig, tone.lag(5), 0.07, 1.8);
	sig = (sig *(1+Env.perc(0.01, rel,9, curve:-8).ar)).tanh;
	sig = sig * -10.dbamp;
	sig = RHPF.ar(sig, 3500, rq);
	sig = sig * env * amp.dbamp.lag(5);
	sig = Pan2.ar(sig);
	Out.ar(out,sig);
}).add;
)

~t = Synth(\hh, [\tone,4000, \rq, 0.3, \rel, 0.5, \amp,0]);

~t=Synth(\hh, [\tone, [4000,5000,6000,7000,8000,9000].choose, \rel, [0.1,0.25,0.5].choose, \rq,[0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9].choose, \amp, 0]);
~t.set(\tone, 6000);

Env.perc(2,2, curve:[-4,4]).plot

s.options.sampleRate_(48000);