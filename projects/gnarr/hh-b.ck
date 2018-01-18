Global.path2track(me.path()) => string ch;

while(true){
    Midi.trigger(ch);
    Time.wait(1.);
}