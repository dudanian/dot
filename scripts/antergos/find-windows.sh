# Add the Windows partition back to grub
sudo os-prober
sudo grub-mkconfig -o /boot/grub/grub.cfg
