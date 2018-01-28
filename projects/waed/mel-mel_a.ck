Global.path2track(me.path()) => string ch;

0 => int my_beat;
2 => int pattern_length;
5 => int octave;
int real_octave;
int note;

[ // -1: pass, -2: note off
-1,-1,-1,7,14,
-1,12,-1,-1,-2,
-1,-1,-1,7,10,
-1,8,-1,-1,-2,

-1,-1,-1,7,14,
-1,12,-1,-1,-2,
-1,-1,-1,7,10,
-1,8,-1,-1,-2,

-1,-1,-1,0,7,
-1,5,-1,-1,-2,
-1,-1,-1,-1,-1,
-1,-1,-1,-1,-1,

-1,-1,-1,-1,-1,
-1,-1,-1,-1,-1,
-1,-1,-1,-1,-1,
-1,-1,-1,-1,-1
] @=> int notes[];

while(true){
    octave => real_octave;
    if(Global.get_slider("range") < .2){
        real_octave--;
    }
    if(Global.get_slider("range") > .8){
        real_octave++;
    }
    
    if(notes[my_beat%notes.size()] >= 0){
        notes[my_beat%notes.size()] + 12*real_octave => note;
        //<<<"note:" + note>>>;
    }
    if(notes[my_beat%notes.size()] >= 0){
        spork ~ Midi.note_off(ch);
        20::ms => now;
        spork ~ Midi.note_on(note, ch);
    }
    else if(notes[my_beat%notes.size()] == -2){
        spork ~ Midi.note_off(ch);
    }
    
    my_beat++;
    Time.wait(1);

}