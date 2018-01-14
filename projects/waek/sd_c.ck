"sd" => string ch;
[
0.,0,0,0,     1,0,0,0,    0,0,0,0,     1,0,0,0,     0,0,0,0,
0,0,0,0,     1,0,0,0,    0,0,0,0,     1,0,0,0,     1,1,1,1
] @=> float notes[];

(Global.globals[0] * 10)$int => int nb_fills;

for(0=>int i; i<nb_fills; i++){
    Std.rand2f(0,1) => notes[Std.rand2(0,notes.size()-1)];
}

while(true){
    if(notes[Time.sub(.25)%40%notes.size()] >= 1.001-Global.globals[0]){
        spork ~ Midi.trigger(ch);
    }
    Time.wait(.25);
}