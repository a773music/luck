Global.path2track(me.path()) => string ch;


[
0,34,0,10,
32,10,0,10,

0,33,4,10,
0,10,10,40
] @=> int notes[];

//[0] @=> notes;

int note;
int ratchet;
int i_played;
while(true){
    0 => i_played;
    1 => ratchet;
    notes[Time.sub(.25)%notes.size()] => note;
    if(Global.get_slider("break")+.1 > Std.rand2f(0,1)){
        Std.rand2(0,48) => note;
    }
    if(Std.rand2f(-1,1) > Global.get_slider("activity")){
        0 => note;
    }
    if(note){
        if(Global.get_slider("break")+.1 > Std.rand2f(.9,1.2) && Time.sub(.25)%4==0){
            Array.random([2,2,3,4])$int => ratchet;
        }
        for(ratchet => int i; i>0; i--){
            spork ~ Midi.note_on(note,ch);
            Time.wait(.25/i);
            1 => i_played;
            
        }
    }
    if(!i_played){
        Time.wait(.25);
    }
}
