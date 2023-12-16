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
	arg freq=220,out=0, amp=(-15),pan=0, atk=0.01, sus=1, rel=0.1, morph=0.2, rqBand=0.1;
	var sig,sig2, env, numBands;

	numBands = 15;
	env = EnvGen.kr(Env.asr(atk,sus,rel, -4), doneAction:2);

	sig = Saw.ar(freq*(1+((1..3)*1))).sum;
	sig =sig + SinOsc.ar(freq*(1+((1..6)*LFNoise1.ar(2).linexp(-1,1,0.001,0.1)))).sum;


	3.do{
		sig = BPF.ar(sig, (0..numBands - 1).linexp(0,numBands - 1, 200, 8000),rqBand).sum;
		sig = (sig*LFNoise1.ar(0.2).linexp(-1,1,0.99,2.22)).softclip;
	};

	// sig = Limiter.ar(sig);
	// sig = sig + sig2;
	sig = LPF.ar(sig, 5000);
	sig = sig*env*amp.dbamp;
	sig = Pan2.ar(sig,pan);
	Out.ar(out, sig);
}).add;
)

~synthFerme= Synth(\fermement, [\freq,555,\amp,-10, \rqBand,0.05]);
~synthFerme.set(\amp,-3);
~synthFerme.set(\freq,0.6);
~synthFerme.set(\rqBand, 0.01);
// (1+((1..10)*0.1))