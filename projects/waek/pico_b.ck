"pico" => string ch;

.5 => float trig;

while(true){
    if(Std.rand2f(0,1) > 1-Global.ind_tr(ch) && Std.rand2f(0,1) < trig){
        Array.random([1,1,1,1,3,4,8,6])$int => int retrig;
        for(0 => int i; i<=retrig; i++){
            spoark ~ Midi.trigger(ch);
            Time.wait(.5/retrig);
        }
        .9 => trig;
    }
    else{
        .1 => trig;
    }
    Time.wait(1.5);
}
    