# need_subs
Extract audio stream from video files, mux with a base video file, upload to Youtube and download subtitles

# Installing
**need_sub** is dependent on **ffmpeg**

## Windows
- Download ffmpeg build for Windows at this [link](https://ffmpeg.zeranoe.com/builds/)
- Extract downloaded file, copy `bin\ffmpeg.exe` to `<need_subs_path>/files` folder

## Linux:
Linux is not supported

# Use
1. Run **need_subs.bat** (or open it in "Command Prompt") and choose what you need:
   - **Mux a file**: mux base video and a single file
   - **Mux files in folder**: mux base video and all of files (filter by extension) in a folder (recurse subfolders)
   - **Create base video file**: Create base vide file, video's frames are file `files/cover.jpg`
   
3. Upload files in `dist` to Youtube, use any tools to download subtitles

# Images
![Interface](http://i.imgur.com/S5C9LYQ.png)

Missing ffmpeg.exe file
![missing](http://i.imgur.com/NjeQ0eF.png)

Create base video file
![base video](http://i.imgur.com/jiVaSxC.png)

Mux a file
![mux a file](http://i.imgur.com/JuT3rja.png)

Mux files in folder
![Mux folder](http://i.imgur.com/Lt6wD8N.png)

Result
![Result](http://i.imgur.com/iQHWOZM.png)
