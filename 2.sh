apt -y purge "nvidia-*" "libnvidia-*"
apt -y --purge '^nvidia-*'
apt -y autoremove --purge
apt clean
apt update
apt -y install linux-headers-$(uname -r)
#apt install nvidia-driver firmware-misc-nonfree
#dpkg-reconfigure nvidia-driver
update-initramfs -u
