Global.path2track(me.path()) => string ch;

3 => int octave;
[-2.,-5,1,2,3,7] @=> float notes_cm[];
[-2.,-5,-4,0,3] @=> float notes_fm[];

float note;

Time.sub() => int first_sub;
int my_sub;

while(true){
    (Time.sub() - first_sub) % 80 => my_sub;

    if(40 <= my_sub && my_sub < 60){
        //<<<"fm">>>;
        //Array.random([5.,-7, -7, 1]) => note;
        Array.random([5.,-7]) => note;
        if(Time.sub()%10 != 0){
            Array.random(notes_fm) => note;
        }
    }
    else {
        //<<<"cm">>>;
        0 => note;
        if(Time.sub()%10 != 0){
            Array.random(notes_cm) => note;
        }
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