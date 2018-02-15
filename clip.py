#!/usr/bin/python2
import threading, datetime, os, time, random
from globals import *
from timer import * 
from midi import *
from touch_osc import *




class clip(threading.Thread):
    global count, running

    ok = False
    running = False
    channel = 0
    midi_channel = 0

    playing_note = -1
    
    def __init__(self, file_name):
        threading.Thread.__init__(self)
        self.part = g.file_name2part(file_name)
        self.channel = g.file_name2channel(file_name)
        self.midi_channel = g.channel2midi_channel(self.channel)
        self.note = g.file_name2note(file_name)
        if os.path.isfile(file_name):
            self.file_name = file_name
            self.ok = True
        else:
            self.file_name = None
            print('missing file: ' + file_name)
        if os.path.isfile('_' + file_name):
            self.stop_file = '_' + file_name
        else:
            self.stop_file = None

            
    def on(self, note=-1, midi_channel=-1):
        if midi_channel == -1:
            midi_channel = self.midi_channel
        if note == -1:
            note = self.note

        if self.playing_note != -1:
            m.note_off(midi_channel, note)
        if not g.mutes[self.channel]:
            m.note_on(midi_channel, note)
            g.activity[self.channel] = 1
        self.playing_note = note
        
    def run(self):
        if self.file_name:
            self.running = True
            execfile(self.file_name)
            self.running = False
            
    def quit(self):
        self.running = False
        self._Thread__stop()
        if self.stop_file:
            execfile(self.stop_file)


    def debug(self):
        print 'clip, file_name: ' + self.file_name + ', channel: ' + str(self.channel) + ', note: ' + str(self.note)
            
