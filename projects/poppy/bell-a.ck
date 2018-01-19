Global.path2track(me.path()) => string ch;

[
9,9,9,9,
9,11,11,11,
11,12,12,12,
12,14,14,14,

14,16,16,16,
16,16,16,16,
0,0,0,0,
0,0,0,0
] @=> int notes[];

Time.beat(.5) * .9 => dur length;
5 => int octave;
int note;

while(true){
    notes[Time.sub(.5)%notes.size()] => note;
    if(note){
        spork ~ Midi.note(note + 12*octave,ch,length);
    }
    Time.wait(.5);
}