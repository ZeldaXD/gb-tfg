rgbasm -L -o rom.obj main.asm
rgblink -n rom.sym -o rom.gb rom.obj
rgbfix -v -p 0xFF rom.gb

@echo off
del *.obj

pause