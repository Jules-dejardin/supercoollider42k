s.options.sampleRate_(48000);
MIDIClient.init;

//ca crack :'(

(
MIDIFunc.cc({
	arg val, ccNum, channel;
	//ccNum.postln;

	if(ccNum == 77, {
		~tweak = val.linlin(0, 127, 30, 3000).round(1).lag(10);
		~synthFerme.set(\freq, ~tweak);
		"var freq".postln;
		~tweak.postln;
	});

		if(ccNum == 78, {
		~morph = val.linlin(0, 127,0.001,0.03).round(0.001).lag(10);
		~synthFerme.set(\morph, ~morph);
		"morph".postln;
		~morph.postln;
	});
	if(ccNum == 79, {
		~filt = val.linlin(0, 127,0,5000).round(10).lag(100);
		~synthFerme.set(\hpf, ~filt);
		"hpf".postln;
		~filt.postln;
	});
	});
)

(
SynthDef(\fermement,{
	arg freq=220,out=0, amp=(-15),pan=0, atk=0.01, sus=1, rel=0.1, morph=0.2, rate=6, rq=0.1;
	var sig,sig2, env;

	env = EnvGen.kr(Env.asr(atk,sus,rel, -4), doneAction:2);

	sig = Saw.ar(freq.lag(10)*(1+((1..3)*LFNoise2.ar(0.5).linexp(-1,1,0.005,0.02)))).sum;

	3.do{
		sig = RLPF.ar(sig, (1..8)*LFNoise2.ar(0.2).linexp(-1,1,200,8000), Rand(0.01,0.4).lag(5));
		sig = (sig * 1.01).wrap2;
	};
	sig = Limiter.ar(sig);
	// sig = sig + sig2;
	sig = LPF.ar(sig, 10000);
	sig = sig*env*amp.dbamp;
	sig = Pan2.ar(sig,pan);
	Out.ar(out, sig);
}).add;
)

~synthFerme.free;
~synthFerme= Synth(\fermement, [\freq,20,\amp,-20]);
~synthFerme.set(\amp,-20);
~synthFerme.set(\freq,0.3);
~synthFerme.set(\morph, 0.04);
// (1+((1..10)*0.1))