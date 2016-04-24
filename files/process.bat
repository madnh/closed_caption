@ECHO OFF

IF [%1]==[] (
	GOTO EXIT
)

IF NOT EXIST %1 (
	ECHO ------- File not found: %1
	GOTO EXIT
)
ECHO Processing on %1

SET _PREFIX=
IF [%2]==[] (
	SET "_PREFIX="
) ELSE (
	SET _PREFIX=[%2]
)

CALL files\base_video.bat
	
IF NOT EXIST "dist\_base.mp4" (
	ECHO ------ Base video file is not found
	GOTO EXIT
)

IF %~x1==.avi GOTO EXTRACT_AUDIO_FILE_AVI
IF %~x1==.AVI GOTO EXTRACT_AUDIO_FILE_AVI
IF %~x1==.mp4 GOTO EXTRACT_AUDIO_FILE
IF %~x1==.MP4 GOTO EXTRACT_AUDIO_FILE
IF %~x1==.mov GOTO EXTRACT_AUDIO_FILE
IF %~x1==.MOV GOTO EXTRACT_AUDIO_FILE

ECHO ------ This file type is unsupported
GOTO EXIT


:EXTRACT_AUDIO_COMPLETE
ECHO ------ Extract audio complete

IF NOT EXIST "dist\_%~nx1.aac" (
	ECHO ------ Extract audio failed
) ELSE (		
	CALL files\ffmpeg -v 16 -y -i "dist\_base.mp4" -i "dist\_%~nx1.aac" -bsf:a aac_adtstoasc -c copy -map 0:0 -map 1:0 "dist\%_PREFIX%%~nx1.mp4"
	
	@del "dist\_%~nx1.aac"
	
	IF NOT EXIST "dist\%_PREFIX%%~nx1.mp4" (
		ECHO ------ Mux base video and audio failed!
	) ELSE (
		ECHO ------ Mux base video and audio success!
	)
)

ECHO.

GOTO EXIT

:EXTRACT_AUDIO_FILE
CALL files\ffmpeg -v 16 -y -i %1 -vn -acodec copy "dist\_%~nx1.aac"
GOTO EXTRACT_AUDIO_COMPLETE

:EXTRACT_AUDIO_FILE_AVI
CALL files\ffmpeg -v 16 -y -i %1 -vn -c:a aac "dist\_%~nx1.aac"
GOTO EXTRACT_AUDIO_COMPLETE


:EXIT
EXIT /B 0