Global.path2track(me.path()) => string ch;

4 => int octave;
Time.beat(.5) * .9 => dur length;
int note;
[
9,0,0,0,
0,4,0,0,

7,0,0,0,
0,2,0,0,

5,0,0,0,
0,0,0,0,

0,0,0,0,
0,0,0,0
] @=> int notes[];

int i;

while(true){
    notes[Time.sub(0.5)%notes.size()] => note;
    if(note){
        Midi.note(note + 12*octave, ch, length);
    }
    
    Time.wait(.5);
}