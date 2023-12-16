(
SynthDef(\half, {
	arg freq=50, amp=(-10), out=0, pan=0, multi=0.5, witch=0;
	var sig, env;
	// env= EnvGen.ar(Env.asr(0.1, 1, 0.2, -4), doneAction:2);
	env = Env.asr(0.1, 1, 0.2, -4).ar(Done.freeSelf);
	// freq = freq+((1..8)*multi.lag(10));
	sig = Saw.ar(freq.lag(10)+((0..8)*multi.lag(10)));

	sig = sig * env * amp.dbamp.lag(2);
	sig = Pan2.ar(sig,pan);
	Out.ar(out, sig);
}).add;
)

s.quit;

~x = Synth(\half, [\amp, -20, \freq, 100]);
~x.set(\freq, 500);
~x.set(\multi, 50);
~x.set(\witch, 1);
~x.set(\amp, -15);

50 + ((0..8)*30)