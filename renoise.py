#!/usr/bin/python2
import liblo, threading, time, os, subprocess, sys
from timer import timer

class renoise(threading.Thread, object):
    # singleton
    _instance = None

    debug_on = False

    renoise_port = 8000
    luck_out_port = 8007
    luck_in_port = 8008

    server = None

    listening = False
    load_done = False
    bpm_done = False
    setup_done = False
    instruments_done = False
    tracks_done = False
    
    song_path = None

    timer = timer()

    nb_instruments = None
    instruments = {}
    nb_tracks = None
    tracks = {}

    def __new__(cls, *args, **kwargs):
        if not cls._instance:
            cls._instance = super(renoise, cls).__new__(
                                cls, *args, **kwargs)
        return cls._instance

    def debug(self, *args):
        if self.debug_on:
            print(''.join(args))

    def start_server(self, port):
        self.debug('in start_server')
        try:
            return liblo.Server(port)
        except liblo.ServerError, err:
            print str(err)
            

    def handle_osc_in(self, path, args, type):
        self.debug('port:' + str(self.luck_in_port) + ', path: ' + path + ' args:' + str(args))
        if path == '/fromrenoise/luck/bpm':
            self.timer.bpm = args[0]
            self.bpm_done = True
        elif path == '/fromrenoise/luck/number_of_instruments':
            self.nb_instruments = args[0]
        elif path == '/fromrenoise/luck/song_loaded':
            self.load_done = True
        elif path == '/fromrenoise/luck/number_of_tracks':
            self.nb_tracks = args[0]
        elif path == '/fromrenoise/luck/instrument_info':
            if args[1].strip() != '':
                self.instruments.update({args[1]:args[0]-1})
                if args[0] == self.nb_instruments - 1:
                    self.instruments_done = True
        elif path == '/fromrenoise/luck/track_info':
            if args[1].strip() != '':
                self.tracks.update({args[1]:args[0]-1})
                if args[0] == self.nb_tracks - 1:
                    self.tracks_done = True
        elif path == '/fromrenoise/luck/song_path':
            self.song_path = args[0].strip()

    def run(self):
        self.debug('in run')
        self.server = self.start_server(self.luck_in_port)
        self.server.add_method(None, None, self.handle_osc_in)
        self.debug('server started')
        while True:
            self.server.recv(10)
            self.listening = True

    def load(self, xrns=None):
        if xrns:
            xrns = os.path.expanduser(xrns)
            if os.path.isfile(xrns):
                liblo.send(self.luck_out_port, "/renoise/luck/get_song_path")
                """
                while self.song_path == None:
                    print('in while, song_path:' + str(self.song_path))
                    time.sleep(.1)
                """
                if self.song_path == xrns:
                    return
                else:
                    liblo.send(self.luck_out_port, "/renoise/luck/load_song", xrns)
            else:
                print('Error: file "' + xrns + '" dosn\'t exist...')
            self.wait_for_load()


    def renoise_running(self):
        lines = os.popen('ps aux', 'r').readlines()
        for line in lines:
            if ' renoise' in line:
                return True
        return False

    def start_renoise(self):
        if not self.renoise_running():
            print('renoise isnt running...')
        while not self.renoise_running():
            time.sleep(.1)
            print('waiting for renoise')

        #os.system('renoise &')
        #subprocess.Popen('renoise')


    def setup(self,xrns=None):
        self.wait_for_server()
        self.start_renoise()
        self.load(xrns)
        self.setup_bpm()
        self.debug('after setup bpm')
        self.setup_instruments()
        self.debug('after setup instruments')
        self.setup_tracks()
        self.debug('after setup tracks')

        

    def wait_for_load(self):
        self.debug('waiting for renoise to load')
        while not self.load_done:
            time.sleep(0.01)
        time.sleep(0.01)
        self.debug('renoise loaded')
        
    def wait_for_server(self):
        self.debug('waiting for osc server to come up...')
        while not self.listening:
            time.sleep(0.01)
        time.sleep(0.01)
        self.debug('osc server running')
        

    def wait_for_setup(self):
        self.debug('waiting for renoise to be setup...')
        while not self.setup_done:
            time.sleep(0.01)
        time.sleep(0.01)
        



    def note_on(self, instr, track, note=48, velocity=128):
        if type(instr) == str and type(track) == str and instr in self.instruments and track in self.tracks:
            liblo.send(self.renoise_port, "/renoise/trigger/note_on", self.instruments[instr], self.tracks[track], note, velocity)
        else:
            print('hmmm note on gone bad...')

    def setup_bpm(self):
        self.debug('in setup_bpm')
        liblo.send(self.luck_out_port, "/renoise/luck/get_bpm")
        while not self.bpm_done:
            time.sleep(.10)

    def setup_instruments(self):
        self.debug('in setup_instruments')
        liblo.send(self.luck_out_port, "/renoise/luck/get_number_of_instruments")
        while not self.nb_instruments:
            time.sleep(.01)
        self.debug('ready for individual instrument setup')
        for instrument_number in range(1, self.nb_instruments+1):
            liblo.send(self.luck_out_port,"/renoise/luck/get_instrument_info", instrument_number)
        while not self.instruments_done:
            time.sleep(.01)

    def setup_tracks(self):
        self.debug('in setup_tracks')
        liblo.send(self.luck_out_port, "/renoise/luck/get_number_of_tracks")
        while not self.nb_tracks:
            time.sleep(.01)
        self.debug('ready for individual track setup')
        for track_number in range(1, self.nb_tracks+1):
            liblo.send(self.luck_out_port,"/renoise/luck/get_track_info", track_number)
        while not self.tracks_done:
            time.sleep(.01)



"""
renoise = renoise()
renoise.start()


"""
