set -x
DEFAULT_AUDIO_SINK_ID=0
CURRENT_CHIME=`pacmd list-sink-inputs | grep -Pzo "index.*(\n.*)+.*media.name = \"door_chime\"" | awk '/index/ {print $2}'`
if [ -z "$CURRENT_CHIME" ]; then
    echo "Unmuting system"
    INPUTS=$(pacmd list-sink-inputs | grep 'index: ' | awk '{print $2}')
    for input in $INPUTS; do
        pacmd move-sink-input $input $DEFAULT_AUDIO_SINK_ID;
    done;
    pacmd set-default-sink $DEFAULT_AUDIO_SINK_ID
fi

