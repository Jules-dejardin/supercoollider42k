s.options.sampleRate_(48000);


(
SynthDef(\n, {
	arg freq=220, amp=(-20), out=0, mult=0.5, rate=1, rq=0.2, clip=1.01, rqBand=0.1, delRate=0.3;
	var sig, env, tri, bpf, numBands;

	numBands = 12;
	env = EnvGen.kr(Env.new([0,1], [5],-4));
	 tri = LFTri.ar(freq + (freq *(1..4)*0.7), 0.2, 0.7).sum;
	freq = freq * (1+(0..8)*mult.lag(5));
	sig = Saw.ar(freq.lag(10), 0.7).sum;
	 sig = sig + tri;

	3.do{
		sig = RLPF.ar(sig, LFNoise2.kr(rate.lag(5)).linexp(-1,1,200,6000), rq.lag(1));
		sig=(sig*clip.lag(5)).softclip;
	};

	bpf = BPF.ar(sig, (0..numBands - 1).linexp(0,numBands - 1, 200, 8000),rqBand.lag(5),0.7).sum;
	sig = CombL.ar(sig,2, LFNoise2.kr(delRate.lag(2)).linexp(-1,1,0.001,0.4), 3, LFNoise2.kr(0.1).linexp(-1,1,0.2,1));

	sig = Pan2.ar(sig, LFNoise2.kr(0.2));
	bpf = Pan2.ar(bpf,0);
	sig = sig + bpf;
	sig = Limiter.ar(sig);
	sig = sig * env * amp.dbamp.lag(3);
	Out.ar(out,sig);
	}).add;
)

~play = Synth(\n, [\amp, -5, \freq,150]);

~play.set(\clip, 1.5);

~play.set(\rate,15);
~play.set(\amp, -5);

(
~rout.stop;
~rout = Routine{
	inf.do{
		~play.set(\freq, rrand(0.1,60));
		~play.set(\mult, rrand(0.6,1.2));
		~play.set(\rq, rrand(0.003, 0.9));
		~play.set(\clip, rrand(0.91, 1.51));
		~play.set(\delRate, rrand(0.1,0.5));
		~play.set(\rqBand, rrand(0.001, 0.6));
		// ~play.set(\rate, rrand(0.5,5));
		rrand(0.5,2 ).wait;
	};
} ;
~rout.play;
)