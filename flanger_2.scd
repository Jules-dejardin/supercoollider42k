s.options.sampleRate_(48000);

(
SynthDef(\radio, {
	arg in=0, out=0, amp=(-15), frate=0.05, pan=0, rate=2, volDel=0.6, rq=0.1, clip=1.01, rateFilt=2, rqBand=0.1;
	var sig, env, flanger, sine;

	sig = SoundIn.ar(in, 1);
	flanger = DelayC.ar(sig, frate.lag(20),frate.lag(5));

	8.do{
		sig = RLPF.ar(sig, LFNoise2.ar(rateFilt.lag(30)).linexp(-1,1,500,3000), rq.lag(10));

		flanger = RHPF.ar(flanger, LFNoise2.ar(rateFilt.lag(15)*0.5).linexp(-1,1,20,3000), rq.lag(50));
		// sig = BPF.ar
		sig = BPF.ar(sig, (0..12).linexp(0,12, 50,5000),rqBand.lag(50), 0.9).sum;
		sig = (sig * clip.lag(10)).softclip;
		flanger = (flanger * clip.lag(50)).softclip;
	};

	 sig = sig + CombC.ar(sig, LFNoise2.ar(rate).linexp(-1,1, 0.4,1), LFNoise2.ar(rate).linexp(-1,1, 0.03,0.3), 5, volDel);
	flanger = flanger + CombL.ar(sig, LFNoise0.ar(rate).linexp(-1,1, 0.8,2), LFNoise2.ar(rate).linexp(-1,1, 0.5,1), 5, volDel+0.2);

	sig = Pan2.ar(sig, pan);
	flanger = Pan2.ar(flanger, SinOsc.ar(0.05));
	sig = Balance2.ar(sig, flanger, 0);
	sig = Limiter.ar(sig);
	sig = sig * amp.dbamp.lag(2);
	Out.ar(out, sig);

}).add;
)

~r = Synth(\radio, [\amp, -25]);
~r.set(\volDel, 0.008);
~r.set(\frate, 0.006);
~r.set(\clip, 0.5);
~r.set(\amp, -10);
~r.set(\rate, 1);
~r.set(\rqBand, 0.8);
~r.set(\rq, 0.9);

s.record;

(
~r = Synth(\radio, [\amp, -5, \volDel, 0.15, \rqBand, 0.1, \frate, 0.0005]);
~rout= Routine{
	inf.do{
		~r.set(\rateFilt, rrand(0.5,2));
		~r.set(\rate, rrand(0.01, 0.4));
		~r.set(\rq, rrand(0.02, 1));
		~r.set(\volDel, rrand(0.05, 0.5));
		// ~r.set(\frate, rrand(0.0005, 0.001));
		rrand(0.5, 10).wait;
	};
};
~rout.play;
)

s.options.device;

