# ======================
# Bluetooth Helper
# /zsh/.config/zsh/ui/bluetooth.zsh
# ======================

_ensure_bluetooth() {
  if ! systemctl is-active --quiet bluetooth; then
    sudo systemctl start bluetooth
    sleep 1  # Tunggu service up
  fi
}

blue() {
  local state choice

  if systemctl is-active --quiet bluetooth; then
    state="ON"
  else
    state="OFF"
  fi

  choice=$(printf "Toggle (Current: %s)\nOn\nOff\nStatus\nScan Devices\nPaired Devices\n" "$state" | \
    fzfui --prompt="Bluetooth > ")

  case "$choice" in
    Toggle*)
      if systemctl is-active --quiet bluetooth; then
        sudo systemctl stop bluetooth && echo "Bluetooth OFF"
      else
        _ensure_bluetooth && echo "Bluetooth ON"
      fi
      ;;

    On)
      _ensure_bluetooth && echo "Bluetooth ON"
      ;;

    Off)
      sudo systemctl stop bluetooth && echo "Bluetooth OFF"
      ;;

    Status)
      systemctl status bluetooth --no-pager
      ;;

    "Scan Devices")
      _ensure_bluetooth
      echo "Scanning for devices (5 seconds)..."
      bluetoothctl --timeout 5 scan on >/dev/null 2>&1

      local device
      device=$(bluetoothctl devices | fzfui --prompt="Connect > ")

      if [[ -n "$device" ]]; then
        local mac
        mac=$(echo "$device" | awk '{print $2}')
        bluetoothctl connect "$mac"
      fi
      ;;

    "Paired Devices")
      _ensure_bluetooth

      local device
      device=$(bluetoothctl devices Paired | \
        fzfui --prompt="Paired > ")

      if [[ -n "$device" ]]; then
        local mac
        mac=$(echo "$device" | awk '{print $2}')

        local action
        action=$(printf "Connect\nDisconnect\nRemove\n" | \
          fzfui --prompt="Action > ")

        case "$action" in
          Connect)
            bluetoothctl connect "$mac"
            ;;
          Disconnect)
            bluetoothctl disconnect "$mac"
            ;;
          Remove)
            bluetoothctl remove "$mac"
            ;;
        esac
      fi
      ;;
   esac
}