#!/bin/bash

# Dosyadan linkleri oku
readarray -t URLS < playlist.txt
STREAM_KEY=$1
RTMP_URL="rtmp://a.rtmp.youtube.com/live2/$STREAM_KEY"

while true; do
  for URL in "${URLS[@]}"; do
    echo "Oynatılıyor: $URL"
    
    # yt-dlp ile videonun ham linkini yakala
    VIDEO_RAW=$(yt-dlp -f "best[ext=mp4]" -g "$URL")
    
    # FFmpeg: Banner 120 saniyede bir 10 saniye görünür
    ffmpeg -re -i "$VIDEO_RAW" -i "reklam.png" \
    -filter_complex "[0:v][1:v]overlay=0:0:enable='lt(mod(t,120),10)'[out]" \
    -map "[out]" -map 0:a \
    -c:v libx264 -preset veryfast -b:v 3000k -maxrate 3000k -bufsize 6000k \
    -pix_fmt yuv420p -g 60 -c:a aac -b:a 128k -ar 44100 \
    -f flv "$RTMP_URL"
  done
done
