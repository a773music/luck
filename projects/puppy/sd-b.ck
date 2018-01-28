Global.path2track(me.path()) => string ch;

[0,0,1,0,
0,1,0,0
] @=> int beats[];

15::ms => dur length;

while(true){
    if(beats[Time.sub(.5)%beats.size()]){
        spork ~ Midi.trigger(ch, length);
    }
    Time.wait(.5);
}
