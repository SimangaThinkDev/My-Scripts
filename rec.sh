#!/bin/bash

OUT_DIR="$HOME/Videos"
mkdir -p "$OUT_DIR"

get_screen_size() {
    xdpyinfo | awk '/dimensions:/ {print $2}'
}

get_system_monitor() {
    # Get default sink
    SINK=$(pactl get-default-sink)

    # Get monitor device of that sink
    pactl list sources short | awk -v sink="$SINK" '$2 ~ sink".monitor" {print $2}'
}

get_microphone() {
    pactl get-default-source
}

while true; do
    read -p "Type \"start\" to begin recording (or \"quit\" to exit): " CMD

    if [ "$CMD" = "quit" ]; then
        echo "Exiting."
        exit 0
    fi

    if [ "$CMD" != "start" ]; then
        echo "Unknown command."
        continue
    fi

    TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
    OUTFILE="$OUT_DIR/recording-$TIMESTAMP.mkv"

    SCREEN_SIZE=$(get_screen_size)
    SYSTEM_MONITOR=$(get_system_monitor)
    MIC_DEVICE=$(get_microphone)

    if [ -z "$SYSTEM_MONITOR" ]; then
        echo "ERROR: Could not find system audio monitor device!"
        echo "Run: pactl list sources short"
        exit 1
    fi

    echo "Screen: $DISPLAY"
    echo "System Audio: $SYSTEM_MONITOR"
    echo "Microphone: $MIC_DEVICE"
    echo "Output file: $OUTFILE"
    echo "Starting recording..."

    ffmpeg \
        -video_size "$SCREEN_SIZE" -framerate 30 -f x11grab -i "$DISPLAY" \
        -f pulse -i "$SYSTEM_MONITOR" \
        -f pulse -i "$MIC_DEVICE" \
        -filter_complex "[1:a][2:a]amix=inputs=2:duration=longest:dropout_transition=3" \
        -c:v libx264 -preset ultrafast -crf 23 \
        "$OUTFILE" &

    FFPID=$!
    echo "Recording started. Type \"stop\" to stop."

    # Wait for "stop"
    while true; do
        read CMD2
        if [ "$CMD2" = "stop" ]; then
            echo "Stopping..."
            kill -INT "$FFPID"
            wait "$FFPID"
            echo "Saved to $OUTFILE"
            break
        else
            echo "Unknown command. Type \"stop\"."
        fi
    done
done

