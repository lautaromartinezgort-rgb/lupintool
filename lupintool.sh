#!/bin/bash

# Colores y estilo "3D" Neón (Texto verde brillante sobre negro)
XT_BG="\e[40m"
XT_FG="\e[37m"
XT_GREEN="\e[1;32m" # Verde brillante
XT_BOLD="\e[1m"
RESET="\e[0m"

# Función para pausar
pausa() {
    echo -e "\n${XT_FG}Presione [ENTER] para volver al menú...${RESET}"
    read -r
}

# Función inteligente para descargar repositorios
instalar_repo() {
    echo -e "\n${XT_GREEN}>>> Descargando $1...${RESET}"
    git clone "$2"
    echo -e "${XT_FG}>>> ¡$1 descargado! Busca la carpeta con 'ls'.${RESET}"
    pausa
}

# Diccionario de comandos
glosario_comandos() {
    clear
    echo -e "${XT_BG}${XT_GREEN}"
    echo " ╔════════════════════════════════════════╗ "
    echo " ║     MANUAL DE COMANDOS DEL SISTEMA     ║ "
    echo " ╠════════════════════════════════════════╣ "
    echo -e " ║ ${XT_FG}ls${XT_GREEN}         Lista archivos.             ║ "
    echo -e " ║ ${XT_FG}cd [ruta]${XT_GREEN}  Cambia de directorio.       ║ "
    echo -e " ║ ${XT_FG}rm -rf [d]${XT_GREEN} Borra carpeta y contenido.  ║ "
    echo -e " ║ ${XT_FG}chmod +x${XT_GREEN}   Da permisos de ejecución.   ║ "
    echo -e " ║ ${XT_FG}dpkg -i${XT_GREEN}    Instala un .deb local.      ║ "
    echo -e " ║ ${XT_FG}apt search${XT_GREEN} Busca en repositorios.      ║ "
    echo -e " ║ ${XT_FG}git clone${XT_GREEN}  Descarga de GitHub.         ║ "
    echo " ╚════════════════════════════════════════╝ "
    pausa
}

