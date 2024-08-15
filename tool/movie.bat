rem ################�ϐ��ݒ�################
set INFO_AVS=%TEMP_DIR%\information.avs
set X264_TC_FILE=%TEMP_DIR%\x264.tc
set FPS=
set TOTAL_TIME=
set KEYINT=

rem ################������擾################
echo;
echo ^>^>%ANALYZE_ANNOUNCE%
echo;

rem ����̃t�H�[�}�b�g�����o��
.\MediaInfo.exe --Inform=General;%%Format/String%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do echo File Format    : %%i
.\MediaInfo.exe --Inform=Video;%%Codec%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do echo Video Codec    : %%i
.\MediaInfo.exe --Inform=Audio;%%Codec%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do echo Audio Codec    : %%i
.\MediaInfo.exe --Inform=Audio;%%Channels%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set AUDIO_CHANNELS=%%i
if not defined AUDIO_CHANNELS set AUDIO_CHANNELS=0
echo Audio Channels : %AUDIO_CHANNELS%
.\MediaInfo.exe --Inform=Audio;%%BitRate_Mode%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set ABITRATE_MODE=%%i
if defined ABITRATE_MODE echo AudioBR Mode   : %ABITRATE_MODE%

rem ����̗e�ʏ����o��
.\MediaInfo.exe --Inform=General;%%FileSize%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set INPUT_FILE_SIZE=%%i
echo FileSize       : %INPUT_FILE_SIZE%byte

rem �Đ����Ԃ̏����o��
.\MediaInfo.exe --Inform=General;%%PlayTime%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul

rem �Đ����Ԃ̐ݒ�
for /f "delims=." %%i in (%TEMP_INFO%) do set TOTAL_TIME=%%i
echo PlayTime       : %TOTAL_TIME%ms

