#!/bin/bash

# ==========================================
# LUPINTOOL v3.0 - ULTIMATE CLI SUITE & PAINT
# Soporte para Mouse, Flechas y Lienzo de Dibujo
# ==========================================

# Detectar gestor de paquetes de forma dinámica
if command -v pkg &> /dev/null; then
    PKG_MAN="pkg install -y"
elif command -v apt &> /dev/null; then
    PKG_MAN="sudo apt install -y"
elif command -v pacman &> /dev/null; then
    PKG_MAN="sudo pacman -S --noconfirm"
elif command -v dnf &> /dev/null; then
    PKG_MAN="sudo dnf install -y"
else
    PKG_MAN="echo 'Gestor de paquetes no detectado automáticamente.'"
fi

# Garantizar dependencias base
for dep in dialog python3; do
    if ! command -v $dep &> /dev/null; then
        echo "Instalando dependencia base: $dep..."
        $PKG_MAN $dep
    fi
done

DIALOG_CMD="dialog --mouse --clear --shadow"

# ==========================================
# MÓDULO PAINT CLI INTERACTIVO
# ==========================================
modo_paint() {
    local ARCHIVO_DIBUJO="$HOME/dibujo_lupintool.txt"
    local ANCHO=30
    local ALTO=12
    local PINCEL="█"
    
    # Inicializar matriz vacía en memoria
    declare -A CANVA
    limpiar_lienzo() {
        for ((y=0; y<ALTO; y++)); do
            for ((x=0; x<ANCHO; x++)); do
                CANVA["$x,$y"]=" "
            done
        done
    }
    limpiar_lienzo

    while true; do
        # Renderizar vista previa del lienzo
        local RENDER="\n"
        for ((y=0; y<ALTO; y++)); do
            RENDER+="  │"
            for ((x=0; x<ANCHO; x++)); do
                RENDER+="${CANVA["$x,$y"]}"
            done
            RENDER+="│\n"
        done

        OPCION=$($DIALOG_CMD --title "Lupintool Paint - Pincel actual: [$PINCEL]" \
            --menu "Lienzo de Dibujo ASCII ($ANCHO x $ALTO):\n$RENDER" 22 65 7 \
            "1" "Dibujar / Colocar Pincel (Coordenadas X, Y)" \
            "2" "Cambiar Carácter de Pincel (Actual: $PINCEL)" \
            "3" "Borrador (Usar espacio en blanco)" \
            "4" "Limpiar Lienzo Completo" \
            "5" "Guardar Dibujo en Archivo ($ARCHIVO_DIBUJO)" \
            "6" "Ver Dibujo Completo en Pantalla" \
            "0" "<< Volver al Menú Principal" \
            3>&1 1>&2 2>&3)

        case $OPCION in
            1)
                COORD=$($DIALOG_CMD --title "Pintar Punto" \
                    --inputbox "Ingresá las coordenadas X e Y separadas por espacio (Ejemplo: 5 3):\n(X: 0 a $((ANCHO-1)), Y: 0 a $((ALTO-1)))" 10 60 \
                    3>&1 1>&2 2>&3)
                if [ -n "$COORD" ]; then
                    read -r px py <<< "$COORD"
                    if [[ "$px" =~ ^[0-9]+$ ]] && [[ "$py" =~ ^[0-9]+$ ]] && [ "$px" -lt "$ANCHO" ] && [ "$py" -lt "$ALTO" ]; then
                        CANVA["$px,$py"]="$PINCEL"
                    else
                        $DIALOG_CMD --title "Error" --msgbox "\n Coordenadas fuera de rango." 7 40
                    fi
                fi
                ;;
            2)
                NUEVO_PINCEL=$($DIALOG_CMD --title "Cambiar Pincel" \
                    --inputbox "Ingresá un símbolo para pintar (Ejemplos: █, #, *, @, O, +):" 9 50 \
                    3>&1 1>&2 2>&3)
                [ -n "$NUEVO_PINCEL" ] && PINCEL="${NUEVO_PINCEL:0:1}"
                ;;
            3) PINCEL=" " ;;
            4) limpiar_lienzo ;;
            5)
                echo "--- DIBUJO LUPINTOOL ---" > "$ARCHIVO_DIBUJO"
                for ((y=0; y<ALTO; y++)); do
                    LINEA=""
                    for ((x=0; x<ANCHO; x++)); do
                        LINEA+="${CANVA["$x,$y"]}"
                    done
                    echo "$LINEA" >> "$ARCHIVO_DIBUJO"
                done
                $DIALOG_CMD --title "Guardado" --msgbox "\n ¡Dibujo guardado con éxito en:\n $ARCHIVO_DIBUJO!" 8 55
                ;;
            6)
                clear
                echo "=========================================="
                echo "          VISTA PREVIA DEL DIBUJO         "
                echo "=========================================="
                for ((y=0; y<ALTO; y++)); do
                    LINEA=""
                    for ((x=0; x<ANCHO; x++)); do
                        LINEA+="${CANVA["$x,$y"]}"
                    done
                    echo "│$LINEA│"
                done
                echo "=========================================="
                read -p "Presioná Enter para continuar dibujando..."
                ;;
            0|*) break ;;
        esac
    done
}