# APARTADO 1: Solo Menús y Frameworks (30 opciones)
apartado_menus() {
    while true; do
        clear
        echo -e "${XT_BG}${XT_GREEN}"
        echo " ╔════════════════════════════════════════╗ "
        echo " ║    APARTADO DE MENÚS Y FRAMEWORKS      ║ "
        echo " ╠════════════════════════════════════════╣ "
        echo -e " ║ ${XT_FG}[1] Tool-X         [16] BlackEye       ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[2] Lazymux        [17] Weeman         ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[3] fsociety       [18] Ghost          ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[4] Onex           [19] Sherlock       ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[5] Hacktronian    [20] Xerosploit     ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[6] DarkFly-Tool   [21] SEToolkit      ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[7] RED_HAWK       [22] D-TECT         ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[8] Zphisher       [23] AndroBugs      ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[9] Routersploit   [24] TheFatRat      ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[10] Seeker        [25] Termux-Alpine  ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[11] HiddenEye     [26] Ubuntu-Termux  ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[12] Shellphish    [27] Nethunter      ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[13] TBomb         [28] Kali-Anonsurf  ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[14] UserRecon     [29] Metasploit     ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[15] OSIF          [30] Cupp           ${XT_GREEN}║ "
        echo " ╠════════════════════════════════════════╣ "
        echo -e " ║ ${XT_FG}[0] VOLVER AL MENÚ PRINCIPAL           ${XT_GREEN}║ "
        echo " ╚════════════════════════════════════════╝ "
        echo -e "${XT_FG}"
        echo -n "LUPINTOOL/MENUS> "
        read -r opt

        case $opt in
            1) instalar_repo "Tool-X" "https://github.com/Rajkumrdusad/Tool-X.git" ;;
            2) instalar_repo "Lazymux" "https://github.com/Gameye98/Lazymux.git" ;;
            3) instalar_repo "fsociety" "https://github.com/Manisso/fsociety.git" ;;
            4) instalar_repo "Onex" "https://github.com/rajkumardusad/onex.git" ;;
            5) instalar_repo "Hacktronian" "https://github.com/thehackingsage/hacktronian.git" ;;
            6) instalar_repo "DarkFly" "https://github.com/Ranginang67/DarkFly-Tool.git" ;;
            7) instalar_repo "RED_HAWK" "https://github.com/Tuhinshubhra/RED_HAWK.git" ;;
            8) instalar_repo "Zphisher" "https://github.com/htr-tech/zphisher.git" ;;
            9) instalar_repo "Routersploit" "https://github.com/threat9/routersploit.git" ;;
            10) instalar_repo "Seeker" "https://github.com/thewhiteh4t/seeker.git" ;;
            11) instalar_repo "HiddenEye" "https://github.com/DarkSecDevelopers/HiddenEye.git" ;;
            12) instalar_repo "Shellphish" "https://github.com/thelinuxchoice/shellphish.git" ;;
            13) instalar_repo "TBomb" "https://github.com/TheSpeedX/TBomb.git" ;;
            14) instalar_repo "UserRecon" "https://github.com/thelinuxchoice/userrecon.git" ;;
            15) instalar_repo "OSIF" "https://github.com/ciku370/OSIF.git" ;;
            16) instalar_repo "BlackEye" "https://github.com/thelinuxchoice/blackeye.git" ;;
            17) instalar_repo "Weeman" "https://github.com/evait-security/weeman.git" ;;
            18) instalar_repo "Ghost" "https://github.com/EntySec/Ghost.git" ;;
            19) instalar_repo "Sherlock" "https://github.com/sherlock-project/sherlock.git" ;;
            20) instalar_repo "Xerosploit" "https://github.com/LionSec/xerosploit.git" ;;
            21) instalar_repo "SEToolkit" "https://github.com/trustedsec/social-engineer-toolkit.git" ;;
            22) instalar_repo "D-TECT" "https://github.com/shawarkhanethicalhacker/D-TECT.git" ;;
            23) instalar_repo "AndroBugs" "https://github.com/AndroBugs/AndroBugs_Framework.git" ;;
            24) instalar_repo "TheFatRat" "https://github.com/Screetsec/TheFatRat.git" ;;
            25) instalar_repo "Termux-Alpine" "https://github.com/Hax4us/TermuxAlpine.git" ;;
            26) instalar_repo "Ubuntu-Termux" "https://github.com/MFDGaming/ubuntu-in-termux.git" ;;
            27) instalar_repo "Nethunter" "https://github.com/Hax4us/Nethunter-In-Termux.git" ;;
            28) instalar_repo "Kali-Anonsurf" "https://github.com/UndeadSec/kali-anonsurf.git" ;;
            29) apt install metasploit -y; pausa ;;
            30) instalar_repo "Cupp" "https://github.com/Mebus/cupp.git" ;;
            0) break ;;
            *) echo -e "Opción inválida."; sleep 1 ;;
        esac
    done
}

