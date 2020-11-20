#! /bin/bash
set -e

readNumber() {
    while true; do
        echo $1
        read $2
        if [[ ${!2} =~ ^[0-9]+$ ]]; then
            break;
        elif [[ -n "$3" ]]; then 
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
        elif [[ -n "$3" ]]; then 
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
        else 
            echo $'This must be Y or n'
        fi
    done
}

writeFile() {
    JSON_CONFIG=$2
    JSON_FILE=$1
    TMP_FILE="$1.tmp"
    if [[ -f "$JSON_FILE" ]]; then
        SCRIPT="console.log(JSON.stringify(Object.assign(require('${JSON_FILE}'),${JSON_CONFIG}),undefined,4))"
        node -e "$SCRIPT" > $TMP_FILE
        rm $JSON_FILE
        mv $TMP_FILE $JSON_FILE
    else 
        node -e "console.log(JSON.stringify(${JSON_CONFIG},undefined,4))" > $JSON_FILE
    fi
}

if [[ -f "./config.json" ]]; then
    readBoolean "A configuration exists. Would you like to override? (Y/n)" OVERRIDE
fi


if [[ "$OVERRIDE" == "n" ]]; then
    echo "Skipping configuration setup..."
    exit 0;
fi

readNumber $'Which GPIO pin is temperature sensor on?\n' GPIO_PIN

JSON_CONFIG="{
    \"gpioPin\": ${GPIO_PIN}
}"

OUTPUT_FILE=./config2.json

writeFile "$OUTPUT_FILE" "$JSON_CONFIG"

./setup-actions.sh


chmod 777 $OUTPUT_FILE