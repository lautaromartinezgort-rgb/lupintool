cat << 'EOF' > lupintool.sh
#!/bin/bash

# ====================================================
# LUPINTOOL v6.2 - MEGA CATALOG + MENÚS EXTRAS
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
# SECCIÓN: GESTOR Y DESCARGA DE MENÚS EXTRAS REALES
# ====================================================
menu_descargar_menus() {
    while true; do
        OPCION=$($DIALOG_CMD --title "Catálogo de Menús y Módulos Extras" \
            --menu "Seleccioná un menú extra para descargar o gestionar:" 18 75 7 \
            "1" "📥 Descargar: Módulo de Info de Hardware y Batería" \
            "2" "📥 Descargar: Módulo de Utilidades de Red Avanzadas" \
            "3" "📥 Descargar: Módulo Gestor de Notas Rápidas CLI" \
            "4" "🌐 Descargar desde URL personalizada (Manual)" \
            "5" "📂 Ver y Ejecutar menús guardados en tu dispositivo" \
            "0" "<< Volver al Menú Principal" \
            3>&1 1>&2 2>&3)

        case $OPCION in
            1)
                # Crear menú extra de Hardware directamente
                cat << 'EOF_EXTRA' > "$HOME/menu_hardware_extra.sh"
#!/bin/bash
DIALOG_EXTRA="dialog --mouse --clear --shadow"
while true; do
    OP=$($DIALOG_EXTRA --title "Menú Extra: Hardware y Batería" --menu "Opciones:" 12 50 3 \
    "1" "Ver Temperatura / Info del Sistema" \
    "2" "Ver Estado de Memoria y Espacio" \
    "0" "Volver" 3>&1 1>&2 2>&3)
    case $OP in
        1) clear; uname -a; sensors 2>/dev/null || echo "Sensores no disponibles"; read -p "Enter..." ;;
        2) clear; free -h; echo ""; df -h; read -p "Enter..." ;;
        0|*) break ;;
    esac
done
EOF_EXTRA
                chmod +x "$HOME/menu_hardware_extra.sh"
                $DIALOG_CMD --title "¡Descargado!" --msgbox "El menú de Hardware se descargó con éxito.\nGuardado en: $HOME/menu_hardware_extra.sh\nPodes ejecutarlo desde la opción 5." 9 60
                ;;
            2)
                # Crear menú extra de Redes directamente
                cat << 'EOF_EXTRA' > "$HOME/menu_red_extra.sh"
#!/bin/bash
DIALOG_EXTRA="dialog --mouse --clear --shadow"
while true; do
    OP=$($DIALOG_EXTRA --title "Menú Extra: Redes" --menu "Opciones:" 12 50 3 \
    "1" "Ver Interfaces de Red (ip a)" \
    "2" "Ver Conexiones Activas (netstat/ss)" \
    "0" "Volver" 3>&1 1>&2 2>&3)
    case $OP in
        1) clear; ip a; read -p "Enter..." ;;
        2) clear; ss -tulnp 2>/dev/null || netstat -tulnp; read -p "Enter..." ;;
        0|*) break ;;
    esac
done
EOF_EXTRA
                chmod +x "$HOME/menu_red_extra.sh"
                $DIALOG_CMD --title "¡Descargado!" --msgbox "El menú de Redes se descargó con éxito.\nGuardado en: $HOME/menu_red_extra.sh\nPodes ejecutarlo desde la opción 5." 9 60
                ;;
            3)
                # Crear menú extra de Notas directamente
                cat << 'EOF_EXTRA' > "$HOME/menu_notas_extra.sh"
#!/bin/bash
DIALOG_EXTRA="dialog --mouse --clear --shadow"
NOTAS_FILE="$HOME/mis_notas_lupintool.txt"
while true; do
    OP=$($DIALOG_EXTRA --title "Menú Extra: Notas Rápidas" --menu "Opciones:" 12 50 4 \
    "1" "Ver Notas Guardadas" \
    "2" "Agregar Nueva Nota" \
    "3" "Borrar Archivo de Notas" \
    "0" "Volver" 3>&1 1>&2 2>&3)
    case $OP in
        1) clear; [ -f "$NOTAS_FILE" ] && cat "$NOTAS_FILE" || echo "No hay notas aún."; read -p "Enter..." ;;
        2) 
           NUEVA=$($DIALOG_EXTRA --title "Nueva Nota" --inputbox "Escribí tu nota:" 8 50 3>&1 1>&2 2>&3)
           [ -n "$NUEVA" ] && echo "- $NUEVA ($(date))" >> "$NOTAS_FILE"
           ;;
        3) rm -f "$NOTAS_FILE"; $DIALOG_CMD --title "Borrado" --msgbox "Notas eliminadas." 6 30 ;;
        0|*) break ;;
    esac
