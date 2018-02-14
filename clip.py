#!/usr/bin/python2
import threading, datetime, os, time, random
from globals import *
from timer import * 
from midi import *

class clip(threading.Thread):
    global count, running

    #m = midi()

    ok = False
    running = False
    midi_channel = 0

    playing_note = -1
    
    def __init__(self, file_name):
        threading.Thread.__init__(self)
        self.part = g.file_name2part(file_name)
        self.channel = g.file_name2channel(file_name)
        self.note = g.file_name2note(file_name)
        #print 'clip filename: ' + file_name + 'channel: ' + str(self.channel)
        if os.path.isfile(file_name):
            self.file_name = file_name
            self.ok = True
            #self.stop_file = '_' + file_name
        else:
            self.file_name = None
            print('missing file: ' + file_name)
        if os.path.isfile('_' + file_name):
            self.stop_file = '_' + file_name
        else:
            self.stop_file = None

            
        """
        self.midi_channel = midi_channel
        self.midi_note = midi_note
        """
            
    def on(self, note=-1, channel=-1):
        if channel == -1:
            channel = self.channel
        if note == -1:
            note = self.note

        if self.playing_note != -1:
            m.note_off(channel, note)
        m.note_on(channel, note)
        self.playing_note = note
        #time.sleep(.001)
        #self.m.note_off(channel, note)
        #self.playing_note = -1
        
    def run(self):
        #global running
        #print('in clip.run...')
        if self.file_name:
            self.running = True
            #running = True
            execfile(self.file_name)
            self.running = False
            
    def quit(self):
        #global running
        self.running = False
        #running = False
        self._Thread__stop()
        if self.stop_file:
            execfile(self.stop_file)


    def debug(self):
        print 'clip, file_name: ' + self.file_name + ', channel: ' + str(self.channel) + ', note: ' + str(self.note)
            
    """
    def file_name2channel(self, file_name):
        file_name = file_name[:file_name.find('-'):]
        file_name = file_name[file_name.find('/')+1:]
        return file_name
    """
#c = clip('test.py')
#print(c)
            
"""
clips = []

for i in range(4):
    c = clip('test.py')
    c.start()
    clips.append(c)


time.sleep(1)

for c in clips:
    c.quit()

"""
