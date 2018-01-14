//<<<"bd b">>>;
0 => int ch;

[0.] @=> float notes[];
notes.clear();

Std.rand2(4,6) => notes.size;
for(0=>int i;i<notes.size(); i++){
    Std.rand2f(0,1) => notes[i];
}
1 => notes[0];

Std.rand2(8,19 - notes.size() - 2) => int random_middle;

while(true){
    if(Time.sub(.25)%40 == 0 || Time.sub(.5)%20 == random_middle){
        for(0 => int i; i<notes.size(); i++){
            if(notes[i] > 1-Global.globals[0]){
                Midi.trigger(ch);
            }
            Time.wait(.25);
        }
    }
    Time.wait(.25);
}

