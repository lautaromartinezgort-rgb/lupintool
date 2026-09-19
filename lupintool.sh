rm -f lupintool.sh ~/lupintool.sh

cat << 'EOF' > lupintool.sh
#!/bin/bash

# =====================================================================
# LUPINTOOL v7.0 - LA SUITE SUPREMA (TODO EN UNO)
# =====================================================================

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

instalar_paquete() {
    local cmd_check="$1"
    local pkg_name="$2"
    if command -v "$cmd_check" &> /dev/null; then
        $DIALOG_CMD --title "Estado" --msgbox "\n El paquete o comando '$cmd_check' ya se encuentra instalado." 7 55
    else
        clear
        echo "=========================================="
        echo " Instalando módulo: $pkg_name..."
        echo "=========================================="
        $PKG_MAN "$pkg_name"
        read -p "Instalación finalizada. Presioná Enter..."
    fi
}

ejecutar_programa() {
    local cmd_check="$1"
    shift
    local run_cmd="$@"
    if ! command -v "$cmd_check" &> /dev/null; then
        $DIALOG_CMD --title "Aviso" --msgbox "\n El programa '$cmd_check' no está instalado.\nInstalalo primero seleccionando su opción." 8 55
    else
        clear
        echo "=========================================="
        echo " Ejecutando: $cmd_check"
        echo "=========================================="
        $run_cmd
        echo ""
        read -p "Presioná Enter para volver al menú..."
    fi
}

# =====================================================================
# 1. JUEGOS Y ARCADE (20 OPCIONES)
# =====================================================================
menu_juegos() {
    while true; do
        OPCION=$($DIALOG_CMD --title "🎮 Colección Masiva: Juegos y Arcade" \
            --menu "Seleccioná un juego:" 22 75 14 \
            "1" "Tetris Clásico (Bastet)" \
            "2" "Tetris Alternativo (Vitetris)" \
            "3" "Space Invaders (NInvaders)" \
            "4" "Pac-Man (Pacman4console)" \
            "5" "Viborita / Snake (NSnake)" \
            "6" "Puzzle numérico 2048 (2048-cli)" \
            "7" "Sudoku interactivo (Nudoku)" \
            "8" "Estrategia numérica (Greed)" \
            "9" "Moon Buggy (Vehículo lunar)" \
            "10" "NetHack (Rol dungeon crawler clásico)" \
            "11" "Dungeon Crawl Stone Soup (Crawl)" \
            "12" "Angband (Rol fantástico avanzado)" \
            "13" "Brogue (Roguelike minimalista)" \
            "14" "Freeciv (Estrategia por turnos global)" \
            "15" "Ajedrez por consola (GNU Chess)" \
            "16" "Juego del Go (GNU Go)" \
            "17" "Aventuras de texto Zork (Frotz)" \
            "18" "Mastermind / Adivinar código" \
            "0" "Volver al Menú Principal" \
            3>&1 1>&2 2>&3)

        case $OPCION in
            1) instalar_paquete "bastet" "bastet" && ejecutar_programa "bastet" bastet ;;
            2) instalar_paquete "vitetris" "vitetris" && ejecutar_programa "vitetris" vitetris ;;
            3) instalar_paquete "ninvaders" "ninvaders" && ejecutar_programa "ninvaders" ninvaders ;;
            4) instalar_paquete "pacman4console" "pacman4console" && ejecutar_programa "pacman4console" pacman4console ;;
            5) instalar_paquete "nsnake" "nsnake" && ejecutar_programa "nsnake" nsnake ;;
            6) instalar_paquete "2048" "2048-cli" && ejecutar_programa "2048" 2048 ;;
            7) instalar_paquete "nudoku" "nudoku" && ejecutar_programa "nudoku" nudoku ;;
            8) instalar_paquete "greed" "greed" && ejecutar_programa "greed" greed ;;
            9) instalar_paquete "moon-buggy" "moon-buggy" && ejecutar_programa "moon-buggy" moon-buggy ;;
            10) instalar_paquete "nethack" "nethack" && ejecutar_programa "nethack" nethack ;;
            11) instalar_paquete "crawl" "crawl" && ejecutar_programa "crawl" crawl ;;
            12) instalar_paquete "angband" "angband" && ejecutar_programa "angband" angband ;;
            13) instalar_paquete "brogue" "brogue" && ejecutar_programa "brogue" brogue ;;
            14) instalar_paquete "freeciv" "freeciv" && ejecutar_programa "freeciv" freeciv-cli ;;
            15) instalar_paquete "gnuchess" "gnuchess" && ejecutar_programa "gnuchess" gnuchess ;;
            16) instalar_paquete "gnugo" "gnugo" && ejecutar_programa "gnugo" gnugo ;;
            17) instalar_paquete "frotz" "frotz" && { $DIALOG_CMD --title "Info" --msgbox "Frotz instalado. Colocá historias .z5 para jugar." 7 50; } ;;
            18) 
               clear
               echo "=== JUEGO MASTERMIND (Adivina el código de 4 dígitos) ==="
               CODIGO=$((RANDOM % 9000 + 1000))
               while true; do
                   read -p "Ingresá tu intento (4 dígitos): " INTENTO
                   if [ "$INTENTO" -eq "$CODIGO" ]; then
                       echo "¡Felicitaciones! ¡Adivinaste el código!"
                       break
                   else
                       echo "Incorrecto. Probá de nuevo."
                   fi
               done
               read -p "Presioná Enter..."
               ;;
            0|*) break ;;
        esac
    done
}

