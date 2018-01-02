MidiMsg midimessage;
MidiOut midiport;
midiport.open(1);

midi_clock_start();


while(true){
    midi_clock_tick();
    20::ms => now;
}



/*
fun void send_2bytes(MidiOut port, int command, int channel, int byte1)
{
    if(keyboardInput == -1){
        return;
    }
	((command & 0x0f) << 4) | ((channel - 1) & 0xf) => midimessage.data1;
	byte1 & 0x7f => midimessage.data2;
	port.send(midimessage);
}
*/

fun void midi_clock_start(){
    250 => midimessage.data1;
    midiport.send(midimessage);
}

fun void midi_clock_tick(){
    248 => midimessage.data1;
    midiport.send(midimessage);
}