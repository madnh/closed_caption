ECHO OFF
COLOR A
CLS
IF NOT EXIST files\ffmpeg.exe (
	ECHO.
	ECHO ---------------------------------
	ECHO !!!!! files\ffmpeg.exe not found
	ECHO ---------------------------------
	PAUSE
	GOTO EXIT
)

:START

CLS
ECHO.
ECHO            NEED SUBTITLES v0.3
ECHO                Author: MaDnh
ECHO                --=0=--
ECHO.
ECHO.
ECHO            1 - Mux a file
ECHO            2 - Mux files in folder
ECHO            3 - Create base video file
ECHO.
ECHO.
ECHO            0 - Exit
ECHO.
ECHO --------------------------------------------------

SET M=
SET /P M=Choose: 

IF %M%==1 GOTO MUX_A_FILE
IF %M%==2 GOTO MUX_MULTI_FILES
IF %M%==3 GOTO CREATE_BASE_VIDEO
IF %M%==0 GOTO EXIT

GOTO START


:CREATE_BASE_VIDEO
CLS
ECHO.
ECHO Create base video file
ECHO ===========================
CALL base.bat true
PAUSE
GOTO START

:MUX_A_FILE
CLS
ECHO.
ECHO Mux a file
ECHO ===========================
SET F=
SET /P F=Video file path: 

IF NOT EXIST %F% (
	ECHO.
	ECHO          File not found
	ECHO.
	ECHO ---------------------------------------------------
	PAUSE
	GOTO START
)
CALL file.bat %F%
ECHO ---------------------------------------------------
PAUSE
GOTO START

:MUX_MULTI_FILES
CLS
ECHO.
ECHO Mux files in folder
ECHO ===========================
SET D=
SET /P D=Video folder path: 

@IF [%D%] EQU [] GOTO PATH_NOT_FOUND
@IF EXIST %D%\NUL GOTO MUX_MULTI_FILES_PATH_FOUND
@IF EXIST %D%\*.* GOTO MUX_MULTI_FILES_PATH_FOUND
@FOR /r %D% %%T IN (*.*) DO (
	GOTO MUX_MULTI_FILES_PATH_FOUND
)

:PATH_NOT_FOUND
ECHO.
ECHO          Path not found
ECHO.
ECHO ---------------------------------------------------
PAUSE
GOTO START

:MUX_MULTI_FILES_PATH_FOUND
SET P=
SET /P P=Result's prefix: 

ECHO.
ECHO -----------------------------------
ECHO Mux multiple .%E% files in: %D%
ECHO -----------------------------------
ECHO.

for /r %D% %%F in (*.*) DO (
	IF NOT [%P%] EQU [] (
		CALL file.bat "%%F" "%P%"
	) ELSE (
		CALL file.bat "%%F"
	)
	
	ECHO.
)

ECHO.
ECHO          Complete!
ECHO.
ECHO ---------------------------------------------------
PAUSE
GOTO START

:EXIT
ECHO.
ECHO Bye :)
ECHO.