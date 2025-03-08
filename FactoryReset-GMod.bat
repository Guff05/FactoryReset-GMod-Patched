@echo off

:: Check if the script is running from the correct Garry's Mod directory
IF NOT EXIST ".\gmod.exe" (
    ECHO Game binary doesn't exist. Are you executing this script from the wrong directory?
    EXIT /B 1
)

:: Warn the user about what the script does
ECHO This script will attempt to reset Garry's Mod to its default state. If the game is running, it will be closed.
ECHO You will lose any settings that have been changed and potentially any saved data, such as duplications.
ECHO Addons will not be removed.
ECHO.

:: Ask for confirmation
CHOICE /M "Are you sure you want to continue?"

IF ERRORLEVEL 2 (
    ECHO Aborting.
    EXIT /B 1
)

ECHO.

:: Stop Garry's Mod if it's running
TASKKILL /f /im "gmod.exe" >NUL 2>&1

:: Remove configuration files
ECHO [1/7] Removing configuration
CALL :DEL_DIR ".\garrysmod\cfg"
CALL :DEL_DIR ".\garrysmod\settings"

:: Remove addon data
ECHO [2/7] Removing stored addon data
CALL :DEL_DIR ".\garrysmod\data"

:: Remove server downloads
ECHO [3/7] Removing downloaded server content
CALL :DEL_DIR ".\garrysmod\download"
CALL :DEL_DIR ".\garrysmod\downloads"
CALL :DEL_DIR ".\garrysmod\downloadlists"

:: Remove base Lua scripts and gamemodes
ECHO [4/7] Removing base Lua scripts and gamemodes
CALL :DEL_DIR ".\garrysmod\gamemodes\base"
CALL :DEL_DIR ".\garrysmod\gamemodes\sandbox"
CALL :DEL_DIR ".\garrysmod\gamemodes\terrortown"
CALL :DEL_DIR ".\garrysmod\lua"

:: Remove SQLite databases
ECHO [5/7] Removing SQLite databases
CALL :DEL_FILE ".\garrysmod\cl.db"
CALL :DEL_FILE ".\garrysmod\sv.db"
CALL :DEL_FILE ".\garrysmod\mn.db"

:: Clear Lua/Workshop cache
ECHO [6/7] Emptying Lua/Workshop cache
CALL :DEL_DIR ".\garrysmod\cache"

:: Trigger Steam to validate and redownload missing files
ECHO [7/7] Marking game's content for validation by Steam
.\gmod.exe -factoryresetstuff

ECHO.
ECHO Finished. Steam will attempt to download some missing files the next time you launch Garry's Mod.
ECHO.

PAUSE
EXIT /B

:DEL_DIR
    :: Remove directory if it exists
    IF EXIST %1 ( RMDIR /S /Q %1 )
    GOTO:EOF

:DEL_FILE
    :: Remove file if it exists
    IF EXIST %1 ( DEL /Q %1 )
    GOTO:EOF
