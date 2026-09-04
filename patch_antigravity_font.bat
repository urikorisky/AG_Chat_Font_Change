@echo off
SETLOCAL EnableDelayedExpansion
title AntiGravity 2.12.2 Font Patcher

echo ===================================================
echo   AntiGravity 2.12.2 Font Size Patcher for Windows
echo ===================================================
echo.

:: 1. Check Node.js installation
where node >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Node.js is not installed on your system.
    echo Please install Node.js from https://nodejs.org/ before running this script.
    echo.
    pause
    exit /b 1
)

:: 2. Target Path Configuration
set "TARGET_DIR=%LOCALAPPDATA%\Programs\Antigravity\resources"
set "ASAR_FILE=!TARGET_DIR!\app.asar"
set "WORKING_DIR=!TARGET_DIR!\app-working"
set "MAIN_JS=!WORKING_DIR!\dist\main.js"

echo [INFO] Target directory: !TARGET_DIR!

:: Check if app.asar exists
if not exist "!ASAR_FILE!" (
    echo [ERROR] Could not locate app.asar at:
    echo "!ASAR_FILE!"
    echo Make sure AntiGravity 2.12.2 is installed in your local AppData folder.
    echo.
    pause
    exit /b 1
)

:: 3. Install/Verify asar package manager tool
echo [INFO] Verifying global @electron/asar module installation...
call npm list -g @electron/asar >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo [INFO] Installing @electron/asar utility globally...
    call npm install -g @electron/asar
)

:: 4. Cleanup old working paths
if exist "!WORKING_DIR!" (
    echo [INFO] Removing previous app-working workspace folder...
    rmdir /s /q "!WORKING_DIR!"
)

:: 5. Unpacking the archive container
echo [INFO] Extracting application bundle archive (app.asar)...
cd /d "!TARGET_DIR!"
call asar extract app.asar app-working

if not exist "!MAIN_JS!" (
    echo [ERROR] Extraction finished, but main entry file could not be found:
    echo "!MAIN_JS!"
    echo.
    pause
    exit /b 1
)

:: 6. Inject the Custom Layout Structural Typography Script
echo [INFO] Injecting layout structural scanner script into main.js...

:: Create a temporary scratch file safely to append script components cleanly
set "TEMP_SCRIPT=%TEMP%\ag_patch_injection.tmp"

echo. > "%TEMP_SCRIPT%"
echo // Structural Layout Font Adjuster for AntiGravity 2.12.2 >> "%TEMP_SCRIPT%"
echo (function() { >> "%TEMP_SCRIPT%"
echo   const electronApp = require('electron').app; >> "%TEMP_SCRIPT%"
echo   function injectLayoutFontSize(contents) { >> "%TEMP_SCRIPT%"
echo     const script = ` >> "%TEMP_SCRIPT%"
echo       setInterval(() ^=> { >> "%TEMP_SCRIPT%"
echo         const textElements = document.querySelectorAll('p, span, code, pre, button, li, td, th'); >> "%TEMP_SCRIPT%"
echo         textElements.forEach(el ^=> { >> "%TEMP_SCRIPT%"
echo           if (el.closest('.antigravity-left-nav') ^|^| el.closest('[class*="sidebar"]') ^| ^| el.closest('[class*="left-panel"]')) return; >> "%TEMP_SCRIPT%"
echo           if (el.closest('.monaco-editor') ^|^| el.closest('[class*="editor"]') ^|^| el.closest('[class*="document-viewer"]')) return; >> "%TEMP_SCRIPT%"
echo           el.style.setProperty('font-size', '16px', 'important'); >> "%TEMP_SCRIPT%"
echo           el.style.setProperty('line-height', '1.5', 'important'); >> "%TEMP_SCRIPT%"
echo           if (el.tagName === 'TD' ^|^| el.tagName === 'TH' ^|^| el.tagName === 'CODE') { >> "%TEMP_SCRIPT%"
echo             el.style.setProperty('font-size', '14px', 'important'); >> "%TEMP_SCRIPT%"
echo           } >> "%TEMP_SCRIPT%"
echo         }); >> "%TEMP_SCRIPT%"
echo       }, 1000); >> "%TEMP_SCRIPT%"
echo     `; >> "%TEMP_SCRIPT%"
echo     contents.executeJavaScript(script).catch(() ^=> {}); >> "%TEMP_SCRIPT%"
echo   } >> "%TEMP_SCRIPT%"
echo   electronApp.whenReady().then(() ^=> { >> "%TEMP_SCRIPT%"
echo     electronApp.on('web-contents-created', (event, contents) ^=> { >> "%TEMP_SCRIPT%"
echo       contents.on('did-finish-load', () ^=> injectLayoutFontSize(contents)); >> "%TEMP_SCRIPT%"
echo       contents.on('dom-ready', () ^=> injectLayoutFontSize(contents)); >> "%TEMP_SCRIPT%"
echo     }); >> "%TEMP_SCRIPT%"
echo   }); >> "%TEMP_SCRIPT%"
echo })(); >> "%TEMP_SCRIPT%"

:: Append injection code safely into source script
type "%TEMP_SCRIPT%" >> "!MAIN_JS!"
del "%TEMP_SCRIPT%"

:: 7. Re-bundle archive container
echo [INFO] Packing files back up into application bundle archive (app.asar)...
call asar pack app-working app.asar

:: 8. Clean up workspace files
echo [INFO] Cleaning up local working directory paths...
rmdir /s /q "!WORKING_DIR!"

echo.
echo ===================================================
echo [SUCCESS] Patch complete! Relaunch AntiGravity 2.12.2
echo ===================================================
echo.
pause
