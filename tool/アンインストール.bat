@echo off
cd /d "%~d0" 1>nul 2>&1
cd "%~p0"
title �ǁA�ǂ����āE�E�E�H�킽���A�Ȃɂ��C�ɏ��悤�Ȃ��Ƃ����H

echo ------------------------------------------------------------------------------
echo �@��ł��  �A���C���X�g�[��
echo ------------------------------------------------------------------------------
echo;

if not exist %WINDIR%\System32\avisynth.dll goto loop1
if exist %WINDIR%\SysWow64\avisynth.dll goto loop1

echo ^>^>���XAvisynth���C���X�g�[������Ă����̂ŁA�A���C���X�g�[���̕K�v�͂Ȃ����B
echo ^>^>��ł�񂱂̃t�H���_���Ƃ��ƂƃS�~���Ɏ����Ă����Ȃ�����ˁI
echo ^>^>�������񂽂̂��ƂȂ�Ēm��Ȃ��񂾂���E�E�E�I
echo;
call quit.bat


:loop1
echo ^>^>�ق�ƂɃA���C���X�g�[������́H�iy/n�j
set /p UNINSTALL=^>^>

if /i "%UNINSTALL%"=="y" goto loop2
if /i "%UNINSTALL%"=="n" goto cancel

echo;
echo ^>^>������Ƃ��I��������I�тȂ�����I
echo;
goto loop1


:loop2
echo ^>^>������x�m�F������H�ق�ƂɃA���C���X�g�[������́H�iy/n�j
set /p UNINSTALL=^>^>

if /i "%UNINSTALL%"=="y" goto loop3
if /i "%UNINSTALL%"=="n" goto cancel

echo;
echo ^>^>������Ƃ��I��������I�тȂ�����I
echo;
goto loop2


:loop3
echo ^>^>�E�E�E�ق�ƂɁH�iy/n�j
set /p UNINSTALL=^>^>

if /i "%UNINSTALL%"=="y" goto loop4
if /i "%UNINSTALL%"=="n" goto cancel

echo;
echo ^>^>������Ƃ��I��������I�тȂ�����I
echo;
goto loop3


:loop4
echo ^>^>�E�E�E�ǂ����Ă��H�iy/n�j
set /p UNINSTALL=^>^>

if /i "%UNINSTALL%"=="y" goto loop5
if /i "%UNINSTALL%"=="n" goto cancel

echo;
echo ^>^>������Ƃ��I��������I�тȂ�����I
echo;
goto loop4


:loop5
echo ^>^>�E�E�E����Ȃɂ��肢���Ă��H�iy/n�j
set /p UNINSTALL=^>^>

if /i "%UNINSTALL%"=="y" goto uninstall
if /i "%UNINSTALL%"=="n" goto cancel

echo;
echo ^>^>������Ƃ��I��������I�тȂ�����I
echo;
goto loop5


:uninstall
echo ^>^>����I��������ɂ���΂�������Ȃ��I
regedit /s uninstall.reg>nul
echo ^>^>�ق�I���W�X�g���̍폜�͏I��������I
echo ^>^>���Ƃ͂�ł�񂱂̃t�H���_���Ƃ��ƂƃS�~���Ɏ����Ă����Ȃ�����ˁI
echo;
echo ^>^>���񂽂Ȃ�āE�E�E�����m��Ȃ��񂾂���E�E�E�I
echo;
goto uninstall_end


:cancel
echo ^>^>���E�E�E�ق�ƁH
echo ^>^>�ׁA�ʂɂ��ꂵ���Ȃ񂩂Ȃ��񂾂���ˁI���Ⴂ���Ȃ��ł�ˁI
echo;


:uninstall_end
call quit.bat
