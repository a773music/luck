Global.path2track(me.path()) => string ch;

[0,0,1,0,
0,0 ,0,1
] @=> int beats[];

10::ms => dur length;

while(true){
    //<<<Time.sub(.5)>>>;
    if(beats[Time.sub(.5)%beats.size()]){
        spork ~ Midi.trigger(ch,length);
    }
    Time.wait(.5);
}
