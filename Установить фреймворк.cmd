@echo off
chcp 65001 >nul
setlocal
title Установка фреймворка design-to-frontend
set "REPO=panchishen/design-to-frontend"
set "MP=panchishen"
set "PLUGIN=design-to-frontend@panchishen"

echo.
echo   Фреймворк веб-проектов «дизайн - фронтенд» для Claude
echo   Этот файл и ставит плагин, и обновляет его: запускай, когда нужна новая версия.
echo.

where git >nul 2>nul
if errorlevel 1 goto nogit

where claude >nul 2>nul
if not errorlevel 1 goto haveclaude
if exist "%USERPROFILE%\.local\bin\claude.exe" goto addpath

echo   [!] Не найден Claude Code - командная строка Claude, через неё ставится плагин.
echo       Приложение Claude при этом не трогаем, оно продолжит работать.
echo.
echo   Нажми любую клавишу, чтобы установить Claude Code, или закрой окно, чтобы отменить.
pause >nul
echo   Устанавливаю Claude Code, это займёт пару минут...
powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://claude.ai/install.ps1 | iex"
if not exist "%USERPROFILE%\.local\bin\claude.exe" goto noclaude

:addpath
set "PATH=%USERPROFILE%\.local\bin;%PATH%"

:haveclaude
echo   [1/2] Подключаю каталог плагинов %REPO% ...
call claude plugin marketplace list 2>nul | findstr /i /c:"%MP%" >nul
if errorlevel 1 goto mpadd
call claude plugin marketplace update %MP%
if errorlevel 1 goto fail
goto plugin
:mpadd
call claude plugin marketplace add %REPO%
if errorlevel 1 goto fail

:plugin
echo.
echo   [2/2] Ставлю плагин design-to-frontend ...
call claude plugin list 2>nul | findstr /i /c:"design-to-frontend" >nul
if errorlevel 1 goto pinstall
call claude plugin update %PLUGIN%
if errorlevel 1 goto fail
goto done
:pinstall
call claude plugin install %PLUGIN%
if errorlevel 1 goto fail

:done
echo.
echo   ГОТОВО. Фреймворк установлен и обновлён до последней версии.
echo.
echo   Дальше:
echo     1. Перезапусти приложение Claude - закрой его полностью и открой снова.
echo     2. Вкладка Code, новая сессия в пустой папке будущего проекта.
echo     3. Напиши /new-project и следуй подсказкам.
echo.
pause
exit /b 0

:nogit
echo   [!] Не найден Git - он нужен, чтобы скачать фреймворк с GitHub.
echo       Сейчас откроется страница загрузки: скачай, установи с настройками
echo       по умолчанию и запусти этот файл снова.
start "" "https://git-scm.com/download/win"
echo.
pause
exit /b 1

:noclaude
echo.
echo   [!] Claude Code установить не удалось.
echo       Установи вручную по инструкции https://code.claude.com/docs/en/setup
echo       и запусти этот файл снова. Не получается - напиши владельцу фреймворка
echo       и приложи скриншот этого окна.
echo.
pause
exit /b 1

:fail
echo.
echo   [!] Что-то пошло не так - текст ошибки выше.
echo       Проверь интернет и запусти файл ещё раз. Не помогло - отправь
echo       скриншот этого окна владельцу фреймворка.
echo.
pause
exit /b 1
