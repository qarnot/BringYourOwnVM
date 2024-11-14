#!/bin/bash


# In the env:
#       SSH_USER: must be provided and not empty
#       SSH_PASSWORD: can be empty, but it's not recommended. Won't be used if a URI for the public key is provided
#       SSH_AUTHORIZED_KEYS_URI: an URI where we can get public keys for SSH_USER


#TODO:
#     - some logging, if possible with a mount from the host ? Or curl -XPOST to the http ? Dunno
#     - some way to report failures right ahead instead of waiting for a timeout


my_dir="$(dirname "$0")"
source "$my_dir/utils.sh"


# Setup users

if [ -z "$SSH_USER" ]; then
    log "No ssh user provided, ssh will not be available"
    exit 5
fi

grep -q "$SSH_USER" /etc/passwd
ret=$?
if [ $ret -ne 0 ]; then
    # FIXME: We could create it, maybe later...
    log "User $SSH_USER does not exist, cannot proceed"
    exit 6
fi

ssh_home="$(grep $SSH_USER /etc/passwd | cut -d':' -f6)"
mkdir -p "$ssh_home/.ssh"

if [ ! -z "$SSH_AUTHORIZED_KEYS_URI" ]; then
    curl -s "$SSH_AUTHORIZED_KEYS_URI" >>"$ssh_home/.ssh/authorized_keys" 2>>${LOG_FILE:-/dev/null}
    ret=$?
    if [ $ret -ne 0 ]; then
        log "Failed to retrieve public key from $SSH_AUTHORIZED_KEYS_URI, curl returned $ret"
        exit 7
    fi
else
    log "No ssh public key given, will use password to login for user $SSH_USER"
    chpasswd <<<"$SSH_USER:$SSH_PASSWORD"
fi


permit_root_login=
if [ "$SSH_USER" = "root" ]; then
    if [ -z "$SSH_AUTHORIZED_KEYS_URI" ]; then
        permit_root_login="yes"
    else
        permit_root_login="without-password"
    fi
else
    permit_root_login="no"
fi


# Try to support various setups, including an old Ubuntu 14.04 with upstart
systemctl restart sshd || systemctl restart ssh || service sshd restart || service ssh restart


# A "normal" ssh configuration, just tweaking PermitRootLogin according to needs

cat >/etc/ssh/sshd_config <<EOF
# Package generated configuration file
# See the sshd_config(5) manpage for details

# What ports, IPs and protocols we listen for
Port 22
# Use these options to restrict which interfaces/protocols sshd will bind to
#ListenAddress ::
#ListenAddress 0.0.0.0
Protocol 2
# HostKeys for protocol version 2
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_dsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key
#Privilege Separation is turned on for security
UsePrivilegeSeparation yes

# Lifetime and size of ephemeral version 1 server key
KeyRegenerationInterval 3600
ServerKeyBits 1024

# Logging
SyslogFacility AUTH
LogLevel INFO

# Authentication:
LoginGraceTime 120
PermitRootLogin $permit_root_login
StrictModes yes

RSAAuthentication yes
PubkeyAuthentication yes
#AuthorizedKeysFile	%h/.ssh/authorized_keys

# Don't read the user's ~/.rhosts and ~/.shosts files
IgnoreRhosts yes
# For this to work you will also need host keys in /etc/ssh_known_hosts
RhostsRSAAuthentication no
# similar for protocol version 2
HostbasedAuthentication no
# Uncomment if you don't trust ~/.ssh/known_hosts for RhostsRSAAuthentication
#IgnoreUserKnownHosts yes

# To enable empty passwords, change to yes (NOT RECOMMENDED)
PermitEmptyPasswords no

# Change to yes to enable challenge-response passwords (beware issues with
# some PAM modules and threads)
ChallengeResponseAuthentication no

# Change to no to disable tunnelled clear text passwords
#PasswordAuthentication yes

# Kerberos options
#KerberosAuthentication no
#KerberosGetAFSToken no
#KerberosOrLocalPasswd yes
#KerberosTicketCleanup yes

# GSSAPI options
#GSSAPIAuthentication no
#GSSAPICleanupCredentials yes

X11Forwarding yes
X11DisplayOffset 10
PrintMotd no
PrintLastLog yes
TCPKeepAlive yes
#UseLogin no

#MaxStartups 10:30:60
#Banner /etc/issue.net

# Allow client to pass locale environment variables
AcceptEnv LANG LC_*
EOF
