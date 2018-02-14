#!/usr/bin/python2
import time
from globals import *


class timer(object):
    # singleton
    _instance = None

    debug_on = False

    tempo = 120
    meter = 4/4.
    running = False
    start_time = time.time()
    
    def __new__(cls, *args, **kwargs):
        if not cls._instance:
            cls._instance = super(timer, cls).__new__(
                                cls, *args, **kwargs)
        return cls._instance
   
    def debug(self, *args):
        if self.debug_on:
            print(''.join(args))



    def beats2time(self, nb_beats):
        return 60. / self.tempo * nb_beats

    def start(self):
        self.start_time = time.time()
        self.running = True

    def wait(self,beats, early=0):
        while not self.running:
            pass
        time.sleep(self.beats2time(beats) - ((time.time() - self.start_time - early) % self.beats2time(beats)))
    
    def sub(self, nb_beats):
        if nb_beats <= 0:
            nb_beats = 1
        return round((time.time() - self.start_time) / self.beats2time(nb_beats * 1.)) 


t = timer()

"""
t.start()
for i in range(8):
    print '-------------'
    print t.sub(.5)
    print t.sub(1)
    print t.sub(2)
    #time.sleep(.01)        
    t.wait(.5)
"""
