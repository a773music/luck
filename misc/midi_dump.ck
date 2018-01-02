MidiIn midi_in;
MidiMsg midi_msg;

1 => int keyboard_device;

int channel, row;
int event_channel, event_type;

int type;
if(!midi_in.open(keyboard_device)){
    <<<"couldnt open", keyboard_device>>>;
    me.exit();
}
while(true){
    midi_in => now;
    while(midi_in.recv(midi_msg)){
        <<<"-----------------">>>;
        <<<now/second>>>;
        <<<midi_msg.data1>>>;
        <<<midi_msg.data2>>>;
        <<<midi_msg.data3>>>;
    }
}