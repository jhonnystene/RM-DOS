#!/bin/bash
nasm -O0 -w+orphan-labels -f bin -o images/disk.img src/bootloader/boot.asm
