cat << 'EOF' > lupintool.sh
#!/bin/bash

# ====================================================
# LUPINTOOL v6.3 - MEGA CATALOG + MENÚS EXTRAS AMPLIADOS
# ====================================================

if command -v pkg &> /dev/null; then
    PKG_MAN="pkg install -y"
elif command -v apt &> /dev/null; then
    PKG_MAN="sudo apt install -y"
elif command -v pacman &> /dev/null; then
    PKG_MAN="sudo pacman -S --noconfirm"
elif command -v dnf &> /dev/null; then
    PKG_MAN="sudo dnf install -y"
else
    PKG_MAN="echo 'Gestor de paquetes no detectado.'"
fi

for dep in dialog python3 curl git; do
    if ! command -v $dep &> /dev/null; then
        $PKG_MAN $dep
    fi
done

DIALOG_CMD="dialog --mouse --clear --shadow"

# ====================================================
# FUNCIONES DE INSTALACIÓN Y EJECUCIÓN
# ====================================================
instalar_paquete() {
    local cmd_check="$1"
    local pkg_name="$2"
    if command -v "$cmd_check" &> /dev/null; then
        $DIALOG_CMD --title "Estado" --msgbox "\n El comando '$cmd_check' ya está instalado en tu sistema." 7 55
    else
        clear
        echo "=========================================="
        echo " Instalando paquete: $pkg_name"
        echo "=========================================="
        $PKG_MAN "$pkg_name"
        read -p "Instalación completada. Presioná Enter..."
    fi
}

ejecutar_programa() {
    local cmd_check="$1"
    shift
    local run_cmd="$@"
    if ! command -v "$cmd_check" &> /dev/null; then
        $DIALOG_CMD --title "Atención" --msgbox "\n El programa '$cmd_check' NO está instalado.\nElegí primero la opción de INSTALAR." 8 55
    else
        clear
        echo "=========================================="
        echo " Ejecutando: $cmd_check"
        echo "=========================================="
        $run_cmd
        echo ""
        read -p "Presioná Enter para regresar al menú..."
    fi
}

# ====================================================
# SECCIÓN: CATÁLOGO MASIVO DE MENÚS EXTRAS DESCARGABLES
# ====================================================
menu_descargar_menus() {
    while true; do
        OPCION=$($DIALOG_CMD --title "Catálogo Ampliado de Menús Extras" \
            --menu "Seleccioná un menú específico para descargar al almacenamiento:" 22 75 12 \
            "1" "📥 Descargar: Módulo de Info de Hardware y Sensores" \
            "2" "📥 Descargar: Módulo de Diagnóstico y Conexiones de Red" \
            "3" "📥 Descargar: Módulo Gestor de Notas y Tareas CLI" \
            "4" "📥 Descargar: Módulo de Respaldo y Copias de Seguridad" \
            "5" "📥 Descargar: Módulo de Control de Procesos y RAM" \
            "6" "📥 Descargar: Módulo de Utilidades Web y Servidor Local" \
            "7" "📥 Descargar: Módulo Generador de Contraseñas y Cripto" \
            "8" "🌐 Descargar desde URL personalizada externa" \
            "9" "📂 Ver y Ejecutar cualquier menú guardado" \
            "0" "<< Volver al Menú Principal" \
            3>&1 1>&2 2>&3)

        case $OPCION in
            1)
                cat << 'EOF_EXTRA' > "$HOME/menu_hardware_extra.sh"
#!/bin/bash
DIALOG_E="dialog --mouse --clear --shadow"
while true; do
    OP=$($DIALOG_E --title "Menú: Hardware" --menu "Opciones:" 14 50 4 \
    "1" "Ver Temperatura y Sensores" \
    "2" "Ver Espacio en Discos (df -h)" \
    "3" "Ver Uso de Memoria RAM" \
    "0" "Volver" 3>&1 1>&2 2>&3)
    case $OP in
        1) clear; sensors 2>/dev/null || uname -a; read -p "Enter..." ;;
        2) clear; df -h; read -p "Enter..." ;;
        3) clear; free -h; read -p "Enter..." ;;
        0|*) break ;;
    esac
