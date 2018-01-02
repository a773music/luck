public class Array {

    [0.] @=> float elements[];
    
    elements.clear();

    public void append(float append_me){
        size() +1 => elements.size;
        append_me => elements[size()-1];
    }

    public void append(int append_me){
        append(append_me$float);
    }

    public void append(float append_me[]){
        for(0=>int i; i<append_me.size();i++){
            append(append_me[i]);
        }
    }

    public void append(int append_me[]){
        for(0=>int i; i<append_me.size();i++){
            append(append_me[i]);
        }
    }

    public void set(int new_elements[]){
        elements.clear();
        append(new_elements);
    }

    public void set(float new_elements[]){
        elements.clear();
        append(new_elements);
    }
    
    public float get(int id){
        1000000 * size() => int safety_offset;
        return elements[(id + safety_offset) % size()];
    }

    public float[] get_all(){
        return elements;
    }
    
    public void reverse(){
        [0.] @=> float tmp[];
        size() => tmp.size;
        for(0 => int i; i<size(); i++){
            elements[i] => tmp[i];
        }
        for(0 => int i; i<size(); i++){
            tmp[i] => elements[size() - i -1];
        }
    }

    public float min(){
        100000000000 => float result;
        for(0 => int i; i<size(); i++){
            if(elements[i] < result){
                elements[i] => result;
            }
        }
        return result;
    }
        
    public float max(){
        -100000000000 => float result;
        for(0 => int i; i<size(); i++){
            if(elements[i] > result){
                elements[i] => result;
            }
        }
        return result;
    }

    public void swap(int a, int b){
        float tmp;
        elements[a] => tmp;
        elements[b] => elements[a];
        tmp => elements[b];
    }
    
    public void sort(){
        float tmp;
        for(0=>int i; i<size(); i++){
            for(0=>int j; j<size()-1; j++){
                if(elements[j] > elements[j+1]){
                    swap(j, j+1);
                }
            }
        }
    }

    public void add(float value){
        for(0=>int i; i<size(); i++){
            elements[i] + value => elements[i];
        }
    }
    
    public void multiply(float value){
        for(0=>int i; i<size(); i++){
            elements[i] * value => elements[i];
        }
    }

    public int search(float needle){
        for(0=>int i; i<size(); i++){
            if(elements[i] == needle){
                return i;
            }
        }
        return -1;
    }

    public int contains(float needle){
        if(search(needle) == -1){
            return false;
        }
        return true;
    }


    public void replace(int id, float value){
        1000000 * size() => int safety_offset;
        value => elements[(id + safety_offset) % size()];
    }
    
    public void invert(){
        if(size() < 1){
            return;
        }
        min() => float old_min;
        multiply(-1);
        add(old_min - min());
    }

    
    public float pop_last(){
        elements[size()-1] => float result;
        size() -1 => elements.size;
        return result;
    }

    public float pop_first(){
        elements[0] => float result;
        rotate(-1);
        size() -1 => elements.size;
        return result;
    }

    public void rotate(){
        rotate(1);
    }
    
    public void rotate(int steps){
        1000000 * size() => int safety_offset;
        [0.] @=> float tmp[];
        size() => tmp.size;
        for(0=>int i; i<size(); i++){
            elements[i] => tmp[i];
        }
        for(0=>int i; i<size(); i++){
            tmp[i] => elements[(i + steps + safety_offset) % size()];
        }


}    
    
        

    public int size(){
        return elements.size();
    }

    public void print(){
        <<<"--- Array content ---">>>;
        for(0=>int i; i<size(); i++){
            <<<i + ":" + elements[i]>>>;
        }
        <<<"---------------------">>>;
    }


    public float random(){
        return elements[Std.rand2(0,elements.size()-1)];
    }
    

    

    // ----------------------------------------
    // old functions
    // ----------------------------------------

    public float quantize(float input){
        // FIXME: needs tesing
        128 => float best_distance;
        float this_distance;
        0 => float best;
        float try;
        for(0=>int i; i<11; i++){
            for(0=>int j; j<size(); j++){
                (elements[j]+i*12) => try;
                Std.fabs(try - input) => this_distance;
                if(this_distance < best_distance){
                    this_distance => best_distance;
                    try => best;
                }
            }
        }
        return best;
    }

    
    public float next_in_scale(float current, int direction){
        // FIXME: needs tesing
        float try;
        int octave;
        
        if(direction > 0){
            0 => try;
            while(try < current){
                for(0=>octave; octave < 10; octave++){
                    for(0=>int i; i< size(); i++){
                        elements[i] + (octave * 12) => try;
                        if(try > current){
                            return try;
                        }
                    }
                    
                }
            }
        }
        else {
            200 => try;
            while(try > current){
                for(10=>octave; octave > 0; octave--){
                    for(size()-1 => int i; i>=0; i--){
                        elements[i] + (octave * 12) => try;
                        if(try < current){
                            return try;
                        }
                    }
                    
                }
            }
        }
    }    

        
    public static int [] array_merge(int a1[], int a2[]){
        // FIXME: needs reworking to OOP
        int result[a1.cap() + a2.cap()];
    
        0 => int j;
    
        for(0=>int i;i<Math.max(a1.cap(),a2.cap());i++){
            if(i<a1.cap()){
                a1[i] => result[j];
                j++;
            }
            if(i<a2.cap()){
                a2[i] => result[j];
                j++;
            }
       
        }
        return result;
    }

    function int [] array_merge(int a1[]){
        // FIXME: needs reworking to OOP
        return array_merge(a1,a1);
    }
    
}


10::week => now;