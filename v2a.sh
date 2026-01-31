#!/bin/bash
# Video-To-Anything (v2a)
# 一個樸實無華的影片轉檔工具

if [ -z "$1" ]; then
  echo "Usage: ./v2a.sh <input_file> [gif|webm]"
  exit 1
fi

INPUT="$1"
FORMAT="${2:-gif}"
BASENAME="${INPUT%.*}"

if [ "$FORMAT" == "gif" ]; then
  echo "🎬 Converting $INPUT to GIF..."
  # 使用 ffmpeg 生成高品質 GIF 調色板
  ffmpeg -y -i "$INPUT" -vf fps=10,scale=320:-1:flags=lanczos,palettegen palette.png
  ffmpeg -y -i "$INPUT" -i palette.png -filter_complex "fps=10,scale=320:-1:flags=lanczos[x];[x][1:v]paletteuse" "${BASENAME}.gif"
  rm palette.png
  echo "✅ Done: ${BASENAME}.gif"
elif [ "$FORMAT" == "webm" ]; then
  echo "🎬 Converting $INPUT to WebM..."
  ffmpeg -y -i "$INPUT" -c:v libvpx-vp9 -crf 30 -b:v 0 -b:a 128k -c:a libopus "${BASENAME}.webm"
  echo "✅ Done: ${BASENAME}.webm"
else
  echo "❌ Unsupported format. Use 'gif' or 'webm'."
  exit 1
fi
