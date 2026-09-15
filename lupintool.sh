#!/bin/bash

# ==========================================
# LUPINTOOL - MENÚ MULTIHERRAMIENTAS COMPLETO
# Sombra / Mouse / Flechas activados
# ==========================================

# Detectar gestor de paquetes
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

# Garantizar la instalación de 'dialog'
if ! command -v dialog &> /dev/null; then
    echo "Instalando la interfaz interactiva (dialog)..."
    $PKG_MAN dialog
fi

# Configuración de Dialog con soporte nativo de MOUSE y FLECHAS
DIALOG_CMD="dialog --mouse --clear --shadow"

# Función de búsqueda web
buscar_web() {
    BUSQUEDA=$($DIALOG_CMD --title "Lupintool - Buscador Web" \
        --inputbox "\nEscribí lo que querés buscar en Internet:" 10 60 \
        3>&1 1>&2 2>&3)

    if [ -n "$BUSQUEDA" ]; then
        query_encoded=$(echo "$BUSQUEDA" | sed 's/ /+/g')
        url="https://html.duckduckgo.com/html/?q=${query_encoded}"

        clear
        echo "=========================================="
        echo " Abriendo resultados para: $BUSQUEDA"
        echo "=========================================="
        
        if command -v termux-open-url &> /dev/null; then
            termux-open-url "$url"
        elif command -v xdg-open &> /dev/null; then
            xdg-open "$url"
        else
            echo "Abre este enlace en tu navegador: $url"
        fi
        echo ""
        read -p "Presiona Enter para regresar al menú de Lupintool..."
    fi
}

# Función universal de instalación
instalar_paquete() {
    local cmd_check="$1"
    local pkg_name="$2"
    if command -v "$cmd_check" &> /dev/null; then
        $DIALOG_CMD --title "Estado de Instalación" --msgbox "\n El comando '$cmd_check' ya está instalado en tu sistema." 8 55
    else
        clear
        echo "=========================================="
        echo " Instalando el paquete: $pkg_name"
        echo "=========================================="
        if command -v pacman &> /dev/null; then
    pacman -S --noconfirm "$pkg_name"
elif command -v pkg &> /dev/null; then
    pkg install -y "$pkg_name"
elif command -v sudo &> /dev/null; then
    sudo apt update && sudo apt install -y "$pkg_name"
else
    apt install -y "$pkg_name"
fi
        echo ""
        read -p "Instalación completada. Presiona Enter para continuar..."
        $DIALOG_CMD --title "Estado de Instalación" --msgbox "\n ¡La instalación de '$pkg_name' finalizó correctamente!" 8 55
    fi
}

# Función universal de ejecución
ejecutar_programa() {
    local cmd_check="$1"
    shift
    local run_cmd="$@"
    if ! command -v "$cmd_check" &> /dev/null; then
        $DIALOG_CMD --title "Atención" --msgbox "\n El comando '$cmd_check' NO está instalado.\n\nSelecciona primero la opción de INSTALAR." 9 55
    else
        clear
        echo "=========================================="
        echo " Ejecutando: $cmd_check"
        echo "=========================================="
        echo ""
        $run_cmd
        echo ""
        echo "=========================================="
        read -p "Presiona Enter para regresar al menú de Lupintool..."
    fi
}

# ==========================================
# MENÚS DE CATEGORÍAS
# ==========================================

