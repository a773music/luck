Global.path2track(me.path()) => string ch;

4 => int octave;
Time.beat(.5) * .9 => dur length;
int note;
[
2,2,2,2,
2,2,2,2,

2,2,2,2,
2,2,2,2,

11,11,11,11,
9,9,9,9,

6,6,6,6,
6,1,1,1
] @=> int notes[];

int i;

while(true){
    notes[Time.sub(0.5)%notes.size()] => note;
    if(note){
        Midi.note(note + 12*octave, ch, length);
    }
    
    Time.wait(.5);
}