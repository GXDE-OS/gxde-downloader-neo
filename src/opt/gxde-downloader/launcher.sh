#!/bin/bash


/opt/gxde-downloader/gxdown-aria2-launcher.sh &


D_DTK_SIZEMODE=1 spark-webapp-runtime -u "file:///opt/gxde-downloader/index.html" --tray --hide-buttons --title="GXDE Downloader"  --desc="GXDE Downloader is a frontend of Aria2c, Using AriaNG" --ico=/opt/gxde-downloader/downloader-arrow.svg 


if [ ! -e "/tmp/_d_dtk_single_instance_${UID}_GXDE Downloader_${UID}" ] ; then
	# Only kill if all the instance
	killall gxdown-aria2-launcher.sh || true
fi