menu_multimedia() {
    while true; do
        OPCION=$($DIALOG_CMD --title "Lupintool - Audio, Video y Edición" \
            --menu "Navega con FLECHAS o haz CLICK con el mouse:" 20 70 12 \
            "1" "[INSTALAR] FFmpeg (Procesador de Audio/Video)" \
            "2" "[ABRIR] FFmpeg (Procesador de Audio/Video)" \
            "3" "[INSTALAR] yt-dlp (Descargador de Videos YouTube/Web)" \
            "4" "[ABRIR] yt-dlp (Descargador de Videos YouTube/Web)" \
            "5" "[INSTALAR] cmus (Reproductor de Música en Terminal)" \
            "6" "[ABRIR] cmus (Reproductor de Música en Terminal)" \
            "7" "[INSTALAR] mpv (Reproductor Multimedia)" \
            "8" "[ABRIR] mpv (Reproductor Multimedia)" \
            "9" "[INSTALAR] SoX (Navaja Suiza de Audio)" \
            "10" "[ABRIR] SoX (Navaja Suiza de Audio)" \
            "11" "[INSTALAR] FLAC (Codificador/Decodificador de Audio)" \
            "12" "[ABRIR] FLAC (Codificador/Decodificador de Audio)" \
            "13" "[INSTALAR] ImageMagick (Edición de Imágenes CLI)" \
            "14" "[ABRIR] ImageMagick (Edición de Imágenes CLI)" \
            "15" "[INSTALAR] FIGlet (Banners de Texto ASCII)" \
            "16" "[ABRIR] FIGlet (Banners de Texto ASCII)" \
            "17" "[INSTALAR] TOIlet (Texto ASCII con Colores)" \
            "18" "[ABRIR] TOIlet (Texto ASCII con Colores)" \
            "19" "[INSTALAR] jp2a (Convertidor de Imagen JPG a ASCII)" \
            "20" "[ABRIR] jp2a (Convertidor de Imagen JPG a ASCII)" \
            "21" "[INSTALAR] MediaInfo (Información Técnica Multimedia)" \
            "22" "[ABRIR] MediaInfo (Información Técnica Multimedia)" \
            "23" "[INSTALAR] Streamlink (Lector de Streams en Vivo)" \
            "24" "[ABRIR] Streamlink (Lector de Streams en Vivo)" \
            "25" "[INSTALAR] gallery-dl (Descargador de Galerías)" \
            "26" "[ABRIR] gallery-dl (Descargador de Galerías)" \
            "27" "[INSTALAR] Graphviz (Generador de Diagramas)" \
            "28" "[ABRIR] Graphviz (Generador de Diagramas)" \
            "29" "[INSTALAR] Vorbis Tools (Codificador OGG/Vorbis)" \
            "30" "[ABRIR] Vorbis Tools (Codificador OGG/Vorbis)" \
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
            9) instalar_paquete "sox" "sox" ;;
            10) ejecutar_programa "sox" sox --help ;;
            11) instalar_paquete "flac" "flac" ;;
            12) ejecutar_programa "flac" flac --help ;;
            13) instalar_paquete "convert" "imagemagick" ;;
            14) ejecutar_programa "convert" convert -version ;;
            15) instalar_paquete "figlet" "figlet" ;;
            16) ejecutar_programa "figlet" figlet Lupintool ;;
            17) instalar_paquete "toilet" "toilet" ;;
            18) ejecutar_programa "toilet" toilet -f mono12 Lupintool ;;
            19) instalar_paquete "jp2a" "jp2a" ;;
            20) ejecutar_programa "jp2a" jp2a --help ;;
            21) instalar_paquete "mediainfo" "mediainfo" ;;
            22) ejecutar_programa "mediainfo" mediainfo --help ;;
            23) instalar_paquete "streamlink" "streamlink" ;;
            24) ejecutar_programa "streamlink" streamlink --help ;;
            25) instalar_paquete "gallery-dl" "gallery-dl" ;;
            26) ejecutar_programa "gallery-dl" gallery-dl --help ;;
            27) instalar_paquete "dot" "graphviz" ;;
            28) ejecutar_programa "dot" dot -V ;;
            29) instalar_paquete "oggenc" "vorbis-tools" ;;
            30) ejecutar_programa "oggenc" oggenc -h ;;
            0) break ;;
            *) break ;;
        esac
    done
}

