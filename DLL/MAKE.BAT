@echo off

rica bp.tp bpc.cfg /CP

bpc -b makedll

e:\engine\dll\makedll

bpc -b skMHLapi

: win32

cmd /c copy skmhlapi.pas skMHLw32.pas
vpc -vvp.vpo -b -cw skMHLw32.pas
cmd /c del skMHLw32.pas

: os2

cmd /c copy skmhlapi.pas skMHLos2.pas
vpc -vvp.vpo -b -co skMHLos2.pas
cmd /c del skMHLos2.pas

del \engine\dll\makedll.exe

copy \engine\dll\skmhl*.dll e:\engine\jt\release

call clean

cd ..\v

call clean

cd ..

call clean

cd \engine\dll

call clean