done
EOF_EXTRA
                chmod +x "$HOME/menu_notas_extra.sh"
                $DIALOG_CMD --title "¡Descargado!" --msgbox "El menú de Notas se descargó con éxito.\nGuardado en: $HOME/menu_notas_extra.sh\nPodes ejecutarlo desde la opción 5." 9 60
                ;;
            4)
                URL=$($DIALOG_CMD --title "Descargar Menú por URL" --inputbox "Ingresá la URL exacta del script (.sh) externo:" 10 60 3>&1 1>&2 2>&3)
                if [ -n "$URL" ]; then
                    NOMBRE_ARCHIVO=$(basename "$URL")
                    [ -z "$NOMBRE_ARCHIVO" ] || [ "$NOMBRE_ARCHIVO" = "/" ] && NOMBRE_ARCHIVO="menu_extra_$RANDOM.sh"
                    curl -sL "$URL" -o "$HOME/$NOMBRE_ARCHIVO"
                    chmod +x "$HOME/$NOMBRE_ARCHIVO"
                    $DIALOG_CMD --title "Descarga Completa" --msgbox "Guardado en:\n$HOME/$NOMBRE_ARCHIVO" 8 55
                fi
                ;;
            5)
                SCRIPT_EVAL=$($DIALOG_CMD --title "Ejecutar Menú Guardado" --inputbox "Ingresá el nombre exacto del archivo (Ej: menu_hardware_extra.sh):" 10 60 3>&1 1>&2 2>&3)
                if [ -n "$SCRIPT_EVAL" ] && [ -f "$HOME/$SCRIPT_EVAL" ]; then
                    clear
                    bash "$HOME/$SCRIPT_EVAL"
                    read -p "Presioná Enter para regresar al menú..."
                else
                    $DIALOG_CMD --title "Error" --msgbox "El archivo no existe en tu carpeta principal ($HOME)." 7 55
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
            --menu "Lienzo de Dibujo ASCII ($ANCHO x $ALTO):\n$RENDER" 22 65 7 \
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
                COORD=$($DIALOG_CMD --title "Pintar" --inputbox "Coordenadas X e Y separadas por espacio (Ej: 5 3):" 10 55 3>&1 1>&2 2>&3)
                if [ -n "$COORD" ]; then
                    read -r px py <<< "$COORD"
                    if [[ "$px" =~ ^[0-9]+$ ]] && [[ "$py" =~ ^[0-9]+$ ]] && [ "$px" -lt "$ANCHO" ] && [ "$py" -lt "$ALTO" ]; then
                        CANVA["$px,$py"]="$PINCEL"
                    fi
                fi
                ;;
            2)
                NUEVO_PINCEL=$($DIALOG_CMD --title "Pincel" --inputbox "Ingresá un símbolo (Ej: █, #, *, @, O, +):" 9 50 3>&1 1>&2 2>&3)
                [ -n "$NUEVO_PINCEL" ] && PINCEL="${NUEVO_PINCEL:0:1}"
                ;;
            3) PINCEL=" " ;;
            4) limpiar_lienzo ;;
            5)
                echo "--- DIBUJO LUPINTOOL ---" > "$ARCHIVO_DIBUJO"
                for ((y=0; y<ALTO; y++)); do
                    LINEA=""
                    for ((x=0; x<ANCHO; x++)); do LINEA+="${CANVA["$x,$y"]}"; done
                    echo "$LINEA" >> "$ARCHIVO_DIBUJO"
                done
                $DIALOG_CMD --title "Guardado" --msgbox "Dibujo guardado en:\n$ARCHIVO_DIBUJO" 8 50
                ;;
            6)
                clear
                echo "=========================================="
                echo "          VISTA PREVIA DEL DIBUJO         "
                echo "=========================================="
                for ((y=0; y<ALTO; y++)); do
                    LINEA=""
                    for ((x=0; x<ANCHO; x++)); do LINEA+="${CANVA["$x,$y"]}"; done
                    echo "│$LINEA│"
                done
                echo "=========================================="
                read -p "Presioná Enter para continuar..."
                ;;
            0|*) break ;;
        esac
    done
}

