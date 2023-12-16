(
SynthDef(\gabberkick, {
	arg bend=(-4), freq=60, ffreq=1000;
    var sig, high, lfo, env, freqValue;

	env = (Env.perc(0.001, 0.08, curve: -1).ar * 48 * \bend.kr(1)).midiratio; //enveloppe de variation de la hauteur
	freqValue = freq.kr(440) * env;
	sig = LFSaw.ar(freqValue);

	sig = (sig * 100).tanh + ((sig.sign - sig) * -8.dbamp);
    high = HPF.ar(sig, 300);
    lfo = SinOsc.ar(8, [0, 0.5pi]).range(0, 0.01);
    high = high.dup(2) + (DelayC.ar(high, 0.01, lfo) * -2.dbamp);
    sig = LPF.ar(sig, 100).dup(2) + high;
    sig = RLPF.ar(sig, 7000, 2);
    sig = BPeakEQ.ar(sig, \ffreq.kr(3000) * XLine.kr(1, 0.8, 0.3), 0.5, 15);
    sig = sig * Env.asr(0.001, 1, 0.05).ar(2, \gate.kr(1));
    Out.ar(\out.kr(0), snd * \amp.kr(0.1));
}).add;
)

(
var durations;
durations = [1, 1, 1, 1, 3/4, 1/4, 1/2, 3/4, 1/4, 1/2];
~pattern = Pbind(
	\instrument,\gabberkick,
	\dur,0.2,
	\freq, 60,
	\ffreq, Pseq((0..(durations.size * 4 - 1)).normalize, inf).linexp(0, 1, 100, 2000),
	\legato,1,
).play;
)