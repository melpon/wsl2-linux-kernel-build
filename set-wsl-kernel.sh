#!/bin/bash
# Usage: ./set-wsl-kernel.sh /mnt/c/Users/<User>/.wslconfig "C:\\Users\\<User>\\wsl-kernel\\bzImage"

set -e

if [ $# -ne 2 ]; then
  echo "Usage: $0 <path-to-.wslconfig> <kernel-path>"
  exit 1
fi

CONFIG_FILE="$1"
KERNEL_PATH="$2"

# バックスラッシュを二重にする（\ → \\）
KERNEL_PATH_ESC="${KERNEL_PATH//\\/\\\\}"
KERNEL_PATH_ESC_ESC="${KERNEL_PATH_ESC//\\/\\\\}"

# .wslconfig が存在しない場合は新規作成
if [ ! -f "$CONFIG_FILE" ]; then
  cat <<EOF > "$CONFIG_FILE"
[wsl2]
kernel=$KERNEL_PATH_ESC
EOF
  echo "Created new $CONFIG_FILE with kernel=$KERNEL_PATH"
  exit 0
fi

# [wsl2] セクションがあるか確認、なければ追加
if ! grep -q "^\[wsl2\]" "$CONFIG_FILE"; then
  {
    echo "[wsl2]"
    echo "kernel=$KERNEL_PATH"_ESC
  } >> "$CONFIG_FILE"
  echo "Added [wsl2] section with kernel=$KERNEL_PATH"
  exit 0
fi

# [wsl2] セクションに kernel= を追加
if grep -q "^kernel=" "$CONFIG_FILE"; then
  sed -i "s|^kernel=.*$|kernel=$KERNEL_PATH_ESC_ESC|" "$CONFIG_FILE"
  echo "Updated kernel= line in $CONFIG_FILE to $KERNEL_PATH"
else
  tmpfile=$(mktemp)
  while IFS= read -r line; do
    printf '%s\n' "$line" >> "$tmpfile"
    if [ "$line" = "[wsl2]" ]; then
      printf 'kernel=%s\n' "$KERNEL_PATH_ESC" >> "$tmpfile"
    fi
  done < "$CONFIG_FILE"
  mv "$tmpfile" "$CONFIG_FILE"
  echo "Added kernel=$KERNEL_PATH under [wsl2] section in $CONFIG_FILE"
fi
