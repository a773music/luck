Global.path2track(me.path()) => string ch;

[1,1,0,1,
0,0 ,1,1,
0,1,0,0,
1,1,0,1
] @=> int beats[];

while(true){
    if(beats[Time.sub(.25)%beats.size()]){
        spork ~ Midi.trigger(ch);
    }
    Time.wait(.25);
}
