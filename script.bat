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
    echo ----------------------------------------------------------------------
    echo  %DATE% ^| %TIME%
    echo ----------------------------------------------------------------------
    echo  1    Crear copia de seguridad  
    echo  2    Crear usuario
    echo  3    Modificar targeta de red (Ejecutar con administrador)
    echo  4    Borrar archivos del log generados
    echo  5    Salir
    echo ----------------------------------------------------------------------
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

        @echo off
setlocal enabledelayedexpansion

REM Crear un timestamp para el archivo ZIP y log (formato YYYYMMDD-HHMMSS)
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set timestamp=%datetime:~0,8%-%datetime:~8,6%

REM Definir la carpeta de logs y crearla si no existe
set log_dir=%~dp0logs
if not exist "%log_dir%" (
    mkdir "%log_dir%"
)

REM Definir el nombre del archivo de log en el directorio logs
set log_file=%log_dir%\log_backup_%timestamp%.txt

REM Definir el nombre del archivo ZIP
set zip_file=backup_%timestamp%.zip

REM Definir la carpeta temporal para la copia de seguridad
set backup_dir=%~dp0backup_temp

REM Crear la carpeta temporal
if not exist "%backup_dir%" (
    mkdir "%backup_dir%"
)

REM Crear el archivo de log
echo Inicio del backup: %date% %time% > %log_file%

REM Obtener el nombre del usuario actual
set current_user=%USERNAME%

REM Leer el archivo de rutas.txt, reemplazar %% por el usuario actual y hacer la copia de seguridad
for /f "tokens=1" %%A in (rutas.txt) do (
    REM Reemplazar %% por el nombre del usuario actual
    set source=%%A
    set source=!source:%%%%=%current_user%!

    echo Copiando de !source! a %backup_dir%\%%~nxA >> %log_file%
    xcopy "!source!" "%backup_dir%\%%~nxA" /E /I /Y /H /C >> %log_file% 2>&1
    if !errorlevel! neq 0 (
        echo Error al copiar de !source! a %backup_dir%\%%~nxA >> %log_file%
    ) else (
        echo Copia exitosa de !source! a %backup_dir%\%%~nxA >> %log_file%
    )
)

REM Comprimir la carpeta de respaldo en un archivo ZIP
powershell Compress-Archive -Path "%backup_dir%\*" -DestinationPath "%~dp0%zip_file%"

REM Verificar si se creó correctamente el archivo ZIP
if exist "%~dp0%zip_file%" (
    echo Archivo ZIP creado exitosamente: %~dp0%zip_file% >> %log_file%
) else (
    echo Error al crear el archivo ZIP >> %log_file%
)

REM Eliminar la carpeta temporal de respaldo
rmdir /S /Q "%backup_dir%"

REM Finalizar el proceso
echo Backup completado: %date% %time% >> %log_file%
echo Backup finalizado. Archivo de log creado en: %log_file%
endlocal

        echo. Copia de seguridad creada con éxito. >> "%logfile%"
        pause
        set var=0
        goto inicio

:op2
    echo. Has elegido la opcion No. 2 >> "%logfile%"
    echo. Creando usuarios... >> "%logfile%"

    :: Leer usuarios y contraseñas desde el archivo
    setlocal enabledelayedexpansion
    set /a line=0

    :: Usar ruta relativa para acceder al archivo usuarios.txt
    set "userfile=%~dp0usuario.txt"

    for /f "usebackq delims=" %%a in ("%userfile%") do (
        set /a line+=1
        if !line! lss 2 (
            set username=%%a
        ) else (
            set password=%%a
            :: Crear el usuario
            net user "!username!" "!password!" /add >> "%logfile%" 2>&1
            if !errorlevel! equ 0 (
                echo. Usuario !username! creado con éxito. >> "%logfile%"
            ) else (
                echo. Error al crear el usuario !username!. >> "%logfile%"
            )
            :: Reiniciar el contador después de cada par
            set username=
            set password=
            set /a line=0
        )
    )

    pause
    set var=0
    goto inicio

:op3
    echo. Has elegido la opcion No. 3 >> "%logfile%"
    echo. Modificando tarjeta de red... >> "%logfile%"

    echo. Listando tarjetas de red disponibles... >> "%logfile%"
    netsh interface show interface

    set /p interface="Introduce el nombre de la interfaz que deseas modificar: "
    set /p ip="Introduce la nueva IP: "
    set /p mask="Introduce la máscara de subred: "
    set /p gateway="Introduce el gateway: "

    echo. Configurando la tarjeta de red con la siguiente información: >> "%logfile%"
    echo. Interfaz: %interface% >> "%logfile%"
    echo. IP: %ip% >> "%logfile%"
    echo. Máscara de subred: %mask% >> "%logfile%"
    echo. Gateway: %gateway% >> "%logfile%"

    netsh interface ip set address name="%interface%" static %ip% %mask% %gateway%

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
    goto fin

:fin
