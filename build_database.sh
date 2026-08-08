#!/bin/bash

sources="readline getc strlen itoa strcmp database"
cmd="ld -m elf_i386 "

for source in $sources; do
    eval "fasm $source.asm"
    cmd+="$source.o "
done

cmd+="-o database"
eval $cmd
