(
SynthDef(\, {
	arg freq = 50, rate=2, amp=(-15), clip=1.1, atk=0.001, witch=0;
	var sig, sig2, env;

	env = Select.ar(witch, [Env.perc(atk,1).ar(Done.freeSelf), EnvGen.ar(Env.new([0,1,1,0], [0.5,1,0.5], [4,-4]), doneAction:2)]);

	sig = Saw.ar(freq.lag(5) * [1,2,3,4,5,6,7,8]).sum;
	sig2 = SinOsc.ar(freq.lag(5) * (1+((1..10)*0.0012))).sum;
	sig = sig +sig2;

	5.do{
		sig = RLPF.ar(sig, LFNoise2.kr(rate).linexp(-1,1,20,800).lag(Rand(5,50)), Rand(0.01,0.3).lag(0.01));
		sig = BPF.ar(sig, (0..8).linexp(0,8, 50,800),Rand(0.1,0.9).lag(5)).sum;
		sig = (sig * clip.lag(10)*0.9).softclip;
	};

	// sig = Limiter.ar(sig);
	 sig = sig + CombL.ar(sig, LFNoise1.ar(10).linexp(-1,1,0.01,0.9),LFNoise1.ar(0.5).linexp(-1,1,0.01,0.8),10);
	sig = sig * env* amp.dbamp.lag(5);
	sig = Pan2.ar(sig, 0);
	Out.ar(0, sig);
}).add;
)
//s.boot;
(
~s = Routine{

	inf.do{
		~drone = Synth(\, [\witch, 1,\atk, 1, \freq,50, \amp,-15,\clip, 0.9]);
		4.do{
		~x = Synth(\, [
			\witch, 1,
				// \freq,rrand(20,100),
				// \rate, rrand(10,100),
			\clip, rrand(0.5,2),
			\atk, rrand(0.001,0.3),
		]);
			rrand(0.1,0.3).wait;
		};
		rrand(0.3,0.8).wait;
	};

};
~s.play;
)
~s.stop;

BufRd
LFNoise1.kr(1).log;

~drone = Synth(\, [\witch, 1, \freq,50, \amp,-15,\clip, 0.9]);

~drone.set(\rate,1);
~drone.set(\freq, 5000);
~drone.set(\clip, 0.8);