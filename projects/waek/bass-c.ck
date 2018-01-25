Global.path2track(me.path()) => string ch;

2 => int octave;
//[15,15] @=> int notes[];
[14,15] @=> int notes[];
Time.sub(20) => int entry_sub;
int my_sub;
int i;
while(true){
    (Time.sub(20) - entry_sub) % notes.size() => my_sub;
    if(i == 0){
        Midi.note_on(notes[my_sub] + 12*octave, ch);
    }
    else if(i == 5 && Global.get_slider("activity") > Std.rand2f(0,.5)){
        Midi.note_on(notes[my_sub] + 12*octave, ch);
    }
    else if(Global.get_slider("activity") > Std.rand2f(.5,1)){
        Midi.note_on(notes[my_sub] + 12*octave, ch);
    }        
    Time.wait(1);
    (i+1)%10 => i;;
}