# ==========================================
# FUNCIONES AUXILIARES
# ==========================================
instalar_paquete() {
    local cmd_check="$1"
    local pkg_name="$2"
    if command -v "$cmd_check" &> /dev/null; then
        $DIALOG_CMD --title "Estado" --msgbox "\n El comando '$cmd_check' ya está instalado." 7 50
    else
        clear
        echo "=========================================="
        echo " Instalando paquete: $pkg_name"
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
        $DIALOG_CMD --title "Error" --msgbox "\n El programa '$cmd_check' NO está instalado.\nInstalalo primero." 8 50
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

buscar_web() {
    BUSQUEDA=$($DIALOG_CMD --title "Buscador Web" --inputbox "\nIngresá tu búsqueda:" 9 55 3>&1 1>&2 2>&3)
    if [ -n "$BUSQUEDA" ]; then
        query_encoded=$(echo "$BUSQUEDA" | sed 's/ /+/g')
        url="https://html.duckduckgo.com/html/?q=${query_encoded}"
        clear
        if command -v xdg-open &> /dev/null; then xdg-open "$url"
        elif command -v w3m &> /dev/null; then w3m "$url"
        else echo "Abrí este enlace: $url"; read -p "Enter para continuar..."; fi
    fi
}

# ==========================================
# MÓDULOS DE HERRAMIENTAS
# ==========================================
menu_mantenimiento() {
    while true; do
        OPCION=$($DIALOG_CMD --title "Lupintool - Mantenimiento y Cripto" \
            --menu "Seleccioná una utilidad:" 18 65 8 \
            "1" "Limpiar Caché y Paquetes Obsoletos del Sistema" \
            "2" "Generador de Contraseñas Seguras (CLI)" \
            "3" "Generador de Hashes (MD5 / SHA256)" \
            "4" "Auditoría de Uso de Disco Rápida (df -h)" \
            "5" "Monitoreo de Memoria RAM en Tiempo Real" \
            "0" "<< Volver al Menú Principal" \
            3>&1 1>&2 2>&3)

        case $OPCION in
            1)
                clear
                echo "Limpiando paquetes obsoletos..."
                if command -v apt &> /dev/null; then sudo apt autoremove -y && sudo apt clean
                elif command -v pacman &> /dev/null; then sudo pacman -Sc --noconfirm; fi
                read -p "Limpieza completada. Presioná Enter..."
                ;;
            2)
                PASS=$(tr -dc 'A-Za-z0-9!@#$%^&*()' < /dev/urandom | head -c 16)
                $DIALOG_CMD --title "Contraseña Generada" --msgbox "\n Tu clave segura es:\n\n $PASS" 9 50
                ;;
            3)
                TEXTO=$($DIALOG_CMD --title "Generador Hash" --inputbox "Ingresá el texto a encriptar:" 9 50 3>&1 1>&2 2>&3)
                if [ -n "$TEXTO" ]; then
                    HASH_MD5=$(echo -n "$TEXTO" | md5sum | awk '{print $1}')
                    HASH_256=$(echo -n "$TEXTO" | sha256sum | awk '{print $1}')
                    $DIALOG_CMD --title "Resultados Hash" --msgbox "MD5: $HASH_MD5\n\nSHA256: $HASH_256" 10 65
                fi
                ;;
            4) clear; df -h; echo ""; read -p "Presioná Enter..." ;;
            5) clear; free -h -s 1; ;;
            0|*) break ;;
        esac
    done
}

