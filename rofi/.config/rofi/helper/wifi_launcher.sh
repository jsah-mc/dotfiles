#!/usr/bin/env bash

# Paths
ROFI_CONFIG="$HOME/.config/rofi/helper/config.rasi"

# Helper: Show notification
notify() {
    notify-send "Wi-Fi" "$1"
}

# Get current status
connected_ssid=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)
wifi_enabled=$(nmcli radio wifi)

# --- Main Menu ---
menu_options="直  List Networks"
if [ "$wifi_enabled" = "enabled" ]; then
    menu_options+="\n睊  Disable Wi-Fi"
    if [ -n "$connected_ssid" ]; then
        menu_options+="\n直  Connected: $connected_ssid"
        menu_options+="\n睊  Disconnect from \"$connected_ssid\""
    fi
else
    menu_options+="\n直  Enable Wi-Fi"
fi

chosen_action=$(echo -e "$menu_options" | rofi -dmenu -i -p "Wi-Fi Control" -config "$ROFI_CONFIG")

case "$chosen_action" in
    *"List Networks"*)
        # --- Network Selection Menu ---
        wifi_list=$(nmcli -t -f "SECURITY,SSID" device wifi list | grep -v '^:' | sort -u -t: -k2)

        list=""
        while IFS=: read -r security ssid; do
            [ -z "$ssid" ] && continue
            [ "$ssid" = "$connected_ssid" ] && continue

            icon=" "
            [[ "$security" =~ "WPA" ]] && icon=" "
            list+="$icon $ssid\n"
        done <<< "$wifi_list"

        chosen_net=$(echo -e "$list" | rofi -dmenu -i -p "Select Network" -config "$ROFI_CONFIG")
        [ -z "$chosen_net" ] && exit

        ssid=$(echo "$chosen_net" | sed -E 's/^[] //g' | xargs)

        # Connect
        if nmcli -g NAME connection | grep -qx "$ssid"; then
            nmcli connection up id "$ssid" && notify "Connected to $ssid"
        else
            if [[ "$chosen_net" =~ "" ]]; then
                pass=$(rofi -dmenu -password -p "Password for $ssid: " -config "$ROFI_CONFIG")
                [ -z "$pass" ] && exit
                nmcli device wifi connect "$ssid" password "$pass" && notify "Connected to $ssid"
            else
                nmcli device wifi connect "$ssid" && notify "Connected to $ssid"
            fi
        fi
        ;;
    *"Enable Wi-Fi"*)
        nmcli radio wifi on && notify "Wi-Fi Enabled"
        ;;
    *"Disable Wi-Fi"*)
        nmcli radio wifi off && notify "Wi-Fi Disabled"
        ;;
    *"Disconnect from"*)
        nmcli device disconnect wlan0 && notify "Disconnected from $connected_ssid"
        ;;
    *)
        exit 0
        ;;
esac
