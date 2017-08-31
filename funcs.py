import re
import os.path
import subprocess


def slug(string):
    s = re.sub('(.)([A-Z][a-z]+)', r'\1-\2', string)
    s = re.sub('([a-z0-9])([A-Z])', r'\1-\2', s).lower()
    s = re.sub('[\s]+', '-', s)
    s = re.sub('[\W]+', '-', s)
    s = re.sub('[-]{2,}', '-', s)

    return s


def escape_file_name(filename):
    return '"' + re.sub('["]', '\\"', filename) + '"'


def natural_key(string_):
    """See http://www.codinghorror.com/blog/archives/001018.html"""
    return [int(s) if s.isdigit() else s for s in re.split(r'(\d+)', string_)]


def extract_audio_file(source_file, video_prefix=None):
    filename, file_extension = os.path.splitext(os.path.basename(source_file))

    audio_filename = '_' + filename + '.aac'
    video_filename = filename + '.mp4'

    target_audio = 'dist/' + audio_filename
    target_video = 'dist/' + ((video_prefix + '__') if video_prefix else '') + video_filename

    if file_extension.lower() == '.avi':
        command = ['ffmpeg', '-v 16', '-y -i', escape_file_name(source_file), '-vn -c:a aac',
                   escape_file_name(target_audio)]
    else:
        command = ['ffmpeg', '-v 16', '-y -i', escape_file_name(source_file), '-vn -acodec copy',
                   escape_file_name(target_audio)]

    extract_audio_code = subprocess.call(' '.join(command), shell=True)

    assert extract_audio_code == 0 and os.path.exists(target_audio), 'Extract audio file failed'

    mix_video_code = subprocess.call(' '.join([
        'ffmpeg -v 16 -y',
        '-i "dist/_base.mp4"',
        '-i ' + escape_file_name(target_audio),
        '-bsf:a aac_adtstoasc -c copy -map 0:0 -map 1:0',
        escape_file_name(target_video)
    ]), shell=True)

    os.remove(target_audio)

    assert mix_video_code == 0 and os.path.exists(target_video), 'Mix base video and audio file failed'


def make_source_base():
    if not os.path.exists('dist/_base.mp4'):
        print 'Create base file'
        subprocess.call(['python base.py'], shell=True)
