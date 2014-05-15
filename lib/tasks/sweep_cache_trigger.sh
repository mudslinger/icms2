#!/bin/sh
export LANG="ja_JP.UTF-8"
trigger_url="http://www.misato-koyou.jp/admin/triggers/sweep_cache"
args="--http-user=itnet --password=itnet"
output=`wget $args -O - $trigger_url  2>&1`

RETVAL=$?
if [ $RETVAL != 0 ] ; then
   echo failed
   echo $output
  logger -t "cms_update_trigger" "異常終了"
else
   logger -t "cms_update_trigger" "正常終了"
fi
