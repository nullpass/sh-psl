#!/bin/sh
#
# logrot.sh - rotate logs in a user's log directory.
#
#
# Will only act on files ending in ".log"
# Meant to be called from cron daily, or monthly, whatever you need.
# 0 0 * * * /home/${USER}/bin/logrot.sh >> /home/${USER}/log/logrot.log 2>&1
# 0 0 * * * /home/me/bin/logrot.sh >> /home/me/log/logrot.log 2>&1
#

. /etc/profile
umask 0022
thisExec=`basename $0`
thisProc="${thisExec}[$$]"
thisHost="`hostname | head -1 | cut -d\. -f1`"
/home/me/bin/locker.sh $$ /home/me/run/logrot.lock create || exit $?
cd ~/log
for f in `ls *.log`; do
        if [ -f $f.4 ]; then mv -vf $f.4 $f.5; fi
        if [ -f $f.3 ]; then mv -vf $f.3 $f.4; fi
        if [ -f $f.2 ]; then mv -vf $f.2 $f.3; fi 
        if [ -f $f.1 ]; then mv -vf $f.1 $f.2; fi
        #copy-truncate the live file so we don't have to restart anything.
        if [ -f $f ]; then cp -vpf $f $f.1 && : > $f; fi
done
rm -f /home/me/run/logrot.lock
