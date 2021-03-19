#!/bin/bash
# issues a sylog message if worker log hasn't been touched in the last minute.
# cribbed from https://stackoverflow.com/questions/28337961/find-out-if-file-has-been-modified-within-the-last-2-minutes
set -eu

FILE=$(realpath "$1")
THRESHOLD=${2:-60} # seconds, default is 60s/1m

# Get current and file times
CURTIME=$(date +%s)
FILETIME=$(stat $FILE -c %Y)
TIMEDIFF=$(expr $CURTIME - $FILETIME)

# Check if file older
if [ $TIMEDIFF -gt $THRESHOLD ]; then
    msg="warning: no change in '$FILE' after $THRESHOLD seconds"
    echo "$msg"
    logger "$msg"
fi
