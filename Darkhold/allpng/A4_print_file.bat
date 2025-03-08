@echo off

REM This script requires ImageMagick, found at https://imagemagick.org/script/download.php

if [%1]==[] goto :eof

REM Set up needed variables
set n=1
set p=1
set x=79
set y=102

:loop
if %n%==1 (
	REM Create the print file and add the first card
	echo Creating print_file_%p%.png and adding card # %n%
	magick convert -size 2475x3525 xc:white -depth 32 %1 -geometry 720x1039!+79+102 -compose over -composite "print_file_%p%.png"
) else (
	REM Add a card to the set x/y position
	echo Adding card # %n%
	magick composite -compose over -geometry 720x1039!+%x%+%y% %1 "print_file_%p%.png" "print_file_%p%.png"
)
shift
set /a n+=1
if %n% == 10 (
	set /a n=1
	set /a p+=1
)

REM Set our x/y positions for the next card.
set /a c = n%%3
if %c% == 1 set /a x = 79
if %c% == 2 set /a x = 877
if %c% == 0 set /a x = 1675

set /a r = (n - 1) / 3
if %r% == 0 set /a y = 102
if %r% == 1 set /a y = 1243
if %r% == 2 set /a y = 2384


if not [%1]==[] goto loop

REM Convert the created PNGs into a PDF
echo Creating PDF print file...
magick convert "print_file_*.png" -scale 2475x3525 -units PixelsPerInch -density 300x300 -quality 100 print_file.pdf
REM del print_file_*.png

pause

@echo on