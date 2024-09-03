# Things to do manually

## `apparmor` and `firejail`

1. Add `lsm=landlock,lockdown,yama,integrity,apparmor,bpf` to kernel parameters (check subsections)
2. Run `sudo aa-enforce firejail-default`
3. Copying `firejail` profiles: `sudo cp ./firejail_profiles/* /etc/firejail/`

### [Grub](https://wiki.archlinux.org/title/Kernel_parameters#GRUB)

Update `/etc/default/grub` with the following.

```
GRUB_CMDLINE_LINUX_DEFAULT="quiet udev.log_priority=3 apparmor=1 lsm=landlock,lockdown,yama,integrity,apparmor,bpf"
```

Then run

```sh
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### [systemd-boot](https://wiki.archlinux.org/title/Kernel_parameters#systemd-boot)

Choose a config in `/boot/loader/entries/*.conf` and add the parameters.

```
options (some_other_params) apparmor=1 lsm=landlock,lockdown,yama,integrity,apparmor,bpf"
```

## Burp Suite

Install plugins in `pkglist/burpsuite`.

## Firefox

Install `pref.js` from dotfiles
