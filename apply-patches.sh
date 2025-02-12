#!/bin/bash

set -e

patches="$(readlink -f -- $1)"
tree="$2"

for project in $(cd $patches/patches/$tree; echo *); do
    p="$(tr _ / <<<$project |sed -e 's;platform/;;g')"
    [ "$p" == build ] && p=build/make
    [ "$p" == treble/app ] && p=treble_app
    [ "$p" == vendor/hardware/overlay ] && p=vendor/hardware_overlay
    pushd $p
    for patch in $patches/patches/$tree/$project/*.patch; do
        git am $patch || { echo -e "\e[31mFailed to apply patch: $patch\e[0m"; exit; }
    done
    popd &>/dev/null
done
