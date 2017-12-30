public class Keyboard{
    //new timeEvent @=> static timeEvent @ tick;

    new Hid @=> static Hid @ hi;
    new HidMsg @=> static HidMsg @ msg;

    open_keyboard();
    spork ~ listen();



    public static void open_keyboard(){
        1 => int kb_dev;
        
        if( !hi.openKeyboard(kb_dev) ) me.exit();
        <<< "keyboard '" + hi.name() + "' ready", "" >>>;
    }
    
    
    public static void listen(){
        <<<"inside listen">>>;

        
        while(true) {
            // wait on event
            hi => now;
            
            // get one or more messages
            while(hi.recv(msg)){
                // check for action type
                if(msg.isButtonDown()){
                    <<< "down:", msg.which, "(code)", msg.key, "(usb key)", msg.ascii, "(ascii)" >>>;
                }
                else {
                    <<< "up:", msg.which, "(code)", msg.key, "(usb key)", msg.ascii, "(ascii)" >>>;
                }
            }
        }
        
    }
    
}

Keyboard dummy;

100::week => now;