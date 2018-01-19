public class Time {
    60 => static float tempo;

    static int i;
    
    public static void wait(){
        wait(1.);
    }
    
    public static void wait(float beats){
        if(beats == 0){
            1. => beats;
        }
        beat(beats) => dur T;
        T - (now % T) => now;
        .01::ms => now;
    }

    public static void early_wait(float beats){
        if(beats == 0){
            1. => beats;
        }
        beat(beats) => dur T;
        (T - (now % T)) => now;
        .00001::ms => now;
    }


    public static int sub(){
        return sub(1.);
    }

    public static int sub(float beats){
        if(beats == 0){
            1. => beats;
        }
        return (now / beat(beats)) $ int;
    }
    

    public static dur beat(){
        return beat(1.);
    }
    
    public static dur beat(float beats){
        if(beats == 0){
            1. => beats;
        }
        return 60::second / tempo * beats;
    }

}

Time dummy;

1::week => now;