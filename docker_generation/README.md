# RISC-V emulation and Docker creation

Here are the step-by-step instructions to generate a Docker image capable of running a QEMU RISC-V emulation:

1. Install Docker and the QEMU extension needed to work with the RISC-V set of instructions:
    ```sudo apt install docker.io qemu-system-riscv64```
2. Clone the Siemens repository with the RISC-V image: ```git clone https://github.com/siemens/isar-riscv.git ```
3. Build the RISC-V Siemens image: 
   1. ```cd isar-riscv```
   2. ```./kas-container build kas-qemu.yml```
4. At this point, it is already possible to execute the RISC-V emulation locally. For example, the following commands will execute a Hardware emulation with 1GB of RAM and 2GB of disk space:
```export IMAGE_NAME=base
qemu-system-riscv64 -m 1G -M virt -cpu rv64 \
    -netdev user,id=vnet,hostfwd=:127.0.0.1:12345-:22 -device virtio-net-pci,netdev=vnet \
    -drive file=build/tmp/deploy/images/qemuriscv64/isar-image-${IMAGE_NAME}-debian-sid-ports-qemuriscv64.ext4.img,if=none,format=raw,id=hd0 \
    -device virtio-blk-device,drive=hd0 \
    -device loader,file=build/tmp/deploy/images/qemuriscv64/fw_jump.elf,addr=0x80200000 \
    -kernel build/tmp/deploy/images/qemuriscv64/isar-image-${IMAGE_NAME}-debian-sid-ports-qemuriscv64-vmlinux \
    -initrd build/tmp/deploy/images/qemuriscv64/isar-image-${IMAGE_NAME}-debian-sid-ports-qemuriscv64-initrd.img \
    -append "console=ttyS0 root=/dev/vda rw" -nographic -snapshot
```
5. Some features of the emulation can be configured, such as the number of CPU cores or size memory of the emulated hardware. To explore this options visit the [QEMU documentation](https://www.qemu.org/docs/master/).
6. To dockenize this emulation we can replicate the same process on top of a Docker container using the Ubuntu Docker image as base:```docker pull ubuntu:latest```
7. Cloning the Dockerfile and 'installation' folder from this repository, we can build a Docker image with the dependencies needed to execute the QEMU image on top of it.
8. The Dockerfile will copy the contents of the folder '/isar-riscv', which should contain the QEMU RISC-V image: ```docker build --tag rebecca:isar_riscv_docker --force-rm .```
9. To run the Docker image and run the QEMU emulator on top of it use this commands:
    1. ```docker run -t -d --name rebecca_isar rebecca:isar_riscv_docker /bin/bash```
    2. ```docker exec -i -t rebecca_isar /bin/bash```
10. This will open a command window from where we can execute the QEMU emulation as if it where installed locally.