# =====================================================================
# 2. EFECTOS VISUALES Y ARTE ASCII
# =====================================================================
menu_efectos() {
    while true; do
        OPCION=$($DIALOG_CMD --title "✨ Efectos Visuales y Arte ASCII" \
            --menu "Elegí un efecto:" 18 70 7 \
            "1" "CMatrix (Lluvia verde Matrix)" \
            "2" "CBonsai (Generador de bonsái ASCII)" \
            "3" "SL (Tren a vapor animado)" \
            "4" "Cowsay & Fortune (Frases con vacas)" \
            "5" "Hollywood (Simulador de hacker pro)" \
            "6" "Figlet (Banners de texto gigante)" \
            "7" "Toilet (Banners con colores y fuentes)" \
            "0" "Volver" \
            3>&1 1>&2 2>&3)
        case $OPCION in
            1) instalar_paquete "cmatrix" "cmatrix" && ejecutar_programa "cmatrix" cmatrix ;;
            2) instalar_paquete "cbonsai" "cbonsai" && ejecutar_programa "cbonsai" cbonsai -l ;;
            3) instalar_paquete "sl" "sl" && ejecutar_programa "sl" sl ;;
            4) instalar_paquete "cowsay" "cowsay fortune" && { clear; fortune | cowsay; read -p "Enter..."; } ;;
            5) instalar_paquete "hollywood" "hollywood" && ejecutar_programa "hollywood" hollywood ;;
            6) instalar_paquete "figlet" "figlet" && { read -p "Texto: " t; figlet "$t"; read -p "Enter..."; } ;;
            7) instalar_paquete "toilet" "toilet" && { read -p "Texto: " t; toilet -f term -F gay "$t"; read -p "Enter..."; } ;;
            0|*) break ;;
        esac
    done
}