# ====================================================
# MENÚ 1: JUEGOS Y ARCADE CLI
# ====================================================
menu_juegos() {
    while true; do
        OPCION=$($DIALOG_CMD --title "Lupintool - Arcade y Juegos CLI" \
            --menu "Seleccioná un juego del catálogo:" 22 75 15 \
            "1" "[INSTALAR] Bastet (Tetris Difícil)" \
            "2" "[ABRIR] Bastet" \
            "3" "[INSTALAR] NInvaders (Space Invaders)" \
            "4" "[ABRIR] NInvaders" \
            "5" "[INSTALAR] Pacman4console (Pacman Arcade)" \
            "6" "[ABRIR] Pacman4console" \
            "7" "[INSTALAR] Moon Buggy (Conducir en la Luna)" \
            "8" "[ABRIR] Moon Buggy" \
            "9" "[INSTALAR] Greed (Estrategia Numérica)" \
            "10" "[ABRIR] Greed" \
            "11" "[INSTALAR] NSnake (Juego Viborita Clásico)" \
            "12" "[ABRIR] NSnake" \
            "13" "[INSTALAR] 2048-cli (Juego Numérico 2048)" \
            "14" "[ABRIR] 2048-cli" \
            "15" "[INSTALAR] Nudoku (Sudoku CLI)" \
            "16" "[ABRIR] Nudoku" \
            "17" "[INSTALAR] BSD Games (Suite de 40+ Juegos Clásicos)" \
            "18" "[ABRIR] BSD Games (Number)" \
            "19" "[INSTALAR] NetHack (RPG / Roguelike Clásico)" \
            "20" "[ABRIR] NetHack" \
            "21" "[INSTALAR] Angband (Dungeon Crawler Roguelike)" \
            "22" "[ABRIR] Angband" \
            "23" "[INSTALAR] Robotfindskitten (Aventura de Texto)" \
            "24" "[ABRIR] Robotfindskitten" \
            "25" "[INSTALAR] OpenAdventure (Colossal Cave Adventure)" \
            "26" "[ABRIR] OpenAdventure" \
            "27" "[INSTALAR] MyMan (Clon Ncurses de Pac-Man)" \
            "28" "[ABRIR] MyMan" \
            "0" "<< Volver al Menú Principal" \
            3>&1 1>&2 2>&3)

        case $OPCION in
            1) instalar_paquete "bastet" "bastet" ;;
            2) ejecutar_programa "bastet" bastet ;;
            3) instalar_paquete "ninvaders" "ninvaders" ;;
            4) ejecutar_programa "ninvaders" ninvaders ;;
            5) instalar_paquete "pacman4console" "pacman4console" ;;
            6) ejecutar_programa "pacman4console" pacman4console ;;
            7) instalar_paquete "moon-buggy" "moon-buggy" ;;
            8) ejecutar_programa "moon-buggy" moon-buggy ;;
            9) instalar_paquete "greed" "greed" ;;
            10) ejecutar_programa "greed" greed ;;
            11) instalar_paquete "nsnake" "nsnake" ;;
            12) ejecutar_programa "nsnake" nsnake ;;
            13) instalar_paquete "2048" "2048-cli" ;;
            14) ejecutar_programa "2048" 2048 ;;
            15) instalar_paquete "nudoku" "nudoku" ;;
            16) ejecutar_programa "nudoku" nudoku ;;
            17) instalar_paquete "number" "bsdgames" ;;
            18) ejecutar_programa "number" number 1234 ;;
            19) instalar_paquete "nethack" "nethack-console" ;;
            20) ejecutar_programa "nethack" nethack ;;
            21) instalar_paquete "angband" "angband" ;;
            22) ejecutar_programa "angband" angband ;;
            23) instalar_paquete "robotfindskitten" "robotfindskitten" ;;
            24) ejecutar_programa "robotfindskitten" robotfindskitten ;;
            25) instalar_paquete "openadventure" "openadventure" ;;
            26) ejecutar_programa "openadventure" openadventure ;;
            27) instalar_paquete "myman" "myman" ;;
            28) ejecutar_programa "myman" myman ;;
            0|*) break ;;
        esac
    done
}

