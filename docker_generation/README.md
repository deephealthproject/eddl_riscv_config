# 1. Docker creation with ISAR RISC-V emulation

Here are the step-by-step instructions to generate a Docker image capable of running the QEMU ISAR RISC-V emulation:

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

# 2. Docker creation with open source RISC-V

Next are the steps needed to generate a Docker image capable of running the open source RISC-V emulation available in [https://people.debian.org/~gio/dqib/](https://people.debian.org/~gio/dqib/):
1. Download the RISC-V image: https://gitlab.com/api/v4/projects/giomasce%2Fdqib/jobs/artifacts/master/download?job=convert_riscv64-virt
2. Extract the contents of the file 'artifacts.zip'
3. This image is already build and can be executed immediately. The file readme.txt extracted from the zip folder will contain the command needed to execute the emulation:
```
    qemu-system-riscv64 -machine virt \
     -cpu rv64 \
     -smp 4 \
     -m 4G \
     -device virtio-blk-device,drive=hd \
     -drive file=image.qcow2,if=none,id=hd \
     -device virtio-net-device,netdev=net \
     -netdev user,id=net,hostfwd=tcp::2222-:22 \
     -bios /usr/lib/riscv64-linux-gnu/opensbi/generic/fw_jump.elf \
     -kernel /usr/lib/u-boot/qemu-riscv64_smode/uboot.elf \
     -object rng-random,filename=/dev/urandom,id=rng \
     -device virtio-rng-device,rng=rng \
     -nographic -append "root=LABEL=rootfs console=ttyS0"
```
4. Same as with the set-up for the ISAR image, we can build a Docker image based on Ubuntu and transfer the files use to execute the emulation.