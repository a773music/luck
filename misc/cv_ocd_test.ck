0 => int note;
// get from command line
if(me.args()) me.arg(0) => Std.atoi => note;

for(0 => int channel; channel<4; channel++){
    Midi.note_on(note,channel);
}