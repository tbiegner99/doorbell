set -x 
MODULE_ID=`pacmd list-modules | grep -Pzo "index.*\n\s*name: <module-null-sink>" | awk '/index/ {print $2}'`
if [ -z "$MODULE_ID" ]; then
    MODULE_ID=`pactl load-module module-null-sink sink_name=Null`
fi
NULL_SINK_ID=`pacmd list-sinks | grep -Pzo "index.*\n\s*name: <Null>" | awk '/index/ {print $2}'`
pacmd set-default-sink $NULL_SINK_ID
INPUTS=$(pacmd list-sink-inputs | grep 'index: ' | awk '{print $2}')
for input in $INPUTS; do
    pacmd move-sink-input $input $NULL_SINK_ID;
done;
echo $MODULE_ID