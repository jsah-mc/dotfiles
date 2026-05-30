#!/usr/bin/env bash

# Paths
ROFI_CONFIG="$HOME/.config/rofi/helper/config.rasi"

# Helper: Show notification
notify() {
    notify-send "Bluetooth" "$1"
}

# Check Bluetooth power status
power=$(bluetoothctl show | grep "Powered: yes" > /dev/null && echo "on" || echo "off")

# --- Main Menu ---
menu_options=""
if [ "$power" = "on" ]; then
    menu_options="  Disable Bluetooth"
    menu_options+="\n  List Devices"

    # Get currently connected device
    connected_device=$(bluetoothctl info | grep "Name:" | head -n 1 | cut -d' ' -f2-)
    if [ -n "$connected_device" ]; then
        menu_options+="\n  Connected: $connected_device"
        menu_options+="\n  Disconnect \"$connected_device\""
    fi
else
    menu_options="  Enable Bluetooth"
fi

chosen_action=$(echo -e "$menu_options" | rofi -dmenu -i -p "Bluetooth Control" -config "$ROFI_CONFIG")

case "$chosen_action" in
    *"List Devices"*)
        # --- Device Selection Menu ---
        # Get list of devices (MAC Address and Name)
        devices=$(bluetoothctl devices | awk '{print $2, $3, $4, $5, $6}')

        list=""
        while read -r mac name; do
            [ -z "$mac" ] && continue
            list+="$name ($mac)\n"
        done <<< "$devices"

        chosen_dev=$(echo -e "$list" | rofi -dmenu -i -p "Select Device" -config "$ROFI_CONFIG")
        [ -z "$chosen_dev" ] && exit

        # Extract MAC Address (last part in parens)
        mac=$(echo "$chosen_dev" | grep -oE '([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})')

        # Connect
        bluetoothctl connect "$mac" && notify "Connected to $name" || notify "Failed to connect"
        ;;
    *"Enable Bluetooth"*)
        rfkill unblock bluetooth
        bluetoothctl power on && notify "Bluetooth Enabled"
        ;;
    *"Disable Bluetooth"*)
        bluetoothctl power off && notify "Bluetooth Disabled"
        ;;
    *"Disconnect"*)
        bluetoothctl disconnect && notify "Disconnected"
        ;;
    *)
        exit 0
        ;;
esac
