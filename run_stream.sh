#!/bin/bash

# YouTube Yayın Anahtarı
STREAM_KEY=$1
RTMP_URL="rtmp://a.rtmp.youtube.com/live2/$STREAM_KEY"
BANNER_PATH="reklam.png"

# Linkler temizlendi: Güvenlik tokenları (st) kaldırıldı ve raw=1 yapıldı
URLS=(
  "https://www.dropbox.com/scl/fi/6e1zbol07nc2rczqih1qw/1.mp4?rlkey=lc632r4pe7f8zukk3u2szyb8o&raw=1"
  "https://www.dropbox.com/scl/fi/37m7kces06fpmf7sth9w1/2.mp4?rlkey=8jy8mjim6oaqnmivavtsgq1s0&raw=1"
  "https://www.dropbox.com/scl/fi/b435jh25b1gtd5q5cjjak/3.mp4?rlkey=m1sy3trneot5cw0qjujmmga2a&raw=1"
  "https://www.dropbox.com/scl/fi/eqm0hkcpw8jncseuv4cto/4.mp4?rlkey=r9d4co9rxow4rjv5jit1yt80a&raw=1"
)

while true; do
  for URL in "${URLS[@]}"; do
    echo "----------------------------------------"
    echo "SIGMA PHONK TV YAYINDA: $URL"
    echo "----------------------------------------"

    # FFmpeg: Başına 'www' koyarak raw=1 ile doğrudan veri akışı
    ffmpeg -re -i "$URL" -i "$BANNER_PATH" \
    -filter_complex "[0:v][1:v]overlay=0:0:enable='lt(mod(t,120),10)'[out]" \
    -map "[out]" -map 0:a \
    -c:v libx264 -preset veryfast -b:v 2500k -maxrate 2500k -bufsize 5000k \
    -pix_fmt yuv420p -g 60 -c:a aac -b:a 128k -ar 44100 \
    -f flv "$RTMP_URL"
    
    echo "Video bitti veya bağlantı koptu. 5 saniye sonra sıradakine geçiliyor..."
    sleep 5
  done
done
