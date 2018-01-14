0 => int ch;

[5,8,10] @=> int notes[];
[.5, .25, -2, .25, .25, .5, -4.5,-3] @=> float lengths[];
3 => int octave;

int i;
while(true){
    notes[Time.sub(16)%notes.size()] + 12*octave => int note;
    lengths[i%lengths.size()] => float length;
    if(length >= 0){
        Midi.note(note, ch, Time.beat(length));
        Time.wait(length);
    }
    else {
        Midi.note_off(ch);
        Time.wait(-1*length * Math.round((.2 + (1-Global.ind[ch])) * 3));
    }
    i++;
}