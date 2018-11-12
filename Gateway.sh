#!/bin/bash
ip=`ifconfig ens33 | grep "inet " | cut -d ' ' -f  10`
echo $ip
option="${1}"
echo $option
username=""
passwd=""
echo "username: ${username}";
case $option in
login)
curl -k -X POST  --data "action=login&ac_id=1&user_ip=&nas_ip=&user_mac=&url=&username=${username}&password=${passwd}&save_me=0" 'https://ipgw.neu.edu.cn/srun_portal_pc.php?url=&ac_id=1' | grep -o "网络已连接"
        ;;
logoff)
curl -k -X POST  --data "action=auto_logout&user_ip=${ip}" 'https://ipgw.neu.edu.cn/srun_portal_pc.php?url=&ac_id=1'|grep -o -E "网络已断开|您似乎未曾连接到网络"
        ;;
logout)
curl -k -X POST  --data "action=auto_logout&username=${username}&password=${passwd}&ajax=1" 'https://ipgw.neu.edu.cn/include/auth_action.php'
        echo
        ;;
info)
curl -k -X POST  --data "action=get_online_info" 'https://ipgw.neu.edu.cn/include/auth_action.php'|awk 'BEGIN{FS=","} {if($1=="not_online"){status="not online" } else {status="online"; total=$1/1073741824; time=$2/3600}} END{printf "账号状态: %-s\n", status; printf "已用流量: %-8.2f GB\n", total; printf "已用时长: %-8.2f hours\n", time;printf "账户余额: %-8s Yuan\n", $3; printf  "ip  地址: %-s", $6;}'
        echo
        ;;
help)
        echo "login 登录"
        echo "logoff 注销"
        echo "logout 全部断开"
        echo "info 上网信息"
        ;;
*) 
	echo "please input operation command, command help"
        ;;
esac
