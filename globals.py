#!/usr/bin/python2
class globals(object):
    # singleton
    _instance = None



    part_names = []
    slider_names = []
    channel_names = []
    
    midi_port_name = 'Midi Through'

    start_part = 0
    lowest_trigger_note = 48
    tempo = 120
    channel_names = []
    sliders = []
    project_folder = ''

    nb_parts = 9
    nb_sliders = 6
    nb_channels = 24
    nb_beaters = 24
    sliders = [0] * nb_sliders
    faders = [0] * nb_channels
    mutes = [0] * nb_channels

    
    beats_per_bar = 8
    part_sync = 8

    
    def __new__(cls, *args, **kwargs):
        if not cls._instance:
            cls._instance = super(globals, cls).__new__(
                                cls, *args, **kwargs)
        return cls._instance


    def debug(self,):
        print '-- globals: ---'
        print 'lowest_trigger_note:' + str(self.lowest_trigger_note)
        print 'tempo:' + str(self.tempo)
        print 'project_folder:' + self.project_folder
        print 'part_names:' + str(self.part_names)

    def file_name_in_channels(self, file_name):
        try:
            self.channel_names.index(self.file_name2channel_name(file_name))
        except:
            return False
        return True
    
    def file_name2channel(self, file_name):
        channel_name = self.file_name2channel_name(file_name)
        try:
            channel = self.channel_names.index(channel_name)
        except:
            return -1
        if channel > 7:
            channel = 9
        return channel

    def file_name2channel_name(self, file_name):
        channel_name = file_name
        channel_name = channel_name[:channel_name.find('-')]
        channel_name = channel_name[channel_name.find('/')+1:]
        return channel_name

    def file_name2part(self, file_name):
        file_name = file_name[file_name.find('-')+1:]
        file_name = file_name[:file_name.find('.')]
        return file_name

    def file_name2note(self, file_name):
        #global lowest_trigger_note
        note = -1
        channel = self.file_name2channel(file_name)
        if channel == 9:
            channel_name = self.file_name2channel_name(file_name)
            try:
                index = self.channel_names.index(channel_name)
            except:
                return -1
            return index - 8 + self.lowest_trigger_note
            print 'index:' + str(index)
                
    
g = globals()