done
EOF_EXTRA
                chmod +x "$HOME/menu_hardware_extra.sh"
                $DIALOG_CMD --title "¡Descargado!" --msgbox "Módulo de Hardware guardado en:\n$HOME/menu_hardware_extra.sh" 8 55
                ;;
            2)
                cat << 'EOF_EXTRA' > "$HOME/menu_red_extra.sh"
#!/bin/bash
DIALOG_E="dialog --mouse --clear --shadow"
while true; do
    OP=$($DIALOG_E --title "Menú: Redes" --menu "Opciones:" 14 50 4 \
    "1" "Ver Interfaces de Red (ip a)" \
    "2" "Ver Conexiones Activas (ss / netstat)" \
    "3" "Comprobar Conectividad (Ping Google)" \
    "0" "Volver" 3>&1 1>&2 2>&3)
    case $OP in
        1) clear; ip a; read -p "Enter..." ;;
        2) clear; ss -tulnp 2>/dev/null || netstat -tulnp; read -p "Enter..." ;;
        3) clear; ping -c 4 8.8.8.8; read -p "Enter..." ;;
        0|*) break ;;
    esac
done
EOF_EXTRA
                chmod +x "$HOME/menu_red_extra.sh"
                $DIALOG_CMD --title "¡Descargado!" --msgbox "Módulo de Redes guardado en:\n$HOME/menu_red_extra.sh" 8 55
                ;;
            3)
                cat << 'EOF_EXTRA' > "$HOME/menu_notas_extra.sh"
#!/bin/bash
DIALOG_E="dialog --mouse --clear --shadow"
NOTAS_FILE="$HOME/notas_lupintool.txt"
while true; do
    OP=$($DIALOG_E --title "Menú: Notas" --menu "Opciones:" 14 50 4 \
    "1" "Ver Notas" \
    "2" "Añadir Nota" \
    "3" "Borrar Archivo de Notas" \
    "0" "Volver" 3>&1 1>&2 2>&3)
    case $OP in
        1) clear; [ -f "$NOTAS_FILE" ] && cat "$NOTAS_FILE" || echo "Sin notas."; read -p "Enter..." ;;
        2) 
           TXT=$($DIALOG_E --title "Nueva Nota" --inputbox "Escribí tu nota:" 8 50 3>&1 1>&2 2>&3)
           [ -n "$TXT" ] && echo "- $TXT ($(date +%D))" >> "$NOTAS_FILE"
           ;;
        3) rm -f "$NOTAS_FILE"; $DIALOG_CMD --title "Aviso" --msgbox "Notas borradas." 6 30 ;;
        0|*) break ;;
    esac
done
EOF_EXTRA
                chmod +x "$HOME/menu_notas_extra.sh"
                $DIALOG_CMD --title "¡Descargado!" --msgbox "Módulo de Notas guardado en:\n$HOME/menu_notas_extra.sh" 8 55
                ;;
            4)
                cat << 'EOF_EXTRA' > "$HOME/menu_backup_extra.sh"
