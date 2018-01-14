4 => int ch;

[1.,.75,2/3.,.5,1/3.,.25] @=> float divs[];

float div;
while(true){
    divs[Math.round(Global.ind[ch + 4] * (divs.size() - 1))$int % divs.size()] => div;
    Midi.trigger(ch);
    if(Std.rand2f(0,1.) < .1){
        Std.rand2(1,40 * Global.globals[1]$int) => int nb_repeats;
        for(0=> int i; i<nb_repeats; i++){
            Time.wait(.125);
            Midi.trigger(ch);
        }
    }
    
    Time.wait(div);

}