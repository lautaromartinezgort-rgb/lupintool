#!/bin/bash

# Colores estilo Windows 98 (Fondo Azul, Texto Blanco, Resaltado Amarillo)
W98_BG="\e[44m"
W98_FG="\e[37m"
W98_HL="\e[1;33m"
W98_TITLE="\e[1;37m"
RESET="\e[0m"

# Función para pausar
pausa() {
    echo -e "\n${W98_HL}Presione [ENTER] para volver al menú...${RESET}"
    read -r
}

# Función inteligente para descargar repositorios
instalar_repo() {
    echo -e "\n${W98_HL}>>> Descargando $1...${RESET}"
    git clone "$2"
    echo -e "${W98_FG}>>> ¡$1 descargado! Busca la carpeta con 'ls'.${RESET}"
    pausa
}

# Diccionario de comandos
glosario_comandos() {
    clear
    echo -e "${W98_BG}${W98_FG}"
    echo "+-----------------------------------------+"
    echo -e "|${W98_TITLE}     MANUAL DE COMANDOS DEL SISTEMA      ${W98_FG}|"
    echo "+-----------------------------------------+"
    echo " ls           Lista archivos."
    echo " cd [ruta]    Cambia de directorio."
    echo " rm -rf [d]   Borra carpeta y contenido."
    echo " chmod +x     Da permisos de ejecución."
    echo " dpkg -i      Instala un .deb local."
    echo " apt search   Busca en repositorios."
    echo " git clone    Descarga de GitHub."
    echo "+-----------------------------------------+"
    pausa
}