# APARTADO 2: Herramientas Individuales (40 opciones)
apartado_herramientas() {
    while true; do
        clear
        echo -e "${XT_BG}${XT_GREEN}"
        echo " ╔════════════════════════════════════════╗ "
        echo " ║    HERRAMIENTAS DE RED Y PAQUETES      ║ "
        echo " ╠════════════════════════════════════════╣ "
        echo -e " ║ ${XT_FG}[1] SQLMap         [21] Netcat         ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[2] Nmap           [22] Tcpdump        ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[3] Hydra          [23] Masscan        ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[4] Hashcat        [24] Amass          ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[5] John Ripper    [25] Sublist3r      ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[6] Nikto          [26] TheHarvester   ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[7] WPScan         [27] Recon-ng       ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[8] XSSer          [28] Tmux           ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[9] Apktool        [29] Ranger         ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[10] Macchanger    [30] MC (Midnight)  ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[11] Proxychains   [31] SQLite3        ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[12] Tor           [32] Chroot         ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[13] Htop          [33] Radare2        ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[14] Neofetch      [34] GDB            ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[15] Wifite        [35] Python         ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[16] Aircrack-ng   [36] NodeJS         ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[17] Tshark        [37] Clang          ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[18] Gobuster      [38] Git            ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[19] Dirb          [39] Wget / Curl    ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[20] OpenSSH       [40] Nano / Vim     ${XT_GREEN}║ "
        echo " ╠════════════════════════════════════════╣ "
        echo -e " ║ ${XT_FG}[0] VOLVER AL MENÚ PRINCIPAL           ${XT_GREEN}║ "
        echo " ╚════════════════════════════════════════╝ "
        echo -e "${XT_FG}"
        echo -n "LUPINTOOL/TOOLS> "
        read -r opt

        case $opt in
            1) apt install sqlmap -y; pausa ;;
            2) apt install nmap -y; pausa ;;
            3) apt install hydra -y; pausa ;;
            4) apt install hashcat -y; pausa ;;
            5) apt install john -y; pausa ;;
            6) apt install nikto -y; pausa ;;
            7) apt install wpscan -y; pausa ;;
            8) apt install xsser -y; pausa ;;
            9) apt install apktool -y; pausa ;;
            10) apt install macchanger -y; pausa ;;
            11) apt install proxychains-ng -y; pausa ;;
            12) apt install tor -y; pausa ;;
            13) apt install htop -y; pausa ;;
            14) apt install neofetch -y; pausa ;;
            15) apt install wifite -y; pausa ;;
            16) apt install aircrack-ng -y; pausa ;;
            17) apt install tshark -y; pausa ;;
            18) apt install gobuster -y; pausa ;;
            19) apt install dirb -y; pausa ;;
            20) apt install openssh -y; pausa ;;
            21) apt install netcat -y; pausa ;;
            22) apt install tcpdump -y; pausa ;;
            23) apt install masscan -y; pausa ;;
            24) apt install amass -y; pausa ;;
            25) apt install sublist3r -y; pausa ;;
            26) apt install theharvester -y; pausa ;;
            27) apt install recon-ng -y; pausa ;;
            28) apt install tmux -y; pausa ;;
            29) apt install ranger -y; pausa ;;
            30) apt install mc -y; pausa ;;
            31) apt install sqlite -y; pausa ;;
            32) apt install chroot -y; pausa ;;
            33) apt install radare2 -y; pausa ;;
            34) apt install gdb -y; pausa ;;
            35) apt install python -y; pausa ;;
            36) apt install nodejs -y; pausa ;;
            37) apt install clang -y; pausa ;;
            38) apt install git -y; pausa ;;
            39) apt install wget curl -y; pausa ;;
            40) apt install nano vim -y; pausa ;;
            0) break ;;
            *) echo -e "Opción inválida."; sleep 1 ;;
        esac
    done
}

