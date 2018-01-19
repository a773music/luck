// ms matrix preset: 1
160 => Time.tempo;

10 => Global.part_sync;
10 => Global.beats_pr_bar;

["activity","range","","","",""] @=> Global.sliders;

// labels for channels
["bass","mel","rings","","","","","",
"bd","sd","click","hh","pico","","","",
"","","","","","","",""] @=> Global.tracks;

// labels for parts
["a","b","mel_a",
"c","","",
"","",""
] @=> Global.parts;
0 => Global.part; // where to start

[.1, .5, .5, .5, .5, .5 ] @=> Global.globals;


Global.set_fader("bass",.15);
Global.set_fader("rings",0);
Global.set_fader("bd",.2);


[0.] @=> Global.scales["rings_seq"];
Std.rand2(5,9) => Global.scales["rings_seq"].size;

Array.fill(0,11,Global.scales["rings_seq"]);

[0.,2,3,7] @=> Global.scales["rings_a"];
[0.,5,7,8] @=> Global.scales["rings_b"];

Global.mute(["pico","sd","click"],1);





1::week => now;

