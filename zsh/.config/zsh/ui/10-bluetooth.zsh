# ======================
# Bluetooth Helper
# /zsh/.config/zsh/ui/bluetooth.zsh
# ======================

blue() {
  local state choice

  if systemctl is-active --quiet bluetooth; then
    state="ON"
  else
    state="OFF"
  fi

  choice=$(printf "Toggle (Current: %s)\nOn\nOff\nStatus\nScan Devices\nPaired Devices\n" "$state" | \
    fzf --height=40% --reverse --border --prompt="Bluetooth > ")

  case "$choice" in
    Toggle*)
      if systemctl is-active --quiet bluetooth; then
        sudo systemctl stop bluetooth && echo "Bluetooth OFF"
      else
        sudo systemctl start bluetooth && echo "Bluetooth ON"
      fi
      ;;

    On)
      sudo systemctl start bluetooth && echo "Bluetooth ON"
      ;;

    Off)
      sudo systemctl stop bluetooth && echo "Bluetooth OFF"
      ;;

    Status)
      systemctl status bluetooth --no-pager
      ;;

    "Scan Devices")
      sudo systemctl start bluetooth >/dev/null 2>&1
      echo "Scanning for devices (5 seconds)..."
      bluetoothctl --timeout 5 scan on >/dev/null 2>&1

      local device
      device=$(bluetoothctl devices | fzf --height=40% --reverse --border --prompt="Connect > ")

      if [[ -n "$device" ]]; then
        local mac
        mac=$(echo "$device" | awk '{print $2}')
        bluetoothctl connect "$mac"
      fi
      ;;

	"Paired Devices")
	  sudo systemctl start bluetooth >/dev/null 2>&1

	  local device
	  device=$(bluetoothctl devices Paired | \
	    fzf --height=40% --reverse --border --prompt="Paired > ")

	  if [[ -n "$device" ]]; then
	    local mac
	    mac=$(echo "$device" | awk '{print $2}')

	    local action
	    action=$(printf "Connect\nDisconnect\nRemove\n" | \
	      fzf --height=30% --reverse --border --prompt="Action > ")

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
