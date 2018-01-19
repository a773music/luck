Global.path2track(me.path()) => string ch;

4 => int octave;
Time.beat(.5) * .9 => dur length;
int note;
[
16,-1,-1,13,
-1,-1,0,-1,

-1,-1,-1,-1,
-1,-1,-1,-1,

16,-1,-1,11,
-1,-1,8,-1,

-1,9,-1,-1,
0,-1,-1,-1
] @=> int notes[];

int i;

while(true){
    notes[Time.sub(0.5)%notes.size()] => note;
    if(note == 0){
        Midi.note_off(ch);
    }
    else if(note > 0){
        //<<<"play:" + note>>>;
        Midi.note(note + 12*octave, ch, length);
    }
    
    Time.wait(.5);
}