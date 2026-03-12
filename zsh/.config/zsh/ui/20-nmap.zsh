# ======================
# Nmap Helper
# /zsh/.config/zsh/ui/nmap.zsh
# ======================

nscan() {
  local choice host

  choice=$(printf "Ping Sweep (Local Network)\nQuick Scan\nFull Scan\nOS Detection\nVuln Scan\nCustom\n" | \
    fzf --height=40% --reverse --border --prompt="Nmap > ")

  case "$choice" in

    "Ping Sweep (Local Network)")
      read "host?Network (example: 192.168.1.0/24): "
      nmap -sn "$host"
      ;;

    "Quick Scan")
      read "host?Target: "
      nmap -T4 -F "$host"
      ;;

    "Full Scan")
      read "host?Target: "
      sudo nmap -p- -T4 "$host"
      ;;

    "OS Detection")
      read "host?Target: "
      sudo nmap -A "$host"
      ;;

    "Vuln Scan")
      read "host?Target: "
      sudo nmap --script vuln "$host"
      ;;

    "Custom")
      read "host?Enter nmap arguments: "
      nmap $host
      ;;
  esac
}