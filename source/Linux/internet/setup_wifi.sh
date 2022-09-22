#! /bin/bash

echo "プロキシを設定"

$current_proxy = printenv http_proxy https_proxy
if [ -z "$current_proxy" ]; then
    echo -e "\n## proxy setting"  >> ~/.bashrc
    echo 'export http_proxy="http://proxy-a.t-kougei.ac.jp:8080"' >> ~/.bashrc
    echo 'export https_proxy=$http_proxy' >> ~/.bashrc
fi

echo "ネットワークを設定"

read -p "工芸ネットユーザ名: " user
read -p "工芸ネットパスワード: " password

sudo apt install wpasupplicant

$supplicant_conf = "
ctrl_interface=/var/run/wpa_supplicant
ctrl_interface_group=0
eapol_version=2
ap_scan=1
network={
    ssid=\"kougei-WiFi.1xST\"
    key_mgmt=WPA-EAP
    pairwise=CCMP
    group=CCMP
    eap=PEAP
    identity=\"$user\"
    password=\"$password\"
    phase1=\"peaplabel=0\"
}"

touch /etc/wpa_supplicant/wpa_supplicant.conf
sed -i -e $supplicant_conf /etc/wpa_supplicant/wpa_supplicant.conf # ファイルの中身を置き換える
wpa_supplicant -Dwext -iwlan0 -c/home/user/wpa_supplicant.conf # 接続の実行

echo "処理終了"