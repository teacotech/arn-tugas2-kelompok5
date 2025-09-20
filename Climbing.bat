@echo off
rem Argumen pertama untuk MAT dan argumen kedua untuk ZAID
echo Pastikan argumen pertama %1 adalah MAT dan argumen kedua %2 adalah ZAID 

set "specialNumber=%1"
set "foundFile_dat="
set "foundFile_INP="
set "ZAID=%2"

rem Deklarasi variabel libs
set "libsValue=ENDFB8.1"

rem Menggunakan variabel `%~dp0`, untuk mengambil absolute path pada workspace di mana .dat file di-folderkan, hehe?
rem Menggunakan iterasi `FOR` untuk meng-iterasi sepanjang file yang berformat .dat dari folder yang berisi .dat (ENDF-BVIII-1)
for %%f in ("%~dp0ENDF-BVIII-1\*.dat") do (
    rem Menggunakan "%%~nxf" untuk mendapatkan hanya berupa nama file (filename) dan format (extension) dari file terbaru. (e.g., n_008-O-16_0825.dat)
    echo "%%~nxf" | findstr /i /c:"%specialNumber%" >nul
    rem findstr hanya mengganti nilai variabel tak terlihat -- errorlevel.
    if not errorlevel 1 (
        set "foundFile_dat=%%f"
        set "baseFileName=%%~nf"
        goto :datFound
    )
)

:datFound

rem Begitu pula untuk .INP yang akan dicari 
for %%f in ("%~dp0INP\*.INP") do (
    echo "%%~nxf" | findstr /i /c:"%specialNumber%" >nul
    if not errorlevel 1 (
        set "foundFile_INP=%%f"
        goto :inpFound
    )
)

:inpFound

if not defined foundFile_dat (
    echo Error: .dat file cannot be found in %specialNumber%
    goto :end
) else ( echo Found .dat file: "%foundFile_dat%")
if not defined foundFile_INP (
    echo Error: .INP file cannot be found in %specialNumber%
    goto :end
) else ( echo Found .INP file: "%foundFile_INP%")

rem Dari sini, kita dapat menjalankan perintah Yth. Bapak Alexander Agung
copy "%foundFile_dat%" tape20
echo Menjalankan NJOY ...
NJOY2016_64.exe < "%foundFile_INP%"

rem Membuat folder output kemudian dinamakan dengan baseFileName-nya.
set "outputDir=%~dp0output_%baseFileName%"
mkdir "%outputDir%"

rem Konstruksi output filename
rem output filename_%LIBS%.out
set "outputFile_out=%outputDir%\%baseFileName%_%libsValue%.out"
rem output filename_%LIBS%.pendf
set "outputFile_pendf=%outputDir%\%baseFileName%_%libsValue%.pendf"
rem output filename0_%LIBS%.ACE
set "outputFile_ACE=%outputDir%\%baseFileName%0_%libsValue%.ACE"
rem output filename ZAID.03c
set "outputFile_ZAID=%outputDir%\%ZAID%.03c"
rem output filename_%LIBS%.XSDIR
set "outputFile_XSDIR=%outputDir%\%baseFileName%_%libsValue%.XSDIR"
rem output filename_%LIBS%.ps
set "outputFile_ps=%outputDir%\%baseFileName%_%libsValue%.ps"

echo Rename Files ...
copy output "%outputFile_out%"
copy tape36 "%outputFile_pendf%"
copy tape38 "%outputFile_ACE%"
copy tape38 "%outputFile_ZAID%"
copy tape39 "%outputFile_XSDIR%"
copy tape48 "%outputFile_ps%"

:end
pause