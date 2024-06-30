#!/bin/bash
echo "RM-DOS Buildscript v2"

echo "Building bootloader + disk image..."
chmod +x create-boot-disk.sh
./create-boot-disk.sh

echo "Building kernel..."
nasm -O0 -w+orphan-labels -f bin -o src/kernel/kernel.bin src/kernel/kernel.asm || exit

echo "Building rmfs-insert..."
gcc -Wall -o rmfs-insert rmfs-insert.c
chmod +x rmfs-insert

echo "Inserting kernel..."
./rmfs-insert images/disk.img src/kernel/kernel.bin KERNEL.SYS
./rmfs-insert images/disk.img src/kernel/kernel.asm TEST.FILE

echo "Running..."
qemu-system-x86_64 -drive format=raw,if=floppy,file=images/disk.img -monitor stdio #-d in_asm
