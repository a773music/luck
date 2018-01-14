while(true){
    if(Time.sub(1)%2 != 0){
        Midi.trigger(3,Std.rand2(1,50) * Global.globals[1] * 1::ms);
    }
    Time.wait(1);
}