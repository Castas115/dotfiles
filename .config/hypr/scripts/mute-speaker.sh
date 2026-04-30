#!/usr/bin/env bash
#
# Mute the built-in laptop speaker (sof-hda-dsp Speaker).
# Idempotent: runs at session start and on USB ethernet plug.

get_speaker_id() {
  wpctl status | awk '
    /^Audio/      { in_audio=1; next }
    /^Video/      { in_audio=0 }
    in_audio && /Sinks:/ { in_sinks=1; next }
    in_sinks && /^[[:space:]]*[├└│].*:$/ { in_sinks=0; next }
    in_sinks && /sof-hda-dsp Speaker/ {
      match($0, /[0-9]+/)
      print substr($0, RSTART, RLENGTH)
      exit
    }
  '
}

id=$(get_speaker_id)
[ -n "$id" ] && wpctl set-mute "$id" 1
