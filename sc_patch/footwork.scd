(
SynthDef(\k, {
	arg out=0, amp=(-5);
	var sig, env;
	sig = SinOsc.ar(Env.perc(0.001, 0.3, curve:-8).ar.linexp(0,1,30,250));
	sig = sig + (SinOsc.ar(Env.perc(0.00,0.01).ar.linexp(0,1,1000,8000),0,1) * Env.perc(0.001,0.01).ar);
	sig = sig *(1 + Env.perc(0.01,0.7).ar);
	sig = sig.tanh;
	env = Env.perc(0.001, 1).ar(Done.freeSelf);
	sig = sig *env *amp.dbamp.lag(3);
	sig = Pan2.ar(sig);
	Out.ar(out,sig);
}).add;

SynthDef(\s, {
	arg out=0, amp=(-5);
	var sig, env;
	sig = SinOsc.ar(Env.perc(0.001, 0.3, curve:-8).ar.linexp(0,1,200,300) * [1, 2.3, 4.6, 7.8]);
	sig = sig * [0, -16, -15, -20].dbamp;
	sig = sig * Env.perc(0,[1,0.3,0.1,0.05]).ar;
	sig = sig.sum;
	env = Env.perc(0.001, 1).ar(Done.freeSelf);
	sig = sig *env *amp.dbamp.lag(3);
	sig = Pan2.ar(sig);
	Out.ar(out,sig);
}).add;

SynthDef(\sn, {
	arg out=0, amp=(-5);
	var sig, env;
	sig = SinOsc.ar(Env.perc(0.001, 0.3, curve:-8).ar.linexp(0,1,200,240) * [1, 2.3, 4.6, 7.8]);
	sig = sig * [0, -16, -15, -20].dbamp;
	sig = sig * Env.perc(0,[1,0.3,0.1,0.05]).ar;
	sig = sig.sum;
	sig = sig + (SinOsc.ar(Env.perc(0.0,0.01).ar.linexp(0,1,3000,6000)) * Env.perc(0.001,0.01).ar);
	sig = sig + (BPF.ar(Hasher.ar(Sweep.ar), 2100,0.1) * Env.perc(0.05,0.08).ar * 10.dbamp);
	sig = sig + (RHPF.ar(Hasher.ar(Sweep.ar), 6400,0.3) * Env.perc(0.02,0.1).ar * -3.dbamp);
	sig = (sig * 1.3).tanh;
	env = Env.perc(0.001, 1).ar(Done.freeSelf);
	sig = sig *env *amp.dbamp.lag(3);
	sig = Pan2.ar(sig);
	Out.ar(out,sig);
}).add;

)

Synth(\k);
Synth(\s);
Synth(\sn);

// faire des patterns
(
// arg lala="banjo";
var s, bpm, beat, tatum, map, pattern, pattern2;

s = Server.default();

bpm = 160;
beat = 60 / bpm;
tatum = beat / 4;

map = Dictionary[
	$k -> \k,
	$s -> \s,
	$n -> \sn,
];

pattern = "
k...k...k..k...k...k..k...k...k..
";
pattern2 = "
n....n..s.n..s.n....n..s.n..s.n..
.....n.......s.n.........n..s....
";

~sn = Routine({
	loop {
	pattern2.do{|character|
		if(character == $.) {
			tatum.wait;
		} {
			if(map[character].notNil) {
					s.bind { Synth(map[character], [\amp, -5]); };
				};
			};
		} ;
	};
}).play;

~k = Routine({
	loop {
	pattern.do{|character|
		if(character == $.) {
			tatum.wait;
		} {
			if(map[character].notNil) {
					s.bind { Synth(map[character], [\amp, -5]); };
				};
			};
		} ;
	};
}).play;
)