# ====================================================
# MENÚ 2: EFECTOS VISUALES Y ARTE ASCII
# ====================================================
menu_efectos() {
    while true; do
        OPCION=$($DIALOG_CMD --title "Lupintool - Efectos Visuales y Arte ASCII" \
            --menu "Seleccioná un efecto o generador:" 22 75 15 \
            "1" "[INSTALAR] CMatrix (Lluvia de Código Matrix)" \
            "2" "[ABRIR] CMatrix" \
            "3" "[INSTALAR] CBonsai (Generador de Arbolito Bonsái)" \
            "4" "[ABRIR] CBonsai" \
            "5" "[INSTALAR] SL (Animación de Tren a Vapor)" \
            "6" "[ABRIR] SL" \
            "7" "[INSTALAR] Cowsay & Fortune (Vaca Parlante con Frases)" \
            "8" "[ABRIR] Cowsay & Fortune" \
            "9" "[INSTALAR] Hollywood (Pantalla Hacker Multiventana)" \
            "10" "[ABRIR] Hollywood" \
            "11" "[INSTALAR] Nyan Cat (Gato Nyan Animado con Música)" \
            "12" "[ABRIR] Nyan Cat" \
            "13" "[INSTALAR] Pipes.sh (Tuberías Animadas 3D)" \
            "14" "[ABRIR] Pipes.sh" \
            "15" "[INSTALAR] TTY-Clock (Reloj Digital Gigante)" \
            "16" "[ABRIR] TTY-Clock" \
            "17" "[INSTALAR] Aafire (Simulador de Fuego ASCII)" \
            "18" "[ABRIR] Aafire" \
            "19" "[INSTALAR] Chafa (Renderizador de Fotos y GIFs)" \
            "20" "[ABRIR] Chafa" \
            "21" "[INSTALAR] Caca-Utils (Aafire, Cacaview, Cacafire)" \
            "22" "[ABRIR] Cacafire" \
            "23" "[INSTALAR] MapSCII (Mapa Mundial Interactivo Vectorial)" \
            "24" "[ABRIR] MapSCII" \
            "25" "[INSTALAR] Peaclock (Reloj y Temporizador Elegante)" \
            "26" "[ABRIR] Peaclock" \
            "0" "<< Volver al Menú Principal" \
            3>&1 1>&2 2>&3)

        case $OPCION in
            1) instalar_paquete "cmatrix" "cmatrix" ;;
            2) ejecutar_programa "cmatrix" cmatrix ;;
            3) instalar_paquete "cbonsai" "cbonsai" ;;
            4) ejecutar_programa "cbonsai" cbonsai -l ;;
            5) instalar_paquete "sl" "sl" ;;
            6) ejecutar_programa "sl" sl ;;
            7) instalar_paquete "cowsay" "cowsay fortune" ;;
            8) clear; fortune | cowsay; read -p "Enter para continuar..." ;;
            9) instalar_paquete "hollywood" "hollywood" ;;
            10) ejecutar_programa "hollywood" hollywood ;;
            11) instalar_paquete "nyancat" "nyancat" ;;
            12) ejecutar_programa "nyancat" nyancat ;;
            13) instalar_paquete "pipes.sh" "pipes" ;;
            14) ejecutar_programa "pipes.sh" pipes.sh ;;
            15) instalar_paquete "tty-clock" "tty-clock" ;;
            16) ejecutar_programa "tty-clock" tty-clock -c ;;
            17) instalar_paquete "aafire" "libaa-bin" ;;
            18) ejecutar_programa "aafire" aafire ;;
            19) instalar_paquete "chafa" "chafa" ;;
            20) 
                clear
                read -p "Ingresá la ruta de la imagen/GIF: " RUTA_IMG
                chafa "$RUTA_IMG"
                read -p "Presioná Enter para continuar..."
                ;;
            21) instalar_paquete "cacafire" "caca-utils" ;;
            22) ejecutar_programa "cacafire" cacafire ;;
            23) instalar_paquete "mapscii" "mapscii" ;;
            24) ejecutar_programa "mapscii" mapscii ;;
            25) instalar_paquete "peaclock" "peaclock" ;;
            26) ejecutar_programa "peaclock" peaclock ;;
            0|*) break ;;
        esac
    done
}

# ====================================================
# MENÚ 3: MULTIMEDIA, AUDIO Y EDICIÓN
# ====================================================
menu_multimedia() {
    while true; do
        OPCION=$($DIALOG_CMD --title "Lupintool - Audio, Video y Edición" \
            --menu "Seleccioná una herramienta multimedia:" 22 75 15 \
            "1" "[INSTALAR] FFmpeg (Procesador de Video y Audio)" \
            "2" "[ABRIR] FFmpeg" \
            "3" "[INSTALAR] Yt-Dlp (Descargador de Videos YouTube)" \
            "4" "[ABRIR] Yt-Dlp" \
            "5" "[INSTALAR] Cmus (Reproductor de Música en Consola)" \
            "6" "[ABRIR] Cmus" \
            "7" "[INSTALAR] MPV (Reproductor Multimedia)" \
            "8" "[ABRIR] MPV" \
            "9" "[INSTALAR] ImageMagick (Convertidor/Editor de Fotos)" \
            "10" "[ABRIR] ImageMagick" \
            "11" "[INSTALAR] FIGlet (Banners de Texto ASCII)" \
            "12" "[ABRIR] FIGlet" \
            "13" "[INSTALAR] TOIlet (Banners ASCII en Colores)" \
            "14" "[ABRIR] TOIlet" \
            "15" "[INSTALAR] MediaInfo (Analizador de Metadatos)" \
            "16" "[ABRIR] MediaInfo" \
            "17" "[INSTALAR] SoX (Editor y Grabador de Audio CLI)" \
            "18" "[ABRIR] SoX" \
            "19" "[INSTALAR] CAVA (Visualizador de Audio en Consola)" \
            "20" "[ABRIR] CAVA" \
            "21" "[INSTALAR] Ncmpcpp (Cliente de Música MPD)" \
            "22" "[ABRIR] Ncmpcpp" \
            "23" "[INSTALAR] Gifsicle (Creador y Editor de GIFs)" \
            "24" "[ABRIR] Gifsicle" \
            "25" "[INSTALAR] ExifTool (Lector de Metadatos EXIF)" \
            "26" "[ABRIR] ExifTool" \
            "0" "<< Volver al Menú Principal" \
            3>&1 1>&2 2>&3)

        case $OPCION in
            1) instalar_paquete "ffmpeg" "ffmpeg" ;;
            2) ejecutar_programa "ffmpeg" ffmpeg -version ;;
            3) instalar_paquete "yt-dlp" "yt-dlp" ;;
            4) ejecutar_programa "yt-dlp" yt-dlp --help ;;
            5) instalar_paquete "cmus" "cmus" ;;
            6) ejecutar_programa "cmus" cmus ;;
            7) instalar_paquete "mpv" "mpv" ;;
            8) ejecutar_programa "mpv" mpv --help ;;
            9) instalar_paquete "convert" "imagemagick" ;;
            10) ejecutar_programa "convert" convert -version ;;
            11) instalar_paquete "figlet" "figlet" ;;
            12) ejecutar_programa "figlet" figlet Lupintool ;;
            13) instalar_paquete "toilet" "toilet" ;;
            14) ejecutar_programa "toilet" toilet -f mono12 Lupintool ;;
            15) instalar_paquete "mediainfo" "mediainfo" ;;
            16) ejecutar_programa "mediainfo" mediainfo --help ;;
            17) instalar_paquete "sox" "sox" ;;
            18) ejecutar_programa "sox" sox --help ;;
            19) instalar_paquete "cava" "cava" ;;
            20) ejecutar_programa "cava" cava ;;
            21) instalar_paquete "ncmpcpp" "ncmpcpp" ;;
            22) ejecutar_programa "ncmpcpp" ncmpcpp ;;
            23) instalar_paquete "gifsicle" "gifsicle" ;;
            24) ejecutar_programa "gifsicle" gifsicle --help ;;
            25) instalar_paquete "exiftool" "libimage-exiftool-perl" ;;
            26) ejecutar_programa "exiftool" exiftool -v ;;
            0|*) break ;;
        esac
    done
}

