# wsl2-linux-kernel-build
自分の環境で WSL2 をビルドして使う用のリポジトリ

## 使い方

1. `.config` と `.kernel-config` を開いて好きなように設定する
2. `sudo apt install build-essential flex bison dwarves libssl-dev libelf-dev` を実行する
3. `./build.sh` を実行する
4. Windows のコマンドプロンプトや PowerShell 上で `wsl --shutdown` する
5. WSL を起動して再びこのディレクトリに戻ってから `./post-updated.sh` を実行する（要 sudo）
