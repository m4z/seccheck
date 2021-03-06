#!/bin/sh
####
#
# SuSE daily security check v2.0 by Marc Heuse <marc@suse.de>
#
# most code was ripped from the OpenBSD /etc/security script ;-)
#
####
#
# TODO: maybe directory writable checks for jobs run in crontab
#
MY_DIR=$(dirname $(readlink -f $0))
. $MY_DIR/basic.inc

. $MY_DIR/helper.inc
. $MY_DIR/security_daily_helper.inc
. $MY_DIR/user_group_password_helper.inc

set_tmpdir "security-daily.sh"

trap 'rm -rf $TMPDIR; exit 1' 0 1 2 3 13 15
LOG="$TMPDIR/security.log"
ERR="$TMPDIR/security.err"
OUT="$TMPDIR/security.out"
TMP1="$TMPDIR/security.tmp1"
TMP2="$TMPDIR/security.tmp2"

# /etc/passwd check
check_passwd

# /etc/shadow check
check_shadow

# /etc/group checking
check_group

# checking root's login scrips for secure path and umask
check_root_login_scripts

# Misc. file checks
# root/uucp/bin/daemon etc. should be in /etc/ftpusers.
check_ftpusers

# executables should not be in the /etc/aliases file.
no_exec_in_etcaliases 

# Files that should not have + signs.
check_no_plus

# .rhosts check
check_rhosts

# Check home directories.  Directories should not be owned by someone else
# or writeable.
check_home_directories_owners

# Files that should not be owned by someone else or writeable.
check_special_files_owner

# Mailboxes should be owned by user and unreadable.
check_mailboxes_owned_by_user_and_unreadable

# File systems should not be globally exported.
check_for_globally_exported_fs

# check remote and local devices
check_promisc

# list loaded modules
list_loaded_kernel_modules

# nfs mounts with missing nosuid
nfs_mounted_with_missing_nosuid

# display programs with bound sockets
display_programs_with_bound_sockets

# ASLR should be enabled per default. it randomizes the heap, stack and load addresses of dynamically linked
#libraries.
check_ASLR_enabled

# to avoid kernel internal address to be leaked via log files
# kernel internal address are useful for exploit writers
check_leak_kernel_internal_addresses

# check xinetd running services
check_xinetd_services

# check systemd running services
check_systemd_services

# check changes on sysctl
check_sysctl

# check if sysctl security options are set
check_specifics_sysctl 
####
#
# Cleaning up
#
rm -rf "$TMPDIR"
exit 0
# END OF SCRIPT
