#!/bin/bash

# 事前に以下のコマンドを実行しておくこと
#
# sudo apt install build-essential flex bison dwarves libssl-dev libelf-dev

set -e

cd "$(dirname $0)"

source ./.config

NOW=$(date +%Y%m%d-%H%M%S)

rm -rf WSL2-Linux-Kernel
git clone --depth 1 --branch $KERNEL_VERSION https://github.com/microsoft/WSL2-Linux-Kernel.git

pushd WSL2-Linux-Kernel
  cp Microsoft/config-wsl .config

  source ../.kernel-config

  make olddefconfig

  make -j$(nproc)

  make modules_install INSTALL_MOD_PATH=./modules

  mkdir -p $(dirname $KERNEL_PREFIX_IN_WSL)
  cp arch/x86/boot/bzImage $KERNEL_PREFIX_IN_WSL-$NOW
popd

bash ./set-wsl-kernel.sh $WSLCONFIG_IN_WSL "$KERNEL_PREFIX_IN_WINDOWS-$NOW"

