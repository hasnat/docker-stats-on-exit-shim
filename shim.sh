#!/usr/bin/env sh

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

for file in /proc/stat /sys/fs/cgroup/**; do

  FILENAME=$(basename $file)
  FILECONTENT="$(cat $file 2>/dev/null || echo "")"
  while read -r line ; do

    if [[ "$line" == *"="* ]]; then
      set -- $line
      FIRST="$1"
      if [[ "$FIRST" != *"="* ]] && ! [[ "$FIRST" =~ ^[0-9]+$ ]]; then
        PREFIX="$FILENAME.$FIRST"
        shift
        for KV in "$@"; do
          KFIELD=$(echo "$KV" | cut -d'=' -f1)
          VFIELD=$(echo "$KV" | cut -d'=' -f2)
          if [ -n "$VFIELD" ] && [ "$VFIELD" -eq "$VFIELD" ] 2>/dev/null; then
            echo $NO_NEWLINE "\"$PREFIX.$KFIELD\":$VFIELD," >> $STATS_OUTPUT_FILE
          else
            echo $NO_NEWLINE "\"$PREFIX.$KFIELD\":\"$VFIELD\"," >> $STATS_OUTPUT_FILE
          fi
        done
      else
        PREFIX="$FILENAME"
        for kv in $line; do
          KFIELD=$(echo "$kv" | cut -d'=' -f1)
          VFIELD=$(echo "$kv" | cut -d'=' -f2)
          if [ -n "$VFIELD" ] && [ "$VFIELD" -eq "$VFIELD" ] 2>/dev/null; then
            echo $NO_NEWLINE "\"$PREFIX.$KFIELD\":$VFIELD," >> $STATS_OUTPUT_FILE
          else
            echo $NO_NEWLINE "\"$PREFIX.$KFIELD\":\"$VFIELD\"," >> $STATS_OUTPUT_FILE
          fi
        done
      fi
    elif [[ $(echo "$line" | wc -w) == 2 ]]; then
      CONTENT=$(echo $line | awk '{$1="";sub(/^ /, ""); print $0}'| sed -E 's#\s*"\s*([^"]+)\s*"\s*#\1#')
      if [ -n "$CONTENT" ] && [ "$CONTENT" -eq "$CONTENT" ] 2>/dev/null; then
        CONTENT_STR="$CONTENT"
      else
        CONTENT_STR="\"$CONTENT\""
      fi
      echo $NO_NEWLINE "\"$FILENAME.$(echo $line | awk 'NR==1 {print $1}')\":$CONTENT_STR," >> $STATS_OUTPUT_FILE
    elif [[ $(echo "$line" | wc -w) -gt 2 ]]; then
      HEAD=$(echo $line | awk '{print $1}')
      REST=$(echo $line | cut -d' ' -f2-)
      INDEX=0
      for VALUE in $REST; do
        if [ -n "$VALUE" ] && [ "$VALUE" -eq "$VALUE" ] 2>/dev/null; then
          echo $NO_NEWLINE "\"$FILENAME.$HEAD.$INDEX\":$VALUE," >> $STATS_OUTPUT_FILE
        else
          echo $NO_NEWLINE "\"$FILENAME.$HEAD.$INDEX\":\"$VALUE\"," >> $STATS_OUTPUT_FILE
        fi
        INDEX=$((INDEX + 1))
      done
    else
      CONTENT=$(echo $line | sed -E 's#\s*"\s*([^"]+)\s*"\s*#\1#')
      if [ -n "$CONTENT" ] && [ "$CONTENT" -eq "$CONTENT" ] 2>/dev/null; then
        CONTENT_STR="$CONTENT"
      else
        CONTENT_STR="\"$CONTENT\""
      fi
      echo $NO_NEWLINE "\"$FILENAME\":$CONTENT_STR," >> $STATS_OUTPUT_FILE
    fi
  done < <(echo "$FILECONTENT")
done;
echo $NO_NEWLINE "\"\":\"\"}" >> $STATS_OUTPUT_FILE
