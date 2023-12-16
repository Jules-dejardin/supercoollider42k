s.options.sampleRate_(48000);
MIDIClient.init;

(
MIDIFunc.cc({
	arg val, ccNum, channel;

	if(ccNum == 77, {
		~tweak = val.linlin(0, 127, 50, 1000).round(1);
		~synthFerme.set(\freq, ~tweak);
		"var freq".postln;
		~tweak.postln;
	});
});
)
