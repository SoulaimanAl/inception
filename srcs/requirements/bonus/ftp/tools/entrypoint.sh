#!/bin/bash
set -e

# Create FTP user if environment variables are set
if [ -n "$FTP_USER" ] && [ -n "$FTP_PASSWORD" ]; then
    useradd -m -d /var/www/html -s /bin/bash $FTP_USER
    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
    chown -R 33:33 /var/www/html
    # Add user to config
    echo "$FTP_USER" >> /etc/vsftpd.userlist
fi

exec vsftpd /etc/vsftpd.conf
