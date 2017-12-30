public class Midi {
    5 => static int default_device; // FIXME 1 or 5, must autoset
    1 => static int default_channel;

    [0,0,0,0, 0,0,0,0] @=> static int triggers_on[];
    [-1,-1,-1,-1] @=> static int notes_on[];

    
    0 => static int debug;

    static int keyboardInput;
    
    new MidiMsg @=> static MidiMsg @ midimessage;
    new MidiOut @=> static MidiOut @ midiport;
    //new MidiOut @=> static MidiOut @ bcrMidiOut;
    //"BCR2000 MIDI 1" @=> static string portName;

    deviceName2Id("MIDIMATE II MIDI 1") => default_device;
    //deviceName2Id("BCR2000 MIDI 2") => keyboardInput;
    midiport.open(default_device);
    //bcrMidiOut.open(keyboardInput);


    public static int deviceName2Id(string portName){
        //"BCR2000 MIDI 1" => string portName;
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
		port.send(midimessage);
	}

    

    /*
    public static void micronPgm(int bank, int program){
        default_channel => int channel;
        send_3bytes(bcrMidiOut, 11, channel, 0, 0);
        send_3bytes(bcrMidiOut, 11, channel, 32, bank);
        send_2bytes(bcrMidiOut, 12, channel, program);
    }
    */

    /*
    public static void micronAllNotesOff(){
        for(0 => int i; i< 128; i++){
            micronNote(i,0);
        }
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


    public static void note_on(float note, int channel, dur length){
        note_on(note, channel);
        length => now;
        note_off(channel);
    }

    
    public static void note_on(float note, int channel){
        Math.max(0,note)$int => int my_note;
        //(channel + 1)% 4 => channel;
        if(notes_on[channel] >= 0){
            note_off(channel);
            1::ms => now;
        }
        send_note(my_note, 127, channel);
        my_note => notes_on[channel];
    }

    public static void note_off(int channel){
        //(channel + 1)% 4 => channel;
        if(notes_on[channel]>=0){
            send_note(notes_on[channel], 0, channel);
            -1 => notes_on[channel];
        }
    }

    
    
    public static void _trigger(int trigger_nb, dur length){
        trigger_nb % 8 => trigger_nb;
        if(triggers_on[trigger_nb] == 1){
            send_note(trigger_nb + 36, 0, 9);
            1::ms=>now;
        }
        send_note(trigger_nb + 36, 127, 9);
        1 => triggers_on[trigger_nb];
        length => now;

        if(triggers_on[trigger_nb] == 1){
            send_note(trigger_nb + 36, 0, 9);
        }
        0 => triggers_on[trigger_nb];
    }

    public static void trigger(int trigger_nb){
        trigger(trigger_nb, 10::ms);
    }
    public static void trigger(int trigger_nb, dur length){
        spork ~ _trigger(trigger_nb, length);
    }

    
}

Midi dummy;

10::week => now;