# RM-DOS
Monolithic, real-mode OS written in Intel-syntax x86 assembly.

## What is RM-DOS?
RM-DOS is a small hobby operating system that I have been working on-and-off on since 2020. The long-term goal is to have it be completely 
self-hosting, but in present day it serves as a sandbox for me to play around in ASM.  
RM-DOS features a custom filesystem (RMFS) and a small handful of programs, but is not yet at the point of being usable for any task.

## Why real mode?
The default BIOS routines for interfacing with hardware are a godsend when you are first getting started. While protected mode would be 
a better choice all around, I am not yet an x86 assembly God so I will take what I can get in terms of pre-installed drivers.

## Short-term TODO?
- Finish FS driver, with functions to create, rename, delete, and edit files
- Text editor
