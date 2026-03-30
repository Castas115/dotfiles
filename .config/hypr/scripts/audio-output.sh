#!/usr/bin/env bash
#
# Selects the audio output sink based on priority order.
# The first available (connected) sink wins.
#
# Usage:
#   audio-output.sh              # apply the highest-priority available sink
#   audio-output.sh --status     # print which sink would be selected

# --- Priority list (highest first) ---
# Each entry is a substring matched against the sink's node.description.
PRIORITY=(
  "Bose QC Ultra 2 Earbuds"
  "Headphones"
  "Speaker"
)

# --- Bluetooth devices (MAC addresses for reconnect) ---
declare -A BT_DEVICES=(
  ["Bose QC Ultra 2 Earbuds"]="E4:58:BC:8F:D1:AB"
)

notify() {
  notify-send -t 3000 -a "Audio Output" "$1"
}

get_sinks() {
  wpctl status | awk '
    /^Audio/      { in_audio=1; next }
    /^Video/      { in_audio=0 }
    in_audio && /Sinks:/ { in_sinks=1; next }
    in_sinks && /^[[:space:]]*[├└│].*:$/ { in_sinks=0; next }
    in_sinks && /^[[:space:]]*│[[:space:]]+[*]?[[:space:]]*[0-9]/ {
      line = $0
      # extract sink id
      match(line, /[0-9]+/)
      id = substr(line, RSTART, RLENGTH)
      # extract description (after the id and ". ")
      sub(/^[^0-9]*[0-9]+\. */, "", line)
      # trim trailing whitespace and volume info
      sub(/[[:space:]]*\[vol:.*/, "", line)
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", line)
      print id "\t" line
    }
  '
}

sink_in_error() {
  local sink_id="$1"
  wpctl inspect "$sink_id" 2>&1 | grep -q 'state: "error"'
}

bt_reconnect() {
  local mac="$1"
  notify "Bluetooth transport broken, reconnecting..."
  bluetoothctl disconnect "$mac" &>/dev/null
  sleep 2
  bluetoothctl connect "$mac" &>/dev/null
  sleep 3
}

select_sink() {
  local sinks
  sinks=$(get_sinks)

  for pattern in "${PRIORITY[@]}"; do
    local match
    match=$(echo "$sinks" | grep -i "$pattern" | head -1)
    if [[ -n "$match" ]]; then
      local id desc
      id=$(echo "$match" | cut -f1)
      desc=$(echo "$match" | cut -f2)
      echo "$id" "$desc"
      return 0
    fi
  done

  return 1
}

result=$(select_sink)

if [[ -z "$result" ]]; then
  notify "No matching sink found"
  exit 1
fi

sink_id=$(echo "$result" | cut -d' ' -f1)
sink_desc=$(echo "$result" | cut -d' ' -f2-)

if [[ "$1" == "--status" ]]; then
  notify "Would select: $sink_desc"
  exit 0
fi

# If the selected sink is a BT device in error state, reconnect and re-select
mac="${BT_DEVICES[$sink_desc]:-}"
if [[ -n "$mac" ]] && sink_in_error "$sink_id"; then
  bt_reconnect "$mac"
  # Re-select after reconnect (sink id may have changed)
  result=$(select_sink)
  if [[ -z "$result" ]]; then
    notify "No matching sink found after reconnect"
    exit 1
  fi
  sink_id=$(echo "$result" | cut -d' ' -f1)
  sink_desc=$(echo "$result" | cut -d' ' -f2-)
fi

wpctl set-default "$sink_id"
notify "Output: $sink_desc"
