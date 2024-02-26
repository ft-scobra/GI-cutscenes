@echo off
setlocal EnableDelayedExpansion

goto :program_start


:audio_choice
    rem Validate user input for audio language
    set /p language=Enter your choice (1-5): 
    if "!language!" equ "1" (
        set "audio_language=chi"
    ) else if "!language!" equ "2" (
        set "audio_language=eng"
    ) else if "!language!" equ "3" (
        set "audio_language=jpn"
    ) else if "!language!" equ "4" (
        set "audio_language=kor"
    ) else if "!language!" equ "5" (
        set "audio_language=chi,eng,jpn,kor"
    ) else (
        goto :audio_choice
    )

    echo,
    echo Selected audio language: !audio_language!
    echo,
    echo ======================================================================================================================
    echo,

    goto :ask_subtitles


:sub_choice
    echo ======================================================================================================================
    echo,
    rem Ask for the subtitle language
    echo Choose the subtitle language:
    echo,
    echo 1. Simplified Chinese
    echo 2. Traditional Chinese
    echo 3. German
    echo 4. English
    echo 5. Spanish
    echo 6. French
    echo 7. Indonesian
    echo 8. Italian
    echo 9. Japanese
    echo 10. Korean
    echo 11. Portuguese
    echo 12. Russian
    echo 13. Thai
    echo 14. Turkish
    echo 15. Vietnamese
    echo,

    :sub_check
    set /p sub_lang="Enter the number corresponding to the subtitle language: "
    if "!sub_lang!"=="1" (set subtitle_language=chi-CN) else (
    if "!sub_lang!"=="2" (set subtitle_language=chi-TW) else (
    if "!sub_lang!"=="3" (set subtitle_language=ger) else (
    if "!sub_lang!"=="4" (set subtitle_language=eng) else (
    if "!sub_lang!"=="5" (set subtitle_language=spa) else (
    if "!sub_lang!"=="6" (set subtitle_language=fre) else (
    if "!sub_lang!"=="7" (set subtitle_language=ind) else (
    if "!sub_lang!"=="8" (set subtitle_language=ita) else (
    if "!sub_lang!"=="9" (set subtitle_language=jpn) else (
    if "!sub_lang!"=="10" (set subtitle_language=kor) else (
    if "!sub_lang!"=="11" (set subtitle_language=por) else (
    if "!sub_lang!"=="12" (set subtitle_language=rus) else (
    if "!sub_lang!"=="13" (set subtitle_language=tha) else (
    if "!sub_lang!"=="14" (set subtitle_language=tur) else (
    if "!sub_lang!"=="15" (set subtitle_language=vie) else (
    goto :sub_check)))))))))))))))
    
    set subtitle=-s

    echo,
    echo Selected subtitle language: !subtitle_language!
    echo,
    echo ======================================================================================================================
    echo,

    goto :ask_format


:format_choice
    rem Validate user input for file format
    set /p file_format=Choose the output file format: 
    if /i "!file_format!" equ "1" (
        set "output_format=MKV"
    ) else if /i "!file_format!" equ "2" (
        set "output_format=MP4"
    ) else (
        goto :format_choice
    )
    echo,
    echo Selected output file format: !output_format!
    echo,
    echo ======================================================================================================================
    echo,
    goto :ask_sub_format


:sub_format_choice
    rem Check user input for sub format
    set /p sub_format=Choose the sub format: 
    if /i "!sub_format!" equ "1" (
        set "sub_format=SS"
    ) else if /i "!sub_format!" equ "2" (
        set "sub_format=HS"
    ) else (
        goto :sub_format_choice
    )
    echo,
    echo Selected sub format: !sub_format!
    echo,
    echo ======================================================================================================================
    echo,
    goto :choice_end


:sub_type_mp4
    if "!sub_format!"=="HS" (
        rem Extracting subtitles
        mkdir "./output/subs" 2>nul
        ffmpeg -i "./output/%fileName%.mkv" "./output/subs/%fileName%.ass"
        echo ======================================================================================================================
        rem Generating an MP4 with Hard Subs
        ren "./output\%fileName%.mkv" %fileName%_temp.mkv
        ffmpeg -y -i "./output/%fileName%_temp.mkv" -i "./output/subs/%fileName%.ass" -map 0:0 -map 0:1 -map 0:2 -map 0:3 -map 0:4 -c:v libx264 -crf 18 -c:a copy -preset veryfast -vf "ass=./output/subs/%fileName%.ass" -c:s mov_text "./output/%fileName%.mp4"
        del "./output\%fileName%_temp.mkv"
        ren "./output\%fileName%.mp4" %fileName%_temp.mp4
        ffmpeg -y -i "./output/%fileName%_temp.mp4" -map 0 -c copy -disposition:s default "./output/%fileName%.mp4"
        del "./output\%fileName%_temp.mp4"
        rmdir /s /q "./output/subs"
        goto :end
    ) else if "!sub_format!"=="SS" (
        rem Extracting subtitles
        mkdir "./output/subs" 2>nul
        ffmpeg -i "./output/%fileName%.mkv" "./output/subs/%fileName%.ass"
        echo ======================================================================================================================
        rem Generating an MP4 with Soft Subs
        ren "./output\%fileName%.mkv" %fileName%_temp.mkv
        ffmpeg -y -i "./output/%fileName%_temp.mkv" -i "./output/subs/%fileName%.ass" -map 0:0 -map 0:1 -map 0:2 -map 0:3 -map 0:4 -map 0:5 -c:v copy -c:a copy -c:s mov_text -metadata:s:s:0 language=eng -disposition:s:0 default "./output/%fileName%.mp4"
        del "./output\%fileName%_temp.mkv"
        rmdir /s /q "./output/subs"
        echo ======================================================================================================================
        goto :end
    ) else ( 
        rem Generating an MP4 with No Subtitles
        ren "./output\%fileName%.mkv" %fileName%_temp.mkv
        ffmpeg -y -i "./output/%fileName%_temp.mkv" -map 0:0 -map 0:1 -map 0:2 -map 0:3 -map 0:4 -map 0:5 -c:v copy -c:a copy "./output/%fileName%.mp4"
        del "./output\%fileName%_temp.mkv"
        echo ======================================================================================================================
        goto :end
    )