# ====================================================
# MENÚ 4: REDES, SERVIDORES Y INTERNET
# ====================================================
menu_redes() {
    while true; do
        OPCION=$($DIALOG_CMD --title "Lupintool - Redes, Servidores y Web" \
            --menu "Seleccioná una herramienta de red:" 22 75 15 \
            "1" "[INSTALAR] OpenSSH (Cliente y Servidor SSH)" \
            "2" "[ABRIR] OpenSSH" \
            "3" "[INSTALAR] Nmap (Escáner de Puertos y Redes)" \
            "4" "[ABRIR] Nmap" \
            "5" "[INSTALAR] Curl (Transferencia de Datos por HTTP/FTP)" \
            "6" "[ABRIR] Curl" \
            "7" "[INSTALAR] Wget (Descargador de Archivos Web)" \
            "8" "[ABRIR] Wget" \
            "9" "[INSTALAR] Speedtest-cli (Medidor de Velocidad)" \
            "10" "[ABRIR] Speedtest-cli" \
            "11" "[INSTALAR] W3M (Navegador Web en Consola)" \
            "12" "[ABRIR] W3M" \
            "13" "[INSTALAR] Lynx (Navegador Web Textual)" \
            "14" "[ABRIR] Lynx" \
            "15" "[INSTALAR] Netcat (Conector TCP/UDP multipropósito)" \
            "16" "[ABRIR] Netcat" \
            "17" "[INSTALAR] Aria2 (Descargador Multihilo Acelerado)" \
            "18" "[ABRIR] Aria2" \
            "19" "[INSTALAR] Iperf3 (Auditor de Ancho de Banda)" \
            "20" "[ABRIR] Iperf3" \
            "21" "[INSTALAR] Tcpdump (Capturador de Paquetes de Red)" \
            "22" "[ABRIR] Tcpdump" \
            "23" "[INSTALAR] MTR (Traceroute y Ping Continuo)" \
            "24" "[ABRIR] MTR" \
            "25" "[INSTALAR] RSync (Sincronización Rápida de Archivos)" \
            "26" "[ABRIR] RSync" \
            "0" "<< Volver al Menú Principal" \
            3>&1 1>&2 2>&3)

        case $OPCION in
            1) instalar_paquete "ssh" "openssh" ;;
            2) ejecutar_programa "ssh" ssh ;;
            3) instalar_paquete "nmap" "nmap" ;;
            4) ejecutar_programa "nmap" nmap --help ;;
            5) instalar_paquete "curl" "curl" ;;
            6) ejecutar_programa "curl" curl --help ;;
            7) instalar_paquete "wget" "wget" ;;
            8) ejecutar_programa "wget" wget --help ;;
            9) instalar_paquete "speedtest-cli" "speedtest-cli" ;;
            10) ejecutar_programa "speedtest-cli" speedtest-cli ;;
            11) instalar_paquete "w3m" "w3m" ;;
            12) ejecutar_programa "w3m" w3m https://duckduckgo.com ;;
            13) instalar_paquete "lynx" "lynx" ;;
            14) ejecutar_programa "lynx" lynx https://duckduckgo.com ;;
            15) instalar_paquete "nc" "netcat-openbsd" ;;
            16) ejecutar_programa "nc" nc -h ;;
            17) instalar_paquete "aria2c" "aria2" ;;
            18) ejecutar_programa "aria2c" aria2c --help ;;
            19) instalar_paquete "iperf3" "iperf3" ;;
            20) ejecutar_programa "iperf3" iperf3 --help ;;
            21) instalar_paquete "tcpdump" "tcpdump" ;;
            22) ejecutar_programa "tcpdump" tcpdump --help ;;
            23) instalar_paquete "mtr" "mtr" ;;
            24) ejecutar_programa "mtr" mtr --help ;;
            25) instalar_paquete "rsync" "rsync" ;;
            26) ejecutar_programa "rsync" rsync --help ;;
            0|*) break ;;
        esac
    done
}

