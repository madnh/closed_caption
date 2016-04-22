ECHO OFF
COLOR A
CLS
IF NOT EXIST ffmpeg.exe (
	ECHO.
	ECHO ---------------------------------
	ECHO !!!!! ffmpeg.exe not found
	ECHO ---------------------------------
	pause
	GOTO EXIT
)

:START

CLS
ECHO.
ECHO            NEED SUBTITLES v0.2
ECHO                Author: MaDnh
ECHO                --=0=--
ECHO.
ECHO.
ECHO            1 - Mux a file
ECHO            2 - Mux files in folder
ECHO            3 - Create base video file (optional)
ECHO.
ECHO.
ECHO            0 - Exit
ECHO.
ECHO --------------------------------------------------
SET /P M=Choose: 
IF %M%==1 GOTO MUX_A_FILE
IF %M%==2 GOTO MUX_FILES_IN_FOLDER
IF %M%==3 GOTO CREATE_BASE_VIDEO
IF %M%==0 GOTO EXIT
GOTO START

:CREATE_BASE_VIDEO

@del "_temp\base.mp4"
CLS

:MAKE_SURE_BASE_VIDEO_EXISTS

IF NOT EXIST "_temp\base.mp4" (
	ECHO.
	IF %M%==3 (
		ECHO.
		ECHO Create base video file
		ECHO ===========================
	) ELSE (
		ECHO ---------------------------------------------------
		ECHO Create base video file
	)
	
	ffmpeg -v 16 -y -loop 1 -i cover.jpg -c:v libx264 -t 1 -pix_fmt yuv420p "_temp\base.mp4"
	
	IF EXIST "_temp\base.mp4" (
		IF %M%==3 (
			ECHO.
			ECHO          Success
			ECHO.
			ECHO.
		) ELSE (
			ECHO Complete!
		)
		ECHO ---------------------------------------------------
	) ELSE (
		IF %M%==3 (
			ECHO.
			ECHO          Failed!
			ECHO.
			ECHO.
			ECHO ---------------------------------------------------
		) ELSE (
			ECHO Failed!
			ECHO ---------------------------------------------------
			PAUSE
			GOTO START
		)
	)		
)

IF %M%==3 (
	PAUSE
) ELSE (
	IF %M%==1 GOTO MUX_A_FILE_BASE_FILE_EXISTS
	IF %M%==2 GOTO MUX_FILES_IN_FOLDER_BASE_FILE_EXISTS
)

GOTO START


:GET_FILE_NAME

set NAME=%~nx1
GOTO MUX_A_FILE_GET_FILE_NAME_OK


:MUX_A_FILE

CLS
ECHO.
ECHO Mux a file
ECHO ===========================
SET /P F=Video file path: 

IF NOT EXIST %F% (
	ECHO.
	ECHO          File not found
	ECHO.
	ECHO.
	ECHO ---------------------------------------------------
	PAUSE
	GOTO START
)

CALL :GET_FILE_NAME %F%
GOTO MAKE_SURE_BASE_VIDEO_EXISTS

:MUX_A_FILE_BASE_FILE_EXISTS
:MUX_A_FILE_GET_FILE_NAME_OK

ffmpeg -v 16 -y -i %F% -vn -acodec copy "_temp\%NAME%.aac"
IF NOT EXIST "_temp\%NAME%.aac" (
	ECHO.
	ECHO          Extract audio failed!
	ECHO.
	ECHO.
	ECHO ---------------------------------------------------
	PAUSE
	GOTO START
) ELSE (
	ffmpeg -v 16 -y -i "_temp\base.mp4" -i "_temp\%NAME%.aac" -bsf:a aac_adtstoasc -c copy -map 0:0 -map 1:0 "dist\%NAME%.mp4"
	IF NOT EXIST "dist\%NAME%.mp4" (
		ECHO.
		ECHO          Mux base video and audio failed!
		ECHO.
		ECHO.
	) ELSE (
		@del "_temp\%NAME%.aac"
		ECHO.
		ECHO          Success!
		ECHO.
		ECHO.
	)
	ECHO ---------------------------------------------------
	PAUSE
	GOTO START
)

:MUX_FILES_IN_FOLDER

CLS
ECHO.
ECHO Mux files in folder
ECHO ===========================
SET /P D=Video folder path: 

@IF EXIST %D%\NUL GOTO PATH_FOUND
@IF EXIST %D%\*.* GOTO PATH_FOUND
@FOR /r %D% %%T in (*.*) DO (
	GOTO PATH_FOUND
)

ECHO.
ECHO          Path not found
ECHO.
ECHO.
ECHO ---------------------------------------------------
PAUSE
GOTO START

:PATH_FOUND

SET /P E=File extension: 

ECHO.
ECHO -----------------------------------
ECHO Mux multiple .%E% files in: %D%
ECHO -----------------------------------
ECHO.

GOTO MAKE_SURE_BASE_VIDEO_EXISTS

:MUX_FILES_IN_FOLDER_BASE_FILE_EXISTS

for /r %D% %%F in (*.%E%) DO (
	ECHO Processing on: %%F
	ffmpeg -v 16 -y -i "%%F" -vn -acodec copy "_temp\%%~nF.aac"
	IF NOT EXIST "_temp\%%~nF.aac" (
		ECHO ------ Extract audio failed!
	) ELSE (
		ffmpeg -v 16 -y -i "_temp\base.mp4" -i "_temp\%%~nF.aac" -bsf:a aac_adtstoasc -c copy -map 0:0 -map 1:0 "dist\%%~nF.mp4"
		
		IF NOT EXIST "dist\%%~nF.mp4" (
			ECHO ------ Mux failed!
		) ELSE (
			@del "_temp\%%~nF.aac"
		)
	)	
)

ECHO.
ECHO          Complete!
ECHO.
ECHO.
ECHO ---------------------------------------------------
PAUSE
GOTO START

:EXIT
ECHO.
ECHO Bye :)
ECHO.