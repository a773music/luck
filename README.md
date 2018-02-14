# Luck

Live environment written in python
* Working with generative sequencing
* Sound generating handled in eurorack (through cv.ocd)
* Interfacing handled by TouchOSC

## Prerequisites
run
```
./install_dependencies
```


## Usage
A project is the equivalent of a "song" or a "track" and consists of:
* 8 monophonic melodic channels
* 16 triggers
* 9 parts, each with mute and an assignable slider
* 6 global values with sliders

To load a project do
```
luck project_path
```
You might want to symlink luck and unluck to your ~/bin folder