# Menú de Hack & Red (90 opciones en 2 columnas angostas)
menus_hacker() {
    while true; do
        clear
        echo -e "${W98_BG}${W98_FG}"
        echo "+-----------------------------------------+"
        echo -e "|${W98_TITLE}   GESTOR DE HACKING & RED (90 TOOLS)    ${W98_FG}|"
        echo "+-----------------------------------------+"
        echo " [1] Tool-X          [46] Wifite"
        echo " [2] Lazymux         [47] Aircrack-ng"
        echo " [3] fsociety        [48] Tshark"
        echo " [4] Onex            [49] Gobuster"
        echo " [5] Hacktronian     [50] Dirb"
        echo " [6] DarkFly-Tool    [51] Netcat"
        echo " [7] RED_HAWK        [52] Tcpdump"
        echo " [8] SQLMap          [53] Masscan"
        echo " [9] Zphisher        [54] Amass"
        echo " [10] Nmap           [55] Sublist3r"
        echo " [11] Metasploit     [56] TheHarvester"
        echo " [12] Routersploit   [57] Recon-ng"
        echo " [13] Seeker         [58] Tmux"
        echo " [14] HiddenEye      [59] Ranger"
        echo " [15] Shellphish     [60] MC"
        echo " [16] TBomb          [61] Wget"
        echo " [17] UserRecon      [62] Curl"
        echo " [18] OSIF           [63] SQLite3"
        echo " [19] Cupp           [64] Chroot"
        echo " [20] Hydra          [65] Radare2"
        echo " [21] Hashcat        [66] GDB"
        echo " [22] John           [67] Binutils"
        echo " [23] Nikto          [68] Strace"
        echo " [24] WPScan         [69] Ltrace"
        echo " [25] XSSer          [70] Python"
        echo " [26] D-TECT         [71] Ruby"
        echo " [27] AndroBugs      [72] Perl"
        echo " [28] Apktool        [73] NodeJS"
        echo " [29] TheFatRat      [74] PHP"
        echo " [30] Termux-Alpine  [75] Clang"
        echo " [31] Ubuntu-Termux  [76] Make"
        echo " [32] Nethunter      [77] CMake"
        echo " [33] Kali-Anonsurf  [78] Git"
        echo " [34] Macchanger     [79] Nano"
        echo " [35] Proxychains    [80] Vim"
        echo " [36] BlackEye       [81] Neovim"
        echo " [37] Weeman         [82] Zip"
        echo " [38] Ghost          [83] Unzip"
        echo " [39] Sherlock       [84] Tar"
        echo " [40] Xerosploit     [85] Unrar"
        echo " [41] SEToolkit      [86] SSH"
        echo " [42] Tor            [87] Rsync"
        echo " [43] Htop           [88] OpenSSL"
        echo " [44] Neofetch       [89] W3m"
        echo " [45] Cmatrix        [90] Lynx"
        echo ""
        echo -e " ${W98_HL}[0] VOLVER AL MENÚ PRINCIPAL${W98_FG}"
        echo "+-----------------------------------------+"
        echo -n -e "C:\> "
        read -r menu_opt

        case $menu_opt in
            1) instalar_repo "Tool-X" "https://github.com/Rajkumrdusad/Tool-X.git" ;;
            2) instalar_repo "Lazymux" "https://github.com/Gameye98/Lazymux.git" ;;
            3) instalar_repo "fsociety" "https://github.com/Manisso/fsociety.git" ;;
            4) instalar_repo "Onex" "https://github.com/rajkumardusad/onex.git" ;;
            5) instalar_repo "Hacktronian" "https://github.com/thehackingsage/hacktronian.git" ;;
            6) instalar_repo "DarkFly-Tool" "https://github.com/Ranginang67/DarkFly-Tool.git" ;;
            7) instalar_repo "RED_HAWK" "https://github.com/Tuhinshubhra/RED_HAWK.git" ;;
            8) apt install sqlmap -y; pausa ;;
            9) instalar_repo "Zphisher" "https://github.com/htr-tech/zphisher.git" ;;
            10) apt install nmap -y; pausa ;;
            11) apt install metasploit -y; pausa ;;
            12) instalar_repo "Routersploit" "https://github.com/threat9/routersploit.git" ;;
            13) instalar_repo "Seeker" "https://github.com/thewhiteh4t/seeker.git" ;;
            14) instalar_repo "HiddenEye" "https://github.com/DarkSecDevelopers/HiddenEye.git" ;;
            15) instalar_repo "Shellphish" "https://github.com/thelinuxchoice/shellphish.git" ;;
            16) instalar_repo "TBomb" "https://github.com/TheSpeedX/TBomb.git" ;;
            17) instalar_repo "UserRecon" "https://github.com/thelinuxchoice/userrecon.git" ;;
            18) instalar_repo "OSIF" "https://github.com/ciku370/OSIF.git" ;;
            19) instalar_repo "Cupp" "https://github.com/Mebus/cupp.git" ;;
            20) apt install hydra -y; pausa ;;
            21) apt install hashcat -y; pausa ;;
            22) apt install john -y; pausa ;;
            23) apt install nikto -y; pausa ;;
            24) apt install wpscan -y; pausa ;;
            25) apt install xsser -y; pausa ;;
            26) instalar_repo "D-TECT" "https://github.com/shawarkhanethicalhacker/D-TECT.git" ;;
            27) instalar_repo "AndroBugs" "https://github.com/AndroBugs/AndroBugs_Framework.git" ;;
            28) apt install apktool -y; pausa ;;
            29) instalar_repo "TheFatRat" "https://github.com/Screetsec/TheFatRat.git" ;;
            30) instalar_repo "Termux-Alpine" "https://github.com/Hax4us/TermuxAlpine.git" ;;
            31) instalar_repo "Ubuntu-in-Termux" "https://github.com/MFDGaming/ubuntu-in-termux.git" ;;
            32) instalar_repo "Nethunter" "https://github.com/Hax4us/Nethunter-In-Termux.git" ;;
            33) instalar_repo "Kali-Anonsurf" "https://github.com/UndeadSec/kali-anonsurf.git" ;;
            34) apt install macchanger -y; pausa ;;
            35) apt install proxychains-ng -y; pausa ;;
            36) instalar_repo "BlackEye" "https://github.com/thelinuxchoice/blackeye.git" ;;
            37) instalar_repo "Weeman" "https://github.com/evait-security/weeman.git" ;;
            38) instalar_repo "Ghost" "https://github.com/EntySec/Ghost.git" ;;
            39) instalar_repo "Sherlock" "https://github.com/sherlock-project/sherlock.git" ;;
            40) instalar_repo "Xerosploit" "https://github.com/LionSec/xerosploit.git" ;;
            41) instalar_repo "SEToolkit" "https://github.com/trustedsec/social-engineer-toolkit.git" ;;
            42) apt install tor -y; pausa ;;
            43) apt install htop -y; pausa ;;
            44) apt install neofetch -y; pausa ;;
            45) apt install cmatrix -y; pausa ;;
            46) apt install wifite -y; pausa ;;
            47) apt install aircrack-ng -y; pausa ;;
            48) apt install tshark -y; pausa ;;
            49) apt install gobuster -y; pausa ;;
            50) apt install dirb -y; pausa ;;
            51) apt install netcat -y; pausa ;;
            52) apt install tcpdump -y; pausa ;;
            53) apt install masscan -y; pausa ;;
            54) apt install amass -y; pausa ;;
            55) apt install sublist3r -y; pausa ;;
            56) apt install theharvester -y; pausa ;;
            57) apt install recon-ng -y; pausa ;;
            58) apt install tmux -y; pausa ;;
            59) apt install ranger -y; pausa ;;
            60) apt install mc -y; pausa ;;
            61) apt install wget -y; pausa ;;
            62) apt install curl -y; pausa ;;
            63) apt install sqlite -y; pausa ;;
            64) apt install chroot -y; pausa ;;
            65) apt install radare2 -y; pausa ;;
            66) apt install gdb -y; pausa ;;
            67) apt install binutils -y; pausa ;;
            68) apt install strace -y; pausa ;;
            69) apt install ltrace -y; pausa ;;
            70) apt install python -y; pausa ;;
            71) apt install ruby -y; pausa ;;
            72) apt install perl -y; pausa ;;
            73) apt install nodejs -y; pausa ;;
            74) apt install php -y; pausa ;;
            75) apt install clang -y; pausa ;;
            76) apt install make -y; pausa ;;
            77) apt install cmake -y; pausa ;;
            78) apt install git -y; pausa ;;
            79) apt install nano -y; pausa ;;
            80) apt install vim -y; pausa ;;
            81) apt install neovim -y; pausa ;;
            82) apt install zip -y; pausa ;;
            83) apt install unzip -y; pausa ;;
            84) apt install tar -y; pausa ;;
            85) apt install unrar -y; pausa ;;
            86) apt install openssh -y; pausa ;;
            87) apt install rsync -y; pausa ;;
            88) apt install openssl -y; pausa ;;
            89) apt install w3m -y; pausa ;;
            90) apt install lynx -y; pausa ;;
            0) break ;;
            *) echo -e "Opción inválida."; sleep 1 ;;
        esac
    done
}

