public class Global {
    8 => static int part_sync;
    8 => static int beats_pr_bar;


    ["192.168.0.5"] @=> static string osc_remote_host[];
    9000 @=> static int osc_remote_port;

    [[0.]] @=> static float scales[][];
    scales.clear();
    
    0 => static int part;
    -1=> static int next_part;
    -1 => static int part_id;
    static int next_part_blink;
    0 => static int last_step;
    24 => static int nb_pulses;
    
    8 => static int nb_melodic_channels;
    
    [
    -1,-1,-1,-1,-1,-1,-1,-1,
    -1,-1,-1,-1,-1,-1,-1,-1,
    -1,-1,-1,-1,-1,-1,-1,-1] @=> static int track_ids[];
    
    10::ms => static dur osc_init_time;
    
    
    // labels for global sliders
    [
    "","","",
    "","",""
    ] @=> static string sliders[];

    // labels for track aka track names
    [
    "","","","","","","","",
    "","","","","","","","",
    "","","","","","","",""
    ] @=> static string tracks[];

    // labels for parts
    [
    "","","",
    "","","",
    "","",""
    ] @=> static string parts[];

    
    [
    .5, .5, .5, .5, .5, .5, .5, .5,
    .5, .5, .5, .5, .5, .5, .5, .5,
    .5, .5, .5, .5, .5, .5, .5, .5] @=> static float ind[];

    [.5, .5, .5, .5, .5, .5] @=> static float globals[];
    
    [0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0] @=> static int mutes[];

    
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


    public static float quantize(float input, string scale){
        if(scales[scale] == null){
            <<<"no scale named '" + scale + "'">>>;
            return -1.;
        }

        128 => float best_distance;
        float this_distance;
        0 => float best;
        float try;
        for(0=>int i; i<11; i++){
            for(0=>int j; j<scales[scale].cap(); j++){
                scales[scale][j]+i*12 => try;
                Std.fabs(try - input) => this_distance;
                if(this_distance < best_distance){
                    this_distance => best_distance;
                    try => best;
                }
            }
        }
        return best;
    }
    

    
    // -----------------------------------------------------
    // setters and getters
    // -----------------------------------------------------
    /*
    public static float ind(int i){
        return ind[i];
    }

    public static float ind(int i, float value){
        value => ind[i];
        return 1.;
    }
    */
    
    /*
    public static float ind_ch(int i){
        return ind[i%nb_melodic_channels];
    }

    public static float ind_ch(int i, float value){
        value => ind[i%nb_melodic_channels];
        return 1.;
    }
      */  



    
    // -----------------------------------------------------
    // mutes
    // -----------------------------------------------------

    public static void mute(string name, int state){
        <<<"muting with name: " + name>>>;
        <<<Array.search(name, tracks)%mutes.size()>>>;
        state => mutes[Array.search(name, tracks)%mutes.size()];
    }


    public static void mute(string names[], int state){
        for(0=>int i; i<names.size(); i++){
            mute(names[i], state);
        }
    }


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
        part_nb % parts.size() => part_nb;
        return parts[part_nb];
    }
    
    private static string track_name(int track_nb){
        track_nb % tracks.size() => track_nb;
        return tracks[track_nb];
    }
    
    private static void next_part_blinker(){
        while(true){
            !next_part_blink => next_part_blink;
            osc_send("/page1/part"+(next_part) ,next_part_blink,osc_init_time);
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
        OscOut xmit;
        xmit.dest(osc_remote_host[0], osc_remote_port);
        xmit.start(address);
        value => xmit.add;
        xmit.send();
    }

    public static void osc_send(string address, float value, dur rest_time){
        osc_send(address, value);
        rest_time => now;
    }

    public static void osc_send(string address, string value){
        OscOut xmit;
        xmit.dest(osc_remote_host[0], osc_remote_port);
        xmit.start(address);
        value => xmit.add;
        xmit.send();
    }

    public static void osc_send(string address, string value, dur rest_time){
        osc_send(address, value);
        rest_time => now;
    }
    
    public static void osc_send_labels(){
        for(0=>int i; i<sliders.size(); i++){
            osc_send("/page1/labelGl"+i,sliders[i],osc_init_time);
        }
        for(0=>int i; i<tracks.size(); i++){
            osc_send("/page1/labelTr"+i,tracks[i],osc_init_time);
        }
        for(0=>int i; i<parts.size(); i++){
            osc_send("/page1/labelPart"+i,parts[i],osc_init_time);
        }
}
    

    public static void osc_send_part(){
        for(0=>int i; i<parts.size(); i++){
            if((i != next_part) &&(i != part)){
                osc_send("/page1/part"+i,0,osc_init_time);
            }
        }
        osc_send("/page1/part"+part,1,osc_init_time);
    }


    public static void osc_pulser(){
        while(true){
            _osc_pulse(Time.sub(1));
            Time.wait(1);
        }
    }
    
    public static void _osc_pulse(int step){
        ((step % beats_pr_bar) % 9)=> step;
        osc_send("/page1/pulse"+step,1,osc_init_time);
        osc_send("/page1/pulse"+last_step,0,osc_init_time);
        step => last_step;
    }


    public static void osc_note(int channel, int state){
        osc_note(channel, state);
        50::ms =>now;
    }        
    public static void osc_note(int channel){
        osc_note(channel, 0);
        osc_note(channel, 1);

    }

    /*
    public static void osc_note(int channel, int state){
        spork ~ _osc_note(channel, state);
    }
    */
    
    public static void osc_activity(int track, int state){
        (track % tracks.size()) => track;
        osc_send("/page1/activityTr"+track, state);
        200::ms => now;
    }

    public static void osc_activity(int track){
        osc_activity(track, 1);
        osc_activity(track, 0);
    }


    public static void osc_clear_activity(){
        for(0=>int i; i<tracks.size(); i++){
            osc_send("/page1/activityTr"+i, 0,osc_init_time);
        }
    }
    
    public static void osc_clear_pulse(){
        for(1=>int i; i<nb_pulses; i++){
            osc_send("/page1/pulse"+i,0, osc_init_time);
        }
        
    }
    
    public static void osc_send_faders(){
        for(0=>int i; i<tracks.size(); i++){
            osc_send("/page1/fader"+i,ind[0],osc_init_time);
        }
    }
    
    public static void osc_send_globals(){
        for(0=>int i; i<globals.size(); i++){
            osc_send("/page1/global"+i,globals[i],osc_init_time);
        }
    }

    public static void osc_send_mutes(){
        for(0=>int i; i<mutes.size(); i++){
            osc_send("/page1/mute"+i,mutes[i],osc_init_time);
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
        20::ms => now;
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
                    for(0=>int i; i<parts.size(); i++){
                        if(address == "/page1/part"+i){
                            i => pressed_part;
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
                    for(0=>int i; i<globals.size(); i++){
                        if(address == "/page1/global"+i){
                            value => globals[i];
                            true => handled;
                        }
                    }
                    
                }
                if(!handled){
                    for(0=>int i; i<=tracks.size(); i++){
                        if(address == "/page1/fader"+i){
                            value => ind[i];
                            true => handled;
                        }
                    }
                    
                }
                
                if(!handled){
                    for(0=>int i; i<mutes.size(); i++){
                        if(address == "/page1/muteCh"+i){
                            value$int => mutes[i];
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
