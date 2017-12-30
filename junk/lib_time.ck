public class Time
{

    120 => static float bpm;

    fun static dur beat()
    {
        return beat(1);
    }
    
    fun static dur beat(float nb_beats)
    {
        return nb_beats * 1::second * 60 / bpm;
    }
    

    fun static void sync()
    {
        sync(1);
    }
    
        fun static void sync(int beats)
    {
        beat(beats) - (now % beat(beats)) => now;
    }

}

Time T;
1::week => now;