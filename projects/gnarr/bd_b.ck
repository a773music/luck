while(true){
    if(Global.globals[0]>Std.rand2f(0,1)){
    //if(Global.globals[0]>.6){
        Midi.trigger(0);
    }
    Time.wait(1.);
}