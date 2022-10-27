# Things to do manually

## `apparmor`

Update `/etc/default/grub` with the following.

```
GRUB_CMDLINE_LINUX_DEFAULT="quiet udev.log_priority=3 apparmor=1 lsm=lockdown,yama,apparmor"
```

then run

```sh
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

## Burp Suite

Install plugins in `pkglist/burpsuite`.

## Firefox

Install `pref.js` from dotfiles
