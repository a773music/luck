Global.path2track(me.path()) => string ch;

[1,1,0,1,
1,0,1,1
] @=> int beats[];

while(true){
    if(beats[Time.sub(.5)%beats.size()]){
        spork ~ Midi.trigger(ch);
    }
    Time.wait(.5);
}
