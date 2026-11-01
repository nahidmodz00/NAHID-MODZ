#!/data/data/com.termux/files/usr/bin/bash

G='\033[1;32m'
C='\033[1;36m'
Y='\033[1;33m'
R='\033[1;31m'
W='\033[1;37m'
N='\033[0m'

PASSFILE="$HOME/.nahid_password"

# First-time password setup
if [ ! -f "$PASSFILE" ]; then
    clear
    echo -e "${G}"
toilet -f big "NAHID • MODZ"
    echo -e "${C}FIRST TIME SETUP${N}"
    read -r -p "Create Your Password: " pass1
    echo
    read -r -p "Confirm Password: " pass2
    echo

    if [ -z "$pass1" ] || [ "$pass1" != "$pass2" ]; then
        echo -e "${R}Password mismatch!${N}"
        exit 1
    fi

    printf '%s' "$pass1" | sha256sum | cut -d ' ' -f1 > "$PASSFILE"
    chmod 600 "$PASSFILE"
    echo -e "${G}Password Created Successfully!${N}"
    sleep 1
fi

# Login screen
clear
echo -e "${G}"
toilet -f big "NAHID MODZ"
echo -e "${C}================================"
echo -e "        SECURE LOGIN SYSTEM"
echo -e "================================${N}"

stored=$(cat "$PASSFILE")
authenticated=false

for attempt in 1 2 3; do
    read -r -p "ENTER PASSWORD: " entered
    echo
    check=$(printf '%s' "$entered" | sha256sum | cut -d ' ' -f1)

    if [ "$check" = "$stored" ]; then
        authenticated=true
        break
    else
        echo -e "${R}WRONG PASSWORD! ATTEMPT $attempt/3${N}"
    fi
done

if [ "$authenticated" != true ]; then
    echo -e "${R}ACCESS DENIED!${N}"
    exit 1
fi

echo -e "${G}ACCESS GRANTED!${N}"
sleep 1

# Visual-only demo loading animation
show_loading() {
    local label="$1"
    local action="$2"
    local i
    echo
    echo -e "${C}${action} ${label}...${N}"
    for i in 0 20 40 60 80 100; do
        printf "\r${G}["
        local filled=$((i / 5))
        printf '%*s' "$filled" '' | tr ' ' '#'
        printf '%*s' "$((20 - filled))" '' | tr ' ' '-'
        printf "] ${Y}%3d%%${N}" "$i"
        sleep 0.35
    done
    echo
    if [ "$action" = "ACTIVATING" ]; then
        echo -e "${G}✓ ${label} ACTIVATED!${N}"
    else
        echo -e "${Y}✓ ${label} DEACTIVATED!${N}"
    fi
    sleep 1
}

names=(
"DEVICE INFO"
"AIM BOT"
"AIM SILENT"
"AIM FOV"
"DRAG HS"
"BODY HS"
"HOLOGRAM"
"INVISIBLE GLUE WALL"
"FAST SWITCH (AWM)"
)

states=(OFF OFF OFF OFF OFF OFF OFF OFF OFF)

while true; do
    clear
    echo -e "${G}"
    toilet -f big "NAHID MODZ"
    echo -e "${C}================================"
    echo -e "       ADVANCED CONTROL PANEL"
    echo -e "================================${N}"

    for i in {0..8}; do
        num=$((i+1))
        if [ "${states[$i]}" = "ON" ]; then
            status="${G}[ON]${N}"
        else
            status="${R}[OFF]${N}"
        fi

        printf "${Y}%02d${N}  %-24s %b\n" \
        "$num" "${names[$i]}" "$status"
    done

    echo -e "${C}--------------------------------"
    echo -e "${Y}[X]${N} DISABLE ALL FEATURES"
    echo -e "${Y}[Q]${N} EXIT MENU"
    echo -e "${C}================================${N}"
    echo -ne "${G}NAHID MODZ > ${N}"

    read -r choice

    case "${choice^^}" in
        [1-9])
            idx=$((choice-1))

            if [ "$idx" -eq 0 ]; then
                clear
                echo -e "${G}DEVICE INFORMATION${N}"
                echo -e "------------------------"
                echo -e "Model: $(getprop ro.product.model)"
                echo -e "Brand: $(getprop ro.product.brand)"
                echo -e "Android: $(getprop ro.build.version.release)"
                echo -e "Kernel: $(uname -r)"
                echo -e "Architecture: $(uname -m)"
                echo
                read -p "Press ENTER to return..."
            else
                if [ "${states[$idx]}" = "OFF" ]; then
                    show_loading "${names[$idx]}" "ACTIVATING"
                    states[$idx]="ON"
                else
                    show_loading "${names[$idx]}" "DEACTIVATING"
                    states[$idx]="OFF"
                fi
            fi
            ;;
        X)
            show_loading "ALL FEATURES" "DEACTIVATING"
            for i in {0..8}; do
                states[$i]="OFF"
            done
            echo -e "${G}✓ ALL FEATURES DEACTIVATED!${N}"
            sleep 1
            ;;
        Q)
            clear
            echo -e "${G}THANK YOU FOR USING NAHID MODZ!${N}"
            exit 0
            ;;
        *)
            echo -e "${R}INVALID COMMAND!${N}"
            sleep 1
            ;;
    esac
done
