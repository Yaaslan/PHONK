#!/bin/bash

# YouTube Yayın Anahtarı (GitHub Secret'tan gelen)
STREAM_KEY=$1
RTMP_URL="rtmp://a.rtmp.youtube.com/live2/$STREAM_KEY"
BANNER_PATH="reklam.png"

# Sonsuz döngü başlat
while true; do
  # playlist.txt dosyasını satır satır tara
  while read -r raw_url; do
    # Linkin etrafındaki boşlukları ve gizli Windows karakterlerini temizle
    URL=$(echo "$raw_url" | tr -d '\r' | xargs)

    # Eğer satır boşsa veya içinde "http" yoksa atla
    if [[ -z "$URL" || "$URL" != http* ]]; then
      continue
    fi

    echo "Sistem Hazırlanıyor... Oynatılacak Link: $URL"
    
    # yt-dlp ile ham video linkini al
    VIDEO_RAW=$(yt-dlp -f "best[ext=mp4]/best" -g "$URL")

    # Eğer link boş döndüyse hata ver ve sıradakine geç
    if [ -z "$VIDEO_RAW" ]; then
      echo "HATA: Video linki alınamadı: $URL"
      continue
    fi

    echo "Yayın Başlatılıyor..."

    # FFmpeg yayını ateşler
    ffmpeg -re -i "$VIDEO_RAW" -i "$BANNER_PATH" \
    -filter_complex "[0:v][1:v]overlay=0:0:enable='lt(mod(t,120),10)'[out]" \
    -map "[out]" -map 0:a \
    -c:v libx264 -preset veryfast -b:v 2500k \
    -c:a aac -b:a 128k -ar 44100 \
    -f flv "$RTMP_URL"

    echo "Video Bitti, Sıradakine Geçiliyor..."
    sleep 2 # Geçişlerde 2 saniye bekleme

  done < playlist.txt
done

  done < playlist.txt
done
