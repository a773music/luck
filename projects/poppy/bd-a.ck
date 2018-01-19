Global.path2track(me.path()) => string ch;

[1,0,0,0,
0,1,0,0
] @=> int beats[];

while(true){
    if(beats[Time.sub(.5)%beats.size()]){
        spork ~ Midi.trigger(ch);
    }
    Time.wait(.5);
}
