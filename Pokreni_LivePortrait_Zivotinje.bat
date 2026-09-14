@echo off
title LivePortrait - Zivotinje (Cats & Dogs)
cd /d "%~dp0"

echo ==============================================================
echo       Pokretanje LivePortrait (Animals) Web Sucelja...
echo ==============================================================

set PYTHONUTF8=1
set NO_PROXY=localhost,127.0.0.1
set PATH=%~dp0ffmpeg;%~dp0.venv\Lib\site-packages\torch\lib;%PATH%

if not exist ".venv\Scripts\activate.bat" (
    echo [GRESKA] Virtualno okruzenje .venv nije pronadeno!
    pause
    exit /b 1
)

call .venv\Scripts\activate.bat

echo Web adresa: http://127.0.0.1:8891
echo.
echo [INFO] AI modeli se ucitavaju na graficku karticu (RTX 4060)...
echo [INFO] Molimo pricekajte 15-20 sekundi.
echo [INFO] Web preglednik ce se automatski otvoriti cim sucelje bude spremno!
echo ==============================================================
echo.

python app_animals.py --server_port 8891

pause
