public class game_of_life {
    [[0]] @=> int elements[][];

    0 => int wrap_around;
    
    public int get_size_y(){
        return elements.size();
    }

    public int get_size_x(){
        if(get_size_y() == 0){
            return 0;
        }
        return elements[0].size();
    }
    
    public void print(){
        string str;
        <<<"printing elements with dimension " + get_size_x() + "x" + get_size_y()>>>;
        for(0 => int i; i<get_size_y(); i++){
            for(0 => int j; j<elements[i].size(); j++){
                str + elements[i][j] => str;
            }
            <<<str>>>;
            "" => str;
        }
            
    }

    
    public void init(int dimension_x, int dimension_y){
        elements.clear();
        dimension_y => elements.size;
        for(0=>int i; i<dimension_y; i++){
            [0] @=> elements[i];
            dimension_x => elements[i].size;
        }
    }


    public void random(){
        random(.5);
    }

    public void random(float density){
        for(0 => int i; i<elements.size(); i++){
            for(0 => int j; j<elements[i].size(); j++){
                if(Std.rand2f(0,1) < density){
                    1 => elements[i][j];
                }
                else {
                    0 => elements[i][j];
                }
                    
            }
        }
        
    }


    public void set(int x, int y, int state){
        // make sure state is either 0 or 1
        if(state != 0) 1 => state;

        // check if requested position is out of bounds
        if(x >= get_size_x() || y >= get_size_y()){
            <<<"in set: x ("+x+") or y("+y+") is out of bounds...">>>;
            return;
        }

        // everythings fine, set the state
        state => elements[y][x];
    }

    public int get(int x, int y){
        // TODO: automatically wrap out of bounds x and y to grid
        // check if requested position is out of bounds
        if(x >= get_size_x() || y >= get_size_y()){
            <<<"in get: x ("+x+") or y("+y+") is out of bounds...">>>;
            return -1;
        }

        // everythings fine, set the state
        return elements[y][x];
    }

    public int count_neighbours(int x, int y){
        int count;
        int local_x, local_y;
        //<<<"in count_neighbours, x:" + x + ", y:" + y>>>;
        for(-1 => int x_offset; x_offset<=1; x_offset++){
            for(-1 => int y_offset; y_offset<=1; y_offset++){
                if(x_offset !=0 || y_offset != 0){
                    if(!wrap_around && ((x_offset == -1 && x == 0) || (x_offset == 1 && x == get_size_x() -1) || (y_offset == -1 && y == 0) || (y_offset == 1 && y == get_size_y() -1))) {
                        //<<<"disregarding wrap-around neighbours">>>;
                    }
                    else {
                        //<<<"x_offset:" + x_offset + ", y_offset:" + y_offset>>>;
                        (x + x_offset + get_size_x())%get_size_x() => local_x;
                        (y + y_offset + get_size_y())%get_size_y() => local_y;
                    
                        count + get(local_x,local_y) => count;
                    }
                }
            }
        }
        //<<<"x:" + x + ", y:" + y + ", neighbours: " + count>>>;
        return count;
    }
    
    public void evolve(){
        /*
        For a space that is 'populated':
        Each cell with one or no neighbors dies, as if by solitude.
        Each cell with four or more neighbors dies, as if by overpopulation.
        Each cell with two or three neighbors survives.

        For a space that is 'empty' or 'unpopulated'
        Each cell with three neighbors becomes populated. 
        */

        int nb_neighbours;
        
        // create + init tmp
        [[0]] @=> int tmp[][];
        tmp.clear();
        get_size_y() => tmp.size;
        for(0=>int i; i<tmp.size(); i++){
            [0] @=> tmp[i];
            get_size_x() => tmp[i].size;
        }

        // copy elements to tmp
        for(0 => int i; i<elements.size(); i++){
            for(0 => int j; j<elements[i].size(); j++){
                elements[i][j] => tmp[i][j];
            }
        }


        for(0 => int y; y<tmp.size(); y++){
            for(0 => int x; x<tmp[y].size(); x++){
                count_neighbours(x,y) => nb_neighbours;
                if(get(x,y)){
                    if(nb_neighbours == 2 || nb_neighbours == 3){
                        set(x,y,1); // survives
                    }
                    else {
                        set(x,y,0); // dies, solitude or overpopulation
                    }
                        
                }
                else {
                    if(nb_neighbours == 3){
                        set(x,y,1); // populate
                    }
                    else {
                        set(x,y,0); // stay empty
                    }
                }
            }
        }
    }


    public void get_row(int row){
        //TODO: get row as array
    }    
    
    public void get_collumn(int collumn){
        //TODO: get collumn as array
    }    
}

/*
game_of_life gol;
gol.init(20,20);

gol.random();
gol.print();

while(true){
    .01::second => now;
    gol.evolve();
    gol.print();
}
*/

1::week => now;
