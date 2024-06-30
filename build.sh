#!/bin/bash
echo "RM-DOS Buildscript v2"

mkdir build

echo "Building bootloader + disk image..."
nasm -O0 -w+orphan-labels -f bin -o build/disk.img src/bootloader/boot.asm

echo "Building kernel..."
nasm -O0 -w+orphan-labels -f bin -o build/kernel.sys src/kernel/kernel.asm || exit

echo "Building rmfs-insert..."
gcc -Wall -o build/rmfs-insert tools/rmfs-insert.c || exit
chmod +x build/rmfs-insert

echo "Inserting kernel..."
./build/rmfs-insert build/disk.img build/kernel.sys KERNEL.SYS || exit
./build/rmfs-insert build/disk.img tools/test.file TEST.FILE || exit

echo "Running..."
qemu-system-x86_64 -drive format=raw,if=floppy,file=build/disk.img -monitor stdio #-d in_asm
