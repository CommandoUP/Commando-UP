@echo off
setlocal EnableExtensions EnableDelayedExpansion

:: =========================================================
:: 
:: =========================================================

:: ====== VERSION SYSTEM ======
set "LOCAL_VERSION=6.0"
set "VERSION_URL=https://raw.githubusercontent.com/CommandoUP/Commando-UP/refs/heads/main/version"
set "UPDATE_URL=https://raw.githubusercontent.com/CommandoUP/Commando-UP/refs/heads/main/CommandoOptimizer.bat"
set "SCRIPT_NAME=CommandoOptimizer.bat"

:: ====== CHECK UPDATE ======
:check_update
cls
echo =========================================================
echo   v%LOCAL_VERSION%
echo =========================================================
echo.
echo [+] Checking for updates...
for /f "delims=" %%a in ('powershell -command "(Invoke-WebRequest -UseBasicParsing %VERSION_URL%).Content"') do set "REMOTE_VERSION=%%a"

if not defined REMOTE_VERSION (
    echo [-] Failed to check updates (no internet or URL error).
    timeout /t 2 >nul
    goto :menu
)

echo [*] Local Version : %LOCAL_VERSION%
echo [*] Remote Version: %REMOTE_VERSION%
echo.

if "%LOCAL_VERSION%"=="%REMOTE_VERSION%" (
    echo [+] You are already using the latest version.
    timeout /t 2 >nul
    goto :menu
) else (
    echo [!] Update available! Downloading new version...
    powershell -command "Invoke-WebRequest -Uri %UPDATE_URL% -OutFile %SCRIPT_NAME%.new"
    if exist "%SCRIPT_NAME%.new" (
        echo [+] Update downloaded successfully.
        echo [+] Replacing old script...
        move /y "%SCRIPT_NAME%.new" "%SCRIPT_NAME%" >nul
        echo [+] Update applied! Please restart the script.
        pause
        exit
    ) else (
        echo [-] Failed to download update.
        pause
        goto :menu
    )
)

:: ====== MAIN MENU ======
:menu
cls
echo =========================================================
echo   PUBG Optimizer v%LOCAL_VERSION% (Fixed Edition)
echo =========================================================
echo.
echo [1] Paks (Paste And Copy GameLoop)
echo [2] Apply DPI/RAM/Resolution/Processor
echo [3] Ultra Optimizer
echo [4] Close GameLoop
echo [5] ADB
echo [0] Exit
echo.
set /p "opt=Choose an option: "

if "%opt%"=="1" goto :paks_menu
if "%opt%"=="2" goto :dpi_res
if "%opt%"=="3" goto :ultra_optimizer
if "%opt%"=="4" goto :close_gameloop
if "%opt%"=="5" goto :adb_menu
if "%opt%"=="0" exit
goto :menu


:: ====== PAKS MENU ======
:paks_menu
cls
echo =========================================================
echo   Paks (Paste And Copy GameLoop)
echo =========================================================
echo.
echo [1] Paks   (Copy from GameLoop)
echo [2] Restore Paks  (Paste to GameLoop)
echo [0] Back
echo.
set /p "paks_opt=Choose an option: "

if "%paks_opt%"=="1" goto :backup_paks
if "%paks_opt%"=="2" goto :restore_paks
if "%paks_opt%"=="0" goto :menu
goto :paks_menu


:: ====== BACKUP ======
:backup_paks
call :find_adb || goto :paks_menu
cls
echo [+] Backing up Paks...
if exist "%SRC_DIR%" rmdir /s /q "%SRC_DIR%"
mkdir "%SRC_DIR%"
"%ADB%" pull "%DST_DIR%" "%SRC_DIR%"
if errorlevel 1 (
  echo [-] Backup Failed. Check ADB connection.
) else (
  echo [+] Backup Completed Successfully. Files saved in "%SRC_DIR%"
)
pause
goto :paks_menu


:: ====== RESTORE ======
:restore_paks
call :find_adb || goto :paks_menu
cls
if not exist "%SRC_DIR%" (
  echo [-] Source folder "%SRC_DIR%" not found.
  pause
  goto :paks_menu
)
echo [+] Restoring Paks...
"%ADB%" push "%SRC_DIR%/." "%DST_DIR%"
if errorlevel 1 (
  echo [-] Restore Failed. Check ADB connection and paths.
) else (
  echo [+] Restore Completed Successfully.
)
pause
goto :paks_menu


:: ====== CLOSE GAMELOOP ======
:close_gameloop
cls
echo [+] Closing all GameLoop processes...
taskkill /F /IM AndroidEmulatorEn.exe >nul 2>&1
taskkill /F /IM AndroidEmulator.exe >nul 2>&1
taskkill /F /IM appmarket.exe >nul 2>&1
echo [+] GameLoop closed successfully.
pause
goto :menu


:: ====== ADB MENU ======
:adb_menu
cls
echo =========================================================
echo   ADB Options
echo =========================================================
echo.
echo [1] ADB Install
echo [2] ADB Check
echo [3] ADB Close
echo [0] Back
echo.
set /p "adb_opt=Choose an option: "

