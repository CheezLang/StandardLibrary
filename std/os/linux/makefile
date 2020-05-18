# linux_fibers.o : linux_fibers.c
# 		clang -c linux_fibers.c

linux_fibers.o : linux_fibers.nasm
		nasm -felf64 -g ./linux_fibers.nasm

clean :
	rm linux_fibers.o
