#!/bin/bash

## Initiate script

if [[ ! -e "${HOME}/.config/GXDE/gxde-downloader/aria2.conf" ]]; then
    mkdir -p "${HOME}/.config/GXDE/gxde-downloader"
    pushd "${HOME}/.config/GXDE/"
    unzip /opt/gxde-downloader/gxde-downloader.zip
    popd
fi
# 捕捉脚本退出信号，杀死该aria2c进程
cleanup() {
    if ps -p $ARIA2C_PID > /dev/null; then
        kill $ARIA2C_PID
    fi
    if ps -p $UPNPC_PID > /dev/null; then
        kill $UPNPC_PID
    fi
}

# 当脚本退出时调用cleanup函数
trap cleanup EXIT

## Update Tracker

pushd "${HOME}/.config/GXDE/gxde-downloader/"
/opt/gxde-downloader/tracker.sh &
popd

# 启动aria2c并记录PID
aria2c --conf-path "${HOME}/.config/GXDE/gxde-downloader/aria2.conf" &
ARIA2C_PID=$!

# 在此处执行其他操作
## Upnp Client 
(while true;do
sleep 5
/opt/gxde-downloader/upnp-helper.py 
sleep 60
done) &
UPNPC_PID=$!


# 等待aria2c进程完成
wait 


