apt purge "nvidia-*" "libnvidia-*"
apt autoremove --purge
apt update
apt install linux-headers-$(uname -r)
apt install nvidia-driver firmware-misc-nonfree
dpkg-reconfigure nvidia-driver
update-initramfs -u