# ====================================================
# MENÚ 5: SISTEMA, ARCHIVOS Y EDITORES
# ====================================================
menu_sistema() {
    while true; do
        OPCION=$($DIALOG_CMD --title "Lupintool - Sistema, Archivos y Editores" \
            --menu "Seleccioná una utilidad de sistema:" 22 75 15 \
            "1" "[INSTALAR] Htop (Monitor Interactivos de Procesos)" \
            "2" "[ABRIR] Htop" \
            "3" "[INSTALAR] Btop (Monitor Futurista de Recursos)" \
            "4" "[ABRIR] Btop" \
            "5" "[INSTALAR] Fastfetch (Resumen de Especificaciones)" \
            "6" "[ABRIR] Fastfetch" \
            "7" "[INSTALAR] Tmux (Multiplexor de Pantallas de Consola)" \
            "8" "[ABRIR] Tmux" \
            "9" "[INSTALAR] Micro (Editor de Texto Moderno e Intuitivo)" \
            "10" "[ABRIR] Micro" \
            "11" "[INSTALAR] Vim (Editor de Texto Avanzado)" \
            "12" "[ABRIR] Vim" \
            "13" "[INSTALAR] Ncdu (Analizador Visivo de Espacio en Disco)" \
            "14" "[ABRIR] Ncdu" \
            "15" "[INSTALAR] Ranger (Navegador de Archivos en Columnas)" \
            "16" "[ABRIR] Ranger" \
            "17" "[INSTALAR] Midnight Commander (Gestor de Archivos MC)" \
            "18" "[ABRIR] Midnight Commander" \
            "19" "[INSTALAR] Fzf (Buscador Difuso Ultra Rápido)" \
            "20" "[ABRIR] Fzf" \
            "21" "[INSTALAR] Bat (Cat Mejorado con Colores y Formato)" \
            "22" "[ABRIR] Bat" \
            "23" "[INSTALAR] Tree (Visualizador de Árbol de Directorios)" \
            "24" "[ABRIR] Tree" \
            "25" "[INSTALAR] Ripgrep (Buscador Rápido dentro de Archivos)" \
            "26" "[ABRIR] Ripgrep" \
            "0" "<< Volver al Menú Principal" \
            3>&1 1>&2 2>&3)

        case $OPCION in
            1) instalar_paquete "htop" "htop" ;;
            2) ejecutar_programa "htop" htop ;;
            3) instalar_paquete "btop" "btop" ;;
            4) ejecutar_programa "btop" btop ;;
            5) instalar_paquete "fastfetch" "fastfetch" ;;
            6) ejecutar_programa "fastfetch" fastfetch ;;
            7) instalar_paquete "tmux" "tmux" ;;
            8) ejecutar_programa "tmux" tmux ;;
            9) instalar_paquete "micro" "micro" ;;
            10) ejecutar_programa "micro" micro ;;
            11) instalar_paquete "vim" "vim" ;;
            12) ejecutar_programa "vim" vim ;;
            13) instalar_paquete "ncdu" "ncdu" ;;
            14) ejecutar_programa "ncdu" ncdu ;;
            15) instalar_paquete "ranger" "ranger" ;;
            16) ejecutar_programa "ranger" ranger ;;
            17) instalar_paquete "mc" "mc" ;;
            18) ejecutar_programa "mc" mc ;;
            19) instalar_paquete "fzf" "fzf" ;;
            20) ejecutar_programa "fzf" fzf ;;
            21) instalar_paquete "bat" "bat" ;;
            22) ejecutar_programa "bat" bat --help ;;
            23) instalar_paquete "tree" "tree" ;;
            24) ejecutar_programa "tree" tree ;;
            25) instalar_paquete "rg" "ripgrep" ;;
            26) ejecutar_programa "rg" rg --help ;;
            0|*) break ;;
        esac
    done
}