menu_redes() {
    while true; do
        OPCION=$($DIALOG_CMD --title "Lupintool - Redes, Servidores y Web" \
            --menu "Navega con FLECHAS o haz CLICK con el mouse:" 20 70 12 \
            "1" "[INSTALAR] OpenSSH (Cliente/Servidor SSH)" \
            "2" "[ABRIR] OpenSSH (Cliente/Servidor SSH)" \
            "3" "[INSTALAR] Nmap (Escáner de Puertos y Redes)" \
            "4" "[ABRIR] Nmap (Escáner de Puertos y Redes)" \
            "5" "[INSTALAR] Curl (Transferencia de Datos por URL)" \
            "6" "[ABRIR] Curl (Transferencia de Datos por URL)" \
            "7" "[INSTALAR] Wget (Descargador de Archivos Web)" \
            "8" "[ABRIR] Wget (Descargador de Archivos Web)" \
            "9" "[INSTALAR] Netcat (La Navaja Suiza de TCP/IP)" \
            "10" "[ABRIR] Netcat (La Navaja Suiza de TCP/IP)" \
            "11" "[INSTALAR] Aria2 (Descargador Multihilo Rápido)" \
            "12" "[ABRIR] Aria2 (Descargador Multihilo Rápido)" \
            "13" "[INSTALAR] Lynx (Navegador Web en Terminal)" \
            "14" "[ABRIR] Lynx (Navegador Web en Terminal)" \
            "15" "[INSTALAR] W3M (Navegador Web Textual)" \
            "16" "[ABRIR] W3M (Navegador Web Textual)" \
            "17" "[INSTALAR] ELinks (Navegador Web Avanzado)" \
            "18" "[ABRIR] ELinks (Navegador Web Avanzado)" \
            "19" "[INSTALAR] iPerf3 (Medidor de Ancho de Banda)" \
            "20" "[ABRIR] iPerf3 (Medidor de Ancho de Banda)" \
            "21" "[INSTALAR] Rsync (Sincronización Rápida)" \
            "22" "[ABRIR] Rsync (Sincronización Rápida)" \
            "23" "[INSTALAR] Rclone (Sincronizador con Nubes)" \
            "24" "[ABRIR] Rclone (Sincronizador con Nubes)" \
            "25" "[INSTALAR] Net-Tools (ifconfig, netstat, arp)" \
            "26" "[ABRIR] Net-Tools (ifconfig, netstat, arp)" \
            "27" "[INSTALAR] DNSUtils (dig, nslookup, host)" \
            "28" "[ABRIR] DNSUtils (dig, nslookup, host)" \
            "29" "[INSTALAR] Whois (Información de Dominios Web)" \
            "30" "[ABRIR] Whois (Información de Dominios Web)" \
            "31" "[INSTALAR] Traceroute (Rastreador de Rutas)" \
            "32" "[ABRIR] Traceroute (Rastreador de Rutas)" \
            "33" "[INSTALAR] MTR (Diagnóstico SSH/Ping/Traceroute)" \
            "34" "[ABRIR] MTR (Diagnóstico SSH/Ping/Traceroute)" \
            "35" "[INSTALAR] fPing (Ping Múltiple e Industrial)" \
            "36" "[ABRIR] fPing (Ping Múltiple e Industrial)" \
            "37" "[INSTALAR] Socat (Retransmisor de Sockets)" \
            "38" "[ABRIR] Socat (Retransmisor de Sockets)" \
            "39" "[INSTALAR] Lighttpd (Servidor Web Ligero)" \
            "40" "[ABRIR] Lighttpd (Servidor Web Ligero)" \
            "41" "[INSTALAR] Nginx (Servidor Web y Proxy Inverso)" \
            "42" "[ABRIR] Nginx (Servidor Web y Proxy Inverso)" \
            "43" "[INSTALAR] OpenVPN (Cliente y Servidor VPN)" \
            "44" "[ABRIR] OpenVPN (Cliente y Servidor VPN)" \
            "45" "[INSTALAR] WireGuard (Herramientas VPN)" \
            "46" "[ABRIR] WireGuard (Herramientas VPN)" \
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
            9) instalar_paquete "nc" "netcat-openbsd" ;;
            10) ejecutar_programa "nc" nc -h ;;
            11) instalar_paquete "aria2c" "aria2" ;;
            12) ejecutar_programa "aria2c" aria2c --help ;;
            13) instalar_paquete "lynx" "lynx" ;;
            14) ejecutar_programa "lynx" lynx https://wiby.me ;;
            15) instalar_paquete "w3m" "w3m" ;;
            16) ejecutar_programa "w3m" w3m https://frogfind.com ;;
            17) instalar_paquete "elinks" "elinks" ;;
            18) ejecutar_programa "elinks" elinks https://google.com ;;
            19) instalar_paquete "iperf3" "iperf3" ;;
            20) ejecutar_programa "iperf3" iperf3 --help ;;
            21) instalar_paquete "rsync" "rsync" ;;
            22) ejecutar_programa "rsync" rsync --help ;;
            23) instalar_paquete "rclone" "rclone" ;;
            24) ejecutar_programa "rclone" rclone --help ;;
            25) instalar_paquete "ifconfig" "net-tools" ;;
            26) ejecutar_programa "ifconfig" ifconfig ;;
            27) instalar_paquete "dig" "dnsutils" ;;
            28) ejecutar_programa "dig" dig -v ;;
            29) instalar_paquete "whois" "whois" ;;
            30) ejecutar_programa "whois" whois --help ;;
            31) instalar_paquete "traceroute" "traceroute" ;;
            32) ejecutar_programa "traceroute" traceroute --help ;;
            33) instalar_paquete "mtr" "mtr" ;;
            34) ejecutar_programa "mtr" mtr --help ;;
            35) instalar_paquete "fping" "fping" ;;
            36) ejecutar_programa "fping" fping -v ;;
            37) instalar_paquete "socat" "socat" ;;
            38) ejecutar_programa "socat" socat -h ;;
            39) instalar_paquete "lighttpd" "lighttpd" ;;
            40) ejecutar_programa "lighttpd" lighttpd -v ;;
            41) instalar_paquete "nginx" "nginx" ;;
            42) ejecutar_programa "nginx" nginx -v ;;
            43) instalar_paquete "openvpn" "openvpn" ;;
            44) ejecutar_programa "openvpn" openvpn --version ;;
            45) instalar_paquete "wg" "wireguard-tools" ;;
            46) ejecutar_programa "wg" wg --help ;;
            0) break ;;
            *) break ;;
        esac
    done
}

