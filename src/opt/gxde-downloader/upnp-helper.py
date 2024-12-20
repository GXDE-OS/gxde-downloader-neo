#!/bin/python3 
import json
import requests
import miniupnpc

# Aria2 JSON-RPC配置
ARIA2_RPC_URL = 'http://localhost:6800/jsonrpc'  # 可在这里修改端口
ARIA2_RPC_SECRET = ''  # 暂时没有启用rpc-secret时留空
# ARIA2_RPC_SECRET = 'your_rpc_secret_here'  # 有rpc-secret时请取消注释并填写密钥

def get_aria2_ports():
    json_data = {
        'jsonrpc': '2.0',
        'id': 'qwer',
        'method': 'aria2.getGlobalOption',
        'params': []  # 无rpc-secret时为空列表
        # 'params': [ARIA2_RPC_SECRET]  # 有rpc-secret时的参数
    }

    response = requests.post(ARIA2_RPC_URL, json=json_data)
    
    if response.status_code == 200:
        data = response.json()
        if 'result' in data:
            ports = data['result'].get('rpc-listen-port', '6800')
            if isinstance(ports, list):
                return [int(port) for port in ports]
            else:
                return [int(ports)]
    else:
        print("Failed to communicate with Aria2.")
        return []

def setup_upnp_mapping(ports):
    upnpc = miniupnpc.UPnP()
    upnpc.discoverdelay = 5000
    discovered = 0

    try:
        discovered = upnpc.discover()
        print(f"Number of UPnP devices discovered: {discovered}")
    except Exception as e:
        if "Success" in str(e):
            print("Discovery returned success, proceeding...")
        else:
            print(f"UPnP discovery failed with error: {e}")
            return

    if discovered > 0:
        for i in range(discovered):
            try:
                # 调用 selectigd() 不带参数，默认选择第一个 IGD
                upnpc.selectigd()
                print(f"Selected IGD: {upnpc.lanaddr}")  # 打印选中的设备局域网地址

                local_ip = upnpc.lanaddr

                for port in ports:
                    try:
                        # 尝试为每个端口添加映射
                        upnpc.addportmapping(port, 'TCP', local_ip, port, 'Aria2 RPC Port', '')
                        print(f"UPnP Port Mapping successful: {local_ip}:{port} -> External Port {port}")
                    except Exception as e:
                        print(f"Failed to add UPnP port mapping for port {port}: {e}")
            except Exception as e:
                print(f"Failed to select IGD {i}: {e}")
    else:
        print("No UPnP devices found.")



if __name__ == '__main__':
    aria2_ports = get_aria2_ports()

    if aria2_ports:
        print(f"Aria2 RPC is running on ports {aria2_ports}. Setting up UPnP...")
        setup_upnp_mapping(aria2_ports)
    else:
        print("Could not retrieve Aria2 port information.")
