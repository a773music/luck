public class Global {
    0 => static int part;
    -1=> static int next_part;
    -1 => static int part_id;
    static int next_part_blink;
    0 => static int last_step;
    8 => static int part_sync;
    8 => static int beats_pr_bar;
    
    [
    -1,-1,-1,-1,
    -1,-1,-1,-1,
    -1,-1,-1,-1] @=> static int track_ids[];
    
    0::ms => static dur osc_init_time;
    
    
    [
    // labels for global sliders
    "","","",
    "","","",

    // labels for channels
    "","","","",
    "","","","",
    "","","","",

    // labels for parts
    "","","",
    "","","",
    "","",""
    ] @=> static string labels[];

    
    [.5, .5, .5, .5,
    .5, .5, .5, .5,
    .5, .5, .5, .5] @=> static float ind[];

    [.5, .5, .5, .5, .5, .5] @=> static float globals[];
    
    [0,0,0,0,
    0,0,0,0,
    0,0,0,0] @=> static int mutes[];

    
    spork ~ osc_listen();
    spork ~ next_part_blinker();
    spork ~ part_switcher();
    spork ~ osc_send_all();
    spork ~ osc_pulser();
    
    .005::ms => now;
    for(0=>int i; i<track_ids.size(); i++){
        add(i,part,".ck") => track_ids[i];
    }
    add(part,".ck") => part_id;


    // -----------------------------------------------------
    // helpers
    // -----------------------------------------------------
    public static int file_exists(string file_name){
        FileIO file;
        file.open(file_name, FileIO.READ) => int exists;
        file.close();
        //<<<"test:" + test>>>;
        return exists;
    }

    

    // -----------------------------------------------------
    // mutes
    // -----------------------------------------------------
    public static void mute(int ch_tr, int state){
        state => mutes[ch_tr%mutes.size()];
    }

    public static void mute(int ch_tr[], int state){
        for(0=>int i; i<ch_tr.size(); i++){
            mute(ch_tr[i], state);
        }
        osc_send_mutes();
    }

    public static void mute(int ch_tr){
        mute(ch_tr,1);
        osc_send_mutes();
    }

    public static void mute(int ch_tr[]){
        mute(ch_tr, 1);
        osc_send_mutes();
    }

    public static void unmute(int ch_tr){
        mute(ch_tr,0);
        osc_send_mutes();
    }

    public static void unmute(int ch_tr[]){
        mute(ch_tr,0);
        osc_send_mutes();
    }



    // -----------------------------------------------------
    // parts
    // -----------------------------------------------------

    private static string part_name(int part_nb){
        part_nb % 9 => part_nb;
        return labels[18 + part_nb];
    }
    
    private static string track_name(int track_nb){
        track_nb % track_ids.size() => track_nb;
        return labels[6 + track_nb];
    }
    
    private static void next_part_blinker(){
        while(true){
            !next_part_blink => next_part_blink;
            osc_send("/page1/part"+(next_part + 1) ,next_part_blink,osc_init_time);
            1::ms => now;
            osc_send_part();
            499::ms => now;
        }
    }

    private static int add(int track_nb, int part_nb, string ending){
        track_name(track_nb) => string track;
        part_name(part_nb) => string part;

        track + "_" + part + ending => string file_name;

        //if((part != "") && (track != "") && file_exists(file_name)){
        if(file_exists(file_name)){
            return Machine.add(file_name);
        }
    }
    
    private static int add(int part_nb, string ending){
        part_name(part_nb) => string part;
        part + ending => string file_name;
        //if((part != "") && (file_exists(file_name))){
        if((file_exists(file_name))){
            return Machine.add(file_name);
        }
    }
    
    private static void part_switcher(){
        int id;
        while(true){
            Time.early_wait(part_sync);
            if(next_part != -1){
                <<<part_name(next_part) + " ---------------">>>;
                for(0=>int i; i< track_ids.size(); i++){
                    add(i,next_part,".ck") => id;
                    if(track_ids[i]){
                        Machine.remove(track_ids[i]);
                    }
                    //-1 => track_ids[i];
                    add(i,part,"_.ck");
                    id => track_ids[i];
                }
                add(next_part,".ck") => id;
                if(part_id){
                    Machine.remove(part_id);
                }
                add(part,"_.ck");
                id => part_id;

                next_part => part;
                -1 => next_part;
            }
        }
    }
    
    

    // -----------------------------------------------------
    // osc
    // -----------------------------------------------------
    public static void osc_send(string address, float value){
        "192.168.0.5" => string osc_remote_host;
        //"192.168.43.124" => string osc_remote_host;
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
        "192.168.0.5" => string osc_remote_host;
        //"192.168.43.124" => string osc_remote_host;
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
            if((i-1 != next_part) &&(i-1 != part)){
                //if(part != next_part){
                osc_send("/page1/part"+i,0,osc_init_time);
            }
        }
        osc_send("/page1/part"+(part+1),1,osc_init_time);
    }


    public static void osc_pulser(){
        while(true){
            _osc_pulse(Time.sub(1));
            Time.wait(1);
        }
    }
    
    /*
    public static void osc_pulse(int step){
        spork ~ _osc_pulse(step);
    }
    */
    
    public static void _osc_pulse(int step){
        ((step % beats_pr_bar) % 9) + 1 => step;
        osc_send("/page1/pulse"+step,1,osc_init_time);
        osc_send("/page1/pulse"+last_step,0,osc_init_time);
        step => last_step;
    }


    public static void osc_note(int channel){
        osc_note(channel, 1);
        50::ms =>now;
        osc_note(channel, 0);
        10::ms => now;
    }
        
    public static void osc_note(int channel, int state){
        spork ~ _osc_note(channel, state);
    }

    
    public static void _osc_note(int channel, int state){
        (channel % 4) + 1 => channel;
        osc_send("/page1/activityCh"+channel, state);
    }

    public static void osc_trigger(int trigger){
        spork ~ _osc_trigger(trigger, 1);
        200::ms => now;
        spork ~ _osc_trigger(trigger, 0);
        100::ms => now;
    }
    public static void osc_trigger(int trigger, int state){
        spork ~ _osc_trigger(trigger, state);
    }

    
    public static void _osc_trigger(int trigger, int state){
        return;
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
    
    public static void osc_clear_pulse(){
        for(1=>int i; i<=9; i++){
            osc_send("/page1/pulse"+i,0, osc_init_time);
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
            osc_send("/page1/muteCh"+i,mutes[i-1],osc_init_time);
        }
        for(1=>int i; i<=8; i++){
            osc_send("/page1/muteTr"+i,mutes[i+3],osc_init_time);
        }
    }        
        
    public static void osc_send_all(){
        osc_clear_pulse();
        20::ms => now;
        osc_send_labels();
        20::ms => now;
        osc_send_faders();
        20::ms => now;
        osc_send_globals();
        20::ms => now;
        osc_send_part();
        20::ms => now;
        osc_clear_activity();
        20::ms => now;
        osc_send_mutes();
    }

    
    
    public static void osc_listen(){
        OscIn oin;
        8000 => oin.port;
        oin.listenAll();
        
        OscMsg msg;
        
        while(true){
            string address;
            int handled;
            float value;
            oin => now;
            int pressed_part;
            while(oin.recv(msg)){
                false => handled;
                msg.address => address;
                msg.getFloat(0) => value;
                if(!handled){
                    for(1=>int i; i<=9; i++){
                        if(address == "/page1/part"+i){
                            i - 1 => pressed_part;
                            //if(part != pressed_part ){
                                pressed_part => next_part;
                                //<<<pressed_part>>>;
                            //}
                            //osc_send_part();
                            //1::ms => now;
                            true => handled;
                        }
                    }
                    
                }
                if(!handled){
                    for(1=>int i; i<=6; i++){
                        if(address == "/page1/global"+i){
                            value => globals[i-1];
                            true => handled;
                        }
                    }
                    
                }
                if(!handled){
                    for(1=>int i; i<=4; i++){
                        if(address == "/page1/faderCh"+i){
                            value => ind[i-1];
                            true => handled;
                        }
                    }
                    
                }
                if(!handled){
                    for(1=>int i; i<=8; i++){
                        if(address == "/page1/faderTr"+i){
                            value => ind[i+3];
                            true => handled;
                        }
                    }
                }
                
                if(!handled){
                    for(1=>int i; i<=4; i++){
                        if(address == "/page1/muteCh"+i){
                            value$int => mutes[i-1];
                            true => handled;
                        }
                    }
                    
                }
                if(!handled){
                    for(1=>int i; i<=8; i++){
                        if(address == "/page1/muteTr"+i){
                            value$int => mutes[i+3];
                            true => handled;
                        }
                    }
                    
                }
                if(!handled){
                    <<<"unhandled: " + address + "   " + value>>>;
                }
            }
        }
    }
}

Global dummy;

1::week => now;
