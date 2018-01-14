"rings" => string ch;

int i;
5 => int octave;


while(true){
    Global.get_fader(ch) * 2 + 1 => float scale;
    (Global.globals[1] -.5) * 24 => float offset;

    Time.sub(.25)% (Global.beats_pr_bar * 4) => int tic;
    Global.scales["rings_seq"][i % (Global.beats_pr_bar * 4) % Global.scales["rings_seq"].size()] => float note;

    note * scale => note;
    note + offset => note;

    Global.quantize(note,"rings_b") => note;
    spork ~ Midi.note(note + octave * 12, ch, 100::ms);

    i++;
    Time.wait(1);
}