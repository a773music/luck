Global.path2track(me.path()) => string ch;

[0.] @=> float notes[];
notes.clear();

Std.rand2(4,6) => notes.size;
for(0=>int i;i<notes.size(); i++){
    Std.rand2f(0,1) => notes[i];
}
1 => notes[0];

while(true){
    if(Time.sub(.25)%40 == 0){
        for(0 => int i; i<notes.size(); i++){
            if(notes[i] >= Std.rand2f(.9,1.1)-Global.globals[0]){
                spork ~ Midi.trigger(ch);
            }
            Time.wait(.25);
        }
    }
    Time.wait(.25);
}

