"click" => string ch;

[1., 1, .5, .25, .125] @=> float len[];

while(true){
    //if(Global.get_fader(ch))
    spork ~ Midi.trigger(ch);
    Time.wait(Std.rand2f(0,(1-Global.get_fader(ch))*3));
    Time.wait(Array.random(len));
}