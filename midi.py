#!/usr/bin/python2
import rtmidi, time

from globals import *

class midi(object):
    # singleton
    _instance = None

    out = rtmidi.MidiOut()
    port_name = ''
    
    def __new__(cls, *args, **kwargs):
        if not cls._instance:
            cls._instance = super(midi, cls).__new__(
                                cls, *args, **kwargs)
        return cls._instance

    def open_by_name(self, name):
        i = 0
        for port in self.out.get_ports():
            if port[:len(name)] == name:
                break
            i = i + 1
        self.out.open_port(i)

    def note_on(self, channel, note, velocity=127):
        note_on = [0x90+channel, note, velocity]
        self.out.send_message(note_on)        
        
    def note_off(self, channel, note):
        note_off = [0x80+channel, note, 0]
        self.out.send_message(note_off)
        
    def __init__(self, name=''):
        if name != '':
            self.port_name = name
            self.open_by_name(self.port_name)

            

m = midi(g.midi_port_name)
