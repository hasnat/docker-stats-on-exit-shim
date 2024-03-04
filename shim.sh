#!/usr/bin/env bash
#set -euxo pipefail
#set -euo pipefail
NO_NEWLINE=-n
exec "$@" &
STATS_OUTPUT_FILE=${STATS_OUTPUT_FILE:-/dev/stdout}
STATS_OUTPUT_PREFIX=${STATS_OUTPUT_PREFIX:-}
BACK_PID=$!
while kill -0 $BACK_PID 2>/dev/null ; do
#    echo "Process is still active..."
    sleep 1
    # You can add a timeout here if you want
done
echo $NO_NEWLINE $STATS_OUTPUT_PREFIX >> $STATS_OUTPUT_FILE
echo $NO_NEWLINE "{" >> $STATS_OUTPUT_FILE

for file in /sys/fs/cgroup/**; do

  FILENAME=$(basename $file)
  FILECONTENT=$(cat $file 2>/dev/null || echo "")
  while read -r line ; do
   if [[ $(echo "$line" | wc -w) == 2 ]]; then

    CONTENT=$(echo $line | awk '{$1="";sub(/^ /, ""); print $0}')
    echo $NO_NEWLINE "\"$FILENAME.$(echo $line | awk 'NR==1 {print $1}')\":\"$CONTENT\"," >> $STATS_OUTPUT_FILE ;
  else
    echo $NO_NEWLINE "\"$FILENAME\":\"$line\"," >> $STATS_OUTPUT_FILE ;
  fi

  done < <(echo "$FILECONTENT")
done;
echo $NO_NEWLINE "\"\":\"\"}" >> $STATS_OUTPUT_FILE