:program_start

rem ASCII Art
echo ======================================================================================================================
echo  ___                 _    _        ___        _                            ___      _                   _            
echo /  _^>  ___ ._ _  ___^| ^|_ ^<_^>._ _  ^|  _^> _ _ _^| ^|_ ___ ___  ___ ._ _  ___  ^| __^>__ _^| ^|_ _ _  ___  ___ _^| ^|_ ___  _ _ 
echo ^| ^<_/\/ ._^>^| ' ^|^<_-^<^| . ^|^| ^|^| ' ^| ^| ^<__^| ^| ^| ^| ^| ^<_-^</ ^| '/ ._^>^| ' ^|/ ._^> ^| _^> \ \/^| ^| ^| '_^>^<_^> ^|/ ^| ' ^| ^| / . \^| '_^>
echo `____/\___.^|_^|_^|/__/^|_^|_^|^|_^|^|_^|_^| `___/`___^| ^|_^| /__/\_^|_.\___.^|_^|_^|\___. ^|___^>/\_\^|_^| ^|_^|  ^<___^|\_^|_. ^|_^| \___/^|_^|  
echo,
echo ======================================================================================================================
echo,
echo,
echo ======================================================================================================================


:choice_start
rem Getting User Input

rem Audio Language
:ask_language
echo,
echo Choose the audio language:
echo,
echo 1. Chinese
echo 2. English
echo 3. Japanese
echo 4. Korean
echo 5. All (multi-audio)
echo,
call :audio_choice


rem Subtitles
:ask_subtitles
    set /p include_subtitles=Do you want to include subtitles (Y/N)? 


rem Validate user input for including subtitles
if /i "!include_subtitles!" == "Y" (
    call :sub_choice
) else if /i "!include_subtitles!" == "N" (
    set subtitle=
    echo Subtitles will not be included.
    echo,
    echo ======================================================================================================================
    echo,
) else (
    goto ask_subtitles
)


rem File Format
:ask_format
    echo Choose output file format(1 or 2): 
    echo,
    echo 1. MKV
    echo 2. MP4
    echo,
    call :format_choice


rem Soft or Hard Subs
:ask_sub_format
if /i "!include_subtitles!" == "N" ( 
    goto :choice_end
)
    echo Choose a subtitle format(1 or 2): 
    echo,
    echo 1. Soft Subs
    echo 2. Hard Subs (MP4 ONLY)
    echo,
    call :sub_format_choice


rem End of Choices
:choice_end



rem Getting the USM file
echo Drag and drop your USM file here, or enter the path manually: 
set /p file="Enter the path to the file: "
set "filePath=%file:"=%"

rem Extracting file name without extension
for %%I in ("%filePath%") do (
    set "fileName=%%~nI"
)

echo,
echo ======================================================================================================================
GICutscenes demuxUsm "%filePath%" -m %subtitle% --audio-lang "%audio_language%"


rem Generating Subtitles
if /i "%include_subtitles%" equ "Y" (
    echo ======================================================================================================================
    echo,
    ren "./output\%fileName%.mkv" %fileName%_temp.mkv
    ffmpeg -i "./output/%fileName%_temp.mkv" -map 0 -map -0:s -map 0:s:m:language:%subtitle_language% -c copy "./output/%fileName%.mkv"
    del "./output\%fileName%_temp.mkv"
    ren "./output\%fileName%.mkv" %fileName%_temp.mkv
    ffmpeg -i "./output/%fileName%_temp.mkv" -map 0 -c copy -disposition:s default "./output/%fileName%.mkv"
    del "./output\%fileName%_temp.mkv"
) 


rem MKV Format
if "!file_format!" == "1" (
    goto :end
)


rem Convert Hardsubs MP4
if "!file_format!" == "2" (
    echo ======================================================================================================================
    echo,
    call :sub_type_mp4
) 


rem End
:end
endlocal
echo,
echo,
echo END
echo,
echo,
echo ======================================================================================================================
echo Press any key to continue...
echo ======================================================================================================================
pause >nul
exit