menu_sistema() {
    while true; do
        OPCION=$($DIALOG_CMD --title "Lupintool - Utilidades y Gestión del Sistema" \
            --menu "Navega con FLECHAS o haz CLICK con el mouse:" 20 70 12 \
            "1" "[INSTALAR] Htop (Monitor de Procesos)" \
            "2" "[ABRIR] Htop (Monitor de Procesos)" \
            "3" "[INSTALAR] Btop (Monitor de Sistema Elegante)" \
            "4" "[ABRIR] Btop (Monitor de Sistema Elegante)" \
            "5" "[INSTALAR] Neofetch (Información de Sistema)" \
            "6" "[ABRIR] Neofetch (Información de Sistema)" \
            "7" "[INSTALAR] Fastfetch (Neofetch Ultra Rápido)" \
            "8" "[ABRIR] Fastfetch (Neofetch Ultra Rápido)" \
            "9" "[INSTALAR] Tree (Visualizador de Carpetas)" \
            "10" "[ABRIR] Tree (Visualizador de Carpetas)" \
            "11" "[INSTALAR] Tmux (Multiplexor de Terminales)" \
            "12" "[ABRIR] Tmux (Multiplexor de Terminales)" \
            "13" "[INSTALAR] Screen (Administrador de Sesiones)" \
            "14" "[ABRIR] Screen (Administrador de Sesiones)" \
            "15" "[INSTALAR] Zsh (Shell Avanzada e Interactiva)" \
            "16" "[ABRIR] Zsh (Shell Avanzada e Interactiva)" \
            "17" "[INSTALAR] Fish (Shell Amigable)" \
            "18" "[ABRIR] Fish (Shell Amigable)" \
            "19" "[INSTALAR] Vim (Editor de Texto Avanzado)" \
            "20" "[ABRIR] Vim (Editor de Texto Avanzado)" \
            "21" "[INSTALAR] Nano (Editor de Texto Fácil)" \
            "22" "[ABRIR] Nano (Editor de Texto Fácil)" \
            "23" "[INSTALAR] Micro (Editor de Texto Moderno)" \
            "24" "[ABRIR] Micro (Editor de Texto Moderno)" \
            "25" "[INSTALAR] Ranger (Explorador de Archivos)" \
            "26" "[ABRIR] Ranger (Explorador de Archivos)" \
            "27" "[INSTALAR] Midnight Commander (Gestor de Archivos)" \
            "28" "[ABRIR] Midnight Commander (Gestor de Archivos)" \
            "29" "[INSTALAR] FZF (Buscador Difuso Interactivo)" \
            "30" "[ABRIR] FZF (Buscador Difuso Interactivo)" \
            "31" "[INSTALAR] Bat (Comando cat con Colores)" \
            "32" "[ABRIR] Bat (Comando cat con Colores)" \
            "33" "[INSTALAR] Eza (Reemplazo Moderno de ls)" \
            "34" "[ABRIR] Eza (Reemplazo Moderno de ls)" \
            "35" "[INSTALAR] FD (Buscador Rápido de Archivos)" \
            "36" "[ABRIR] FD (Buscador Rápido de Archivos)" \
            "37" "[INSTALAR] Ripgrep (Buscador de Texto Rápido)" \
            "38" "[ABRIR] Ripgrep (Buscador de Texto Rápido)" \
            "39" "[INSTALAR] JQ (Procesador y Filtro JSON)" \
            "40" "[ABRIR] JQ (Procesador y Filtro JSON)" \
            "41" "[INSTALAR] 7-Zip (Compresor/Descompresor)" \
            "42" "[ABRIR] 7-Zip (Compresor/Descompresor)" \
            "43" "[INSTALAR] Unrar (Extraer Archivos .RAR)" \
            "44" "[ABRIR] Unrar (Extraer Archivos .RAR)" \
            "45" "[INSTALAR] NCDU (Analizador de Disco)" \
            "46" "[ABRIR] NCDU (Analizador de Disco)" \
            "47" "[INSTALAR] Duf (Visualizador de Discos Bonito)" \
            "48" "[ABRIR] Duf (Visualizador de Discos Bonito)" \
            "49" "[INSTALAR] Procs (Reemplazo Moderno de ps)" \
            "50" "[ABRIR] Procs (Reemplazo Moderno de ps)" \
            "51" "[INSTALAR] TLDR (Manuales Simplificados)" \
            "52" "[ABRIR] TLDR (Manuales Simplificados)" \
            "0" "<< Volver al Menú Principal" \
            3>&1 1>&2 2>&3)

        case $OPCION in
            1) instalar_paquete "htop" "htop" ;;
            2) ejecutar_programa "htop" htop ;;
            3) instalar_paquete "btop" "btop" ;;
            4) ejecutar_programa "btop" btop ;;
            5) instalar_paquete "neofetch" "neofetch" ;;
            6) ejecutar_programa "neofetch" neofetch ;;
            7) instalar_paquete "fastfetch" "fastfetch" ;;
            8) ejecutar_programa "fastfetch" fastfetch ;;
            9) instalar_paquete "tree" "tree" ;;
            10) ejecutar_programa "tree" tree ;;
            11) instalar_paquete "tmux" "tmux" ;;
            12) ejecutar_programa "tmux" tmux ;;
            13) instalar_paquete "screen" "screen" ;;
            14) ejecutar_programa "screen" screen --help ;;
            15) instalar_paquete "zsh" "zsh" ;;
            16) ejecutar_programa "zsh" zsh --version ;;
            17) instalar_paquete "fish" "fish" ;;
            18) ejecutar_programa "fish" fish ;;
            19) instalar_paquete "vim" "vim" ;;
            20) ejecutar_programa "vim" vim ;;
            21) instalar_paquete "nano" "nano" ;;
            22) ejecutar_programa "nano" nano ;;
            23) instalar_paquete "micro" "micro" ;;
            24) ejecutar_programa "micro" micro ;;
            25) instalar_paquete "ranger" "ranger" ;;
            26) ejecutar_programa "ranger" ranger ;;
            27) instalar_paquete "mc" "mc" ;;
            28) ejecutar_programa "mc" mc ;;
            29) instalar_paquete "fzf" "fzf" ;;
            30) ejecutar_programa "fzf" fzf --help ;;
            31) instalar_paquete "bat" "bat" ;;
            32) ejecutar_programa "bat" bat --help ;;
            33) instalar_paquete "eza" "eza" ;;
            34) ejecutar_programa "eza" eza -la ;;
            35) instalar_paquete "fd" "fd" ;;
            36) ejecutar_programa "fd" fd --help ;;
            37) instalar_paquete "rg" "ripgrep" ;;
            38) ejecutar_programa "rg" rg --help ;;
            39) instalar_paquete "jq" "jq" ;;
            40) ejecutar_programa "jq" jq --help ;;
            41) instalar_paquete "7z" "p7zip" ;;
            42) ejecutar_programa "7z" 7z --help ;;
            43) instalar_paquete "unrar" "unrar" ;;
            44) ejecutar_programa "unrar" unrar --help ;;
            45) instalar_paquete "ncdu" "ncdu" ;;
            46) ejecutar_programa "ncdu" ncdu ;;
            47) instalar_paquete "duf" "duf" ;;
            48) ejecutar_programa "duf" duf ;;
            49) instalar_paquete "procs" "procs" ;;
            50) ejecutar_programa "procs" procs ;;
            51) instalar_paquete "tldr" "tldr" ;;
            52) ejecutar_programa "tldr" tldr --help ;;
            0) break ;;
            *) break ;;
        esac
    done
}

