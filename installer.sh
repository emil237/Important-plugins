#!/usr/bin/bash
#

# colors
Color_Off="\e[0m" # Text Reset
Red="\e[0;31m"    # Red
Yellow="\e[0;33m" # Yellow
Blue='\e[0;34m'   # Blue
Green='\e[0;32m'  # Green

###########################################
# Configure where we can find things here #
pyVersion=$(python -c"from sys import version_info; print(version_info[0])")
SitUrl='https://raw.githubusercontent.com/emil237/Important-plugins/main'
TmpDir='/var/volatile/tmp'

####################
#  Depends Checking  #
arrVar=("ffmpeg" "gstplayer" "exteplayer3" "enigma2-plugin-systemplugins-serviceapp")

if [ "${pyVersion}" = 3 ]; then
    arrVar+=("python3-core" "python3-futures3" "python3-image" "python3-json" "python3-multiprocessing" "python3-pillow" "python3-requests" "python3-cryptography")
else
    arrVar+=("python-core" "python-futures" "python-image" "python-imaging" "python-json" "python-multiprocessing" "python-requests" "python-cryptography")
fi
for PkgFile in "${arrVar[@]}"; do
    if ! grep -qs "Package: $PkgFile" '/var/lib/opkg/status'; then
        echo -e ">>>>   Please Wait Install ${Green}${PkgFile}${Color_Off}   <<<<"
        echo
        opkg install "${PkgFile}"
        wait
        sleep 0.8
        clear
    fi
done

if [ "$(opkg info libcrypto-compat | grep -Fic Package)" = 1 ]; then
    LibPkg="libcrypto-compat"
else
    LibPkg="libcrypto-compat-1.0.0"
fi
####################################
# Build
if [ -z "$Pkg" ]; then
    clear
    echo -e "> ${Red}Nova Store${Color_Off}"
    echo
    echo "  1 - Cccam"
    echo "  2 - Ncam"
    echo "  3 - Oscam"
    echo "  4 - Raedquicksignal"
    echo "  5 - Arabicsavior"
    echo "  6 - Ajpanel"
    echo "  7 - Dreamsatpanel"
    echo "  8 - Keyadder"
    echo
    echo "  x - Exit"
    echo
    echo "- Enter option:"

    read -r choice
    case $choice in
    "1") Pkg=enigma2-plugin-softcams-cccam-all-images ;;
    "2") Pkg=enigma2-plugin-softcams-ncam ;;
    "3") Pkg=enigma2-softcams-oscam-all-images ;;
    "4") Pkg=enigma2-plugin-extensions-raedquicksignal ;;
    "5") Pkg=enigma2-plugin-extensions-arabicsavior ;;
    "6") Pkg=enigma2-plugin-extensions-ajpanel ;;
    "7") Pkg=enigma2-plugin-extensins-dreamsatpanel ;;
    "8") Pkg=enigma2-plugin-extensions-keyadder ;;
    x)
        clear
        echo
        echo -e "${Blue}Goodbye ;)${Color_Off}"
        echo
        ;;
    *)
####################

IFS='-'
read -ra PkgName <<<"${Pkg}"

rm -rf $TmpDir/"${Pkg:?}"* >/dev/null 2>&1

if [ "$(opkg list-installed "$Pkg" | awk '{ print $3 }')" = "$VerPkg" ]; then
    echo " You are use the laste Version: $VerPkg"

    echo ""
    echo "******************************************************"
    echo "**                                                    "
    echo "**    ${PkgName[3]} : ${VerPkg}                       "
    echo -e "**   Edit Script by  : ${Yellow}Emil_Nabil${Color_Off} "
    echo "**                                                    "
    echo "******************************************************"
    echo ""

    sleep 2
    exit 1
elif [ -z "$(opkg list-installed "$Pkg" | awk '{ print $3 }')" ]; then
    echo
    clear
else
    opkg remove --force-depends "$Pkg"
fi

echo -e "${Yellow}Downloading ${PkgName[3]} plugin Please Wait ......${Color_Off}"
wget --no-check-certificate $SitUrl/"${Pkg}"_"${VerPkg}"_all.ipk -qP $TmpDir

echo -e "${Yellow}Insallling ${PkgName[3]} plugin Please Wait ......${Color_Off}"
opkg install --force-overwrite $TmpDir/"${Pkg}"_"${VerPkg}"_all.ipk

rm -rf $TmpDir/"${Pkg:?}"* >/dev/null 2>&1

if [ "$choice" = 7 ] || [ "$choice" = 8 ]; then
    if [ "$(opkg list-installed | grep -Fic ${LibPkg})" = 0 ]; then
        opkg install ${LibPkg}
    fi
fi

sleep 0.8
sync
echo ""
echo ""
echo "******************************************************"
echo "**                                                    "
echo "**    ${PkgName[3]} : ${VerPkg}                       "
echo -e "**   Edit Script by  : ${Yellow}Emil_Nabil${Color_Off} "
echo "**                                                    "
echo "******************************************************"
echo ""
echo ""

sleep 2
echo -e "${Yellow}" "Device will restart now" "${Color_Off}"

wait
exit 0
