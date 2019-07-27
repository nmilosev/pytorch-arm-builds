# pytorch-arm-builds

Unofficial ARMv6, ARMv7 and Aarch64 builds of pytorch and torchvision. Can be used on Raspberry Pi 0, 1, 2, 3, 4, Android phones etc.

# FAQ

### 1. Build process?
Build process is described here in great detail: https://nmilosev.svbtle.com/compling-arm-stuff-without-an-arm-board-build-pytorch-for-the-raspberry-pi

These are built on Fedora x86_64 system with a qemu-static chroot buildsystem. All details in the blog post.

Builds for armv6 are done on a Raspberry Pi Zero WH (Raspbian).

### 2. Dependencies
The only dependency for the python package of torch is numpy, and I suggest using your distro's package manager to download a binary version rather than compiling it yourself.

Some other dependencies are also needed, like openblas, libgom, pillow etc. The Python interpreter will warn you upon import what you are missing.

Fedora dependencies can be installed with:

```
sudo dnf install openblas-devel blas-devel m4 cmake python3-Cython python3-devel python3-yaml python3-setuptools python3-numpy python3-cffi python3-wheel 
```

Raspbian dependencies can be installed with:

```
sudo apt install libopenblas-dev libblas-dev m4 cmake cython python3-dev python3-yaml python3-setuptools python3-wheel python3-pillow python3-numpy

```

### 3. Testing
A small ShuffleNet inference test is in this repo and I would love if you are using these packages to report back on performance!

It can be ran with a simple:

```
python3 inference.py tiger.jpg # or other picture
```

after the torch and torchvision packages have been installed. It will do inference 10 times so you can report back to me your average time. Thanks!

PyTorch version| torchvision version  | Device | Time |
|--|--|--|--|
| 1.1.0 | 0.30 | i5-4500U (x86_64) | 0.076s |
| 1.1.0 | 0.30 | Pi2 (ARMv7) | 3.56s |
| 1.1.0 | 0.30 | LG G6 (AArch64) | 0.481s |
| 1.1.0 | 0.30 | Pi0WH (ARMv6) - Raspbian build | 4.654s |

### 4. Python 2.x/3.4/3.5/3.6 builds?

I only build with the latest Python 3 version in my Fedora build system (current: F30 -> 3.7.3) but you can modify my build process and build with other Python versions easily.

### 5. ARMv6 (Pi Zero) builds?

Sadly, Fedora stopped the support for ARMv6 a while back so I cannot use the same process to build for Pi Zero. Check other project if you need inference (e.g. ONNX Runtime). If you happen to have a build for ARMv6 I would love to have it!

**Update**: You can now have ARMv6 builds! :) These are built a little bit differently (no numpy support for now, coming soon). 

### 6. Keeping up with the upstream

I will try to publish new builds within 72h of new release announcements. If you see an outdated build open an issue.

### 7. Build options

There are for small devices only, so no CUDA, no DISTRIBUTED etc.:

```
export NO_CUDA=1
export NO_DISTRIBUTED=1
export NO_MKLDNN=1 
export BUILD_TEST=0
export MAX_JOBS=8
```

### 8. Older versions

Look through the commit history! This repository was started in July 2019.

# Remarks

I provide no support for these builds, but feel free to ping me if something is broken. I am not to be held responsible if you burn something or fall down the stairs while using these.
