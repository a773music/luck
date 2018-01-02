# Luck

Live environment written in ChucK
* Working with generative sequencing
* Sound generating handled in eurorack (through cv.ocd)
* Interfacing handled by TouchOSC

## Usage
A project is the equivalent of a "song" or a "track" and consists of:
* 4 monophonic melodic channels
* 8 triggers
* 9 parts, each with mute and an assignable slider
* 6 global values with sliders

To load a project do
```
cd projects/some_project
chuck ../../lib/*.ck init.ck
```
You might want to automate this in a bash script or similar