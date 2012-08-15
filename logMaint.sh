#!/bin/sh
#
# app logs maintenance. 
#
# meant to be run daily from cron
#
#30 0 * * * /app/bin/logMaint.sh >> /var/log/cron.err 2>&1
#
matches="access.*[0-9]
email.log.*[0-9]
errors.*[0-9]
ldserver.log.*[0-9]"

Where="/var//logs/web/bar.dom.ltd
/var/logs/web/foo.dom.ltd"

cd /

thisExec=`basename $0`
thisProc="${thisExec}[$$]"
thisHost="`hostname | head -1 | cut -d\. -f1`"

for Here in ${Where}; do
        for name in ${matches}; do
                echo "`date` ${thisHost} ${thisProc} gzip ${name} in ${Here}"
                /usr/bin/find ${Here} -mount -type f -name ${name} -exec /usr/bin/gzip -9vf {} \;
                #/usr/bin/find ${Here} -mount -type f -name ${name} -ls
        done
        for name in ${matches}; do
                echo "`date` ${thisHost} ${thisProc} rm ${name}.gz in ${Here}"
                /usr/bin/find ${Here} -mount -type f -mtime +30 -name ${name}.gz -exec rm -f {} \; -print
                #/usr/bin/find ${Here} -mount -type f -mtime +30 -name ${name}.gz -ls
        done
done

