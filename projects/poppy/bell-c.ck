Global.path2track(me.path()) => string ch;

[
6,6,6,6,
6,8,8,8,

8,9,9,9,
9,9,9,9,

9,11,11,11,
11,13,13,13,

13,13,13,13,
13,9,9,9
] @=> int lo[];

[
9,9,9,9,
9,11,11,11,

11,13,13,13,
13,13,13,13,

13,14,14,14,
14,16,16,16,

16,16,16,16,
16,13,13,13
] @=> int hi[];

Time.beat(.5) * .9 => dur length;
5 => int octave;
int note;

Midi.note_off(ch);
while(true){
    lo[Time.sub(.5)%lo.size()] => note;
    if(note){
        spork ~ Midi.note(note + 12*octave,ch,length);
    }
    Time.wait(.5);
}