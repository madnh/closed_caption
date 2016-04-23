@ECHO OFF

IF NOT [%1]==[] (
	IF EXIST "dist\_base.mp4" (
		@DEL "base.mp4"
	)
)

IF NOT EXIST "dist\_base.mp4" (
	ECHO ---------------------------------------------------
	CALL files\ffmpeg -v 16 -y -loop 1 -i files\cover.jpg -c:v libx264 -t 1 -pix_fmt yuv420p "dist\_base.mp4"
	
	IF EXIST "dist\_base.mp4" (
		ECHO Create base video file: Complete
	) ELSE (
		ECHO Create base video file: Failed
	)		
	ECHO ---------------------------------------------------
)