menu_multimedia() {
    while true; do
        OPCION=$($DIALOG_CMD --title "Lupintool - Audio, Video y Gráficos" \
            --menu "Elegí una opción:" 20 70 12 \
            "1" "[INSTALAR] FFmpeg" "2" "[ABRIR] FFmpeg" \
            "3" "[INSTALAR] yt-dlp" "4" "[ABRIR] yt-dlp" \
            "5" "[INSTALAR] cmus" "6" "[ABRIR] cmus" \
            "7" "[INSTALAR] ImageMagick" "8" "[ABRIR] ImageMagick" \
            "9" "[INSTALAR] FIGlet" "10" "[ABRIR] FIGlet" \
            "11" "[INSTALAR] TOIlet" "12" "[ABRIR] TOIlet" \
            "13" "[INSTALAR] Chafa (Visualizador de fotos terminal)" "14" "[ABRIR] Chafa" \
            "0" "<< Volver al Menú Principal" \
            3>&1 1>&2 2>&3)

        case $OPCION in
            1) instalar_paquete "ffmpeg" "ffmpeg" ;;
            2) ejecutar_programa "ffmpeg" ffmpeg -version ;;
            3) instalar_paquete "yt-dlp" "yt-dlp" ;;
            4) ejecutar_programa "yt-dlp" yt-dlp --help ;;
            5) instalar_paquete "cmus" "cmus" ;;
            6) ejecutar_programa "cmus" cmus ;;
            7) instalar_paquete "convert" "imagemagick" ;;
            8) ejecutar_programa "convert" convert -version ;;
            9) instalar_paquete "figlet" "figlet" ;;
            10) ejecutar_programa "figlet" figlet Lupintool ;;
            11) instalar_paquete "toilet" "toilet" ;;
            12) ejecutar_programa "toilet" toilet -f mono12 Lupintool ;;
            13) instalar_paquete "chafa" "chafa" ;;
            14) ejecutar_programa "chafa" chafa --help ;;
            0|*) break ;;
        esac
    done
}

menu_redes() {
    while true; do
        OPCION=$($DIALOG_CMD --title "Lupintool - Redes y Servidores" \
            --menu "Elegí una opción:" 20 70 12 \
            "1" "[INSTALAR] Nmap" "2" "[ABRIR] Nmap" \
            "3" "[INSTALAR] Curl" "4" "[ABRIR] Curl" \
            "5" "[INSTALAR] Netcat" "6" "[ABRIR] Netcat" \
            "7" "[INSTALAR] Speedtest-cli (Medidor de Velocidad)" "8" "[ABRIR] Speedtest-cli" \
            "9" "[INSTALAR] W3M" "10" "[ABRIR] W3M" \
            "0" "<< Volver al Menú Principal" \
            3>&1 1>&2 2>&3)

        case $OPCION in
            1) instalar_paquete "nmap" "nmap" ;;
            2) ejecutar_programa "nmap" nmap --help ;;
            3) instalar_paquete "curl" "curl" ;;
            4) ejecutar_programa "curl" curl --help ;;
            5) instalar_paquete "nc" "netcat-openbsd" ;;
            6) ejecutar_programa "nc" nc -h ;;
            7) instalar_paquete "speedtest-cli" "speedtest-cli" ;;
            8) ejecutar_programa "speedtest-cli" speedtest-cli ;;
            9) instalar_paquete "w3m" "w3m" ;;
            10) ejecutar_programa "w3m" w3m https://duckduckgo.com ;;
            0|*) break ;;
        esac
    done
}

