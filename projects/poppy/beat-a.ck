Global.path2track(me.path()) => string ch;

//[10,11,22,23,34,35,43,49,54,55,56] @=> int ghost[]; //47 48
[55,56] @=> int ghost[];
[57,58,62] @=> int sd_roll[];

[31,32,38,39,61] @=> int hh[];
[41,42,44,53,69,70,71,72] @=> int small_sd[];
//[50,51,52,63,64,67,68] @=> int sd[];
[50,52,63,64,68] @=> int sd[];
[45,46] @=> int small_bd[];
[
//16,34,16,10,
//32,10,16,10,
0,73,0,73,
0,74,0,74,

0,20,4,10,
0,33,10,40
] @=> int notes[];

[0,1] @=> int beats_ghost[];
[
0,0,0,0,
1,0,0,0,
0,0,0,0,
0,0,1,0
] @=> int beats_sd[];

//[34] @=> notes;

int note;
while(true){
    0 => note;
    Time.sub(.25) => int sub;
    if(beats_ghost[sub%beats_ghost.size()]){
        Array.random(ghost)$int => note;
        //<<<"ghost:" + note>>>;
    }
    if(beats_sd[sub%beats_sd.size()]){
        Array.random(sd)$int => note;
        <<<"sd:" + note>>>;
    }
    if(sub%64>64-(6*Global.get_slider("break"))){
        Array.random(sd)$int => note;
        
    }        
    
    if(note){
        spork ~ Midi.note_on(note,ch);
    }
    Time.wait(.25/2);
    spork ~ Midi.note_off(ch);
    Time.wait(.25);
}
