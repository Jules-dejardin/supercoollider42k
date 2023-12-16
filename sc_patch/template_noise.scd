s.options.sampleRate_(48000);


(
SynthDef(\n, {
	arg freq=220, amp=(-20), out=0, mult=0.5, rate=1, rq=0.2, clip=1.01, rqBand=0.1, delRate=0.3;
	var sig, env, tri, bpf, numBands;

	numBands = 12;
	env = EnvGen.kr(Env.new([0,1], [5],-4));
	 tri = LFTri.ar(freq + (freq *(1..4)*0.5)).sum;
	freq = freq * (1+(0..8)*mult.lag(5));
	sig = Saw.ar(freq.lag(10)).sum;
	 sig = sig + tri;

	6.do{
		sig = RLPF.ar(sig, LFNoise1.kr(rate.lag(5)).linexp(-1,1,150,8000), rq.lag(5));
		sig=(sig*clip.lag(5)).softclip;
	};

	bpf = BPF.ar(sig, (0..numBands - 1).linexp(0,numBands - 1, 200, 8000),rqBand.lag(5)).sum;
	sig = CombL.ar(sig,3, LFNoise2.kr(delRate.lag(2)).linexp(-1,1,0.01,0.4), 3, LFNoise2.kr(0.1).linexp(-1,1,0.2,1));

	sig = Pan2.ar(sig, LFNoise2.kr(0.2));
	bpf = Pan2.ar(bpf,0);
	sig = sig + bpf;
	sig = Limiter.ar(sig);
	sig = sig * env * amp.dbamp.lag(3);
	Out.ar(out,sig);
	}).add;
)

~play = Synth(\n, [\amp, -15, \freq,150]);

~play.set(\clip, 1.5);

~play.set(\amp, -5);

(
~rout.stop;
~rout = Routine{
	inf.do{
		~play.set(\freq, rrand(300,500));
		~play.set(\mult, rrand(0.3,0.9));
		~play.set(\rq, rrand(0.001, 0.6));
		~play.set(\clip, rrand(0.91, 1.1));
		// ~play.set(\delRate, rrand(0.01,0.5));
		~play.set(\rqBand, rrand(0.001, 0.4));
		~play.set(\rate, rrand(0.5,5));
		rrand(0.5,2 ).wait;
	};
} ;
~rout.play;
)
~play.set(\mult, 0.3);
~play.set(\rq, 0.5);
~play.set(\delRate, 9);
~play.set(\rate, 50);

(
SynthDef(\noise, {
	arg freq=220, out=0, amp=(-15),pan=0, rq=0.1, mult=0.5, rate=5, clip=1.01, rqBand=0.2;
	var sig, env, numBands, sub;

	numBands = 15;
	env = Env.asr(5,1,1,-5).ar(Done.freeSelf);

	sub = SinOsc.ar((freq.lag(5))*(1+(1..12)*0.4)).sum;
	sub = RLPF.ar(sub, freq/2, 0.6, 0.7);
	freq = freq+((0..8)*mult);
	sig = Saw.ar(freq.lag(10)).sum;

	5.do{
		sig = RLPF.ar(sig, LFNoise0.kr(rate.lag(5)).linexp(-1,1,200,8000), rq.lag(10), 0.9);
		sub = (sub*(clip.lag(2)/2)).wrap2;
		sig = (sig*clip.lag(5)).softclip;
	};

	sig = BPF.ar(sig, (0..numBands - 1).linexp(0,numBands - 1, 200, 5000),rqBand.lag(5)).sum;
	pan = Pan2.ar(CombL.ar(sig, LFNoise0.ar(2).linexp(-1,1,0.001,0.1), LFNoise1.ar(20).linexp(-1,1,0.01,0.5), 10), LFNoise2.ar(0.5));
	sig = sig + sub + pan;
	sig = Limiter.ar(sig);
	sig = sig*env*amp.dbamp.lag(2);
	sig = Pan2.ar(sig,pan);
	Out.ar(out, sig);
}).add;
)

~x = Synth(\noise, [\mult,50, \freq, 120, \amp, -10, \rate,0.8, \rq,0.003, \rqBand, 0.005]);
~x.set(\rqBand, 0.6);
~x.set(\rq, 0.05);
~x.set(\rate, 1);

(
~route = Routine{
	10.do{
		~x.set(\mult, rrand(0.5,200));
		~x.set(\rate, rrand(0.8, 10));
		~x.set(\clip, rrand(1, 3));
		~x.set(\rq, rrand(0.001, 0.3));
		~x.set(\rqBand, rrand(0.001, 0.5));
		~x.set(\freq, rrand(50,800));
		rrand(0.2, 0.8).wait;
	};
};
~route.play;
)

~x.set
{Env.asr(5, 1, 0.2,-4).kr(Done.freeSelf)}.plot(5);

Line