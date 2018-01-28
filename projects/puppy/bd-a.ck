Global.path2track(me.path()) => string ch;

[1,0,0,0,
0,1,0,0
] @=> int beats[];

while(true){
    .1::ms => now;
    //if(beats[Time.sub(.5)%beats.size()]){
        if(Global.ints["basshit"]){
        spork ~ Midi.trigger(ch);
    }
    Time.wait(.5);
}
