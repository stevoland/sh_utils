#!/bin/bash
# crontab
# MAILTO=user@domain.com
# MY SNAPSHOTS
# 	@hourly /home/user/scripts/mysnapshot.sh hourly &>/dev/null
# 	@midnight /home/user/scripts/mysnapshot.sh nightly &>/dev/null
# 	@monthly /home/user/scripts/mysnapshot.sh monthly &>/dev/null
# 	

#
# GNU Free Documentation License 1.2
# 06-11-08 - AskApache (www.askapache.com)
#
#
#    .mysnapshot
#    |-- hourly.0    (one hour ago)
#    |-- nightly.0   (one night ago)
#    |-- weekly.0    (one week ago)
#    `-- monthly.0   (one month ago)
#

### Source and Destination
source=$HOME/sites
dest=$HOME/.mysnapshot/${1:-hourly}.0/`basename $source`

### Make Nice - lower load
renice 19 -p $$ &>/dev/null

### Non-Absolute links, check source exists
cd $source || exit 1

### Hide errs, copy dirtree
find . -depth -print0 2>/dev/null | cpio -0admp $dest &>/dev/null

cd $OLDPWD

exit 0
