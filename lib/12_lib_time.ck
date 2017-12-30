public class Time {
    60 => static float tempo;
    
    public static void wait(float beats){
        beat(beats) => dur T;
        T - (now % T) => now;
        .01::ms => now;
        
    }


    public static int sub(float beats){
        return (now / beat(beats)) $ int;
    }
    

    public static dur beat(){
        return beat(1);
    }
    
    public static dur beat(float beats){
        return 60::second / tempo * beats;
    }

}

Time dummy;

1::week => now;