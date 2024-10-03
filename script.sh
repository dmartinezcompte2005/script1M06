#!/bin/bash

logfile="log.txt" # Nombre del archivo de registro
userfile="usuario.txt" # Archivo que contiene los usuarios y contraseñas

crear_usuario() {
    line=0
    echo "Creando usuarios..." >> "$logfile"

    # Leer usuarios y contraseñas desde el archivo
    while IFS= read -r line_content; do
        line=$((line + 1))

        if [ "$line" -eq 1 ]; then
            username="$line_content"
        elif [ "$line" -eq 2 ]; then
            password="$line_content"

            # Comprobar si el usuario ya existe
            if id "$username" &>/dev/null; then
                echo "El usuario $username ya existe." >> "$logfile"
                echo "El usuario $username ya existe."
            else
                # Crear el usuario
                if useradd "$username" -p "$(openssl passwd -1 "$password")" >> "$logfile" 2>&1; then
                    echo "Usuario $username creado con éxito." >> "$logfile"
                    echo "Usuario $username creado con éxito."
                else
                    echo "Error al crear el usuario $username." >> "$logfile"
                    echo "Error al crear el usuario $username."
                fi
            fi

            # Reiniciar el contador después de cada par
            username=""
            password=""
            line=0
        fi
    done < "$userfile"

    echo
}

while true; do
    clear
    echo "----------------------------------------------------------------------"
    echo "$(date '+%Y-%m-%d') | $(date '+%H:%M:%S')"
    echo "----------------------------------------------------------------------"
    echo " 1    Crear copia de seguridad"
    echo " 2    Crear usuario"
    echo " 3    Modificar tarjeta de red (Ejecutar con administrador)"
    echo " 4    Borrar archivos del log generados"
    echo " 5    Salir"
    echo "----------------------------------------------------------------------"
    echo

    # Solicitar opción si 'var' no ha sido establecida
    if [ -z "$var" ]; then
        read -p "Seleccione una opción [1-5]: " var
    fi

    case "$var" in
        1) 
            echo "Opción 1: Crear copia de seguridad"
            # Aquí puedes llamar a la función o script para crear copia de seguridad
            ;;
        2) 
            echo "Opción 2: Crear usuraio por fichero"
            crear_usuario
            ;;
        3) 
            echo "Opción 3: Modificar tarjeta de red"
            # Aquí puedes llamar a la función correspondiente o script
            ;;
        4) 
            echo "Opción 4: Borrar archivos del log"
            # Aquí puedes llamar a la función correspondiente o script
            ;;
        5) 
            echo "Saliendo..."
            exit 0
            ;;
        *) 
            # Mensaje de error si la opción no es válida
            echo "El número \"$var\" no es una opción válida, por favor intente de nuevo."
            ;;
    esac

    echo
    read -p "Presiona Enter para continuar..."
    var="" # Reinicia 'var' para la próxima iteración
done
