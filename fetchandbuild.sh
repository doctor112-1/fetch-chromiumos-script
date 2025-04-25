mkdir -p ~/chromiumos
cd ~/chromiumos
repo init -u https://chromium.googlesource.com/chromiumos/manifest -b stable
repo sync -j8
BOARD=amd64-generic
echo $BOARD
cros build-packages --board=${BOARD}
cros build-image --board=${BOARD} --no-enable-rootfs-verification test