menu_programacion() {
    while true; do
        OPCION=$($DIALOG_CMD --title "Lupintool - Lenguajes de Programación y Git" \
            --menu "Navega con FLECHAS o haz CLICK con el mouse:" 20 70 12 \
            "1" "[INSTALAR] Python 3 (Lenguaje de Programación)" \
            "2" "[ABRIR] Python 3 (Lenguaje de Programación)" \
            "3" "[INSTALAR] Node.js (Entorno JavaScript)" \
            "4" "[ABRIR] Node.js (Entorno JavaScript)" \
            "5" "[INSTALAR] Ruby (Lenguaje Dinámico)" \
            "6" "[ABRIR] Ruby (Lenguaje Dinámico)" \
            "7" "[INSTALAR] Perl (Lenguaje de Scripting)" \
            "8" "[ABRIR] Perl (Lenguaje de Scripting)" \
            "9" "[INSTALAR] Go / Golang (Lenguaje de Google)" \
            "10" "[ABRIR] Go / Golang (Lenguaje de Google)" \
            "11" "[INSTALAR] Rust (Compilador de Rust)" \
            "12" "[ABRIR] Rust (Compilador de Rust)" \
            "13" "[INSTALAR] Clang / C++ (Compilador C/C++)" \
            "14" "[ABRIR] Clang / C++ (Compilador C/C++)" \
            "15" "[INSTALAR] GCC (Colección Compiladores GNU)" \
            "16" "[ABRIR] GCC (Colección Compiladores GNU)" \
            "17" "[INSTALAR] Make (Automatización de Compilación)" \
            "18" "[ABRIR] Make (Automatización de Compilación)" \
            "19" "[INSTALAR] CMake (Generador de Construcción)" \
            "20" "[ABRIR] CMake (Generador de Construcción)" \
            "21" "[INSTALAR] Lua (Lenguaje Scripting de Juegos)" \
            "22" "[ABRIR] Lua (Lenguaje Scripting de Juegos)" \
            "23" "[INSTALAR] PHP (Lenguaje Backend Web)" \
            "24" "[ABRIR] PHP (Lenguaje Backend Web)" \
            "25" "[INSTALAR] Java / OpenJDK 17" \
            "26" "[ABRIR] Java / OpenJDK 17" \
            "27" "[INSTALAR] SQLite3 (Base de Datos en Archivo)" \
            "28" "[ABRIR] SQLite3 (Base de Datos en Archivo)" \
            "29" "[INSTALAR] Redis (Cliente/Servidor Clave-Valor)" \
            "30" "[ABRIR] Redis (Cliente/Servidor Clave-Valor)" \
            "31" "[INSTALAR] Git (Control de Versiones)" \
            "32" "[ABRIR] Git (Control de Versiones)" \
            "33" "[INSTALAR] GitHub CLI (Herramienta Oficial)" \
            "34" "[ABRIR] GitHub CLI (Herramienta Oficial)" \
            "0" "<< Volver al Menú Principal" \
            3>&1 1>&2 2>&3)

        case $OPCION in
            1) instalar_paquete "python3" "python" ;;
            2) ejecutar_programa "python3" python3 --version ;;
            3) instalar_paquete "node" "nodejs" ;;
            4) ejecutar_programa "node" node -v ;;
            5) instalar_paquete "ruby" "ruby" ;;
            6) ejecutar_programa "ruby" ruby -v ;;
            7) instalar_paquete "perl" "perl" ;;
            8) ejecutar_programa "perl" perl -v ;;
            9) instalar_paquete "go" "golang" ;;
            10) ejecutar_programa "go" go version ;;
            11) instalar_paquete "rustc" "rust" ;;
            12) ejecutar_programa "rustc" rustc --version ;;
            13) instalar_paquete "clang" "clang" ;;
            14) ejecutar_programa "clang" clang --version ;;
            15) instalar_paquete "gcc" "gcc" ;;
            16) ejecutar_programa "gcc" gcc --version ;;
            17) instalar_paquete "make" "make" ;;
            18) ejecutar_programa "make" make --version ;;
            19) instalar_paquete "cmake" "cmake" ;;
            20) ejecutar_programa "cmake" cmake --version ;;
            21) instalar_paquete "lua" "lua54" ;;
            22) ejecutar_programa "lua" lua -v ;;
            23) instalar_paquete "php" "php" ;;
            24) ejecutar_programa "php" php -v ;;
            25) instalar_paquete "java" "openjdk-17" ;;
            26) ejecutar_programa "java" java -version ;;
            27) instalar_paquete "sqlite3" "sqlite" ;;
            28) ejecutar_programa "sqlite3" sqlite3 --version ;;
            29) instalar_paquete "redis-cli" "redis" ;;
            30) ejecutar_programa "redis-cli" redis-cli --version ;;
            31) instalar_paquete "git" "git" ;;
            32) ejecutar_programa "git" git --version ;;
            33) instalar_paquete "gh" "gh" ;;
            34) ejecutar_programa "gh" gh --version ;;
            0) break ;;
            *) break ;;
        esac
    done
}

