# GLOBAL VARS

INSTALLROOT=/tmp/F30ARM64
ARCH=aarch64
FEDORAVER=30
PYTORCHVER=v1.2.0
CORES=4
TORCHVISIONVER=v0.4.0
DNS=10.0.3.10

# HOST

dnf install qemu-system-arm qemu-user-static virt-manager

dnf install --releasever=$FEDORAVER --installroot=$INSTALLROOT --forcearch=$ARCH \
	--repo=fedora --repo=updates systemd passwd dnf fedora-release vim-minimal \
	openblas-devel blas-devel m4 cmake python3-Cython python3-devel python3-yaml \
	python3-pillow python3-setuptools python3-numpy python3-cffi python3-wheel \
	gcc-c++ tar gcc git make tmux -y

# BIND /dev/urandom

mount -o bind /dev $INSTALLROOT/dev # from outside the chroot, we need urandom

# INSIDE CHROOT

cat << EOF | chroot $INSTALLROOT

cd /root

uname -a

echo 'nameserver $DNS' > /etc/resolv.conf

git clone https://github.com/pytorch/pytorch --recursive && cd pytorch
git checkout $PYTORCHVER
git submodule update --init --recursive

export NO_CUDA=1
export NO_DISTRIBUTED=1
export NO_MKLDNN=1 
export BUILD_TEST=0
export MAX_JOBS=$CORES

python3 setup.py bdist_wheel

cd /root

python3 -m pip install /root/pytorch/dist/*.whl

git clone https://github.com/pytorch/vision --recursive && cd vision
git checkout $TORCHVISIONVER
git submodule update --init --recursive
python3 setup.py bdist_wheel

EOF

cp $INSTALLROOT/root/pytorch/dist/*.whl .
cp $INSTALLROOT/root/vision/dist/*.whl .

# CLEANUP

umount $INSTALLROOT/dev
rm -rf $INSTALLROOT