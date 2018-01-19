Global.path2track(me.path()) => string ch;


[
16,34,16,10,
32,10,16,10,

0,20,4,10,
0,33,10,40
] @=> int notes[];

//[34] @=> notes;

int note;

while(true){
    notes[Time.sub(.25)%notes.size()] => note;
    if(Global.get_slider("break") > Std.rand2f(0,1)){
        Std.rand2(0,64) => note;
    }
    if(Std.rand2f(-.1,1) > Global.get_slider("activity")){
        0 => note;
    }
    if(note){
        spork ~ Midi.note_on(note,ch);
    }
    Time.wait(.25/2);
    spork ~ Midi.note_off(ch);
    Time.wait(.25);
}
