#!/bin/sh
as main.asm -o main.o
as stdio.asm -o stdio.o
ld main.o stdio.o -o hw4