# ====================================================
# MENÚ 6: CIBERSEGURIDAD Y HACKING ÉTICO
# ====================================================
menu_seguridad() {
    while true; do
        OPCION=$($DIALOG_CMD --title "Lupintool - Ciberseguridad y Hacking" \
            --menu "Seleccioná una herramienta de seguridad:" 22 75 15 \
            "1" "[INSTALAR] Nikto (Escáner de Vulnerabilidades Web)" \
            "2" "[ABRIR] Nikto" \
            "3" "[INSTALAR] SQLMap (Auditoría e Inyección SQL)" \
            "4" "[ABRIR] SQLMap" \
            "5" "[INSTALAR] Hydra (Auditoría de Credenciales por Red)" \
            "6" "[ABRIR] Hydra" \
            "7" "[INSTALAR] John the Ripper (Crackeador de Hashes)" \
            "8" "[ABRIR] John the Ripper" \
            "9" "[INSTALAR] Gobuster (Escáner de Directorios y Subdominios)" \
            "10" "[ABRIR] Gobuster" \
            "11" "[INSTALAR] Metasploit (Framework de Pentesting)" \
            "12" "[ABRIR] Metasploit" \
            "13" "[INSTALAR] Aircrack-ng (Auditoría de Redes WiFi)" \
            "14" "[ABRIR] Aircrack-ng" \
            "15" "[INSTALAR] Hashcat (Recuperación Rápida de Hashes)" \
            "16" "[ABRIR] Hashcat" \
            "17" "[INSTALAR] Radare2 (Ingeniería Inversa y Desensamblador)" \
            "18" "[ABRIR] Radare2" \
            "19" "[INSTALAR] Searchsploit (Base de Datos de Exploits)" \
            "20" "[ABRIR] Searchsploit" \
            "21" "[INSTALAR] Dirb (Buscador Web de Directorios Ocultos)" \
            "22" "[ABRIR] Dirb" \
            "23" "[INSTALAR] Crunch (Generador de Diccionarios de Claves)" \
            "24" "[ABRIR] Crunch" \
            "25" "[INSTALAR] Macchanger (Modificador de Dirección MAC)" \
            "26" "[ABRIR] Macchanger" \
            "0" "<< Volver al Menú Principal" \
            3>&1 1>&2 2>&3)

        case $OPCION in
            1) instalar_paquete "nikto" "nikto" ;;
            2) ejecutar_programa "nikto" nikto -h ;;
            3) instalar_paquete "sqlmap" "sqlmap" ;;
            4) ejecutar_programa "sqlmap" sqlmap -h ;;
            5) instalar_paquete "hydra" "hydra" ;;
            6) ejecutar_programa "hydra" hydra -h ;;
            7) instalar_paquete "john" "john" ;;
            8) ejecutar_programa "john" john ;;
            9) instalar_paquete "gobuster" "gobuster" ;;
            10) ejecutar_programa "gobuster" gobuster -h ;;
            11) instalar_paquete "msfconsole" "metasploit-framework" ;;
            12) ejecutar_programa "msfconsole" msfconsole ;;
            13) instalar_paquete "aircrack-ng" "aircrack-ng" ;;
            14) ejecutar_programa "aircrack-ng" aircrack-ng --help ;;
            15) instalar_paquete "hashcat" "hashcat" ;;
            16) ejecutar_programa "hashcat" hashcat --help ;;
            17) instalar_paquete "r2" "radare2" ;;
            18) ejecutar_programa "r2" r2 -h ;;
            19) instalar_paquete "searchsploit" "exploitdb" ;;
            20) ejecutar_programa "searchsploit" searchsploit ;;
            21) instalar_paquete "dirb" "dirb" ;;
            22) ejecutar_programa "dirb" dirb ;;
            23) instalar_paquete "crunch" "crunch" ;;
            24) ejecutar_programa "crunch" crunch ;;
            25) instalar_paquete "macchanger" "macchanger" ;;
            26) ejecutar_programa "macchanger" macchanger --help ;;
            0|*) break ;;
        esac
    done
}

