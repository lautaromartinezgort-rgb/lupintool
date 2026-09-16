cat << 'EOF' > ~/Lupintool/lupintool.sh
#!/bin/bash

# ====================================================
# LUPINTOOL v5.0 - INFINITE DYNAMIC CLI ENGINE
# Acceso masivo a miles de herramientas por categoría
# ====================================================

if command -v pkg &> /dev/null; then
    PKG_MAN="pkg"
    INS_CMD="pkg install -y"
elif command -v apt &> /dev/null; then
    PKG_MAN="apt"
    INS_CMD="sudo apt install -y"
else
    PKG_MAN="unknown"
    INS_CMD="echo 'Gestor no soportado'"
fi

for dep in dialog python3 curl git; do
    if ! command -v $dep &> /dev/null; then
        $INS_CMD $dep
    fi
done

DIALOG_CMD="dialog --mouse --clear --shadow"

# ====================================================
# NAVEGADOR Y BUSCADOR DINÁMICO DE PAQUETES (+500)
# ====================================================
explorar_categoria_dinamica() {
    local CAT_NOMBRE="$1"
    local BUSQUEDA_KW="$2"

    clear
    echo "================================================="
    echo " Buscando paquetes para: $CAT_NOMBRE ($BUSQUEDA_KW)"
    echo "================================================="
    
    TMP_FILE=$(mktemp)

    if [ "$PKG_MAN" = "apt" ]; then
        apt-cache search "$BUSQUEDA_KW" | head -n 100 > "$TMP_FILE"
    elif [ "$PKG_MAN" = "pkg" ]; then
        pkg search "$BUSQUEDA_KW" | head -n 100 > "$TMP_FILE"
    else
        echo "No se puede realizar la búsqueda dinámica."
        rm -f "$TMP_FILE"
        return
    fi

    if [ ! -s "$TMP_FILE" ]; then
        $DIALOG_CMD --title "Error" --msgbox "No se encontraron paquetes para esta categoría." 8 50
        rm -f "$TMP_FILE"
        return
    fi

    OPCIONES=()
    i=1
    while IFS= read -r line; do
        PKG_NAME=$(echo "$line" | awk '{print $1}')
        PKG_DESC=$(echo "$line" | cut -d' ' -f2- | cut -c1-40)
        OPCIONES+=("$PKG_NAME" "$PKG_DESC")
        ((i++))
    done < "$TMP_FILE"

    SELECCION=$($DIALOG_CMD --title "Explorador Masivo - $CAT_NOMBRE" \
        --menu "Seleccioná un paquete para instalar/ejecutar:" 22 75 14 \
        "${OPCIONES[@]}" 3>&1 1>&2 2>&3)

    if [ -n "$SELECCION" ]; then
        clear
        echo "================================================="
        echo " Instalando / Ejecutando: $SELECCION"
        echo "================================================="
        $INS_CMD "$SELECCION"
        echo ""
        read -p "¿Intentar ejecutar '$SELECCION'? (s/n): " RESP
        if [[ "$RESP" =~ ^[Ss]$ ]]; then
            $SELECCION || echo "El comando no coincide exactamente con el nombre del paquete."
        fi
        read -p "Presioná Enter para regresar..."
    fi

    rm -f "$TMP_FILE"
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
    for ((y=0; y<ALTO; y++)); do
        for ((x=0; x<ANCHO; x++)); do CANVA["$x,$y"]=" "; done
    done

    while true; do
        local RENDER="\n"
        for ((y=0; y<ALTO; y++)); do
            RENDER+="  │"
            for ((x=0; x<ANCHO; x++)); do RENDER+="${CANVA["$x,$y"]}"; done
            RENDER+="│\n"
        done

        OPCION=$($DIALOG_CMD --title "Lupintool Paint [$PINCEL]" \
            --menu "Lienzo de Dibujo ASCII ($ANCHO x $ALTO):\n$RENDER" 22 65 6 \
            "1" "Pintar Punto (Coordenadas X Y)" \
            "2" "Cambiar Carácter de Pincel" \
            "3" "Borrador" \
            "4" "Guardar Dibujo ($ARCHIVO_DIBUJO)" \
            "0" "<< Volver" 3>&1 1>&2 2>&3)

        case $OPCION in
            1)
                COORD=$($DIALOG_CMD --title "Pintar" --inputbox "Ingresá Coordenadas X e Y (Ej: 5 3):" 10 50 3>&1 1>&2 2>&3)
                if [ -n "$COORD" ]; then
                    read -r px py <<< "$COORD"
                    [ -n "$px" ] && [ -n "$py" ] && CANVA["$px,$py"]="$PINCEL"
                fi
                ;;
            2)
                NUEVO_PINCEL=$($DIALOG_CMD --title "Pincel" --inputbox "Ingresá símbolo:" 9 40 3>&1 1>&2 2>&3)
                [ -n "$NUEVO_PINCEL" ] && PINCEL="${NUEVO_PINCEL:0:1}"
                ;;
            3) PINCEL=" " ;;
            4)
                echo "--- DIBUJO LUPINTOOL ---" > "$ARCHIVO_DIBUJO"
                for ((y=0; y<ALTO; y++)); do
                    LINEA=""
                    for ((x=0; x<ANCHO; x++)); do LINEA+="${CANVA["$x,$y"]}"; done
                    echo "$LINEA" >> "$ARCHIVO_DIBUJO"
                done
                $DIALOG_CMD --title "Guardado" --msgbox "Guardado en $ARCHIVO_DIBUJO" 7 40
                ;;
            0|*) break ;;
        esac
    done
}

# ====================================================
# MENÚ PRINCIPAL MASIVO
# ====================================================
while true; do
    CATEGORIA=$($DIALOG_CMD --title "=== LUPINTOOL v5.0 INFINITE ENGINE ===" \
        --menu "Seleccioná una categoría para buscar hasta 500+ herramientas:" 20 70 10 \
        "1" "🎮 Juegos CLI y Arcade (Explorar +500 juegos)" \
        "2" "✨ Efectos Visuales y Arte ASCII (Explorar +500 paquetes)" \
        "3" "🎵 Multimedia y Edición (Explorar +500 herramientas)" \
        "4" "🌐 Redes, Servidores y Web (Explorar +500 herramientas)" \
        "5" "💻 Sistema y Archivos (Explorar +500 herramientas)" \
        "6" "🛡️ Ciberseguridad y Hacking (Explorar +500 herramientas)" \
        "7" "🛠️ Mantenimiento y Utilidades (Explorar +500 paquetes)" \
        "8" "🎨 Paint CLI (Lienzo Interactivo)" \
        "0" "❌ Salir de Lupintool" \
        3>&1 1>&2 2>&3)

    case $CATEGORIA in
        1) explorar_categoria_dinamica "Juegos CLI" "game" ;;
        2) explorar_categoria_dinamica "Efectos Visuales" "ascii" ;;
        3) explorar_categoria_dinamica "Multimedia" "media" ;;
        4) explorar_categoria_dinamica "Redes y Web" "network" ;;
        5) explorar_categoria_dinamica "Sistema" "sys" ;;
        6) explorar_categoria_dinamica "Ciberseguridad" "security" ;;
        7) explorar_categoria_dinamica "Mantenimiento" "tool" ;;
        8) modo_paint ;;
        0|*) clear; echo "¡Gracias por usar Lupintool v5.0!"; exit 0 ;;
    esac
done
EOF
