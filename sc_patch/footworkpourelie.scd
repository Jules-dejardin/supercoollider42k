///load samples
(
~projectPath=PathName(thisProcess.nowExecutingPath).parentPath;
~sampleDirPath=n audio server, programming language, and IDE for sound synthesis and algorithmi~projectPath++"Musique/";

(
~loadSamples = {
	~buffers = Dictionary.new;

	PathName(~sampleDirPath).entries.do{
		arg subfolder;
		~buffers.add(
			subfolder.folderName.asSymbol ->
			Array.fill(
				subfolder.entries.size,
				{
					arg i;
					Buffer.read(s, subfolder.entries[i].fullPath);
				}
			)
		);0
	};
};
ServerBoot.add(~loadSamples);
)
)

//12 || 1 || 0 ||2 |3 || 18
Synth(\k);
Synth(\s);
Synth(\sn);
// init
~pattern1 =".................................";
~pattern2 =".................................";
~pattern3 =".................................";
~pattern4 =".................................";
~break = Synth(\looper, [\buf, ~buffers[\breaks][0]]);

~sample = Synth(\lectechant, [\buf, ~buffers[\objets][66]]);
~break = Synth(\looper, [\buf, ~buffers[\breaks][1], \amp, 0]);
~break = Synth(\looper, [\buf, ~buffers[\breaks][2], \amp, 0]);
~break = Synth(\looper, [\buf, ~buffers[\breaks][3], \amp, 0]);
~break = Synth(\looper, [\buf, ~buffers[\breaks][4], \amp, 0]);
//kick
~pattern1 ="k...k...k..k...k...k..k...k...k..";
~pattern1 ="...k...k...k...k";
~pattern1 ="k...k...k...k....";
//rope
~pattern3 ="l.l..l.l..l..l...".scramble;
~pattern3 =".......l.........";
~pattern3 ="...l...l...l...l.";
~pattern3=".";
//aoe
~pattern2 =".................";
~pattern2 ="t................"; //trompe
~pattern2 ="t.......l........";
//synth drum
~pattern4 ="n....n....n....";
~pattern4 ="....s....s....s....s";
~pattern4 ="..s.s..s.s..s.s..s.s";
~pattern4 ="....................";
~loop.set(\loop, 0);
~loop = Synth(\looper, [\buf, ~buffers[\loop_160_foot][0], \loop,1 ]);
~trpt = Synth(\lectechant, [\buf, ~buffers[\age_of_cut][11]]);
~loop.set(\amp, 0);
~loop.set(\dw, 1);
~loop.set(\rqBand, 0.05);
~loop.set(\volBand, 2);
s.quit;

(
// init
~pattern1 =".................................";
~pattern2 =".................................";
~pattern3 =".................................";
~pattern4 =".................................";
~break = Synth(\looper, [\buf, ~buffers[\breaks][0], \amp, 3]);
)

(
var s, bpm, beat, tatum, map, pattern2;
s = Server.default();

bpm = 160;
beat = 60 / bpm;
tatum = beat / 4;

map = Dictionary[
	$k -> \k,
	$s -> \s,
	$n -> \sn,
	$l -> \lectechant,
];

~k = Routine({
	loop {
	~pattern1.do{|character|
		if(character == $.) {
			tatum.wait;
		} {
			if(map[character].notNil) {
					s.bind { Synth(map[character], [\amp, 0]); };
				};
			};
		} ;
	};
}).play;

~samp1 = Routine({
	loop {
	~pattern2.do{|character|
		if(character == $.) {
			tatum.wait;
		} {
				if(character == $t){
				s.bind{
				~trpt.set(\rel,0.001);
			~trpt = Synth(\lectechant, [\buf, ~buffers[\age_of_cut][11],\amp, -5]);
				};
			} {if(character == $l) {
					s.bind{
						~sample.set(\rel, 0.001);
						~sample = Synth(map[character], [\buf, ~buffers[\age_of_cut][[0,1,2,3,4,5,6].choose], \amp,-5])};
				};
				};
			};
		};
	};
}).play;

~samp2 = Routine({
	loop {
	~pattern3.do{|character|
		if(character == $.) {
			tatum.wait;
		} {
			if(map[character].notNil) {
					s.bind{
						~sample2.set(\rel, 0.001);
						~sample2 = Synth(map[character], [\buf, ~buffers[\objets][[15,17,10,11,12,18,46].choose], \amp,-5])};
				};
			};
		};
	};
}).play;

~sn = Routine({
	loop {
	~pattern4.do{|character|
		if(character == $.) {
			tatum.wait;
		} {
			if(map[character].notNil) {
					s.bind { Synth(map[character], [\amp, -5]); };
				};
			};
		};
	};
}).play;

~loop = Synth(\looper, [\buf, ~buffers[\loop_160_foot][0], \loop,1]);
)
