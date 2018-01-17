Global.path2track(me.path()) => string ch;

3 => int octave;
[-2.,-5,1,2,3,7] @=> float notes[];

while(true){
    0 => float note;
    if(Time.sub()%10 != 0){
        Array.random(notes) => note;
    }


    note + octave*12 => note;
    if(Global.get_fader(ch) * Std.rand2f(.6,1.4) > .3 || Time.sub()%10 == 0){
        spork ~ Midi.note_on(note, ch);
    }
    else{
        spork ~ Midi.note_off(ch);
    }
    
    if(Global.get_fader(ch) * Std.rand2f(.7,1.2)<.5){
        Time.wait(2);
    }
    else {
        Time.wait(1);
    }

}