# =====================================================================
# 3. MULTIMEDIA, AUDIO, VIDEO Y DESCARGAS
# =====================================================================
menu_multimedia() {
    while true; do
        OPCION=$($DIALOG_CMD --title "🎵 Multimedia, Video y Descargas" \
            --menu "Herramientas:" 18 70 6 \
            "1" "FFmpeg (Conversor universal de audio/video)" \
            "2" "Yt-Dlp (Descargador avanzado de YouTube/Web)" \
            "3" "MPV Player (Reproductor multimedia consola)" \
            "4" "MPlayer (Reproductor alternativo)" \
            "5" "Cmus (Reproductor de música con interfaz)" \
            "0" "Volver" 3>&1 1>&2 2>&3)
        case $OPCION in
            1) instalar_paquete "ffmpeg" "ffmpeg" ;;
            2) instalar_paquete "yt-dlp" "yt-dlp" ;;
            3) instalar_paquete "mpv" "mpv" ;;
            4) instalar_paquete "mplayer" "mplayer" ;;
            5) instalar_paquete "cmus" "cmus" && ejecutar_programa "cmus" cmus ;;
            0|*) break ;;
        esac
    done
}

# =====================================================================
# 4. REDES, SERVIDORES Y WEB
# =====================================================================
menu_redes() {
    while true; do
        OPCION=$($DIALOG_CMD --title "🌐 Redes, Servidores y Web" \
            --menu "Herramientas de red:" 19 70 7 \
            "1" "Nmap (Escáner de redes y puertos)" \
            "2" "Curl y Wget (Peticiones y descargas web)" \
            "3" "Speedtest-cli (Medidor de velocidad de internet)" \
            "4" "Netcat / NC (Navaja suiza de redes)" \
            "5" "Traceroute / MTR (Rutas de red)" \
            "6" "Servidor HTTP local rápido (Python 3)" \
            "7" "Navegador web de texto (W3M / Lynx)" \
            "0" "Volver" 3>&1 1>&2 2>&3)
        case $OPCION in
            1) instalar_paquete "nmap" "nmap" ;;
            2) instalar_paquete "curl" "curl wget" ;;
            3) instalar_paquete "speedtest-cli" "speedtest-cli" && speedtest-cli ;;
            4) instalar_paquete "nc" "netcat" ;;
            5) instalar_paquete "traceroute" "traceroute" ;;
            6) clear; echo "Iniciando servidor web local en puerto 8080 (Ctrl+C para salir)..."; python3 -m http.server 8080 ;;
            7) instalar_paquete "w3m" "w3m lynx" ;;
            0|*) break ;;
        esac
    done
}

# =====================================================================
# 5. SISTEMA, RENDIMIENTO Y EDITORES
# =====================================================================
menu_sistema() {
    while true; do
        OPCION=$($DIALOG_CMD --title "💻 Sistema, Rendimiento y Editores" \
            --menu "Herramientas del sistema:" 19 70 7 \
            "1" "Htop (Monitor interactivo de procesos)" \
            "2" "Btop (Monitor visual avanzado)" \
            "3" "Fastfetch (Info detallada de hardware/sistema)" \
            "4" "Micro Editor (Editor moderno tipo GUI)" \
            "5" "Nano y Vim (Editores de texto clásicos)" \
            "6" "Midnight Commander (Gestor de archivos visual)" \
            "7" "Ranger (Gestor de archivos por consola con VIM)" \
            "0" "Volver" 3>&1 1>&2 2>&3)
        case $OPCION in
            1) instalar_paquete "htop" "htop" && htop ;;
            2) instalar_paquete "btop" "btop" && btop ;;
            3) instalar_paquete "fastfetch" "fastfetch" && fastfetch && read -p "Enter..." ;;
            4) instalar_paquete "micro" "micro" ;;
            5) instalar_paquete "nano" "nano vim" ;;
            6) instalar_paquete "mc" "mc" && mc ;;
            7) instalar_paquete "ranger" "ranger" && ranger ;;
            0|*) break ;;
        esac
    done
}

