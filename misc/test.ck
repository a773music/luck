0 => int channel;

spork ~ trig(1.,0);
spork ~ trig(1/3.,1);
spork ~ trig(1/4.,2);
//spork ~ trig(1/24.,7);


Array notes;
notes.append([60,62,64,65,67,69,71,72]);

/*
while(true){
    Time.wait(8);
    for(0=>int i; i<7; i++){
        Midi.note_on(notes.random(), channel, Time.beat(.25));
    }
}
*/
fun void trig(float beats, int trigger){
    while(true){
        //<<<Time.sub(beats)>>>;
        Midi.trigger(trigger);
        Time.wait(beats);
    }
}    


1::week => now;
