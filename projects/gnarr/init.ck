150 => Time.tempo;

[
// labels for global sliders
"activity","length","",
"","","",

// labels for channels
"bass","rings","","",
"bd","glitch","pico_el","hh",
"dinkys","","","",

// labels for parts
"a","b","",
"","","",
"","",""
] @=> Global.labels;

// individual sliders
[.0, .5, .5, .5,
.5, .5, .5, .5,
.5, .5, .5, .5] @=> Global.ind;

[.05, .05, .5, .5, .5, .5] @=> Global.globals;


spork ~ pulse();

fun void pulse(){
    while(true){
        spork ~ Midi._trigger(7,10::ms,0);
        Time.wait(1/24.);
    }
}
1::week => now;
