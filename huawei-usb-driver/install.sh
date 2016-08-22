#! /bin/bash

cd ~/Downloads
wget http://download.myusbmodem.com/home/Huawei%20miscellaneous/HUAWEI%20Data%20Cards%20Linux%20Driver.zip
unzip &> /dev/null
if [ "$?" -gt "0" ]; then
  echo "Unzip required."
  read -r -p "Do you want me to install it? [Y/n]: " response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]] ;then
    sudo apt-get install unzip
  else
    echo "Installation halted."
    exit 0;
  fi
fi

unzip ~/Downloads/HUAWEI*.zip -d huawei_driver && cd huawei_driver && tar -zxf *.tar.gz
driver_path="$HOME/Downloads/huawei_driver"
sudo bash $driver_path/driver/install $driver_path

# In order to detect the available USB devices, the below command was used.
# $ lsusb
# 
# This will give you the below output.
# Bus 001 Device 002: ID 0483:91d1 STMicroelectronics Sensor Hub
# ......
# ......
# Bus 001 Device 010: ID 12d1:1506 Huawei Technologies Co., Ltd. Modem/Networkcard

# The following command will give you usb devices details.
# $ usb-devices
# Results given
# T:  Bus=01 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480 MxCh=12
# D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=01 MxPS=64 #Cfgs=  1
# P:  Vendor=1d6b ProdID=0002 Rev=04.04
# S:  Manufacturer=Linux 4.4.0-34-generic xhci-hcd
# S:  Product=xHCI Host Controller
# S:  SerialNumber=0000:00:14.0
# C:  #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=0mA
# I:  If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
# ...........
# ...........
# T:  Bus=01 Lev=01 Prnt=01 Port=02 Cnt=02 Dev#= 16 Spd=480 MxCh= 0
# D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=ff MxPS=64 #Cfgs=  1
# P:  Vendor=12d1 ProdID=15ca Rev=01.02
# S:  Manufacturer=HUAWEI
# S:  Product=HUAWEI Mobile
# S:  SerialNumber=FFFFFFFFFFFFFFFF
# C:  #Ifs= 1 Cfg#= 1 Atr=a0 MxPwr=500mA
# I:  If#= 0 Alt= 0 #EPs= 2 Cls=08(stor.) Sub=06 Prot=50 Driver=usb-storage

# Now wen need to add Product ID and the Vendor ID was captured using the output of the commands above into usb_modemswitch rules:
sudo sed -i '/LABEL="modeswitch_rules_end"/ i \
# Huawei E3272 \
ATTR{idVendor}=="12d1", ATTR{idProduct}=="157c", RUN +="usb_modeswitch \'\%b\/%k\\'" \
# Huawei E3531 \
ATTR{idVendor}=="12d1", ATTR{idProduct}=="15ca", RUN +="usb_modeswitch \'\%b\/%k\\'"' /lib/udev/rules.d/40-usb_modeswitch.rules

sudo touch /etc/usb_modeswitch.d/12d1:157c
sudo usb_modeswitch -H -v 0x12d1 -p 0x157c
sudo usb_modeswitch -J -v 0x12d1 -p 0x157c

sudo usb_modeswitch -H -v 0x12d1 -p 0x15ca
sudo usb_modeswitch -J -v 0x12d1 -p 0x15ca

clear
echo "Now you should see it under available network connections and under lsusb it appears with a different product number:"
echo "Bus 001 Device 024: ID 12d1:1506 Huawei Technologies Co., Ltd. Modem/Networkcard"
echo "You might have to reboot or remove and reinsert the modem a couple of times to get it to work. Also remember to add it into edit connection/add mobile broadband connection."