#!/bin/bash
DIALOG_E="dialog --mouse --clear --shadow"
while true; do
    OP=$($DIALOG_E --title "Menú: Backup" --menu "Opciones:" 14 50 3 \
    "1" "Respaldar carpeta personal a archivo .tar.gz" \
    "2" "Ver respaldos generados" \
    "0" "Volver" 3>&1 1>&2 2>&3)
    case $OP in
        1) 
           tar -czf "$HOME/backup_$(date +%Y%m%d_%H%M%S).tar.gz" --exclude="*.tar.gz" "$HOME/lupintool.sh" 2>/dev/null
           $DIALOG_E --title "Listo" --msgbox "Respaldo creado en tu directorio." 6 40
           ;;
        2) clear; ls -lh "$HOME"/*.tar.gz 2>/dev/null; read -p "Enter..." ;;
        0|*) break ;;
    esac
done
EOF_EXTRA
                chmod +x "$HOME/menu_backup_extra.sh"
                $DIALOG_CMD --title "¡Descargado!" --msgbox "Módulo de Backup guardado en:\n$HOME/menu_backup_extra.sh" 8 55
                ;;
            5)
                cat << 'EOF_EXTRA' > "$HOME/menu_procesos_extra.sh"
#!/bin/bash
DIALOG_E="dialog --mouse --clear --shadow"
while true; do
    OP=$($DIALOG_E --title "Menú: Procesos" --menu "Opciones:" 14 50 3 \
    "1" "Ver Top 20 Procesos por Consumo" \
    "2" "Buscar y Matar Proceso por Nombre" \
    "0" "Volver" 3>&1 1>&2 2>&3)
    case $OP in
        1) clear; ps aux --sort=-%mem | head -n 20; read -p "Enter..." ;;
        2) 
           PROC=$($DIALOG_E --title "Matar Proceso" --inputbox "Nombre del proceso a cerrar:" 8 50 3>&1 1>&2 2>&3)
           [ -n "$PROC" ] && pkill -f "$PROC" && $DIALOG_E --title "Ok" --msgbox "Proceso finalizado." 6 30
           ;;
        0|*) break ;;
    esac
done
EOF_EXTRA
                chmod +x "$HOME/menu_procesos_extra.sh"
                $DIALOG_CMD --title "¡Descargado!" --msgbox "Módulo de Procesos guardado en:\n$HOME/menu_procesos_extra.sh" 8 55
                ;;
            6)
                cat << 'EOF_EXTRA' > "$HOME/menu_web_extra.sh"
#!/bin/bash
DIALOG_E="dialog --mouse --clear --shadow"
while true; do
    OP=$($DIALOG_E --title "Menú: Web y Servidor" --menu "Opciones:" 14 50 3 \
    "1" "Iniciar servidor HTTP local (Python 3) en puerto 8080" \
    "2" "Ver IP local asignada" \
    "0" "Volver" 3>&1 1>&2 2>&3)
    case $OP in
        1) clear; echo "Iniciando servidor en puerto 8080 (Ctrl+C para salir)..."; python3 -m http.server 8080 ;;
        2) clear; hostname -I; read -p "Enter..." ;;
        0|*) break ;;
    esac
done
EOF_EXTRA
                chmod +x "$HOME/menu_web_extra.sh"
                $DIALOG_CMD --title "¡Descargado!" --msgbox "Módulo Web guardado en:\n$HOME/menu_web_extra.sh" 8 55
                ;;
            7)
                cat << 'EOF_EXTRA' > "$HOME/menu_cripto_extra.sh"
#!/bin/bash
DIALOG_E="dialog --mouse --clear --shadow"
while true; do
    OP=$($DIALOG_E --title "Menú: Cripto y Claves" --menu "Opciones:" 14 50 3 \
    "1" "Generar Clave Ultra Segura (24 caracteres)" \
    "2" "Generar Hash SHA256 de un texto" \
    "0" "Volver" 3>&1 1>&2 2>&3)
    case $OP in
        1) 
           CLAVE=$(tr -dc 'A-Za-z0-9!@#$%' < /dev/urandom | head -c 24)
           $DIALOG_E --title "Clave" --msgbox "Clave generada:\n\n$CLAVE" 8 45
           ;;
        2) 
           TXT=$($DIALOG_E --title "Hash" --inputbox "Texto:" 8 40 3>&1 1>&2 2>&3)
           [ -n "$TXT" ] && { H=$(echo -n "$TXT" | sha256sum | awk '{print $1}'); $DIALOG_E --title "SHA256" --msgbox "$H" 8 60; }
           ;;
        0|*) break ;;
    esac
done
EOF_EXTRA
                chmod +x "$HOME/menu_cripto_extra.sh"
                $DIALOG_CMD --title "¡Descargado!" --msgbox "Módulo Cripto guardado en:\n$HOME/menu_cripto_extra.sh" 8 55
                ;;
            8)
                URL=$($DIALOG_CMD --title "URL Externa" --inputbox "Ingresá la URL del script (.sh):" 10 60 3>&1 1>&2 2>&3)
                if [ -n "$URL" ]; then
                    NOM=$(basename "$URL")
                    [ -z "$NOM" ] || [ "$NOM" = "/" ] && NOM="menu_url_$RANDOM.sh"
                    curl -sL "$URL" -o "$HOME/$NOM"
                    chmod +x "$HOME/$NOM"
                    $DIALOG_CMD --title "Descarga" --msgbox "Guardado como:\n$HOME/$NOM" 8 55
                fi
                ;;
            9)
                MOD=$($DIALOG_CMD --title "Ejecutar Menú" --inputbox "Nombre del archivo extra (Ej: menu_hardware_extra.sh):" 10 60 3>&1 1>&2 2>&3)
                if [ -n "$MOD" ] && [ -f "$HOME/$MOD" ]; then
                    clear
                    bash "$HOME/$MOD"
                    read -p "Presioná Enter para volver..."
                else
                    $DIALOG_CMD --title "Error" --msgbox "El archivo no se encuentra en $HOME." 7 50
                fi
                ;;
            0|*) break ;;
        esac
    done
}

# ====================================================
# MÓDULO PAINT CLI
# ====================================================
modo_paint() {
    local ARCHIVO_DIBUJO="$HOME/dibujo_lupintool.txt"
    local ANCHO=30
    local ALTO=12
    local PINCEL="█"
    
    declare -A CANVA
    limpiar_lienzo() {
        for ((y=0; y<ALTO; y++)); do
            for ((x=0; x<ANCHO; x++)); do CANVA["$x,$y"]=" "; done
        done
    }
    limpiar_lienzo

    while true; do
        local RENDER="\n"
        for ((y=0; y<ALTO; y++)); do
            RENDER+="  │"
            for ((x=0; x<ANCHO; x++)); do RENDER+="${CANVA["$x,$y"]}"; done
            RENDER+="│\n"
        done

        OPCION=$($DIALOG_CMD --title "Lupintool Paint [$PINCEL]" \
            --menu "Lienzo ASCII ($ANCHO x $ALTO):\n$RENDER" 22 65 7 \
            "1" "Pintar Punto (Coordenadas X Y)" \
            "2" "Cambiar Carácter de Pincel" \
            "3" "Borrador (Espacio en blanco)" \
            "4" "Limpiar Lienzo Completo" \
            "5" "Guardar Dibujo ($ARCHIVO_DIBUJO)" \
            "6" "Ver Dibujo en Pantalla" \
            "0" "<< Volver al Menú Principal" \
            3>&1 1>&2 2>&3)

        case $OPCION in
            1)
                COORD=$($DIALOG_CMD --title "Pintar" --inputbox "Coordenadas X e Y (Ej: 5 3):" 10 55 3>&1 1>&2 2>&3)
                if [ -n "$COORD" ]; then
                    read -r px py <<< "$COORD"
                    [[ "$px" =~ ^[0-9]+$ ]] && [[ "$py" =~ ^[0-9]+$ ]] && [ "$px" -lt "$ANCHO" ] && [ "$py" -lt "$ALTO" ] && CANVA["$px,$py"]="$PINCEL"
                fi
                ;;
            2)
                NUEVO=$($DIALOG_CMD --title "Pincel" --inputbox "Símbolo (█, #, *, @, O):" 9 50 3>&1 1>&2 2>&3)
                [ -n "$NUEVO" ] && PINCEL="${NUEVO:0:1}"
                ;;
            3) PINCEL=" " ;;
            4) limpiar_lienzo ;;
            5)
                echo "--- DIBUJO ---" > "$ARCHIVO_DIBUJO"
                for ((y=0; y<ALTO; y++)); do
                    LINEA=""
                    for ((x=0; x<ANCHO; x++)); do LINEA+="${CANVA["$x,$y"]}"; done
                    echo "$LINEA" >> "$ARCHIVO_DIBUJO"
                done
                $DIALOG_CMD --title "Guardado" --msgbox "Guardado en $ARCHIVO_DIBUJO" 8 50
                ;;
            6)
                clear
                for ((y=0; y<ALTO; y++)); do
                    LINEA=""
                    for ((x=0; x<ANCHO; x++)); do LINEA+="${CANVA["$x,$y"]}"; done
                    echo "│$LINEA│"
                done
                read -p "Enter..."
                ;;
            0|*) break ;;
        esac
    done
}

# ====================================================
# MENÚS PRINCIPALES DE JUEGOS, EFECTOS, ETC.
# ====================================================
menu_juegos() {
    while true; do
        OPCION=$($DIALOG_CMD --title "Arcade y Juegos CLI" \
            --menu "Seleccioná un juego:" 20 70 8 \
            "1" "Instalar y Abrir Bastet (Tetris)" \
            "2" "Instalar y Abrir NInvaders" \
            "3" "Instalar y Abrir Pacman4console" \
            "4" "Instalar y Abrir NSnake (Viborita)" \
            "5" "Instalar y Abrir 2048-cli" \
            "6" "Instalar y Abrir Nudoku" \
            "0" "Volver" 3>&1 1>&2 2>&3)
        case $OPCION in
            1) instalar_paquete "bastet" "bastet" && ejecutar_programa "bastet" bastet ;;
            2) instalar_paquete "ninvaders" "ninvaders" && ejecutar_programa "ninvaders" ninvaders ;;
            3) instalar_paquete "pacman4console" "pacman4console" && ejecutar_programa "pacman4console" pacman4console ;;
            4) instalar_paquete "nsnake" "nsnake" && ejecutar_programa "nsnake" nsnake ;;
            5) instalar_paquete "2048" "2048-cli" && ejecutar_programa "2048" 2048 ;;
            6) instalar_paquete "nudoku" "nudoku" && ejecutar_programa "nudoku" nudoku ;;
            0|*) break ;;
        esac
    done
}

menu_efectos() {
    while true; do
        OPCION=$($DIALOG_CMD --title "Efectos Visuales" \
            --menu "Seleccioná un efecto:" 18 70 6 \
            "1" "CMatrix (Matrix)" \
            "2" "CBonsai (Bonsái)" \
            "3" "SL (Tren a Vapor)" \
            "4" "Cowsay & Fortune" \
            "5" "Hollywood (Hacker)" \
            "0" "Volver" 3>&1 1>&2 2>&3)
        case $OPCION in
            1) instalar_paquete "cmatrix" "cmatrix" && ejecutar_programa "cmatrix" cmatrix ;;
            2) instalar_paquete "cbonsai" "cbonsai" && ejecutar_programa "cbonsai" cbonsai -l ;;
            3) instalar_paquete "sl" "sl" && ejecutar_programa "sl" sl ;;
            4) instalar_paquete "cowsay" "cowsay fortune" && { clear; fortune | cowsay; read -p "Enter..."; } ;;
            5) instalar_paquete "hollywood" "hollywood" && ejecutar_programa "hollywood" hollywood ;;
            0|*) break ;;
        esac
    done
}

menu_multimedia() {
    while true; do
        OPCION=$($DIALOG_CMD --title "Multimedia y Audio" \
            --menu "Herramientas:" 18 70 5 \
            "1" "FFmpeg" "2" "Yt-Dlp" "3" "MPV Player" "4" "FIGlet (Banners)" "0" "Volver" \
            3>&1 1>&2 2>&3)
        case $OPCION in
            1) instalar_paquete "ffmpeg" "ffmpeg" ;;
            2) instalar_paquete "yt-dlp" "yt-dlp" ;;
            3) instalar_paquete "mpv" "mpv" ;;
            4) instalar_paquete "figlet" "figlet" && figlet Lupintool && read -p "Enter..." ;;
            0|*) break ;;
        esac
    done
}

menu_redes() {
    while true; do
        OPCION=$($DIALOG_CMD --title "Redes y Web" \
            --menu "Herramientas:" 18 70 5 \
            "1" "Nmap" "2" "Curl" "3" "Wget" "4" "Speedtest-cli" "0" "Volver" \
            3>&1 1>&2 2>&3)
        case $OPCION in
            1) instalar_paquete "nmap" "nmap" ;;
            2) instalar_paquete "curl" "curl" ;;
            3) instalar_paquete "wget" "wget" ;;
            4) instalar_paquete "speedtest-cli" "speedtest-cli" && speedtest-cli ;;
            0|*) break ;;
        esac
    done
}

menu_sistema() {
    while true; do
        OPCION=$($DIALOG_CMD --title "Sistema" \
            --menu "Herramientas:" 18 70 5 \
            "1" "Htop" "2" "Btop" "3" "Fastfetch" "4" "Micro Editor" "0" "Volver" \
            3>&1 1>&2 2>&3)
        case $OPCION in
            1) instalar_paquete "htop" "htop" && htop ;;
            2) instalar_paquete "btop" "btop" && btop ;;
            3) instalar_paquete "fastfetch" "fastfetch" && fastfetch && read -p "Enter..." ;;
            4) instalar_paquete "micro" "micro" ;;
            0|*) break ;;
        esac
    done
}

menu_seguridad() {
    while true; do
        OPCION=$($DIALOG_CMD --title "Seguridad" \
            --menu "Herramientas:" 18 70 4 \
            "1" "Nikto" "2" "SQLMap" "3" "Hydra" "0" "Volver" \
            3>&1 1>&2 2>&3)
        case $OPCION in
            1) instalar_paquete "nikto" "nikto" ;;
            2) instalar_paquete "sqlmap" "sqlmap" ;;
            3) instalar_paquete "hydra" "hydra" ;;
            0|*) break ;;
        esac
    done
}

menu_mantenimiento() {
    while true; do
        OPCION=$($DIALOG_CMD --title "Mantenimiento" \
            --menu "Acciones:" 18 70 4 \
            "1" "Limpiar Paquetes Obsoletos" \
            "2" "Generar Contraseña Segura" \
            "3" "Ver Espacio en Disco" \
            "0" "Volver" 3>&1 1>&2 2>&3)
        case $OPCION in
            1) clear; sudo apt autoremove -y 2>/dev/null || pkg clean; read -p "Enter..." ;;
            2) 
               P=$(tr -dc 'A-Za-z0-9!@#$' < /dev/urandom | head -c 20)
               $DIALOG_CMD --title "Clave" --msgbox "$P" 7 35
               ;;
            3) clear; df -h; read -p "Enter..." ;;
            0|*) break ;;
        esac
    done
}

# ====================================================
# MENÚ PRINCIPAL
# ====================================================
while true; do
    CATEGORIA=$($DIALOG_CMD --title "=== LUPINTOOL v6.3 ===" \
        --menu "Seleccioná una categoría principal:" 22 75 10 \
        "1" "🎮 Juegos CLI y Arcade" \
        "2" "✨ Efectos Visuales y Arte ASCII" \
        "3" "🎵 Audio, Video y Multimedia" \
        "4" "🌐 Redes, Servidores y Web" \
        "5" "💻 Sistema, Archivos y Editores" \
        "6" "🛡️ Ciberseguridad y Hacking" \
        "7" "🛠️ Mantenimiento y Utilidades" \
        "8" "🎨 Paint CLI (Lienzo de Dibujo)" \
        "9" "📥 Catálogo Ampliado de Menús Extras" \
        "0" "❌ Salir" \
        3>&1 1>&2 2>&3)

    case $CATEGORIA in
        1) menu_juegos ;;
        2) menu_efectos ;;
        3) menu_multimedia ;;
        4) menu_redes ;;
        5) menu_sistema ;;
        6) menu_seguridad ;;
        7) menu_mantenimiento ;;
        8) modo_paint ;;
        9) menu_descargar_menus ;;
        0|*) clear; echo "¡Chau!"; exit 0 ;;
    esac
done
EOF
