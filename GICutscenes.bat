@echo off

rem Getting the USM file
echo Drag and drop your USM file here, or enter the path manually:
set /p file="Enter the path to the file: "
set "filePath=%file:"=%"
GICutscenes demuxUsm "%filePath%" -m -s

echo ----------------------------------------------------
echo %filePath%
echo %file%
echo ----------------------------------------------------


rem Extracting file name without extension
for %%I in ("%filePath%") do (
    set "fileName=%%~nI"
)

echo ----------------------------------------------------
echo %fileName%
echo ----------------------------------------------------

rem Extracting subtitles
mkdir "./output/subs" 2>nul
ffmpeg -i "./output/%fileName%.mkv" -map 0:s:0 "./output/subs/%fileName%.ass"

echo ----------------------------------------------------
echo ----------------------------------------------------

ffmpeg -i "./output/%fileName%.mkv" -i "./output/subs/%fileName%.ass" -map 0:0 -map 0:2 -c:v libx264 -crf 18 -c:a copy -preset veryfast -vf "ass=./output/subs/%fileName%.ass" "./output/%fileName%.mp4"

pause