# =====================================================================
# 6. CIBERSEGURIDAD Y HACKING ÉTICO
# =====================================================================
menu_seguridad() {
    while true; do
        OPCION=$($DIALOG_CMD --title "🛡️ Ciberseguridad y Auditoría" \
            --menu "Herramientas de pentesting:" 18 70 5 \
            "1" "Nikto (Escáner de vulnerabilidades web)" \
            "2" "SQLMap (Detección de inyecciones SQL)" \
            "3" "Hydra (Pruebas de fuerza bruta)" \
            "4" "John the Ripper (Rompedor de hashes)" \
            "0" "Volver" 3>&1 1>&2 2>&3)
        case $OPCION in
            1) instalar_paquete "nikto" "nikto" ;;
            2) instalar_paquete "sqlmap" "sqlmap" ;;
            3) instalar_paquete "hydra" "hydra" ;;
            4) instalar_paquete "john" "johnthetipper" ;;
            0|*) break ;;
        esac
    done
}

# =====================================================================
# 7. MANTENIMIENTO, CLAVES Y UTILIDADES
# =====================================================================
menu_mantenimiento() {
    while true; do
        OPCION=$($DIALOG_CMD --title "🛠️ Mantenimiento, Claves y Utilidades" \
            --menu "Utilidades avanzadas:" 19 70 6 \
            "1" "Limpiar paquetes obsoletos y caché" \
            "2" "Generador de contraseñas ultra seguras" \
            "3" "Ver espacio total en disco (df -h)" \
            "4" "Ver uso de memoria RAM (free -h)" \
            "5" "Generador de Hash SHA256 de un texto" \
            "0" "Volver" 3>&1 1>&2 2>&3)
        case $OPCION in
            1) clear; apt clean && apt autoremove -y 2>/dev/null || pkg clean; read -p "Enter..." ;;
            2) 
               P=$(tr -dc 'A-Za-z0-9!@#$%' < /dev/urandom | head -c 24)
               $DIALOG_CMD --title "Clave Generada" --msgbox "\n$P" 8 45
               ;;
            3) clear; df -h; read -p "Enter..." ;;
            4) clear; free -h; read -p "Enter..." ;;
            5) 
               TXT=$($DIALOG_CMD --title "Hash SHA256" --inputbox "Ingresá el texto:" 8 45 3>&1 1>&2 2>&3)
               [ -n "$TXT" ] && { H=$(echo -n "$TXT" | sha256sum | awk '{print $1}'); $DIALOG_CMD --title "Resultado SHA256" --msgbox "$H" 8 65; }
               ;;
            0|*) break ;;
        esac
    done
}

# =====================================================================
# 8. MODO PAINT CLI (LIENZO DE DIBUJO)
# =====================================================================
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
            "5" "Guardar Dibujo en Archivo de Texto" \
            "6" "Ver Dibujo en Pantalla Completa" \
            "0" "Volver al Menú Principal" \
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
                $DIALOG_CMD --title "Guardado" --msgbox "Guardado con éxito en $ARCHIVO_DIBUJO" 8 50
                ;;
            6)
                clear
                for ((y=0; y<ALTO; y++)); do
                    LINEA=""
                    for ((x=0; x<ANCHO; x++)); do LINEA+="${CANVA["$x,$y"]}"; done
                    echo "│$LINEA│"
                done
                read -p "Enter para volver..."
                ;;
            0|*) break ;;
        esac
    done
}

# =====================================================================
# MENÚ PRINCIPAL
# =====================================================================
while true; do
    CATEGORIA=$($DIALOG_CMD --title "=== LUPINTOOL v7.0 (EDICIÓN SUPREMA) ===" \
        --menu "Seleccioná una categoría general:" 22 75 9 \
        "1" "🎮 Arcade y Juegos Clásicos (20 Juegos)" \
        "2" "✨ Efectos Visuales y Arte ASCII" \
        "3" "🎵 Multimedia, Video y Descargas" \
        "4" "🌐 Redes, Servidores y Web" \
        "5" "💻 Sistema, Rendimiento y Editores" \
        "6" "🛡️ Ciberseguridad y Pentesting" \
        "7" "🛠️ Mantenimiento, Claves y Utilidades" \
        "8" "🎨 Paint CLI (Lienzo de Dibujo)" \
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
        0|*) clear; echo "¡Chau!"; exit 0 ;;
    esac
done
EOF

chmod +x lupintool.sh
./lupintool.sh
