#!/bin/bash

set -e
cd "$(dirname $0)"

pushd WSL2-Linux-Kernel
  sudo rsync -a ./modules/lib/modules/$(make kernelrelease)/ /lib/modules/$(make kernelrelease)/
  sudo depmod -a
popd
