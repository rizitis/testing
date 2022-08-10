# -------------------------------------------------------------------------
# Live OS Post Install routine.
# This is where you can override the default post-installation routine
# by (re-)defining the function "live_post_install()".
# -------------------------------------------------------------------------

# The example below is an extension to what the setup2hd script does.
# By default, setup2hd will only copy a few customizations from the Live OS
# to the hard drive.  Things that do *not* get installed are (among others):
# - the 'live' user plus homedirectory
# - the runlevel (Slackware Live starts in runlevel 4)
# - sudo and su configuration
# These *are* copied in the example below.

live_post_install () {
  # Re-use some of the custom configuration from 0099-@DISTRO@_zzzconf-*.sxz
  # (some of these may not be present but the command will not fail):
  dialog --title "POST-INSTALL @UDISTRO@ LIVE (@LIVEDE@) DATA" --infobox \
   "\nCopying Live modifications to hard disk ..." 5 65
  # Do not overwrite a custom keymap:
  if [ ! -f $T_PX/etc/rc.d/rc.keymap ]; then
    unsquashfs -f -dest $T_PX \
      /mnt/livemedia/@LIVEMAIN@/system/0099*zzzconf*.sxz \
      /etc/rc.d/rc.keymap
  fi
  unsquashfs -f -dest $T_PX \
    /mnt/livemedia/@LIVEMAIN@/system/0099*zzzconf*.sxz \
    /etc/X11/xdm/liveslak-xdm \
    /etc/X11/xorg.conf.d/30-keyboard.conf \
    /etc/group \
    /etc/hardwareclock \
    /etc/inittab \
    /etc/localtime* \
    /etc/passwd \
    /etc/profile.d/lang.sh \
    /etc/rc.d/rc.font \
    /etc/rc.d/rc.gpm \
    /etc/shadow \
    /etc/skel \
    /etc/slackpkg \
    /etc/suauth \
    /etc/sudoers \
    /etc/vconsole.conf \
    /home/live
  # Point xdm to the custom /etc/X11/xdm/liveslak-xdm/xdm-config:
  sed -i ${T_PX}/etc/rc.d/rc.4 -e 's,bin/xdm -nodaemon,& -config /etc/X11/xdm/liveslak-xdm/xdm-config,'
  # Remove the marker file from the filesystem root:
  rm -f ${T_PX}/@MARKER@

  cat << EOF > $TMP/tempmsg

 @CDISTRO@ Live Edition (@LIVEDE@) has been installed to your hard drive!
 We installed the ${ACT_MODS} active modules.
 After rebooting, your installed computer will look exactly like the Live OS.

EOF
  dialog --title "POST INSTALL HINTS AND TIPS" --msgbox "`cat $TMP/tempmsg`" \
    18 65
  rm $TMP/tempmsg

  # Setting MAINSELECT to "CONFIGURE" will call the usual Slackware
  # setup scripts next (timeconfig, netconfig, mouseconfig etc...).
  # If you want to skip all that and do your own config instead,
  # add it right below these lines and then set MAINSELECT to
  # "EXIT" instead of "CONFIGURE".

  # ... one thing you must NOT FORGET TO DO is:
  #printf "%-16s %-16s %-11s %-16s %-3s %s\n" "#/dev/cdrom" "/mnt/cdrom" "auto" "noauto,owner,ro,comment=x-gvfs-show" "0" "0" >> $T_PX/etc/fstab
  #printf "%-16s %-16s %-11s %-16s %-3s %s\n" "/dev/fd0" "/mnt/floppy" "auto" "noauto,owner" "0" "0" >> $T_PX/etc/fstab
  #printf "%-16s %-16s %-11s %-16s %-3s %s\n" "devpts" "/dev/pts" "devpts" "gid=5,mode=620" "0" "0" >> $T_PX/etc/fstab
  #printf "%-16s %-16s %-11s %-16s %-3s %s\n" "proc" "/proc" "proc" "defaults" "0" "0" >> $T_PX/etc/fstab
  #printf "%-16s %-16s %-11s %-16s %-3s %s\n" "tmpfs" "/dev/shm" "tmpfs" "defaults" "0" "0" >> $T_PX/etc/fstab

  # Remember, change to "EXIT" if you want to skip Slackware's post-config!
  MAINSELECT="CONFIGURE"

} # END live_post_install()

