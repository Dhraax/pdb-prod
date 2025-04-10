@echo off
echo.
echo WARNING: 'Y' will delete all unsaved changes! Commit or stash them before continuing.
@echo on

del modules /S
rd modules\PB_EE
rd modules

del /f PB_EE.mod

%CD%/tools/win/nasher/nasher.exe install  --verbose --erfUtil:"%CD%/tools/win/neverwinter64/nwn_erf.exe" --gffUtil:"%CD%/tools/win/neverwinter64/nwn_gff.exe" --tlkUtil:"%CD%/tools/win/neverwinter64/nwn_tlk.exe" --nssCompiler:"%CD%/tools/win/nwnsc/nwnsc.exe" --installDir:"%CD%" --nssFlags:"-oe -i %CD%/nwn-base-scripts" --no

del /f server\config\nwserver.env
del /f server\modules\PB_EE.mod
del /f server\settings.tml
copy modules\PB_EE.mod server\modules\PB_EE.mod
copy config\nwserver.env server\config\nwserver.env
copy settings.tml server\settings.tml

cd server
docker-compose down 
docker-compose up --no-recreate -d
pause