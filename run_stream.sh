#!/bin/bash

# YouTube Yayın Anahtarı (GitHub Secrets'tan otomatik gelir)
STREAM_KEY=$1
RTMP_URL="rtmp://a.rtmp.youtube.com/live2/$STREAM_KEY"
BANNER_PATH="reklam.png"

# Senin Dropbox Linklerin (dl=1 olarak güncellendi)
URLS=(
  "https://www.dropbox.com/scl/fi/eqm0hkcpw8jncseuv4cto/Video.Guru_20260405_013006229.mp4?rlkey=r9d4co9rxow4rjv5jit1yt80a&st=soxi4t4z&dl=1"
  "https://www.dropbox.com/scl/fi/b435jh25b1gtd5q5cjjak/Video.Guru_20260405_013503897.mp4?rlkey=m1sy3trneot5cw0qjujmmga2a&st=wqy6ixu4&dl=1"
  "https://www.dropbox.com/scl/fi/6e1zbol07nc2rczqih1qw/Video.Guru_20260405_165947566.mp4?rlkey=lc632r4pe7f8zukk3u2szyb8o&st=bh8ff08w&dl=1"
  "https://www.dropbox.com/scl/fi/37m7kces06fpmf7sth9w1/Video.Guru_20260405_165605915.mp4?rlkey=8jy8mjim6oaqnmivavtsgq1s0&st=028kzsti&dl=1"
)

while true; do
  for URL in "${URLS[@]}"; do
    echo "----------------------------------------"
    echo "SIGMA PHONK TV YAYINDA: $URL"
    echo "----------------------------------------"

    # FFmpeg: Dropbox üzerinden doğrudan akış
    # Banner her 2 dakikada bir 10 saniye görünür
    ffmpeg -re -i "$URL" -i "$BANNER_PATH" \
    -filter_complex "[0:v][1:v]overlay=0:0:enable='lt(mod(t,120),10)'[out]" \
    -map "[out]" -map 0:a \
    -c:v libx264 -preset veryfast -b:v 2500k -maxrate 2500k -bufsize 5000k \
    -pix_fmt yuv420p -g 60 -c:a aac -b:a 128k -ar 44100 \
    -f flv "$RTMP_URL"
    
    echo "Video döngüsü tamamlandı, sıradakine geçiliyor..."
    sleep 3
  done
done