# APARTADO 3: Juegos Retro (40 opciones)
apartado_juegos() {
    while true; do
        clear
        echo -e "${XT_BG}${XT_GREEN}"
        echo " ╔════════════════════════════════════════╗ "
        echo " ║     CATÁLOGO DE JUEGOS Y ARTE ASCII    ║ "
        echo " ╠════════════════════════════════════════╣ "
        echo -e " ║ ${XT_FG}[1] nSnake         [21] Frotz          ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[2] nInvaders      [22] Angband        ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[3] Pacman4Console [23] Brogue         ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[4] Moon-Buggy     [24] Cataclysm      ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[5] GNU Chess      [25] Crawl          ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[6] Typespeed      [26] Dopewars       ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[7] ASCII-Jump     [27] Empire         ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[8] Nudoku         [28] Moria          ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[9] Bastet         [29] SlashEM        ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[10] Nethack       [30] Tome           ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[11] 2048-cli      [31] Fortune        ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[12] Sudoku        [32] Cowsay         ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[13] Tty-Solitaire [33] SL (Tren)      ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[14] Vitetris      [34] Figlet         ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[15] Greed         [35] Toilet         ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[16] MyMan         [36] Nyancat        ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[17] BSDGames      [37] Pipes.sh       ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[18] Cavez Phear   [38] CBonsai        ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[19] Dwarf Fort.   [39] Asciiquarium   ${XT_GREEN}║ "
        echo -e " ║ ${XT_FG}[20] Cmatrix       [40] Hollywood      ${XT_GREEN}║ "
        echo " ╠════════════════════════════════════════╣ "
        echo -e " ║ ${XT_FG}[0] VOLVER AL MENÚ PRINCIPAL           ${XT_GREEN}║ "
        echo " ╚════════════════════════════════════════╝ "
        echo -e "${XT_FG}"
        echo -n "LUPINTOOL/JUEGOS> "
        read -r opt

        case $opt in
            1) apt install nsnake -y; pausa ;;
            2) apt install ninvaders -y; pausa ;;
            3) apt install pacman4console -y; pausa ;;
            4) apt install moon-buggy -y; pausa ;;
            5) apt install gnuchess -y; pausa ;;
            6) apt install typespeed -y; pausa ;;
            7) apt install asciijump -y; pausa ;;
            8) apt install nudoku -y; pausa ;;
            9) apt install bastet -y; pausa ;;
            10) apt install nethack-console -y; pausa ;;
            11) apt install 2048-cli -y; pausa ;;
            12) apt install sudoku -y; pausa ;;
            13) apt install ttysolitaire -y; pausa ;;
            14) apt install vitetris -y; pausa ;;
            15) apt install greed -y; pausa ;;
            16) apt install myman -y; pausa ;;
            17) apt install bsdgames -y; pausa ;;
            18) apt install cavez-of-phear -y; pausa ;;
            19) apt install dwarffortress -y; pausa ;;
            20) apt install cmatrix -y; pausa ;;
            21) apt install frotz -y; pausa ;;
            22) apt install angband -y; pausa ;;
            23) apt install brogue -y; pausa ;;
            24) apt install cataclysm-dda-curses -y; pausa ;;
            25) apt install crawl -y; pausa ;;
            26) apt install dopewars -y; pausa ;;
            27) apt install empire -y; pausa ;;
            28) apt install moria -y; pausa ;;
            29) apt install slashem -y; pausa ;;
            30) apt install tome -y; pausa ;;
            31) apt install fortune -y; pausa ;;
            32) apt install cowsay -y; pausa ;;
            33) apt install sl -y; pausa ;;
            34) apt install figlet -y; pausa ;;
            35) apt install toilet -y; pausa ;;
            36) apt install nyancat -y; pausa ;;
            37) apt install pipes-sh -y; pausa ;;
            38) apt install cbonsai -y; pausa ;;
            39) apt install asciiquarium -y; pausa ;;
            40) apt install hollywood -y; pausa ;;
            0) break ;;
            *) echo -e "Opción inválida."; sleep 1 ;;
        esac
    done
}

# Bucle principal del menú
while true; do
    clear
    echo -e "${XT_BG}${XT_GREEN}"
    echo " ╔════════════════════════════════════════╗ "
    echo " ║                                        ║ "
    echo -e " ║        ${XT_BOLD}L U P I N T O O L  V6.0${XT_GREEN}         ║ "
    echo " ║                                        ║ "
    echo " ╠════════════════════════════════════════╣ "
    echo " ║                                        ║ "
    echo -e " ║  ${XT_FG}[1] Gestor de Menús (30 Menús)${XT_GREEN}        ║ "
    echo -e " ║  ${XT_FG}[2] Herramientas Individuales (40)${XT_GREEN}    ║ "
    echo -e " ║  ${XT_FG}[3] Juegos Retro y ASCII (40)${XT_GREEN}         ║ "
    echo -e " ║  ${XT_FG}[4] Manual de Comandos${XT_GREEN}                ║ "
    echo -e " ║  ${XT_FG}[5] Salir a Termux${XT_GREEN}                    ║ "
    echo " ║                                        ║ "
    echo " ╚════════════════════════════════════════╝ "
    echo -e "${XT_FG}"
    echo -n "LUPINTOOL> "
    
    read -r main_opt

    case $main_opt in
        1) apartado_menus ;;
        2) apartado_herramientas ;;
        3) apartado_juegos ;;
        4) glosario_comandos ;;
        5) 
            echo -e "\n${XT_GREEN}Cerrando sesión de Lupintool...${RESET}\n"
            exit 0
            ;;
        *) 
            echo -e "\nComando erróneo. Intente nuevamente."
            sleep 1
            ;;
    esac
done
