Global.path2track(me.path()) => string ch;

while(true){
    if(Global.globals[0]>Std.rand2f(0,1)){
        spork ~ Midi.trigger(ch);
    }
    Time.wait(1.);
}