//[1.,0,0,0,.5,.6,.70]
int i;
while(true){
    if(i<0 && Global.globals[0] > Std.rand2f(0.,1)){
        spork ~ Midi.trigger(1,Std.rand2(1,30)*1::ms);
    }
    Time.wait(.25);
    if(Std.rand2f(0,1) < .1 && i<0){
        Std.rand2(7,3) => i;
    }
    i--;
}