public class Global {

    0 => static int last_step;
    
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

    0 => static int part;
    
    spork ~ osc_listen();
    osc_send_all();

    for(0=>int i; i<400; i++){
        osc_tr_act(i);
        .5::second => now;
    }



    public static void osc_send(string address, float value){
        "192.168.0.5" => string osc_remote_host;
        9000 => int osc_remote_port;

        OscOut xmit;
        xmit.dest(osc_remote_host, osc_remote_port);
        xmit.start(address);
        value => xmit.add;
        xmit.send();
        5::ms => now;
    }

    public static void osc_send(string address, string value){
        "192.168.0.5" => string osc_remote_host;
        9000 => int osc_remote_port;

        OscOut xmit;
        xmit.dest(osc_remote_host, osc_remote_port);
        xmit.start(address);
        value => xmit.add;
        xmit.send();
        5::ms => now;
    }

    public static void osc_send_labels(){
        osc_send("/page1/labelGl1",labels[0]);
        osc_send("/page1/labelGl2",labels[1]);
        osc_send("/page1/labelGl3",labels[2]);
        osc_send("/page1/labelGl4",labels[3]);
        osc_send("/page1/labelGl5",labels[4]);
        osc_send("/page1/labelGl6",labels[5]);

        osc_send("/page1/labelCh1",labels[6]);
        osc_send("/page1/labelCh2",labels[7]);
        osc_send("/page1/labelCh3",labels[8]);
        osc_send("/page1/labelCh4",labels[9]);

        osc_send("/page1/labelTr1",labels[10]);
        osc_send("/page1/labelTr2",labels[11]);
        osc_send("/page1/labelTr3",labels[12]);
        osc_send("/page1/labelTr4",labels[13]);
        osc_send("/page1/labelTr5",labels[14]);
        osc_send("/page1/labelTr6",labels[15]);
        osc_send("/page1/labelTr7",labels[16]);
        osc_send("/page1/labelTr8",labels[17]);

        osc_send("/page1/labelPart1",labels[18]);
        osc_send("/page1/labelPart2",labels[19]);
        osc_send("/page1/labelPart3",labels[20]);
        osc_send("/page1/labelPart4",labels[21]);
        osc_send("/page1/labelPart5",labels[22]);
        osc_send("/page1/labelPart6",labels[23]);
        osc_send("/page1/labelPart7",labels[24]);
        osc_send("/page1/labelPart8",labels[25]);
        osc_send("/page1/labelPart9",labels[26]);

}
    

    public static void osc_send_part(){
        osc_send("/page1/partA",0);
        osc_send("/page1/partB",0);
        osc_send("/page1/partC",0);
        osc_send("/page1/partD",0);
        osc_send("/page1/partE",0);
        osc_send("/page1/partF",0);
        osc_send("/page1/partG",0);
        osc_send("/page1/partH",0);
        osc_send("/page1/partI",0);
        if(part == 0)
            osc_send("/page1/partA",1);
        else if(part == 1)
            osc_send("/page1/partB",1);
        else if(part == 2)
            osc_send("/page1/partC",1);
        else if(part == 3)
            osc_send("/page1/partD",1);
        else if(part == 4)
            osc_send("/page1/partE",1);
        else if(part == 5)
            osc_send("/page1/partF",1);
        else if(part == 6)
            osc_send("/page1/partG",1);
        else if(part == 7)
            osc_send("/page1/partH",1);
        else if(part == 8)
            osc_send("/page1/partI",1);
        else if(part == 9)
            osc_send("/page1/partJ",1);
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


    public static void osc_ch_act(int channel){
        spork ~ _osc_ch_act(channel);
    }

    
    public static void _osc_ch_act(int channel){
        (channel % 4) + 1 => channel;
        osc_send("/page1/activityCh"+channel,1);
        250::ms =>now;
        osc_send("/page1/activityCh"+channel,0);

    }

    public static void osc_tr_act(int trigger){
        spork ~ _osc_tr_act(trigger);
    }

    
    public static void _osc_tr_act(int trigger){
        (trigger % 8) + 1 => trigger;
        osc_send("/page1/activityTr"+trigger,1);
        250::ms =>now;
        osc_send("/page1/activityTr"+trigger,0);

    }


    
    public static void osc_send_all(){
        osc_send("/page1/faderCh1",ind[0]);
        osc_send("/page1/faderCh2",ind[1]);
        osc_send("/page1/faderCh3",ind[2]);
        osc_send("/page1/faderCh4",ind[3]);

        osc_send("/page1/faderTr1",ind[4]);
        osc_send("/page1/faderTr2",ind[5]);
        osc_send("/page1/faderTr3",ind[6]);
        osc_send("/page1/faderTr4",ind[7]);
        osc_send("/page1/faderTr5",ind[8]);
        osc_send("/page1/faderTr6",ind[9]);
        osc_send("/page1/faderTr7",ind[10]);
        osc_send("/page1/faderTr8",ind[11]);

        osc_send("/page1/global1",globals[0]);
        osc_send("/page1/global2",globals[1]);
        osc_send("/page1/global3",globals[2]);
        osc_send("/page1/global4",globals[3]);
        osc_send("/page1/global5",globals[4]);
        osc_send("/page1/global6",globals[5]);
        
        osc_send_part();
        osc_send_labels();
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
