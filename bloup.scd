s.options.sampleRate_(48000);

(
SynthDef(\, {
	arg freq=220, amp=(-15), panRate=1, out=0, atk=0.001, rate=3, rq = 0.3, sat=1, dur=25, tr=0, in=0, harmo=0.3;
	var sig, env, pan, evolve, ev,dry;


	env = EnvGen.kr(Env.perc(atk,1,curve:(-4)),doneAction:2);

	dry = SoundIn.ar(in,2);
	sig = SoundIn.ar(in,2);
	/*evolve = LFNoise1.ar(0.7).linlin(-1,1,0.01,0.5);
	ev = Select.kr(Trig.ar(tr, dur),[freq, XLine.ar(1, freq,dur)]);

	sig = LFSaw.ar(ev * [0.51,1,3,5]).sum;
	sig = sig + (SinOsc.ar(ev * [0.5,1*evolve,3*evolve,5*evolve]).sum);*/
	5.do{
		sig = RLPF.ar(sig, LFNoise2.ar(rate).linlin(-1,1,200,8000),rq);
		sig = BPF.ar(sig, (0..10).linexp(0,10, 200,8000),harmo).sum;
		sig = (sig*LFNoise2.kr(sat).linlin(-1,1,1.001,1.01)).fold2;
	};


	// sig = Limiter.ar(sig);
	sig = sig * env * amp.dbamp;
	sig = LPF.ar(sig, 8000);
	sig = CombL.ar(sig,
		LFNoise2.kr(0.3).exprange(0.05,0.999),
		LFNoise2.kr(0.3).exprange(0.1,0.99),
		1);
	sig = Limiter.ar(sig);
	// sig = GVerb.ar(sig, 1, 0.3, 0.2, spread:5, maxroomsize:10);
	sig = Pan2.ar(sig, LFNoise2.ar(panRate));
	// sig = XFade2.ar(Pan2.ar(dry*amp.dbamp), Pan2.ar(sig),0.6);
	Out.ar(out,sig);
}).add;
)

~p = Synth(\);
~p.set(\tr,1);
~p.set(\panRate, 50);
~p.set(\sat, 5);
~p.set(\freq,1);
~p.set(\dur,10);

(
~play = Routine{
	inf.do{
		~p = Synth(\, [\rate, rrand(1,10)]);
	rrand(0.3,1).wait;
};
};
	~play.play;
)

~max=100;
(1..~max)/~max;