rem CFR�i�Œ�t���[�����[�g�j��VFR�i�σt���[�����[�g�j�̔��f
.\MediaInfo.exe --Inform=Video;%%FrameRate_Mode%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set FPS_MODE=%%i
if "%FPS_MODE%"=="VFR" goto vfr_info

rem CFR�̐ݒ�
set VFR=false
.\MediaInfo.exe --Inform=Video;%%FrameRate%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set INPUT_FPS=%%i
if defined INPUT_FPS echo Framerate      : %INPUT_FPS%fps^(CFR^)
goto fps_main

rem VFR�̐ݒ�
:vfr_info
set VFR=true
.\MediaInfo.exe --Inform=Video;%%FrameRate%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set INPUT_FPS=%%i
echo Framerate      : %INPUT_FPS%fps^(VFR^)
.\MediaInfo.exe --Inform=Video;%%FrameRate_Minimum%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do echo Minimum FPS    : %%i
.\MediaInfo.exe --Inform=Video;%%FrameRate_Maximum%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do echo Maximum FPS    : %%i

:fps_main
if not defined DEFAULT_FPS (
    set CHANGE_FPS=false
    set FPS=%INPUT_FPS%
) else (
    set CHANGE_FPS=true
    set FPS=%DEFAULT_FPS%
)

rem �𑜓x�̐ݒ�
.\MediaInfo.exe --Inform=Video;%%Width%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set IN_WIDTH=%%i
echo Width          : %IN_WIDTH%pixels
.\MediaInfo.exe --Inform=Video;%%Height%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set IN_HEIGHT=%%i
echo Height         : %IN_HEIGHT%pixels

rem �A�X�y�N�g��
.\MediaInfo.exe --Inform=Video;%%DisplayAspectRatio%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set D_ASPECT=%%i
echo Aspect Ratio   : %D_ASPECT%
.\MediaInfo.exe --Inform=Video;%%PixelAspectRatio%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set P_ASPECT=%%i

rem �C���^�[���[�X�֘A�̐ݒ�
:interlace
.\MediaInfo.exe --Inform=Video;%%ScanType%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set SCAN_TYPE=%%i
if defined SCAN_TYPE echo Scan Type      : %SCAN_TYPE%
.\MediaInfo.exe --Inform=Video;%%ScanOrder%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set SCAN_ORDER=%%i
if defined SCAN_ORDER echo Scan Order     : %SCAN_ORDER%

rem IDR�t���[���Ԃ̍ő�Ԋu�E�e�ʏ���̐ݒ�
if /i "%DECODER%"=="avi" goto avisource_info
if /i "%DECODER%"=="ffmpeg" goto ffmpegsource_info
if /i "%DECODER%"=="directshow" goto directshowsource_info
if /i "%DECODER%"=="qt" goto qtsource_info

:directshowsource_info
(
    echo DirectShowSource^(%INPUT_FILE_PATH%, audio = false^)
)> %INFO_AVS%
goto infoavs

:qtsource_info
(
    echo LoadPlugin^("QTSource.dll"^)
    echo;
    echo QTInput^(%INPUT_FILE_PATH%, quality = 100, audio = 0^)
)> %INFO_AVS%
goto infoavs

:avisource_info
echo AVISource^(%INPUT_FILE_PATH%, audio = false^)> %INFO_AVS%
goto infoavs

:ffmpegsource_info
(
    echo LoadPlugin^("ffms2.dll"^)
    echo FFVideoSource^(%INPUT_FILE_PATH%,seekmode=-1,cache=false,threads=1^)
)> %INFO_AVS%

:infoavs
(
    echo;
    echo _isyv12 = IsYV12^(^)
    echo _isrgb = IsRGB^(^)
    echo _fps = Framerate^(^)
    if defined FPS (
        echo _keyint = String^(Round^(%FPS%^)^)
    ) else (
        echo _keyint = String^(Round^(_fps^)^)
    )
    echo _premium_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_PREMIUM%^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _normal_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_NORMAL%^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _premium_bitrate_new = String^(Floor^(Float^(%DEFAULT_SIZE_PREMIUM_NEW%^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _youtube_partner_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_YOUTUBE_PARTNER%^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _youtube_normal_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_YOUTUBE_NORMAL%^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _twitter_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_TWITTER%^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _in_width = String^(Floor^(Float^(%IN_WIDTH%^) * %P_ASPECT%^)^)
    echo;
    echo WriteFileStart^("yv12.txt","_isyv12",append = false^)
    echo WriteFileStart^("rgb.txt","_isrgb",append = false^)
    echo WriteFileStart^("fps.txt","_fps",append = false^)
    echo WriteFileStart^("keyint.txt","_keyint",append = false^)
    echo WriteFileStart^("premium_bitrate.txt","_premium_bitrate",append = false^)
    echo WriteFileStart^("normal_bitrate.txt","_normal_bitrate",append = false^)
    echo WriteFileStart^("premium_bitrate_new.txt","_premium_bitrate_new",append = false^)
    echo WriteFileStart^("in_width.txt","_in_width",append = false^)
    echo WriteFileStart^("youtube_partner_bitrate.txt","_youtube_partner_bitrate",append = false^)
    echo WriteFileStart^("youtube_normal_bitrate.txt","_youtube_normal_bitrate",append = false^)
    echo WriteFileStart^("twitter_bitrate.txt","_twitter_bitrate",append = false^)
    echo;
    echo Trim^(0,-1^)
    echo;
    echo return last
)>> %INFO_AVS%

.\avs2pipe_gcc.exe info %INFO_AVS% 1>nul 2>&1

if exist %TEMP_DIR%\yv12.txt (
    for /f "delims=" %%i in (%TEMP_DIR%\yv12.txt) do set YV12=%%i>nul
    for /f "delims=" %%i in (%TEMP_DIR%\rgb.txt) do set RGB=%%i>nul
    for /f "delims=" %%i in (%TEMP_DIR%\keyint.txt) do set /a KEYINT=%%i*10>nul
    for /f "delims=" %%i in (%TEMP_DIR%\premium_bitrate.txt) do set /a P_TEMP_BITRATE=%%i>nul
    for /f "delims=" %%i in (%TEMP_DIR%\normal_bitrate.txt) do set /a I_TEMP_BITRATE=%%i>nul
    for /f "delims=" %%i in (%TEMP_DIR%\premium_bitrate_new.txt) do set /a P_TEMP_BITRATE_NEW=%%i>nul
    for /f "delims=" %%i in (%TEMP_DIR%\youtube_partner_bitrate.txt) do set /a Y_P_TEMP_BITRATE=%%i>nul
    for /f "delims=" %%i in (%TEMP_DIR%\youtube_normal_bitrate.txt) do set /a Y_I_TEMP_BITRATE=%%i>nul
    for /f "delims=" %%i in (%TEMP_DIR%\twitter_bitrate.txt) do set /a TW_TEMP_BITRATE=%%i>nul
    for /f "delims=" %%i in (%TEMP_DIR%\in_width.txt) do set IN_WIDTH_MOD=%%i>nul

    for /f "delims=" %%i in (%TEMP_DIR%\fps.txt) do set AVS_FPS=%%i>nul 2>&1
) else (
    goto info_check
)
if not defined FPS set FPS=%AVS_FPS%

rem �o�͉𑜓x�̐ݒ�
set /a IN_WIDTH_ODD=%IN_WIDTH% %% 2
set /a IN_HEIGHT_ODD=%IN_HEIGHT% %% 2
set /a OUT_HEIGHT=%DEFAULT_HEIGHT% + %DEFAULT_HEIGHT% %% 2
if defined DEFAULT_WIDTH (
    set /a OUT_WIDTH=%DEFAULT_WIDTH%
    goto info_check
)
set /a OUT_WIDTH_TEMP=%DEFAULT_HEIGHT% * %IN_WIDTH_MOD% / %IN_HEIGHT%
set /a OUT_WIDTH=%OUT_WIDTH_TEMP% + %OUT_WIDTH_TEMP% %% 2
rem �j�R�j�R�V�d�l�p�i���𑜓x�j
set /a OUT_HEIGHT_NICO_NEW_H=%DEFAULT_HEIGHT_NEW_H% + %DEFAULT_HEIGHT_NEW_H% %% 2
set /a OUT_WIDTH_TEMP=%DEFAULT_HEIGHT_NEW_H% * %IN_WIDTH_MOD% / %IN_HEIGHT%
set /a OUT_WIDTH_NICO_NEW_H=%OUT_WIDTH_TEMP% + %OUT_WIDTH_TEMP% %% 2
rem �j�R�j�R�V�d�l�p�i���𑜓x�j
set /a OUT_HEIGHT_NICO_NEW_M=%DEFAULT_HEIGHT_NEW_M% + %DEFAULT_HEIGHT_NEW_M% %% 2
set /a OUT_WIDTH_TEMP=%DEFAULT_HEIGHT_NEW_M% * %IN_WIDTH_MOD% / %IN_HEIGHT%
set /a OUT_WIDTH_NICO_NEW_M=%OUT_WIDTH_TEMP% + %OUT_WIDTH_TEMP% %% 2
rem �j�R�j�R�V�d�l�p�i��𑜓x�j
set /a OUT_HEIGHT_NICO_NEW_L=%DEFAULT_HEIGHT_NEW_L% + %DEFAULT_HEIGHT_NEW_L% %% 2
set /a OUT_WIDTH_TEMP=%DEFAULT_HEIGHT_NEW_L% * %IN_WIDTH_MOD% / %IN_HEIGHT%
set /a OUT_WIDTH_NICO_NEW_L=%OUT_WIDTH_TEMP% + %OUT_WIDTH_TEMP% %% 2
rem Twitter�p
set /a OUT_HEIGHT_TWITTER=%DEFAULT_HEIGHT_TWITTER% + %DEFAULT_HEIGHT_TWITTER% %% 2
set /a OUT_WIDTH_TEMP=%DEFAULT_HEIGHT_TWITTER% * %IN_WIDTH_MOD% / %IN_HEIGHT%
set /a OUT_WIDTH_TWITTER=%OUT_WIDTH_TEMP% + %OUT_WIDTH_TEMP% %% 2

:info_check
echo;
if not defined TOTAL_TIME (
    echo ^>^>%ANALYZE_ERROR%
    call error.bat
    echo;
)
if not defined KEYINT (
    echo;
    if /i "%DECODER%"=="avi" (
        set DECODER=ffmpeg
        goto ffmpegsource_info
    ) else if /i "%DECODER%"=="ffmpeg" (
        set DECODER=directshow
        goto directshowsource_info
    ) else (
        echo ^>^>%DECODE_ERROR3%
        call error.bat
    )
)
goto movie_mode_question


rem ################�ݒ�̎���################
:movie_mode_question
echo;
echo ^>^>%ANALYZE_END%
echo;
echo;
call setting_question.bat


rem ################�G���R��ƊJ�n################
echo;
echo %HORIZON%
echo;
echo;
echo ^>^>%VIDEO_ENC_ANNOUNCE%
echo;

rem ################�f���G���R�[�h################
rem AVS�t�@�C���쐬
if /i "%RGB%"=="true" (
    if /i "%FULL_RANGE%"=="on" (
        if /i "%COLORMATRIX%"=="BT.709" (
            set AVS_SCALE=matrix^=^"PC.709^"^,
        ) else (
            set AVS_SCALE=matrix^=^"PC.601^"^,
        )
    ) else (
        if /i "%COLORMATRIX%"=="BT.709" (
            set AVS_SCALE=matrix^=^"Rec709^"^,
        ) else (
            set AVS_SCALE=matrix^=^"Rec601^"^,
        )
    )
) else (
    set AVS_SCALE=
)


if /i "%DECODER%"=="avi" goto avisource_video
if /i "%DECODER%"=="ffmpeg" goto ffmpegsource_video
if /i "%DECODER%"=="directshow" goto directshowsource_video
if /i "%DECODER%"=="qt" goto qtsource_video

:directshowsource_video
(
    if "%VFR%"=="true" (
        echo DirectShowSource^(%INPUT_FILE_PATH%, audio = false, fps=%INPUT_FPS%, convertfps=true^)
    ) else (
        echo DirectShowSource^(%INPUT_FILE_PATH%, audio = false, fps=%INPUT_FPS%, convertfps=false^)
    )
)> %VIDEO_AVS%
goto vbr_avs

:qtsource_video
(
    echo LoadPlugin^("QTSource.dll"^)
    echo;
    echo QTInput^(%INPUT_FILE_PATH%, quality = 100, audio = 0^)
)> %VIDEO_AVS%
goto vbr_avs

:avisource_video
if "%RGB%"=="true" (
    echo AVISource^(%INPUT_FILE_PATH%, audio = false^)> %VIDEO_AVS%
) else (
    echo AVISource^(%INPUT_FILE_PATH%, audio = false, pixel_type="YUY2"^)> %VIDEO_AVS%
)
goto vbr_avs

:ffmpegsource_video
date /t>nul
echo %INPUT_FILE_TYPE% | findstr /i "avi mkv mp4 flv">nul
if "%ERRORLEVEL%"=="0" (
    set SEEKMODE=1
) else (
    set SEEKMODE=-1
)
ffmsindex.exe -f %INPUT_FILE_PATH% %TEMP_DIR%\input.ffindex
echo;
(
    echo LoadPlugin^("ffms2.dll"^)
    echo;
    echo fps_num = Int^(%FPS% * 1000^)
    if "%VFR%"=="true" (
        echo FFVideoSource^(%INPUT_FILE_PATH%,cachefile="input.ffindex",seekmode=%SEEKMODE%,threads=1,fpsnum=fps_num,fpsden=1000^)
    ) else (
        echo FFVideoSource^(%INPUT_FILE_PATH%,cachefile="input.ffindex",seekmode=%SEEKMODE%,threads=1^)
    )
)> %VIDEO_AVS%

:vbr_avs
echo;>> %VIDEO_AVS%
if "%ABITRATE_MODE%"=="VBR" (
    if not "%A_SYNC%"=="n" (
        echo EnsureVBRMP3Sync^(^)>> %VIDEO_AVS%
    )
)
echo;>> %VIDEO_AVS%
if /i "%DEINT%"=="a" (
    if "%SCAN_TYPE%"=="Interlaced" goto yadif
    if "%SCAN_TYPE%"=="MBAFF" goto yadif
) else if /i "%DEINT%"=="y" goto yadif

rem �v���O���b�V�u
if "%IN_WIDTH_ODD%"=="1" (
    if "%IN_HEIGHT_ODD%"=="1" (
        echo Crop^(0,0,-1,-1^)>> %VIDEO_AVS%
    ) else (
        echo Crop^(0,0,-1,0^)>> %VIDEO_AVS%
    )
) else if "%IN_HEIGHT_ODD%"=="1" echo Crop^(0,0,0,-1^)>> %VIDEO_AVS%

echo ConvertToYV12^(%AVS_SCALE%interlaced=false^)>> %VIDEO_AVS%
echo;>> %VIDEO_AVS%
goto fps_avs

rem �C���^�[���[�X
:yadif
echo Load_Stdcall_Plugin^("yadif.dll"^)>> %VIDEO_AVS%
echo ConvertToYV12^(%AVS_SCALE%interlaced=true^)>> %VIDEO_AVS%
echo;>> %VIDEO_AVS%
if "%SCAN_TYPE%"=="MBAFF" (
    echo Yadif^(order=1^)>> %VIDEO_AVS%
    goto fps_avs
)
if "%SCAN_ORDER%"=="Top" (
    echo Yadif^(order=1^)>> %VIDEO_AVS%
    goto fps_avs
)
if "%SCAN_ORDER%"=="Bottom" (
    echo Yadif^(order=0^)>> %VIDEO_AVS%
    goto fps_avs
)
echo Yadif^(order=-1^)>> %VIDEO_AVS%

:fps_avs
if not defined RESIZER set RESIZER=Spline16Resize
(
    echo;
    if "%CHANGE_FPS%"=="true" echo ChangeFPS^(%FPS%^)
    echo;

    if not "%IN_WIDTH%"=="%WIDTH%" echo %RESIZER%^(%WIDTH%,last.height^(^)^)
    if not "%IN_HEIGHT%"=="%HEIGHT%" echo %RESIZER%^(last.width^(^),%HEIGHT%^)
)>> %VIDEO_AVS%

:denoise_avs
(
    if not "%DENOISE%"=="n" (
        echo LoadPlugin^("RemoveGrain.dll"^)
        echo LoadPlugin^("Repair.dll"^)
        echo src=last
        echo blur=src.RemoveGrain^(%RG_MODE%^)
        echo last=Repair^(blur, src^)
    )
    echo;
    echo return last
)>> %VIDEO_AVS%

echo ^>^>%AVS_END%
echo;

call x264_enc.bat

rem ################�����G���R�[�h################
echo ^>^>%VIDEO_ENC_END%
echo;

if "%A_BITRATE%"=="0" (
    echo ^>^>%SILENCE_ANNOUNCE%
    echo;
    .\silence.exe %FINAL_WAV% -l 0.1 -c 2 -s 44100 -b 16
    .\neroAacEnc.exe -lc -br 0 -if %FINAL_WAV% -of %TEMP_M4A%
    goto :eof
)

echo ^>^>%AUDIO_ENC_ANNOUNCE%
echo ^>^>%WAV_ANNOUNCE%
echo;

if /i "%DECODER%"=="avi" goto avisource_audio
if /i "%DECODER%"=="ffmpeg" goto ffmpegsource_audio
if /i "%DECODER%"=="directshow" goto directshowsource_audio
if /i "%DECODER%"=="qt" goto qtsource_audio

:directshowsource_audio
(
    echo DirectShowSource^(%INPUT_FILE_PATH%, video = false^)
    echo;
    echo return last
)> %AUDIO_AVS%
goto temp_wav

:qtsource_audio
(
    echo LoadPlugin^("QTSource.dll"^)
    echo;
    echo QTInput^(%INPUT_FILE_PATH%, quality = 100, audio = 1^)
    echo;
    echo return last
)> %AUDIO_AVS%
goto temp_wav

:avisource_audio
(
    echo AVISource^(%INPUT_FILE_PATH%, audio = true^)
    echo;
    echo return last
)> %AUDIO_AVS%
goto temp_wav

:ffmpegsource_audio
echo;
(
    echo LoadPlugin^("ffms2.dll"^)
    echo;
    echo FFAudioSource^(%INPUT_FILE_PATH%, cachefile="input.ffindex"^)
    echo;
    echo return last
)> %AUDIO_AVS%

:temp_wav
if exist %PROCESS_E_FILE% del %PROCESS_E_FILE%
if not "%WAV_FAIL%"=="y" (
    echo s>%PROCESS_S_FILE%
    start /b process.bat 2>nul
)
.\avs2pipe_gcc.exe audio %AUDIO_AVS% > %TEMP_WAV% 2>nul
if "%WAV_FAIL%"=="y" (
    del %PROCESS_S_FILE% 2>nul
    set WAV_FAIL=
    goto wav_process
)
for %%i in (%TEMP_WAV%) do if %%~zi EQU 0 set WAV_FAIL=y
if "%WAV_FAIL%"=="y" goto directshowsource_audio
del %PROCESS_S_FILE% 2>nul

:wav_process
ping localhost -n 1 >nul
if not exist %PROCESS_E_FILE% goto wav_process 1>nul 2>&1
del %PROCESS_E_FILE%

call m4a_enc.bat

