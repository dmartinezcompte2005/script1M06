@echo off

:: Obtener la fecha y hora actuales para el nombre del archivo de log en horario español
for /f "tokens=2 delims==" %%I in ('"wmic os get localdatetime /value"') do set datetime=%%I
set datetime=%datetime:~0,4%%datetime:~4,2%%datetime:~6,2%_%datetime:~8,2%%datetime:~10,2%%datetime:~12,2%
set logdir=logs
set logfile=%logdir%\log_%datetime%.txt

:: Verificar si la carpeta de logs existe, si no, crearla
IF NOT EXIST "%logdir%" (
    mkdir "%logdir%"
)

:: Crear el archivo de log
echo Archivo de log creado el %date% a las %time% > "%logfile%"

TITLE Bienvenido %USERNAME% a nuestra primera script del menu
MODE con:cols=80 lines=40

:: Verificar si se pasó un parámetro
IF "%1" NEQ "" (
    SET var=%1
) ELSE (
    SET var=0
)

:inicio
cls
echo -----------------------------------------------------
echo  %DATE% ^| %TIME%
echo -----------------------------------------------------
echo  1    Crear copia de seguridad  
echo  2    Crear usuario
echo  3    Modificar targeta de red  
echo  4    Borrar archivos .log generados
echo  5    Salir
echo -----------------------------------------------------
echo.

IF "%var%"=="0" (
    SET /p var= ^> Seleccione una opcion [1-5]:
)

if "%var%"=="1" goto op1
if "%var%"=="2" goto op2
if "%var%"=="3" goto op3
if "%var%"=="4" goto op4
if "%var%"=="5" goto salir

::Mensaje de error, validación cuando se selecciona una opción fuera de rango
echo. El numero "%var%" no es una opcion valida, por favor intente de nuevo.
echo.
pause
set var=0
goto inicio

:op1
echo. Has elegido la opcion No. 1 >> "%logfile%"
echo. Creando copia de seguridad... >> "%logfile%"
:: Aquí iría el código para crear la copia de seguridad
echo. Copia de seguridad creada con éxito. >> "%logfile%"
pause
set var=0
goto inicio

:op2
echo. Has elegido la opcion No. 2 >> "%logfile%"
echo. Creando usuario... >> "%logfile%"
:: Aquí iría el código para crear el usuario
set /p username=Ingrese el nombre del usuario:
:: Aquí iría el código para usar el nombre del usuario
echo. Usuario %username% creado con éxito. >> "%logfile%"
pause
set var=0
goto inicio

:op3
echo. Has elegido la opcion No. 3 >> "%logfile%"
echo. Modificando tarjeta de red... >> "%logfile%"
:: Aquí iría el código para modificar la tarjeta de red
echo. Tarjeta de red modificada con éxito. >> "%logfile%"
pause
set var=0
goto inicio

:op4
echo. Has elegido la opcion No. 4
echo. Mostrando archivos .txt generados... 
:: Mostrar archivos .txt
dir "%logdir%\*.txt" /S
echo. Borrando archivos .txt generados... 
:: Borrar archivos .txt de forma recursiva
del /S /Q "%logdir%\*.txt"
echo. Archivos .txt borrados con éxito. 
pause
set var=0
goto inicio

:salir
echo Saliendo del script...
pause
goto fin

:fin
