public class Global {

    0 => static int part;
    -1=> static int next_part;
    0 => static int last_step;
    4 => static int part_sync;
    
    0::ms => static dur osc_init_time;
    
    [
    "global1","global2","global3",
    "global4","global5","global6",

    "ch1","ch2","ch3","ch4",
    "tr1","tr2","tr3","tr4",
    "tr5","tr6","tr7","tr8",

    "part1","part2","part3",
    "part4","part5","part6",
    "part7","part8","part9"
    ] @=> static string labels[];

    
    [.5, .5, .5, .5,
    .5, .5, .5, .5,
    .5, .5, .5, .5] @=> static float ind[];

    [.5, .5, .5, .5, .5, .5] @=> static float globals[];
    
    [0,0,0,0,
    0,0,0,0,
    0,0,0,0] @=> static int mute[];

    
    spork ~ osc_listen();
    osc_send_all();

    /*
    for(0=>int i; i<400; i++){
        osc_trigger(Math.random2(0,400));
        .005::second => now;
    }
    */


    public static void osc_send(string address, float value){
        //"192.168.0.5" => string osc_remote_host;
        "192.168.43.124" => string osc_remote_host;
        9000 => int osc_remote_port;

        OscOut xmit;
        xmit.dest(osc_remote_host, osc_remote_port);
        xmit.start(address);
        value => xmit.add;
        xmit.send();
    }

    public static void osc_send(string address, float value, dur rest_time){
        osc_send(address, value);
        rest_time => now;
    }

    public static void osc_send(string address, string value){
        //"192.168.0.5" => string osc_remote_host;
        "192.168.43.124" => string osc_remote_host;
        9000 => int osc_remote_port;

        OscOut xmit;
        xmit.dest(osc_remote_host, osc_remote_port);
        xmit.start(address);
        value => xmit.add;
        xmit.send();
    }

    public static void osc_send(string address, string value, dur rest_time){
        osc_send(address, value);
        rest_time => now;
    }
    
    public static void osc_send_labels(){
        for(1=>int i; i<=6; i++){
            osc_send("/page1/labelGl"+i,labels[i-1],osc_init_time);
        }
        for(1=>int i; i<=4; i++){
            osc_send("/page1/labelCh"+i,labels[i+5],osc_init_time);
        }
        for(1=>int i; i<=8; i++){
            osc_send("/page1/labelTr"+i,labels[i+9],osc_init_time);
        }
        for(1=>int i; i<=9; i++){
            osc_send("/page1/labelPart"+i,labels[i+17],osc_init_time);
        }

}
    

    public static void osc_send_part(){
        for(1=>int i; i<=9; i++){
            osc_send("/page1/part"+i,0,osc_init_time);
        }
        osc_send("/page1/part"+(part+1),1,osc_init_time);
    }

    public static void osc_pulse(int step){
        spork ~ _osc_pulse(step);
    }

    
    public static void _osc_pulse(int step){
        (step % 9) + 1 => step;
        osc_send("/page1/pulse"+step,1);
        osc_send("/page1/pulse"+last_step,0);
        step => last_step;
    }


    public static void osc_note(int channel){
        osc_note(channel, 1);
        50::ms =>now;
        osc_note(channel, 0);
    }
        
    public static void osc_note(int channel, int state){
        spork ~ _osc_note(channel, state);
    }

    
    public static void _osc_note(int channel, int state){
        (channel % 4) + 1 => channel;
        osc_send("/page1/activityCh"+channel, state);
    }

    public static void osc_trigger(int trigger){
        osc_trigger(trigger, 1);
        50::ms => now;
        osc_trigger(trigger, 0);
    }
    public static void osc_trigger(int trigger, int state){
        spork ~ _osc_trigger(trigger, state);
    }

    
    public static void _osc_trigger(int trigger, int state){
        (trigger % 8) + 1 => trigger;
        osc_send("/page1/activityTr"+trigger, state);
    }


    public static void osc_clear_activity(){
        for(1=>int i; i<=4; i++){
            osc_send("/page1/activityCh"+i, 0,osc_init_time);
        }
        for(1=>int i; i<=8; i++){
            osc_send("/page1/activityTr"+i, 0,osc_init_time);
        }
        
    }
    
    public static void osc_send_faders(){
        for(1=>int i; i<=4; i++){
            osc_send("/page1/faderCh"+i,ind[i-1],osc_init_time);
        }
        for(1=>int i; i<=8; i++){
            osc_send("/page1/faderTr"+i,ind[i+3],osc_init_time);
        }
    }
    
    public static void osc_send_globals(){
        for(1=>int i; i<=6; i++){
            osc_send("/page1/global"+i,globals[i-1],osc_init_time);
        }
    }

    public static void osc_send_mutes(){
        for(1=>int i; i<=4; i++){
            osc_send("/page1/muteCh"+i,mute[i-1],osc_init_time);
        }
        for(1=>int i; i<=8; i++){
            osc_send("/page1/muteTr"+i,mute[i+3],osc_init_time);
        }
    }        
        
    public static void osc_send_all(){
        osc_send_labels();
        20::ms => now;
        osc_send_faders();
        20::ms => now;
        osc_send_globals();
        20::ms => now;
        osc_send_part();
        20::ms => now;
        osc_clear_activity();
        osc_send_mutes();
    }

    public static void osc_listen(){
        OscIn oin;
        8000 => oin.port;
        oin.listenAll();
        
        OscMsg msg;
        
        while(true){
            string address;
            float value;
            oin => now;
            while(oin.recv(msg)){
                msg.address => address;
                msg.getFloat(0) => value;
                <<<address + "   " + value>>>;
            }
        }
        
        
        
        
    }
}

Global dummy;

1::week => now;
