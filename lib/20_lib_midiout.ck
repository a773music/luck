public class Midi {
    0 => static int debug;

    -1 => static int default_device; // FIXME 1 or 5, must autoset
    1 => static int default_channel;

    [
    0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0
    ] @=> static int triggers_on[];
    [
    -1,-1,-1,-1,
    -1,-1,-1,-1
    ] @=> static int notes_on[];

    7 => static int auto_trigger_nb;
    1/4. => static float auto_trigger_wait;

    static int keyboardInput;
    
    new MidiMsg @=> static MidiMsg @ midimessage;
    new MidiOut @=> static MidiOut @ midiport;
    
    deviceName2Id("MIDIMATE II MIDI 1") => default_device;
    midiport.open(default_device);
    

    if(default_device >= 0){
        spork ~ midi_clock(midiport);
    }

    spork ~ auto_trigger();
    
    public static int deviceName2Id(string portName){
        int success;
        for(0=>int i; i<10; i++){
            midiport.open(i) => success;
            if(midiport.name() == portName){
                //midiport.close();
                return i;
            }
            else {
                //midiport.close();
                
            }
        }
        <<<"no port named:" + portName>>>;
        //Me.exit;
        return - 1;
        
    }

    public static void reset(){
        for(0 => int i; i <= 127; i++){
            controller(i,0);
        }
    }
    
    public static void controller(int controllernum, int value){
        controller(controllernum, value, default_channel);
    }
    
    public static void controller(int controllernum, int value, int channel){
	    send_3bytes(0xb, channel, controllernum, value);
    }

    public static void send_3bytes(int command, int channel, int byte1, int byte2){
        send_3bytes(midiport, command, channel, byte1, byte2);
}
    public static void send_3bytes(MidiOut port, int command, int channel, int byte1, int byte2){
        if(default_device == -1){
            return;
        }
	    ((command & 0xf) << 4) | ((channel - 1) & 0xf) => midimessage.data1;
	    command | channel => command;
	    byte1 & 0x7f  => midimessage.data2;
        if(byte2 != -1){
	        byte2 & 0x7f => midimessage.data3;
        }
        if(debug){
            <<<"Sending midi out...">>>;
            <<<"data1:"+ midimessage.data1>>>;
            <<<"data2:"+ midimessage.data2>>>;
            <<<"data3:"+ midimessage.data3>>>;
        }
	    port.send(midimessage);
        
    }


    public static void send_2bytes(int command, int channel, int byte1){
        send_2bytes(midiport, command, channel, byte1);
    }
    
    public static void send_2bytes(MidiOut port, int command, int channel, int byte1)
	{
        if(keyboardInput == -1){
            return;
        }
		((command & 0x0f) << 4) | ((channel - 1) & 0xf) => midimessage.data1;
		byte1 & 0x7f => midimessage.data2;
        if(debug){
            <<<"Sending midi out...">>>;
            <<<"data1:"+ midimessage.data1>>>;
            <<<"data2:"+ midimessage.data2>>>;
            <<<"data3:"+ midimessage.data3>>>;
        }
		port.send(midimessage);
	}

    public static void midi_clock(MidiOut port){
        midi_clock_stop(port);
        midi_clock_start(port);
        while(true){
            midi_clock_tick(port);
            Time.wait(1/24.);
        }
    }
    

    public static void auto_trigger(){
        while(true){
            if(auto_trigger_nb > -1){
                spork ~ Midi.trigger(auto_trigger_nb + Global.nb_melodic_channels,10::ms,0);
            }
            Time.wait(auto_trigger_wait);
        }
    }
    

    
    public static void midi_clock_start(MidiOut port){
        if(debug){
            <<<"sending midi clock start">>>;
        }
        250 => midimessage.data1;
        0 => midimessage.data2;
        0 => midimessage.data3;
        midiport.send(midimessage);
    }
    
    public static void midi_clock_stop(MidiOut port){
        if(debug){
            <<<"sending midi clock stop">>>;
        }
        252 => midimessage.data1;
        0 => midimessage.data2;
        0 => midimessage.data3;
        midiport.send(midimessage);
    }
    
    public static void midi_clock_tick(MidiOut port){
        if(debug){
            <<<"sending midi clock tick">>>;
        }
        248 => midimessage.data1;
        0 => midimessage.data2;
        0 => midimessage.data3;
        midiport.send(midimessage);
    }    
    

    /*
    public static void micronPgm(int bank, int program){
        default_channel => int channel;
        send_3bytes(bcrMidiOut, 11, channel, 0, 0);
        send_3bytes(bcrMidiOut, 11, channel, 32, bank);
        send_2bytes(bcrMidiOut, 12, channel, program);
    }
    */
    
    public static void send_note(int note, int velocity, int channel){
        channel + 1 => channel;
        int command;
        Math.min(127,velocity)$int => velocity;
        if(velocity > 0){
            9 => command; //noteon
        }
        else {
            8 => command; //noteoff
        }
        //<<<"sending note:" + note + ", velocity:" + velocity + ", channel:" + channel>>>;
        send_3bytes(midiport, command, channel, note, velocity);
    }


    public static void note(float note, string channel_name, dur length){
        note_on(note, channel_name);
        length => now;
        note_off(channel_name);
    }

    
    public static void note_on(float note, string channel_name){
        if(!channel_name.length()) return;
        Array.search(channel_name,Global.tracks) => int ch;
        if(ch<0){
            <<<"Midi.note_on: no fader with name '" +channel_name+"'">>>;
            return;
        }
        
        if(Global.mutes[ch]) return;
        //<<<"activity ch:" + ch>>>;
        spork ~ Global.osc_activity(ch);
        Math.max(0,note)$int => int my_note;
        if(notes_on[ch] >= 0){
            note_off(channel_name);
            1::ms => now;
        }
        send_note(my_note, 127, ch);
        //Global.osc_activity(ch);
        my_note => notes_on[ch];
    }

    public static void note_off(string channel_name){
        if(!channel_name.length()) return;
        Array.search(channel_name,Global.tracks) => int ch;
        if(ch<0){
            <<<"Midi.note_on: no fader with name '" +channel_name+"'">>>;
            return;
        }
        
        if(notes_on[ch]>=0){
            send_note(notes_on[ch], 0, ch);
            //Global.osc_activity(ch,0);
            -1 => notes_on[ch];
        }
    }

    
    public static void _trigger(string trigger_name, dur length, int allow_mute){
        if(!trigger_name.length()) return;
        Array.search(trigger_name,Global.tracks) => int track;
        if(track<0){
            <<<"Midi._trigger: no track with name '" +trigger_name+"'">>>;
            return;
        }

        _trigger(track, length, allow_mute);
    } 
    
    public static void _trigger(int track, dur length, int allow_mute){
        // actual trigger function
        track % Global.tracks.size() => track;
        track - Global.nb_melodic_channels => int trigger;
        if(allow_mute && Global.mutes[track]){
            return;
        }

        if(allow_mute) spork ~ Global.osc_activity(track);
        //<<<"a, track:" + track + ",trigger:" + trigger>>>;
        if(triggers_on[trigger] == 1){
            send_note(trigger + 36, 0, 9);
            //Global.osc_activity(trigger_name,0);
            1::ms=>now;
        }
        send_note(trigger + 36, 127, 9);
        //Global.osc_activity(trigger_name,1);
        1 => triggers_on[trigger];
        length => now;

        if(triggers_on[trigger] == 1){
            send_note(trigger + 36, 0, 9);
            //Global.osc_activity(trigger_name,0);
            
        }
        0 => triggers_on[trigger];
    }

    public static void trigger(string trigger_name){
        trigger(trigger_name, 10::ms);
        200::ms => now; // let live
    }
    
    public static void trigger(string trigger_name, dur length){
        trigger(trigger_name, length, 1);
        200::ms => now; // let live
    }
    
    public static void trigger(string trigger_name, dur length, int allow_mute){
        _trigger(trigger_name, length, allow_mute);
        200::ms => now; // let live
        
    }

    public static void trigger(int track, dur length, int allow_mute){
        _trigger(track, length, allow_mute);
        200::ms => now; // let live
        
    }

    
}

Midi dummy;

10::week => now;