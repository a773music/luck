Global.path2track(me.path()) => string ch;

5 => int octave;

Time.sub(20) => int first_sub;
int my_sub;
int i;
while(true){
    (Time.sub(20) - first_sub)%2 => my_sub;


    Global.get_fader(ch) * 2 + 1 => float scale;
    (Global.globals[1] -.5) * 24 => float offset;
    
    Time.sub(.25)% (Global.beats_pr_bar * 4) => int tic;
    Global.scales["rings_seq"][i % (Global.beats_pr_bar * 4) % Global.scales["rings_seq"].size()] => float note;

    note * scale => note;
    note + offset => note;
    
    if(my_sub == 0){
        //<<<"Ebm">>>;
        Global.quantize(note,"rings_c1") => note;
    }
    else if(my_sub == 1) {
        //<<<"Abm">>>;
        Global.quantize(note,"rings_c2") => note;
    }        
    spork ~ Midi.note(note + octave * 12, ch, 100::ms);

    Time.wait(1);
    i++;
}