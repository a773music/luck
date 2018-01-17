Global.path2track(me.path()) => string ch;

while(true){
    if(Time.sub()%2){
        //<<<ch>>>;
        spork ~ Midi.trigger(ch,Std.rand2(8,9)*1::ms);
    }
    Time.wait(1);
}