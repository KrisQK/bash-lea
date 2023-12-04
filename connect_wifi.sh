#!/bin/bash

# 函数来检查是否已经连接到互联网
check_internet() {
    ping -c 1 www.google.com > /dev/null 2>&1
    return $?
}
osascript -e "display notification \"lqkkkk\" with title \"woshi\""

# 函数来显示通知
show_notification() {
    local title="$1"
    local message="$2"
    osascript -e "display notification \"$message\" with title \"$title\""
}

# 获取可用的Wi-Fi网络列表
wifi_list=$(networksetup -listpreferredwirelessnetworks en0)

# 循环检查每个Wi-Fi网络是否可用并连接，最多尝试连接三次
attempts=0
max_attempts=3
connected=false
connected_network=""

while [ $attempts -lt $max_attempts ] && [ "$connected" = false ]; do
    while IFS= read -r line; do
        networksetup -setairportnetwork en0 "$line"
        sleep 5 # 可以根据需要调整等待时间
        if check_internet; then
            echo "已连接到网络: $line"
            connected=true
            connected_network="$line"
            break
        fi
    done <<< "$wifi_list"
    ((attempts++))
done

if [ "$connected" = true ]; then
    show_notification "Wi-Fi连接成功" "已连接到网络: $connected_network"
else
    echo "未能成功连接到任何网络"
fi