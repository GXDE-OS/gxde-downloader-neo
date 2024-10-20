#!/bin/bash
if [[ ! -e "${HOME}/.config/GXDE/gxde-downloader/aria2.conf" ]]; then
    mkdir -p "${HOME}/.config/GXDE/gxde-downloader"
    pushd "${HOME}/.config/GXDE/"
    unzip /opt/gxde-downloader/gxde-downloader.zip
    popd
fi

# 启动aria2c并记录PID
aria2c --conf-path "${HOME}/.config/GXDE/gxde-downloader/aria2.conf" &
ARIA2C_PID=$!

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
