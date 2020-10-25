#!/bin/bash
if test "`whoami`" != "root"; then
	echo "Please run as root."
	exit
fi

if [ ! -e images/bismuth.flp ]
then
	mkdosfs -C images/bismuth.flp 1440 || exit
fi

nasm -O0 -w+orphan-labels -f bin -o src/bootloader/boot.bin src/bootloader/boot.asm || exit
dd status=noxfer conv=notrunc if=src/bootloader/boot.bin of=images/bismuth.flp || exit

function recurse_compile {
	echo "Compiling directory $1..."
	cd $1
	for filename in *; do
		if [ ! -f "$filename" ]; then
			recurse_compile $filename
		else
			if [ ${filename: -4} == ".zyr" ]; then
				echo "Compiling file $filename into ${filename%.zyr}.asm..."
				zephyr $filename ${filename%.zyr}.asm
			fi
		fi

	done
	cd ..
}

echo "Compiling Zephyr files..."
recurse_compile src

nasm -O0 -w+orphan-labels -f bin -o src/kernel/kernel.bin src/kernel/kernel.asm || exit

rm -rf tmp-loop
mkdir tmp-loop
mount -o loop -t vfat images/bismuth.flp tmp-loop
cp src/kernel/kernel.bin tmp-loop
sync
sleep 0.2
umount tmp-loop || exit
rm -rf tmp-loop

qemu-system-x86_64 -fda images/bismuth.flp
