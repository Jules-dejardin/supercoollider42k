s.options.sampleRate_(48000);
MIDIClient.init;

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
	arg freq=220,out=0, amp=(-15),pan=0, atk=0.01, sus=1, rel=0.1, morph=0.1, rate=1, rq=0.1;
	var sig,sig2, env;

	env = EnvGen.kr(Env.asr(atk,sus,rel, -4), doneAction:2);

	sig = SinOsc.ar(freq*(1+((1..7)*morph)), SinOsc.ar(0.1).exprange(0.1,1)).sum;
	sig2 = LFSaw.ar(5*(1+((1..10)*0.2))).sum;
	sig2 = LPF.ar(sig, 600);

	5.do{
		sig = RLPF.ar(sig, (1..10)*LFNoise2.ar(rate).exprange(200,8000), morph.linlin(0.001,0.03,1,0.1).lag(1));
		sig = (sig*(morph.linlin(0.001,0.03, 0.8,10))).softclip;
		sig2 = RLPF.ar(sig2, (1..10)*LFNoise2.ar(Rand(0.1,20)).exprange(5,700), Rand(0.001,0.1)).sum;
		sig2 = (sig2*Rand(0.9,10)).softclip;
	};

	// sig = Limiter.ar(sig);
	sig = sig + sig2;
	sig = HPF.ar(sig, morph.linlin(0.001,0.03,7000,0).round(1).lag(5));
	sig = sig*env*amp.dbamp;
	sig = Pan2.ar(sig,pan);
	Out.ar(out, sig);
}).add;
)

~synthFerme= Synth(\fermement, [\freq,220,\amp,-30]);
~synthFerme.set(\amp,-15);
~synthFerme.set(\rate,15oo);
~synthFerme.set(\rq,0.9);
(1+((1..10)*0.1))