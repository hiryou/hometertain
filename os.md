## OS Image

Download img.xz from [here](https://odroid.in). This instruction uses ubuntu 18.04 minimal (headless)

Obtain list of current mounting devices
```bash
diskutil list
```

Uncompress xz to img
```bash
$ xz -d /path/to/ubuntu-image.xz
# this will generate ubuntu-image.img
```

Plug eMMC module to eMMC reader, then eMMC reader to SSD card reader -> computer
diskutil check again to obtain the correct path to eMMC module
```bash
diskutil list
```

Now unmount eMMC path, and flash it
```bash
diskutil unmountdisk /dev/diskX
sudo dd of=/dev/diskX bs=1m if=/path/to/ubuntu-image.img
# waiting..
```

Once done, remember to unmount it
```bash
diskutil unmountdisk /dev/diskX
```

Now you can plug it to the droid/raspberry-pi. 
- If this is an xu3 board, plug ethernet cable via the USB 3.0 dongle
- Turn on the board. Default login is root/odroid.
