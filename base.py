#!/usr/bin/python

from subprocess import call

return_code = call("ffmpeg -v 16 -y -loop 1 -i files/cover.jpg -c:v libx264 -t 1 -pix_fmt yuv420p dist/_base.mp4",
                   shell=True)

if return_code:
    print 'Error: ' + str(return_code)
else:
    print('Success')
