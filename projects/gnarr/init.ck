150 => Time.tempo;

10 => Global.part_sync;
10 => Global.beats_pr_bar;

["activity","length","", "","",""] @=> Global.sliders;

// labels for channels
["bass","","","rings","","","","",
"bd","glitch","pico_el","hh","dinkys","","","",
"","","","","","","",""] @=> Global.tracks;

// labels for parts
["a","b","",
"","","",
"","",""] @=> Global.parts;

Global.set_fader("bass", .0);

[.05, .05, .5, .5, .5, .5] @=> Global.globals;

1::week => now;
