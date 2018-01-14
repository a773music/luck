Global.path2track(me.path()) => string ch;

while(true){
    if(Time.sub(1)%2 != 0){
        spork ~ Midi.trigger(ch,Std.rand2(1,50) * Global.globals[1] * 1::ms);
    }
    Time.wait(1);
}