# Menú de Juegos (45 opciones en 2 columnas angostas)
menu_juegos() {
    while true; do
        clear
        echo -e "${W98_BG}${W98_FG}"
        echo "+-----------------------------------------+"
        echo -e "|${W98_TITLE}       JUEGOS RETRO & ASCII (45)         ${W98_FG}|"
        echo "+-----------------------------------------+"
        echo " [1] nSnake          [24] Cataclysm"
        echo " [2] nInvaders       [25] Crawl"
        echo " [3] Pacman4Console  [26] Dopewars"
        echo " [4] Moon-Buggy      [27] Empire"
        echo " [5] GNU Chess       [28] Moria"
        echo " [6] Typespeed       [29] SlashEM"
        echo " [7] ASCII-Jump      [30] Tome"
        echo " [8] Nudoku          [31] Fortune"
        echo " [9] Bastet          [32] Cowsay"
        echo " [10] Nethack        [33] SL (Tren)"
        echo " [11] 2048-cli       [34] Figlet"
        echo " [12] Sudoku         [35] Toilet"
        echo " [13] Tty-Solitaire  [36] Cava"
        echo " [14] Vitetris       [37] Nyancat"
        echo " [15] Greed          [38] BB (Demo)"
        echo " [16] MyMan          [39] Pipes.sh"
        echo " [17] BSDGames       [40] CBonsai"
        echo " [18] Cavez of Phear [41] Asciiquarium"
        echo " [19] Ascii-Patrol   [42] Hollywood"
        echo " [20] Dwarf Fortress [43] TTY-Clock"
        echo " [21] Frotz          [44] Neo (Matrix)"
        echo " [22] Angband        [45] Cmatrix"
        echo " [23] Brogue"
        echo ""
        echo -e " ${W98_HL}[0] VOLVER AL MENÚ PRINCIPAL${W98_FG}"
        echo "+-----------------------------------------+"
        echo -n -e "C:\> "
        read -r game_opt

        case $game_opt in
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
            19) snap install ascii-patrol; pausa ;;
            20) apt install dwarffortress -y; pausa ;;
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
            36) apt install cava -y; pausa ;;
            37) apt install nyancat -y; pausa ;;
            38) apt install bb -y; pausa ;;
            39) apt install pipes-sh -y; pausa ;;
            40) apt install cbonsai -y; pausa ;;
            41) apt install asciiquarium -y; pausa ;;
            42) apt install hollywood -y; pausa ;;
            43) apt install tty-clock -y; pausa ;;
            44) apt install libaa-bin -y; pausa ;;
            45) apt install cmatrix -y; pausa ;;
            0) break ;;
            *) echo -e "Opción inválida."; sleep 1 ;;
        esac
    done
}

# Bucle principal del menú
while true; do
    echo -e "${W98_BG}${W98_FG}"
    clear
    echo "+-----------------------------------------+"
    echo -e "|${W98_TITLE}         L U P I N T O O L V 6.0         ${W98_FG}|"
    echo -e "|${W98_TITLE}           (Edición Windows 98)          ${W98_FG}|"
    echo "+-----------------------------------------+"
    echo "  [1] Gestor de Hacking & Red (90 Tools)   "
    echo "  [2] Catálogo de Juegos Retro (45 Items)  "
    echo "  [3] Manual de Comandos                 "
    echo -e "  ${W98_HL}[4] Salir a la Terminal${W98_FG}                "
    echo "+-----------------------------------------+"
    echo -n -e "C:\> "
    
    read -r main_opt

    case $main_opt in
        1) menus_hacker ;;
        2) menu_juegos ;;
        3) glosario_comandos ;;
        4) 
            echo -e "\n${W98_HL}Cerrando sesión de Lupintool...${RESET}\n"
            exit 0
            ;;
        *) 
            echo -e "\nComando erróneo. Intente nuevamente."
            sleep 1
            ;;
    esac
done
