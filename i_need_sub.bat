ECHO OFF
COLOR A
CLS
IF NOT EXIST ffmpeg.exe (
	ECHO.
	ECHO ---------------------------------
	ECHO !!!!! ffmpeg.exe not found
	ECHO ---------------------------------
	GOTO EXIT
)
:START
CLS
ECHO.
ECHO            I NEED SUBTITLES v0.0.0.0.0.1
ECHO                 Copyright @ MaDnh
ECHO                      -=0=-
ECHO        ------------------------------------------
ECHO.
ECHO.
ECHO                1 - Create base video
ECHO                2 - Extract audio files
ECHO.
ECHO                3 - Mux audio and base video
ECHO.
ECHO.
ECHO                0 - Exit
ECHO.
ECHO --------------------------------------------------
SET /P M=Choose: 
IF %M%==1 GOTO CREATE_BASE_VIDEO
IF %M%==2 GOTO EXTRACT_AUDIO_FILES
IF %M%==3 GOTO MUX
IF %M%==0 GOTO EXIT
GOTO START

:CREATE_BASE_VIDEO
CLS
ECHO.
ECHO Create base video....
ECHO ===========================
ffmpeg -v 16 -y -loop 1 -i cover.jpg -c:v libx264 -t 1 -pix_fmt yuv420p "dist\base.mp4"
ECHO.
ECHO.
ECHO Success!
ECHO.
ECHO.
PAUSE
GOTO START
:EXTRACT_AUDIO_FILES
CLS
ECHO.
ECHO Extract audio files
ECHO ===========================
SET /P D=Video folder path: 
IF NOT EXIST %D%\*.* (
	ECHO.
	ECHO                             Path not found, or empty folder
	ECHO.
	ECHO.
	ECHO -----------------------------------
	PAUSE
	GOTO EXTRACT_AUDIO_FILES
)
:EXTRACT_AUDIO_FILES_CHOOSE_EXT
SET /P E=File extension: 
ECHO.
ECHO -----------------------------------
ECHO Extract audio from .%E% files in: %D%
ECHO -----------------------------------
for /r %D% %%V in (*.%E%) DO (
	ECHO Processing on: %%V
	ffmpeg -v 16 -y -i "%%V" -vn -acodec copy "dist\audio_files\%%~nV.aac"
)
ECHO.
ECHO.
ECHO Success!
ECHO.
ECHO.
PAUSE
GOTO START
:MUX
CLS
ECHO.
ECHO Mux audio and base video
ECHO ===========================
for %%A in (dist\audio_files\*.aac) DO (
	echo Processing on: %%~nA.aac
	ffmpeg -v 16 -y -i "dist\base.mp4" -i "%%A" -bsf:a aac_adtstoasc -c copy -map 0:0 -map 1:0 "dist\video_files\%%~nA.mp4"
)
ECHO.
ECHO.
ECHO Success!
ECHO.
ECHO.
PAUSE
GOTO START
:EXIT