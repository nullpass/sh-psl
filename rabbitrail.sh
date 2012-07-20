#!/bin/sh
#
# rabbitrail.sh -- Follow the Rabbit Trail 
#
# Build a PID list starting with $1 following 
# parents back to `init` and display as a forest.
#
# This won't work on Solaris `ps`, in fact it was 
# designed on gentoo servers, user beware.
# If your ps supports --no-headers and --forest
# then you're probably OK.
#
if [ "$1" ]; then
  p=$1
	plist=$p
	while [ $p -gt 1 ]; do
		#Parent of given ($p) is this: (exit if `ps` fails)
		ppid="`ps -p $p -o ppid --no-headers 2> /dev/null | awk '{print $1}' | egrep '^[0-9]+$'`" || exit 10
		#Add to the list
		plist="${plist} ${ppid}"
		#Set index.
		p=${ppid}
	done
	#Display the process tree ending with $1
	date
	ps -o uid,pid,ppid,etime,stime,tty,cmd -p "${plist}" --forest
else
	exit 1
fi
