#!/bin/bash

STREAM_KEY=$1
RTMP_URL="rtmp://a.rtmp.youtube.com/live2/$STREAM_KEY"
BANNER_PATH="reklam.png"

# Sonsuz döngü
while true; do
  # playlist.txt içindeki her satırı temizleyerek oku
  while IFS= read -r line || [[ -n "$line" ]]; do
    # Satır sonundaki gizli karakterleri (\r) temizle ve boşlukları at
    URL=$(echo "$line" | tr -d '\r' | xargs)

    # Eğer satır boşsa atla
    if [ -z "$URL" ]; then
      continue
    fi

    echo "Oynatılıyor: $URL"
    
    # yt-dlp ile linki al
    VIDEO_RAW=$(yt-dlp -f "best[ext=mp4]" -g "$URL")

    # Eğer video linki alınamadıysa sıradakine geç
    if [ -z "$VIDEO_RAW" ]; then
      echo "Hata: Video linki alınamadı, atlanıyor."
      continue
    fi

    # FFmpeg yayını başlat
    ffmpeg -re -i "$VIDEO_RAW" -i "$BANNER_PATH" \
    -filter_complex "[0:v][1:v]overlay=0:0:enable='lt(mod(t,120),10)'[out]" \
    -map "[out]" -map 0:a \
    -c:v libx264 -preset veryfast -b:v 2500k \
    -c:a aac -b:a 128k -ar 44100 \
    -f flv "$RTMP_URL"

  done < playlist.txt
done