menu_sistema() {
    while true; do
        OPCION=$($DIALOG_CMD --title "Lupintool - Utilidades y Sistema" \
            --menu "Elegí una opción:" 20 70 12 \
            "1" "[INSTALAR] Htop" "2" "[ABRIR] Htop" \
            "3" "[INSTALAR] Btop" "4" "[ABRIR] Btop" \
            "5" "[INSTALAR] Fastfetch / Neofetch" "6" "[ABRIR] Fastfetch" \
            "7" "[INSTALAR] Tmux" "8" "[ABRIR] Tmux" \
            "9" "[INSTALAR] Micro (Editor de texto)" "10" "[ABRIR] Micro" \
            "11" "[INSTALAR] Ncdu (Analizador de espacio)" "12" "[ABRIR] Ncdu" \
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
            11) instalar_paquete "ncdu" "ncdu" ;;
            12) ejecutar_programa "ncdu" ncdu ;;
            0|*) break ;;
        esac
    done
}

menu_diversion() {
    while true; do
        OPCION=$($DIALOG_CMD --title "Lupintool - Juegos y Efectos ASCII" \
            --menu "Elegí una opción:" 20 70 12 \
            "1" "[INSTALAR] CMatrix" "2" "[ABRIR] CMatrix" \
            "3" "[INSTALAR] Cowsay" "4" "[ABRIR] Cowsay" \
            "5" "[INSTALAR] CBonsai" "6" "[ABRIR] CBonsai" \
            "7" "[INSTALAR] Hollywood" "8" "[ABRIR] Hollywood" \
            "9" "[INSTALAR] SL (Tren)" "10" "[ABRIR] SL" \
            "11" "[INSTALAR] Pipes.sh" "12" "[ABRIR] Pipes.sh" \
            "0" "<< Volver al Menú Principal" \
            3>&1 1>&2 2>&3)

        case $OPCION in
            1) instalar_paquete "cmatrix" "cmatrix" ;;
            2) ejecutar_programa "cmatrix" cmatrix ;;
            3) instalar_paquete "cowsay" "cowsay" ;;
            4) ejecutar_programa "cowsay" cowsay "¡Lupintool 3.0 con Paint!" ;;
            5) instalar_paquete "cbonsai" "cbonsai" ;;
            6) ejecutar_programa "cbonsai" cbonsai -l ;;
            7) instalar_paquete "hollywood" "hollywood" ;;
            8) ejecutar_programa "hollywood" hollywood ;;
            9) instalar_paquete "sl" "sl" ;;
            10) ejecutar_programa "sl" sl ;;
            11) instalar_paquete "pipes.sh" "pipes" ;;
            12) ejecutar_programa "pipes.sh" pipes.sh ;;
            0|*) break ;;
        esac
    done
}

# ==========================================
# MENÚ PRINCIPAL
# ==========================================
menu_principal() {
    while true; do
        CATEGORIA=$($DIALOG_CMD --title "=== LUPINTOOL v3.0 ULTIMATE ===" \
            --menu "Navegá con FLECHAS / MOUSE y presioná ENTER:" 20 65 8 \
            "1" "🎨 Paint CLI (Lienzo de Dibujo Interactivo)" \
            "2" "🛠️ Mantenimiento, Cripto y Diagnóstico" \
            "3" "🎵 Audio, Video y Gráficos" \
            "4" "🌐 Redes, Web y Servidores" \
            "5" "💻 Utilidades del Sistema" \
            "6" "🎮 Juegos y Efectos Visuales" \
            "7" "🔍 Buscador Web Rápido" \
            "0" "❌ Salir" \
            3>&1 1>&2 2>&3)

        case $CATEGORIA in
            1) modo_paint ;;
            2) menu_mantenimiento ;;
            3) menu_multimedia ;;
            4) menu_redes ;;
            5) menu_sistema ;;
            6) menu_diversion ;;
            7) buscar_web ;;
            0|*) clear; echo "¡Gracias por usar Lupintool 3.0!"; exit 0 ;;
        esac
    done
}

menu_principal

