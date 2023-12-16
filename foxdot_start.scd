Quarks.install("FoxDot");

FoxDot.start;

FoxDot.midi;

s.quit;

(
SynthDef(\masupersaw, {
	arg out=0, freq=220, amp=(-6), lpf=5000, detune=20, rq=1;
	var sig, env;

	sig = LFSaw.ar(freq);
	3.do {
		arg i;
		sig = LFSaw.ar(freq+i*detune) + sig;
	};
	sig = BLowPass.ar(sig, lpf*LFTri.kr(0.1).exprange(1, freq/4), rq);
	sig = sig * amp.dbamp;
	sig = Pan2.ar(sig);
	Out.ar(out, sig);
}).add;
)

(
~monsynth = Synth(\masupersaw,[
	\freq:200,
	\lpf:95,
	\rq:0.5,
	\amp:-18,
	\detune:1,
]);
)

~monsynth.set(\detune,10);
~monsynth.set(\lpf, 150);
~monsynth.set(\rq, 1.5);
~monsynth.set(\freq, 90);