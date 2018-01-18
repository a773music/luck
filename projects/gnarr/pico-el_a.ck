Global.path2track(me.path()) => string ch;

while(true){
    Time.wait(Std.rand2(2,5)*.5);
    if(Std.rand2f(0,1)<Global.globals[0]){
        spork ~ Midi.trigger(ch);
    }
}