Global.path2track(me.path()) => string ch;


[12,14,15,19] @=> int notes[];
float note;

int sub;
int div;
5 => int octave;

while(true){
    (32  / (Global.get_fader(ch) + 1))$int => div;
    Array.random(notes) => note;
    Time.sub(.5)% div => sub;
    if(sub < 7 * Global.globals[0] * Std.rand2f(.6,1.4)){
        1::ms + 190::ms* Global.globals[1] => dur length;
        spork ~ Midi.note(Array.random(notes) + 12*octave, ch ,length);
    }
    Time.wait(.5);
}