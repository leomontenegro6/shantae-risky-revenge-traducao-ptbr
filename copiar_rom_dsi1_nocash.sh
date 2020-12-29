#!/bin/bash
mkdir -v zxc
sudo mount -v -o loop,offset=65536 "/media/Storage/Emulacao/Nintendo DS/Emuladores/No\$GBA (DSi)/DSI-1.SD" zxc/
sudo cp -v shantae2_tinke.nds zxc/roms/dsiware/shantae2_br.nds
sudo umount -v zxc
rmdir -v zxc
