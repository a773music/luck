Global.path2track(me.path()) => string ch;

[0,0,1,0,
0,1,0,0
] @=> int beats[];

130::ms => dur length;

while(true){
    if(beats[Time.sub(.5)%beats.size()]){
        spork ~ Midi.trigger(ch,10::ms + length * Global.get_slider("length"));
    }
    Time.wait(.5);
}
