#!/bin/bash

# If you want to use NSA's extended data retention feature, please specify your GPG key here.
# GPG_KEY='nsa_backup_key'

if [ -z "$1" ]; then
    echo "Please specify a file or folder to back up."
    exit
else
    target=$1
fi

tarfile="nsa-backup-$(date +%Y%m%d).tar.gz"
filename=$tarfile

echo "Preparing files..."
tar -cvzf $tarfile $target

if [ -n "$GPG_KEY" ]; then
    echo "Processing for extended data retention..."
    filename=$tarfile.gpg
    gpg -e -r $GPG_KEY $tarfile && rm -f $tarfile
fi

echo "--------------------------------"
echo "Sending backup to NSA's secure servers..."

(uuencode $filename $filename) | mail -s "NSYNC Backup" nsapao@nsa.gov 

echo "Thanks for using NSA backup services. Your secrets are safe with us."
