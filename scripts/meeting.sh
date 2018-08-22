#!/usr/bin/env bash

set -e

MEETINGS=$HOME/wikidata/Meetings

ident=${1:-default}

today=$(date "+%Y-%m-%d")
meeting="$MEETINGS/meeting-$today-$ident.md"

if [ ! -e "$meeting" ]; then
  cat > "$meeting" << EOF
# Meeting about ${ident} on ${today}

## Attendees

- Mats
- Others..

## Action items

- Item1
EOF
fi

nvim "$meeting"
