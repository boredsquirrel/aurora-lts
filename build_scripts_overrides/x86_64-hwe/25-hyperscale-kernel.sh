#!/usr/bin/env bash

set -xeuo pipefail

dnf versionlock delete \
    kernel \
    kernel-devel \
    kernel-devel-matched \
    kernel-core \
    kernel-modules \
    kernel-modules-core \
    kernel-modules-extra \
    kernel-uki-virt

dnf update -y \
    --enablerepo="centos-hyperscale" \
    --enablerepo="centos-hyperscale-kernel" \
    kernel

dnf versionlock add \
    kernel \
    kernel-devel \
    kernel-devel-matched \
    kernel-core \
    kernel-modules \
    kernel-modules-core \
    kernel-modules-extra \
    kernel-uki-virt

# Only necessary when not building with Nvidia
KERNEL_SUFFIX=""
QUALIFIED_KERNEL="$(rpm -qa | grep -P 'kernel-(|'"$KERNEL_SUFFIX"'-)(\d+\.\d+\.\d+)' | sed -E 's/kernel-(|'"$KERNEL_SUFFIX"'-)//')"
/usr/bin/dracut --no-hostonly --kver "$QUALIFIED_KERNEL" --reproducible --zstd -v -f
