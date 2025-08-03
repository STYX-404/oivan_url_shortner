#!/bin/sh

rake db:prepare

FILE=/app/tmp/pids/server.pid

if test -f "$FILE"; then
  rm $FILE
fi

puma -C config/puma.rb
