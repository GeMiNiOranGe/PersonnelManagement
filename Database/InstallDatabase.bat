@echo off

@REM echo 1. Install database   
@REM echo 2. Re-install database
@REM echo 3. Restore data       
@REM echo 0. Uninstall database 
@REM set /p option="-> Choose an option: "

@REM for %%i in (*.sql) do (
@REM     sqlcmd /S . /d master -E -i"%%i"
@REM )
pause
sqlcmd /S . /d master -E -i"InitialDatabase.sql"
sqlcmd /S . /d master -E -i"CreateStoredProcedure.sql"
sqlcmd /S . /d master -E -i"PopulateData.sql"
pause