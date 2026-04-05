#!/bin/bash

# YouTube Yayın Anahtarı
STREAM_KEY=$1
RTMP_URL="rtmp://a.rtmp.youtube.com/live2/$STREAM_KEY"
BANNER_PATH="reklam.png"

# LİNKLERİNİ BURAYA EKLE (Arada birer boşluk bırakarak)
URLS=("https://youtu.be/f_mGxEdvvLA?si=2MiVBeP0VVlxoOfF" "https://youtu.be/NY5DgRqfBCU?si=AYIsdqLB29DVbvIT")

while true; do
  for URL in "${URLS[@]}"; do
    echo "----------------------------------------"
    echo "SU AN YAYINLANAN: $URL"
    echo "----------------------------------------"
    
    # yt-dlp ile ham video linkini al
    VIDEO_RAW=$(yt-dlp -f "best[ext=mp4]/best" -g "$URL")

    # Eğer link boşsa hata ver ve bekle
    if [ -z "$VIDEO_RAW" ]; then
      echo "HATA: Link cekilemedi, 5 saniye sonra tekrar denenecek..."
      sleep 5
      continue
    fi

    # FFmpeg yayını başlat
    ffmpeg -re -i "$VIDEO_RAW" -i "$BANNER_PATH" \
    -filter_complex "[0:v][1:v]overlay=0:0:enable='lt(mod(t,120),10)'[out]" \
    -map "[out]" -map 0:a \
    -c:v libx264 -preset veryfast -b:v 2500k \
    -c:a aac -b:a 128k -ar 44100 \
    -f flv "$RTMP_URL"

    echo "Video bitti, siradaki videoya geciliyor..."
    sleep 2
  done
done
