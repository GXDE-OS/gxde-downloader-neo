#!/bin/bash

## Initiate script

if [[ ! -e "${HOME}/.config/GXDE/gxde-downloader/aria2.conf" ]]; then
    mkdir -p "${HOME}/.config/GXDE/gxde-downloader"
    pushd "${HOME}/.config/GXDE/"
    unzip /opt/gxde-downloader/gxde-downloader.zip
    popd
fi

## Update Tracker

pushd "${HOME}/.config/GXDE/gxde-downloader/"
/opt/gxde-downloader/tracker.sh &
popd
# 启动aria2c并记录PID
aria2c --conf-path "${HOME}/.config/GXDE/gxde-downloader/aria2.conf" &
ARIA2C_PID=$!

## Upnp Client 
while true;do
/opt/gxde-downloader/upnp-helper.py 
sleep 60
done
# 捕捉脚本退出信号，杀死该aria2c进程
cleanup() {
    if ps -p $ARIA2C_PID > /dev/null; then
        kill $ARIA2C_PID
    fi
}

# 当脚本退出时调用cleanup函数
trap cleanup EXIT

# 在此处执行其他操作

# 等待aria2c进程完成
wait $ARIA2C_PID
