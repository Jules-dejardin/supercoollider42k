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
	arg freq=220,out=0, amp=(-15),pan=0, atk=0.01, sus=1, rel=0.1, morph=0.1, rate=6, rq=0.1;
	var sig,sig2, env;

	env = EnvGen.kr(Env.asr(atk,sus,rel, -4), doneAction:2);

	sig = SinOsc.ar(freq*(1+((1..7)*morph))).sum;
/*	sig2 = LFSaw.ar(5*(1+((1..10)*0.2))).sum;
	sig2 = LPF.ar(sig, 600);*/

	// 3.do{
	sig = RLPF.ar(sig, LFNoise2.ar(rate).exprange(2000,4000).lag(10),0.5);
//		sig = BPF.ar(sig, (1..8)*100, freq.linlin(3000,30,2,0.001)).sum;
		// sig = (sig*(morph.linlin(0.001,0.03, 0.8,5))).softclip;
		// sig2 = RLPF.ar(sig2, (1..10)*LFNoise2.ar(Rand(0.1,20)).exprange(5,700), Rand(0.001,0.1)).sum;
		// sig2 = (sig2*Rand(0.9,10)).softclip;
// };

	// sig = Limiter.ar(sig);
	// sig = sig + sig2;
	sig = HPF.ar(sig, 7000);
	sig = sig*env*amp.dbamp;
	sig = Pan2.ar(sig,pan);
	Out.ar(out, sig);
}).add;
)

~synthFerme= Synth(\fermement, [\freq,3000,\amp,-40, \morph, 0.0011]);
~synthFerme.set(\amp,-20);
~synthFerme.set(\rate,1);
~synthFerme.set(\morph, 0.001);
// (1+((1..10)*0.1))