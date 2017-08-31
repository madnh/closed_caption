#!/usr/bin/python

import sys
from funcs import *

make_source_base()

args = sys.argv[1:]
args_count = len(args)
video_file = args[0]
prefix = ''

print 'File: ', video_file
assert (os.path.exists(video_file)), 'Input file not found'

if args_count > 1:
    prefix = args[1]

extract_audio_file(video_file, prefix)
