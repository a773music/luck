// ms matrix preset: 2

130 => Time.tempo;

16 => Global.part_sync => Global.beats_pr_bar;

["activity","break","length","","",""] @=> Global.sliders;
[.4, .0, .5, .5, .5, .5 ] @=> Global.globals;

// labels for channels
["bass","bell","hi","beat","","","","",
"bd","sd","click","hh","pico","","","",
"","","","","","","",""] @=> Global.tracks;

// labels for parts
["a","b","c",
"","","",
"","",""
] @=> Global.parts;

0 => Global.part; // start here

Global.mute([
"bell","hi","beat",
"sd","click","hh","pico"
],1);


int i;
while(true){
    1::second => now;
}

1::week => now;