Global.path2track(me.path()) => string ch;

4 => int octave;
Time.beat(.5) * .9 => dur length;
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
int note;

0 => Global.ints["basshit"];
.05::ms  => now;



int i;

while(true){
    notes[Time.sub(0.5)%notes.size()] => note;
    if(note){
        if(Time.sub(.5)%4 == 0 || Std.rand2f(0,.5) < Global.get_slider("activity")){
            1 => Global.ints["basshit"];
            Midi.note(note + 12*octave, ch, length);
        }

    }
    1::ms => now;
    0 => Global.ints["basshit"];
    
    
    Time.wait(.5);
}