menu_seguridad() {
    while true; do
        OPCION=$($DIALOG_CMD --title "Lupintool - Hacking Ético y Ciberseguridad" \
            --menu "Navega con FLECHAS o haz CLICK con el mouse:" 20 70 12 \
            "1" "[INSTALAR] Nikto (Escáner de Vulnerabilidades)" \
            "2" "[ABRIR] Nikto (Escáner de Vulnerabilidades)" \
            "3" "[INSTALAR] SQLMap (Inyección SQL Automatizada)" \
            "4" "[ABRIR] SQLMap (Inyección SQL Automatizada)" \
            "5" "[INSTALAR] Hydra (Crackeador de Contraseñas Red)" \
            "6" "[ABRIR] Hydra (Crackeador de Contraseñas Red)" \
            "7" "[INSTALAR] John the Ripper (Descifrador Hashes)" \
            "8" "[ABRIR] John the Ripper (Descifrador Hashes)" \
            "9" "[INSTALAR] Aircrack-ng (Auditoría Redes WiFi)" \
            "10" "[ABRIR] Aircrack-ng (Auditoría Redes WiFi)" \
            "11" "[INSTALAR] WPScan (Auditoría Sitios WordPress)" \
            "12" "[ABRIR] WPScan (Auditoría Sitios WordPress)" \
            "13" "[INSTALAR] Gobuster (Buscador Directorios Ocultos)" \
            "14" "[ABRIR] Gobuster (Buscador Directorios Ocultos)" \
            "15" "[INSTALAR] FFUF (Fuzzer Web de Alta Velocidad)" \
            "16" "[ABRIR] FFUF (Fuzzer Web de Alta Velocidad)" \
            "17" "[INSTALAR] Hashcat (Restaurador de Contraseñas)" \
            "18" "[ABRIR] Hashcat (Restaurador de Contraseñas)" \
            "19" "[INSTALAR] TShark (Análisis Paquetes Terminal)" \
            "20" "[ABRIR] TShark (Análisis Paquetes Terminal)" \
            "21" "[INSTALAR] Tcpdump (Capturador Tráfico de Red)" \
            "22" "[ABRIR] Tcpdump (Capturador Tráfico de Red)" \
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
            9) instalar_paquete "aircrack-ng" "aircrack-ng" ;;
            10) ejecutar_programa "aircrack-ng" aircrack-ng --help ;;
            11) instalar_paquete "wpscan" "wpscan" ;;
            12) ejecutar_programa "wpscan" wpscan --help ;;
            13) instalar_paquete "gobuster" "gobuster" ;;
            14) ejecutar_programa "gobuster" gobuster -h ;;
            15) instalar_paquete "ffuf" "ffuf" ;;
            16) ejecutar_programa "ffuf" ffuf -h ;;
            17) instalar_paquete "hashcat" "hashcat" ;;
            18) ejecutar_programa "hashcat" hashcat --help ;;
            19) instalar_paquete "tshark" "tshark" ;;
            20) ejecutar_programa "tshark" tshark -v ;;
            21) instalar_paquete "tcpdump" "tcpdump" ;;
            22) ejecutar_programa "tcpdump" tcpdump --help ;;
            0) break ;;
            *) break ;;
        esac
    done
}

