#!/usr/bin/python

import sys
from os import listdir
from funcs import *

make_source_base()

args = sys.argv[1:]
args_count = len(args)
folder_index = 0
FNULL = open(os.devnull, 'w')

for arg_dir in args:
    assert os.path.exists(arg_dir), 'Folder not exists: ' + arg_dir

    dir_files = listdir(arg_dir)
    dir_files.sort()
    files = [f for f in dir_files if os.path.isfile(os.path.join(arg_dir, f))]
    prefix = slug(os.path.basename(arg_dir))
    folder_index += 1

    print str(folder_index) + ') ' + arg_dir

    file_index = 0

    for video_file in sorted(files, key=natural_key):
        full_path_video_file = os.path.join(arg_dir, video_file)
        file_index += 1

        print '    ' + str(file_index) + '| ' + video_file
        extract_audio_file(full_path_video_file, prefix)

    print ''
