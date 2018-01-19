Global.path2track(me.path()) => string ch;

[
1,0,1,0,
1,0,1,1
] @=> int notes[];

int note;

40::ms => dur length;

while(true){
    notes[Time.sub(.5)%notes.size()] => note;

    if(note){
        spork ~ Midi.trigger(ch,1::ms + (Global.get_slider("length") * length));
    }
    Time.wait(.5);
}
    