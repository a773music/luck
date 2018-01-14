1 => int rings_channel;

Array notes;
notes.append([12,14,15,19]);
float note;

int sub;
int div;
5 => int octave;

while(true){
    (32  / (Global.ind[rings_channel] + 1))$int => div;
    notes.random() => note;
    Time.sub(.5)% div => sub;
    //<<<"in rings, div:" + div>>>;
    if(sub < 7 * Global.globals[0] * Std.rand2f(.6,1.4)){
        //<<<"note on rings:" + note>>>;
        1::ms + 190::ms* Global.globals[1] => dur length;
        Midi.note(notes.random() + 12*octave, rings_channel ,length);
    }
    Time.wait(.5);
}