if "%adb_opt%"=="1" goto :adb_install
if "%adb_opt%"=="2" goto :adb_check
if "%adb_opt%"=="3" goto :close_adb
if "%adb_opt%"=="0" goto :menu
goto :adb_menu


:: ====== ADB INSTALL ======
:adb_install
cls
echo [+] Running ADB Installer (adb-setup-1.4.3.exe)...
if exist "%~dp0adb-setup-1.4.3.exe" (
    start "" "%~dp0adb-setup-1.4.3.exe"
    echo [+] Installer launched successfully.
) else (
    echo [-] adb-setup-1.4.3.exe not found in script folder.
)
pause
goto :adb_menu


:: ====== CLOSE ADB ======
:close_adb
cls
echo [+] Stopping ADB server...
call :find_adb || goto :adb_menu
"%ADB%" kill-server
echo [+] ADB server stopped successfully.
pause
goto :adb_menu


:: ====== ULTRA OPTIMIZER MENU ======
:ultra_optimizer
cls
echo =========================================================
echo    Commando PUBG Optimizer v%LOCAL_VERSION%
echo =========================================================
echo.
echo [1] Clean PUBG Cache
echo [2] Apply GPU/IO Boost
echo [3] Set Emulator Priority to HIGH
echo [4] Optimize Network Stack
echo [5] Pin Emulator to Specific Cores
echo [6] Launch PUBG
echo [0] Back to Main Menu
echo.
set /p "opt2=Choose an option: "

if "%opt2%"=="1" goto :clean_cache
if "%opt2%"=="2" goto :gpu_boost
if "%opt2%"=="3" goto :priority_high
if "%opt2%"=="4" goto :net_opt
if "%opt2%"=="5" goto :pin_cores
if "%opt2%"=="6" goto :launch_pubg
if "%opt2%"=="0" goto :menu
goto :ultra_optimizer


:: ====== CLEAN CACHE ======
:clean_cache
call :find_adb || goto :ultra_optimizer
cls
echo [+] Cleaning PUBG Cache...
"%ADB%" shell rm -rf /sdcard/Android/data/%PKG%/cache >nul 2>&1
echo [+] Cache Cleaned.
pause
goto :ultra_optimizer


:: ====== GPU BOOST ======
:gpu_boost
call :find_adb || goto :ultra_optimizer
cls
echo [+] Applying GPU/IO Boost...
"%ADB%" shell settings put global gpu_debug_layers 1 >nul 2>&1
"%ADB%" shell settings put global gpu_debug_app %PKG% >nul 2>&1
echo [+] GPU/IO Boost Applied.
pause
goto :ultra_optimizer


:: ====== PRIORITY HIGH ======
:priority_high
cls
echo [+] Setting Emulator Priority to HIGH...
wmic process where name="AndroidEmulatorEn.exe" CALL setpriority "high" >nul 2>&1
echo [+] Priority Set to HIGH.
pause
goto :ultra_optimizer


:: ====== NET OPTIMIZE ======
:net_opt
cls
echo [+] Optimizing Network Stack...
netsh int tcp set global autotuninglevel=normal >nul
netsh int tcp set global ecncapability=disabled >nul
netsh int tcp set global timestamps=disabled >nul
netsh int tcp set global rss=enabled >nul
echo [+] Network Stack Optimized.
pause
goto :ultra_optimizer


:: ====== PIN CORES ======
:pin_cores
cls
echo [+] Pinning Emulator to Specific Cores...
for /F "tokens=2 delims=," %%a in ('tasklist /fi "imagename eq AndroidEmulatorEn.exe" /fo csv /nh') do (
    start "" /affinity 0xF /high taskkill /pid %%~a /T /F
)
echo [+] Emulator Pinned to Specific Cores.
pause
goto :ultra_optimizer


:: ====== LAUNCH PUBG ======
:launch_pubg
call :find_adb || goto :ultra_optimizer
cls
echo [+] Launching PUBG Mobile...
"%ADB%" shell monkey -p com.tencent.ig -c android.intent.category.LAUNCHER 1
echo [+] PUBG Launched Successfully!
pause
goto :ultra_optimizer


:: ====== ADB CHECK ======
:adb_check
call :find_adb
if errorlevel 1 (
    echo [-] ADB not found.
) else (
    echo [+] ADB is found at: %ADB%
    "%ADB%" start-server >nul 2>&1
    echo [+] ADB server started successfully.
)
pause
goto :adb_menu


:: ====== FIND ADB ======
:find_adb
set "ADB="
for %%P in (
  "%ProgramFiles%\TxGameAssistant\appmarket\adb.exe"
  "%ProgramFiles(x86)%\TxGameAssistant\appmarket\adb.exe"
  "%ProgramFiles%\GameLoop\adb.exe"
  "%ProgramFiles(x86)%\GameLoop\adb.exe"
  "%~dp0platform-tools\adb.exe"
  "%~dp0adb.exe"
) do (
  if exist "%%~fP" set "ADB=%%~fP" & goto :adb_found
)

where adb >nul 2>&1 && for /f "delims=" %%A in ('where adb') do set "ADB=%%A" & goto :adb_found

cls
echo [+] ADB not found. Put adb.exe near the script or enable it in GameLoop.
pause
exit /b 1

:adb_found
"%ADB%" start-server >nul 2>&1
exit /b 0