menu_diversion() {
    while true; do
        OPCION=$($DIALOG_CMD --title "Lupintool - Juegos y Efectos de Terminal" \
            --menu "Navega con FLECHAS o haz CLICK con el mouse:" 20 70 12 \
            "1" "[INSTALAR] SL (Animación de Tren a Vapor)" \
            "2" "[ABRIR] SL (Animación de Tren a Vapor)" \
            "3" "[INSTALAR] CMatrix (Lluvia Estilo Matrix)" \
            "4" "[ABRIR] CMatrix (Lluvia Estilo Matrix)" \
            "5" "[INSTALAR] Cowsay (Vaca Habladora ASCII)" \
            "6" "[ABRIR] Cowsay (Vaca Habladora ASCII)" \
            "7" "[INSTALAR] Fortune (Frases Aleatorias)" \
            "8" "[ABRIR] Fortune (Frases Aleatorias)" \
            "9" "[INSTALAR] CBonsai (Arbolito Bonsái ASCII)" \
            "10" "[ABRIR] CBonsai (Arbolito Bonsái ASCII)" \
            "11" "[INSTALAR] Hollywood (Pantalla Hacker Película)" \
            "12" "[ABRIR] Hollywood (Pantalla Hacker Película)" \
            "13" "[INSTALAR] Nyan Cat (Gato Nyan en Terminal)" \
            "14" "[ABRIR] Nyan Cat (Gato Nyan en Terminal)" \
            "15" "[INSTALAR] Pipes (Animación de Tuberías)" \
            "16" "[ABRIR] Pipes (Animación de Tuberías)" \
            "17" "[INSTALAR] TTY-Clock (Reloj Digital Gigante)" \
            "18" "[ABRIR] TTY-Clock (Reloj Digital Gigante)" \
            "19" "[INSTALAR] Bastet (Juego de Tetris Difícil)" \
            "20" "[ABRIR] Bastet (Juego de Tetris Difícil)" \
            "21" "[INSTALAR] Pacman4console (Juego Pacman)" \
            "22" "[ABRIR] Pacman4console (Juego Pacman)" \
            "23" "[INSTALAR] Moon Buggy (Juego Conducir Luna)" \
            "24" "[ABRIR] Moon Buggy (Juego Conducir Luna)" \
            "25" "[INSTALAR] Greed (Estrategia Numérica)" \
            "26" "[ABRIR] Greed (Estrategia Numérica)" \
            "0" "<< Volver al Menú Principal" \
            3>&1 1>&2 2>&3)

        case $OPCION in
            1) instalar_paquete "sl" "sl" ;;
            2) ejecutar_programa "sl" sl ;;
            3) instalar_paquete "cmatrix" "cmatrix" ;;
            4) ejecutar_programa "cmatrix" cmatrix ;;
            5) instalar_paquete "cowsay" "cowsay" ;;
            6) ejecutar_programa "cowsay" cowsay Hola desde Lupintool ;;
            7) instalar_paquete "fortune" "fortune" ;;
            8) ejecutar_programa "fortune" fortune ;;
            9) instalar_paquete "cbonsai" "cbonsai" ;;
            10) ejecutar_programa "cbonsai" cbonsai -l ;;
            11) instalar_paquete "hollywood" "hollywood" ;;
            12) ejecutar_programa "hollywood" hollywood ;;
            13) instalar_paquete "nyancat" "nyancat" ;;
            14) ejecutar_programa "nyancat" nyancat ;;
            15) instalar_paquete "pipes.sh" "pipes" ;;
            16) ejecutar_programa "pipes.sh" pipes.sh ;;
            17) instalar_paquete "tty-clock" "tty-clock" ;;
            18) ejecutar_programa "tty-clock" tty-clock -c ;;
            19) instalar_paquete "bastet" "bastet" ;;
            20) ejecutar_programa "bastet" bastet ;;
            21) instalar_paquete "pacman4console" "pacman4console" ;;
            22) ejecutar_programa "pacman4console" pacman4console ;;
            23) instalar_paquete "moon-buggy" "moon-buggy" ;;
            24) ejecutar_programa "moon-buggy" moon-buggy ;;
            25) instalar_paquete "greed" "greed" ;;
            26) ejecutar_programa "greed" greed ;;
            0) break ;;
            *) break ;;
        esac
    done
}

# ==========================================
# MENÚ PRINCIPAL
# ==========================================
menu_principal() {
    while true; do
        CATEGORIA=$($DIALOG_CMD --title "=== LUPINTOOL CLI ===" \
            --menu "Elige una categoría con las FLECHAS / MOUSE y presiona ENTER:" 20 65 9 \
            "1" "Audio, Video y Multimedia" \
            "2" "Redes, Servidores y Web" \
            "3" "Utilidades y Sistema" \
            "4" "Programación y Desarrollo" \
            "5" "Hacking y Ciberseguridad" \
            "6" "Juegos y Efectos de Terminal" \
            "7" "Buscador Web (Buscar en Internet)" \
            "0" "Salir de Lupintool" \
            3>&1 1>&2 2>&3)

        case $CATEGORIA in
            1) menu_multimedia ;;
            2) menu_redes ;;
            3) menu_sistema ;;
            4) menu_programacion ;;
            5) menu_seguridad ;;
            6) menu_diversion ;;
            7) buscar_web ;;
            0) clear; echo "¡Gracias por usar Lupintool!"; exit 0 ;;
            *) exit 0 ;;
        esac
    done
}

menu_principal
