[.99,0,0,.9,  0,.5,0,.1] @=> float probs[];

fun void ratchet(int nb_ratchets, dur start_time, dur end_time){
    for(0=> int i; i<nb_ratchets; i++){
        (start_time * (nb_ratchets - i)/nb_ratchets) + (end_time * i / nb_ratchets)=> dur ratchet_time;
        
        //<<<start_time, end_time,ratchet_time>>>;
        Midi.trigger(0);
        ratchet_time => now;
        
    }
    100::ms => now;
}


while(true){
    if(probs[Time.sub(.5)%probs.size()] >= 1-Std.rand2f(Global.globals[0],0)){
        if(Std.rand2f(0,1) < .2 && Time.sub(1)%4 == -1){
            spork ~ ratchet(Std.rand2(2,4),20::ms, Std.rand2(120,60)*1::ms);
        }
        else {
            Midi.trigger(0);
        }
    }
    Time.wait(.5);
}