s.boot; // ou ctrl + b

s.options.sampleRate_(48000); // d'autres s.options sont disponible pour le choix de la carte son par exemple
s.options.outDevice_("maSuperCarteSon");
 ServerOptions.outDevices; //pour lister tous les devices
s.options.numInputBusChannels_(2); // changer le nombre de cannaux d'entré
s.plotTree; // ou ctrl + alt + t
s.meter; // ou ctrl + m
s.freqscope; // ou ctrl + alt + m
// racourci doc pour chaque éléments = Ctrl + D
//evaluation block de code : Ctrl + Enter
//evaluation d'une ligne de code : Maj + Enter
///////////////////////////////
// ctrl + maj + .  || coupe le son///
//////////////////////////////
/*
Dans le lien ci-dessous vous trouverez une liste des UGen générant du son (Sine, Saw, Sqrt,...)
mais aussi des filtres, des saturations, delay...
https://doc.sccode.org/Guides/Tour_of_UGens.html

un lien aussi vers le prof qui m'a appris beaucoup :
--------------------------------
https://www.youtube.com/watch?v=yRzsOOiJ_p4&list=PLPYzvS8A_rTaNDweXe6PX4CXSGq4iEWYC&ab_channel=EliFieldsteel
--------------------------------
*/

(
SynthDef(\sine, {
	arg freq=440, out=0, amp=0.6, atk=0.01, rel=1, panRate=0.5; //variables controlables de l'extérieur
	var sig, env, pan; //variables internes

	env = EnvGen.kr(Env.new([0,1,0],[atk,rel],[-4, 4]), doneAction:2); // enveloppe

	sig = SinOsc.ar(freq); //synthèse
	sig = sig + CombL.ar(sig, 1.5, 0.2,5, 1/3) ; // delay
	sig = FreeVerb.ar(sig, 0.3, 0.5, 0.8); // reverb

	sig = sig * amp * env ; //gestion du volume
	pan = SinOsc.kr(panRate); //panning auto, une sine va déjà de 1 à -1,
	// pan = LFNoise1.kr(panRate).bipolar(1); // possibilité de le faire plus finement comme ceci
	sig = Pan2.ar(sig, pan);

	Out.ar(out, sig); //sortie
}).add;
)

(
~play = Synth(\sine, [
	\freq, 500,
	\amp, 0.4,
	\rel, 2,
	\atk, 0.006,
	\panRate,0.7
]);
)
~play.free;

(
~patern = Pbind(
	\instrument, \sine,
	\freq, Pseq([Pwhite(220, 800, 1),Pwhite(120, 200,1)], inf),
	\dur, Pwhite(1/16, 1/4, inf),
	\atk, 0.06,
	\rel, Pwhite(1/16,1, inf),
).play;
)

~patern.stop;

Env.new([0,1,0.5,0],[0.5,1,1],[-3,-5,0]).plot; // pour regarder notre enveloppe

(
SynthDef(\SuperSine, {
	arg out=0, freq=100, amp=1, atk=0.03, rel=1, curve=(-4), pan=0; //variable que l'on peux changer de l'exterieur
	var sig, env; //variable interne

	env = EnvGen.kr(Env.new([0,1,0],[atk,rel],curve),doneAction:2); //création de l'enveloppe
	sig = LFSaw.ar(freq);	//synthèse
	sig = sig * env * amp.dbamp; //gestion des amplitudes
	sig = Pan2.ar(sig,pan); //panning

	Out.ar(out,sig); //sortie
};).add
)

~play = Synth(\SuperSine, [\amp, -15, \atk, 0.1,\rel, 1, \freq,150]);

(
~freak = Pbind(
	\instrument, \SuperSine,
	\amp, Pseq([-6,-12,-6,0],inf),
	\freq, Pseq([220,120,108], inf),
	\dur, 1/2 ,
).play;
)

(
~medium = Routine{
	// 0.5.wait;
	inf.do {
		var laps = Array.fill(20,{rrand(0.3,2)}).choose.asStream;
		var atk = Array.fill(20, {rrand(0.03,1)}).choose.asStream;
		var freq = Array.fill(100, {rrand(50.0,500.0)}).choose.asStream;
		var amp = Array.fill(20, {rrand((-60),(-3))}).choose.asStream;
		Synth(\SuperSine, [
			\freq, freq,
			\atk, atk,
			\amp, amp,
		]);
		laps.wait;
	}
};
~medium.play;
)

(
~medium = Routine{
	// 0.5.wait;
	inf.do {
		var laps = Array.fill(20,{rrand(0.01,0.15)}).choose.asStream;
		var atk = 0.03;
		var pan = Array.fill(20,{rrand(-1,1)}).choose.asStream;
		var freq = Array.fill(100, {rrand(300.0,2000.0)}).choose.asStream;
		var amp = Array.fill(20, {rrand((-60),(-7))}).choose.asStream;
		Synth(\SuperSine, [
			\freq, freq,
			\atk, atk,
			\amp, amp,
			\rel, 0.1,
			\pan, pan,
		]);
		laps.wait;
	}
};
~medium.play;
)