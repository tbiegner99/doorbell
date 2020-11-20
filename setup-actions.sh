#! /bin/bash
set -e

readNumber() {
    while true; do
        echo $1
        read $2
        if [[ ${!2} =~ ^[0-9]+$ ]]; then
            break;
        elif [[ -z "${!2}" && -n "$3" ]]; then 
            printf -v $2 "$3" 
            break;
        else 
            echo $'This must be a number'
        fi
    done
}

readRequired() {
    while true; do
        echo $1
        read $2
        if [[ ${!2} =~ ^.+$ ]]; then
            break;
        elif [[ -z "${!2}" && -n "$3" ]]; then 
            printf -v $2 "$3" 
            break;
        else 
            echo $'This is required'
        fi
    done
}

readBoolean() {
    while true; do
        echo $1
        read $2
        if [[ ${!2} =~ ^(Y|n)$ ]]; then
            break;
        elif [[ -z "${!2}" && -n "$3" ]]; then 
            printf -v $2 "$3" 
            break;   
        else 
            echo $'This must be Y or n'
        fi
    done
}

readChimeConfig() {
    readRequired "Chime Sound file: " CHIME

    CONFIG="{
        \"type\": \"chime\",
        \"sound\": \"${CHIME}\",
        \"mute\": true
    }"

    printf -v $1 "$CONFIG"
}

readLogConfig() {
    readRequired "Message: " MESSAGE

    CONFIG="{
        \"type\": \"log\",
        \"message\": \"${MESSAGE}\"
    }"

    printf -v $1 "$CONFIG"
}


readActionConfig() {
    echo $1
    echo "Enter a doorbell action:"
    echo "1. Chime - splays a sound through the speaker."
    echo "2. Log - outputs a message to console"
    echo "3. Done"
    while true; do
        readNumber "Enter Choice (1-4): " CHOICE
        if ((CHOICE >= 1 && CHOICE <= 4)); then
            break;
        fi
        echo "Number out of range."
    done;
    
    case $CHOICE in
        1)
            readChimeConfig $2
            ;;
        2) 
            readLogConfig $2
            ;;
        3)
            printf -v $2 ""
    esac
}

if [[ ! -f "./config.json" ]]; then
    echo "No config exists. run setup-config.sh first";
    exit 1 
fi
ACTIONS=""
while true; do
    readActionConfig "Configure actions" ACTION
    echo $ACTION
    if [ -z "$ACTION" ]; then
        break;
    fi

    if [ ! -z "$ACTIONS" ]; then
        ACTIONS="$ACTIONS, ";
    fi
    ACTIONS="$ACTIONS $ACTION"
done

OUTPUT_FILE="./config.json"

JSON_CONFIG="{
    \"actions\": [$ACTIONS]
}"


if [[ -f "./$OUTPUT_FILE" ]]; then
    node -e "console.log(JSON.stringify(Object.assign(require('$OUTPUT_FILE'),${JSON_CONFIG}),undefined,4))" > "$OUTPUT_FILE.tmp"
    rm $OUTPUT_FILE
    mv "$OUTPUT_FILE.tmp" $OUTPUT_FILE
fi

chmod 777 $OUTPUT_FILE