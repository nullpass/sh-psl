#!/bin/sh
#
# fixPerms.sh 
#
if [ "${1}" = "please" ]; then
   fileOwner="apache"
   fileGroup="webdev"
   dirOwner="apache"
   dirGroup="webdev"
   fileMode="0660"
   dirMode="0770"
   appRoot="/www/html/"
else
   exit
fi

#
echo "file user and group"
find ${appRoot} -type f \( ! -user ${fileOwner} -o ! -group ${fileGroup} \) -exec chown ${fileOwner}:${fileGroup} {} \; -ls
echo "file modes"
find ${appRoot} -type f ! -perm ${fileMode} -exec chmod ${fileMode} {} \; -ls

echo "file user and group"
find ${appRoot} -type d \( ! -user ${dirOwner} -o ! -group ${dirGroup} \) -exec chown ${dirOwner}:${dirGroup} {} \; -ls
echo "file modes"
find ${appRoot} -type d ! -perm ${dirMode} -exec chmod ${dirMode} {} \; -ls

echo "result"
find ${appRoot} -ls
