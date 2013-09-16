# == Definition: ramdisk
#
# Configure ramdisk
#
# === Parameters
#
# $mounted  (u)mount the ramdisk
#
# $path     Path to mount the ramdisk
#
# $fstype   Filesystem type of ramdisk : tmpfs or ramfs
#
# $atboot   Mount fs at boot
#
# $size     Ramdisk size
#
# $mode     Ramdisk file mode
#
# $owner    Ramdisk owner
#
# $group    Ramdisk group owner
#
# === Examples
#
# ramdisk { 'php_sessions':
#   ensure  => present,
#   path    => '/var/lib/php5',
#   atboot  => true,
#   size    => '256M',
#   mode    => '1733',
#   owner   => 'root',
#   group   => 'root',
# }
#
# === Authors
#
# Benjamin Dos Santos <benjamin.dossantos@gmail.com>
#
define ramdisk(
  $ensure = 'present',
  $mount = 'mounted',
  $path = '/tmp/ramdisk',
  $fstype = 'tmpfs',
  $options = 'UNSET',
  $atboot = true,
  $size = '64M',
  $mode = '1777',
  $owner = 'root',
  $group = 'root'
) {
  if $::kernelmajversion <= 2.4 {
    fail('Unsuported kernel version')
  }

  if $ensure == 'present' {
    $file_ensure  = 'directory'
    $mount_ensure = 'mounted'
  } else {
    $file_ensure  = 'absent'
    $mount_ensure = 'absent'
  }

  $options_real = $options ? {
    'UNSET' => "size=${size},mode=${mode},uid=${owner},gid=${group}",
    default => $options,
  }

  file { $path:
    ensure  => $file_ensure,
    mode    => $mode,
    owner   => $owner,
    group   => $group,
  } ->

  mount { $path:
    ensure  => $mount_ensure,
    device  => 'tmpfs',
    fstype  => $fstype,
    options => $options_real,
    atboot  => $atboot,
  }
}