rem ################�ϐ��ݒ�################
set INFO_AVS1=%TEMP_DIR%\information1.avs
set INFO_AVS2=%TEMP_DIR%\information2.avs


rem ################������擾################
echo;
echo ^>^>%ANALYZE_ANNOUNCE%
echo;

rem �Đ����Ԏ擾
(
    echo LoadPlugin^("warpsharp.dll"^)
    echo LoadAviUtlInputPlugin^("nvvinput.aui", "NVVSource"^)
    echo;
    echo NVVSource^(%INPUT_FILE_PATH%^)
    echo;
    echo _time = String^(Ceil^(framecount^(^) / framerate^(^)^)^)
    echo _fps = String^(framerate^(^)^)
    echo _keyint = String^(Round^(framerate^(^)^)^)
    echo _in_width = String^(Ceil(width^(^)^)^)
    echo _in_height = String^(Ceil(height^(^)^)^)
    echo _out_width = %DEFAULT_WIDTH%
    echo _out_height = String^(Round^(%DEFAULT_WIDTH%*height^(^)/width^(^)^)^)
    echo;
    echo WriteFileStart^("time.txt","_time",append = false^)
    echo WriteFileStart^("keyint.txt","_keyint",append = false^)
    echo WriteFileStart^("fps.txt","_fps",append = false^)
    echo WriteFileStart^("in_width.txt","_in_width",append = false^)
    echo WriteFileStart^("in_height.txt","_in_height",append = false^)
    echo WriteFileStart^("out_width.txt","_out_width",append = false^)
    echo WriteFileStart^("out_height.txt","_out_height",append = false^)
    echo Trim^(0,-1^)
    echo;
    echo return last
)> %INFO_AVS1%

.\avs2pipe_gcc.exe info %INFO_AVS1% 1>nul 2>&1

for /f %%i in (%TEMP_DIR%\time.txt) do set /a TOTAL_TIME=%%i * 1000
echo PlayTime     : %TOTAL_TIME%ms

echo Format       : NVV^(NiVE Video^)

if "%DEFAULT_FPS%"=="" (
    set CHANGE_FPS=false
    set FPS=%INPUT_FPS%
) else (
    set CHANGE_FPS=true
    set FPS=%DEFAULT_FPS%
)


for /f %%i in (%TEMP_DIR%\keyint.txt) do set /a KEYINT=10*%%i

for /f %%i in (%TEMP_DIR%\fps.txt) do set FPS=%%i
echo FPS          : %FPS%fps^(CFR^)

for /f %%i in (%TEMP_DIR%\in_width.txt) do set /a IN_WIDTH=%%i
echo Width        : %IN_WIDTH%pixels

for /f %%i in (%TEMP_DIR%\in_height.txt) do set /a IN_HEIGHT=%%i
echo Height       : %IN_HEIGHT%pixels

for /f %%i in (%TEMP_DIR%\out_width.txt) do set /a OUT_WIDTH=%%i
for /f %%i in (%TEMP_DIR%\out_height.txt) do set /a OUT_HEIGHT=%%i
set /a OUT_HEIGHT_MOD=%OUT_HEIGHT% %% 2
set /a OUT_HEIGHT-=%OUT_HEIGHT_MOD%

rem ���̑��̏��̎擾
(
    echo BlankClip^(length=1, width=32, height=32^)
    echo _premium_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_PREMIUM%^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _normal_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_NORMAL%^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _premium_bitrate_new = String^(Floor^(Float^(%DEFAULT_SIZE_PREMIUM_NEW%^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _twitter_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_TWITTER%^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo WriteFileStart^("premium_bitrate.txt","_premium_bitrate",append = false^)
    echo WriteFileStart^("normal_bitrate.txt","_normal_bitrate",append = false^)
    echo WriteFileStart^("premium_bitrate_new.txt","_premium_bitrate_new",append = false^)
    echo WriteFileStart^("twitter_bitrate.txt","_twitter_bitrate",append = false^)
    echo;
)> %INFO_AVS2%
echo return last>> %INFO_AVS2%

.\avs2pipe_gcc.exe info %INFO_AVS2% 1>nul 2>&1

for /f %%i in (%TEMP_DIR%\premium_bitrate.txt) do set /a P_TEMP_BITRATE=%%i 2>nul
for /f %%i in (%TEMP_DIR%\normal_bitrate.txt) do set /a I_TEMP_BITRATE=%%i 2>nul
for /f %%i in (%TEMP_DIR%\premium_bitrate_new.txt) do set /a P_TEMP_BITRATE_NEW=%%i 2>nul
for /f "delims=" %%i in (%TEMP_DIR%\twitter_bitrate.txt) do set /a TW_TEMP_BITRATE=%%i>nul

echo;

echo ^>^>%ANALYZE_END%
echo;
echo;


rem ################�ݒ�̎���################
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
if /i "%FULL_RANGE%"=="on" set AVS_SCALE=matrix^=^"PC.601^"^,

(
    echo LoadPlugin^("warpsharp.dll"^)
    echo LoadAviUtlInputPlugin^("nvvinput.aui", "NVVSource"^)
    echo;
    echo NVVSource^(%INPUT_FILE_PATH%^)
    echo ConvertToYV12^(%AVS_SCALE%interlaced=false^)
    echo;

    if "%CHANGE_FPS%"=="true" echo ChangeFPS^(%FPS%^)
    echo;

    if "%RESIZER%"=="" set RESIZER=Spline16Resize
    if not "%IN_WIDTH%"=="%WIDTH%" echo %RESIZER%^(%WIDTH%,last.height^(^)^)
    if not "%IN_HEIGHT%"=="%HEIGHT%" echo %RESIZER%^(last.width^(^),%HEIGHT%^)
    echo;
    echo return last
)> %VIDEO_AVS%

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
echo;

(
    echo LoadPlugin^("warpsharp.dll"^)
    echo LoadAviUtlInputPlugin^("nvvinput.aui", "NVVSource"^)
    echo;
    echo NVVSource^(%INPUT_FILE_PATH%^)
    echo return last
)> %AUDIO_AVS%

echo ^>^>%WAV_ANNOUNCE%
if exist %PROCESS_E_FILE% del %PROCESS_E_FILE%
echo s>%PROCESS_S_FILE%
start /b process.bat 2>nul
.\avs2pipe_gcc.exe audio %AUDIO_AVS% > %TEMP_WAV% 2>nul
echo;
del %PROCESS_S_FILE% 2>nul
:wav_process
ping localhost -n 1 >nul
if not exist %PROCESS_E_FILE% goto wav_process 1>nul 2>&1
del %PROCESS_E_FILE%

call m4a_enc.bat
