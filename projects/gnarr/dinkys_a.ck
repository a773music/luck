Global.path2track(me.path()) => string ch;

[1.,.75,2/3.,.5,1/3.,.25] @=> float divs[];

float div;
while(true){
    divs[Math.round(Global.get_fader(ch) * (divs.size() - 1))$int % divs.size()] => div;
    spork ~ Midi.trigger(ch);
    if(Std.rand2f(0,1.) < .1){
        Std.rand2(1,40 * Global.globals[1]$int) => int nb_repeats;
        for(0=> int i; i<nb_repeats; i++){
            Time.wait(.125);
            spork ~ Midi.trigger(ch);
        }
    }
    
    Time.wait(div);

}