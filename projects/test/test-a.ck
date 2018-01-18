while(true){
    <<<"now">>>;
    spork ~ Midi.note_on(Std.rand2(36,50),"test");
    Time.wait(2);
}