# ====================================================
# MENÚ 7: MANTENIMIENTO, CLAVES Y CRIPTO
# ====================================================
menu_mantenimiento() {
    while true; do
        OPCION=$($DIALOG_CMD --title "Lupintool - Mantenimiento y Utilidades" \
            --menu "Seleccioná una acción de soporte:" 20 70 10 \
            "1" "Limpiar Caché y Paquetes Obsoletos del Sistema" \
            "2" "Generador de Contraseñas Seguras (16 Caracteres)" \
            "3" "Generador de Contraseñas Seguras (32 Caracteres)" \
            "4" "Generador de Hashes (MD5, SHA1, SHA256)" \
            "5" "Auditoría de Almacenamiento en Disco (df -h)" \
            "6" "Monitoreo de Memoria RAM en Tiempo Real" \
            "7" "Visor de Procesos en Ejecución (ps aux)" \
            "8" "Cifrar un Archivo con Contraseña (OpenSSL AES-256)" \
            "9" "Descifrar un Archivo (OpenSSL AES-256)" \
            "0" "<< Volver al Menú Principal" \
            3>&1 1>&2 2>&3)

        case $OPCION in
            1)
                clear
                echo "=========================================="
                echo " Limpiando caché y paquetes viejos..."
                echo "=========================================="
                if command -v apt &> /dev/null; then sudo apt autoremove -y && sudo apt clean
                elif command -v pkg &> /dev/null; then pkg clean
                elif command -v pacman &> /dev/null; then sudo pacman -Sc --noconfirm; fi
                read -p "Limpieza finalizada. Presioná Enter..."
                ;;
            2)
                PASS=$(tr -dc 'A-Za-z0-9!@#$%^&*()' < /dev/urandom | head -c 16)
                $DIALOG_CMD --title "Clave Generada (16)" --msgbox "\n Tu contraseña segura:\n\n $PASS" 9 55
                ;;
            3)
                PASS=$(tr -dc 'A-Za-z0-9!@#$%^&*()' < /dev/urandom | head -c 32)
                $DIALOG_CMD --title "Clave Generada (32)" --msgbox "\n Tu contraseña larga:\n\n $PASS" 9 60
                ;;
            4)
                TEXTO=$($DIALOG_CMD --title "Generador Hash" --inputbox "Ingresá el texto a procesar:" 9 50 3>&1 1>&2 2>&3)
                if [ -n "$TEXTO" ]; then
                    H_MD5=$(echo -n "$TEXTO" | md5sum | awk '{print $1}')
                    H_SHA1=$(echo -n "$TEXTO" | sha1sum | awk '{print $1}')
                    H_SHA256=$(echo -n "$TEXTO" | sha256sum | awk '{print $1}')
                    $DIALOG_CMD --title "Resultados Hash" --msgbox "MD5:\n$H_MD5\n\nSHA1:\n$H_SHA1\n\nSHA256:\n$H_SHA256" 14 65
                fi
                ;;
            5) clear; df -h; echo ""; read -p "Presioná Enter para continuar..." ;;
            6) clear; free -h -s 1 ;;
            7) clear; ps aux | head -n 30; echo ""; read -p "Presioná Enter..." ;;
            8)
                clear
                read -p "Ruta del archivo a cifrar: " RUTA_ORIG
                if [ -f "$RUTA_ORIG" ]; then
                    openssl enc -aes-256-cbc -salt -in "$RUTA_ORIG" -out "$RUTA_ORIG.enc"
                    echo "¡Archivo cifrado generado: $RUTA_ORIG.enc!"
                else
                    echo "El archivo no existe."
                fi
                read -p "Presioná Enter..."
                ;;
            9)
                clear
                read -p "Ruta del archivo .enc a descifrar: " RUTA_ENC
                if [ -f "$RUTA_ENC" ]; then
                    openssl enc -d -aes-256-cbc -in "$RUTA_ENC" -out "${RUTA_ENC%.enc}_restaurado"
                    echo "¡Archivo descifrado con éxito!"
                else
                    echo "El archivo no existe."
                fi
                read -p "Presioná Enter..."
                ;;
            0|*) break ;;
        esac
    done
}

# ====================================================
# MENÚ PRINCIPAL
# ====================================================
while true; do
    CATEGORIA=$($DIALOG_CMD --title "=== LUPINTOOL v6.2 MEGA CATALOG ===" \
        --menu "Seleccioná una categoría para explorar sus herramientas:" 22 75 10 \
        "1" "🎮 Juegos CLI y Arcade (Tetris, Pacman, NetHack, Sudoku)" \
        "2" "✨ Efectos Visuales y Arte ASCII (Matrix, Bonsái, Chafa)" \
        "3" "🎵 Audio, Video y Multimedia (FFmpeg, Yt-Dlp, MPV)" \
        "4" "🌐 Redes, Servidores y Web (SSH, Nmap, Curl, Speedtest)" \
        "5" "💻 Sistema, Archivos y Editores (Htop, Btop, Micro, Vim)" \
        "6" "🛡️ Ciberseguridad y Hacking (Nikto, SQLMap, Hydra, John)" \
        "7" "🛠️ Mantenimiento, Claves y Criptografía" \
        "8" "🎨 Paint CLI (Lienzo Interactivo de Dibujo)" \
        "9" "📥 Catálogo y Descarga de Menús Extras" \
        "0" "❌ Salir de Lupintool" \
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
        0|*) clear; echo "¡Gracias por usar Lupintool v6.2!"; exit 0 ;;
    esac
done
EOF
