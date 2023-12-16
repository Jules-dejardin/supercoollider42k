(
SynthDef(\1, {
	arg freq = 50, rate=2;
	var sig;

	sig = LFSaw.ar(freq * [0.5,0.6,0.7,0.8,0.9,1,2,3,4,6,8,9,16]).sum;
	3.do{
		sig = RLPF.ar(sig, LFNoise2.kr(rate).linexp(-1,1,100,8000), 0.9);
		sig = BPF.ar(sig, (0..12).linexp(0,12, 100,10000),LFNoise2.ar(0.2).linexp(-1,1,0.1,0.3)).sum;
		sig = (sig * LFNoise1.kr(0.2).linlin(-1,1,1,3)).softclip;
	};
	// sig = Limiter.ar(sig);
	sig = sig * Env.asr(0.01,1,0.1).ar(Done.freeSelf);
	sig = sig * \amp.kr(-15.dbamp);
	sig = LPF.ar(sig, 12000);
	sig = Pan2.ar(sig);
	Out.ar(0, sig);
}).add;
)

~z= Synth(\1);
~z.set(\freq,1000);

(
~play1 = Routine{
	~z.set(\freq, rrand(10,1000).asStream);
		rrand(0.1,0.6).wait;
};
	~play1.play;
)

~play1.stop;
~z.set(\freq, 666);



(
~s = Routine{

	inf.do{
		Synth(\, [\freq,rrand(20,800), \rate, rrand(0.1,10)]);
		rrand(0.1,0.4).wait;
	};

};
~s.play;
)

~s
~s.set(\freq, 90);
~s.set(\rate, 5);