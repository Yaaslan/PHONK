#!/bin/bash

# YouTube Yayın Anahtarı (GitHub Secrets'tan otomatik gelir)
STREAM_KEY=$1
RTMP_URL="rtmp://a.rtmp.youtube.com/live2/$STREAM_KEY"
BANNER_PATH="reklam.png"

# Catbox.moe Linkleri (Doğrudan Video Bağlantıları)
URLS=(
  "https://files.catbox.moe/kipxm5.mp4"
  "https://files.catbox.moe/gvf9yw.mp4"
  "https://files.catbox.moe/q7un9k.mp4"
  "https://files.catbox.moe/lkzkkk.mp4"
)

while true; do
  for URL in "${URLS[@]}"; do
    echo "----------------------------------------"
    echo "SIGMA PHONK TV CANLI YAYINDA: $URL"
    echo "----------------------------------------"

    # FFmpeg: Doğrudan Catbox linkinden akış
    # Banner her 2 dakikada bir 10 saniye görünür
    ffmpeg -re -i "$URL" -i "$BANNER_PATH" \
    -filter_complex "[0:v][1:v]overlay=0:0:enable='lt(mod(t,120),10)'[out]" \
    -map "[out]" -map 0:a \
    -c:v libx264 -preset veryfast -b:v 2500k -maxrate 2500k -bufsize 5000k \
    -pix_fmt yuv420p -g 60 -c:a aac -b:a 128k -ar 44100 \
    -f flv "$RTMP_URL"
    
    echo "Video bitti, sıradaki videoya geçiliyor..."
    sleep 3
  done
done
