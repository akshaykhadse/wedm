for /f "tokens=1* delims=." %%i in ('dir /b *.svg') do (
    "C:\Program Files\Inkscape\inkscape.exe" --without-gui --file="%%i.svg" --export-pdf="%%i.pdf"
)