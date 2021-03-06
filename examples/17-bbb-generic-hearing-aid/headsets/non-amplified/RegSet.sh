#!/bin/bash
set -e


# NON-APLIFIED Headset (PGA = 30.5)

#INPUT
sudo i2cset -f -y 2 0x38 0x40 0x0a 0x01 i
sudo i2cset -f -y 2 0x38 0x40 0x0b 0x08 i
sudo i2cset -f -y 2 0x38 0x40 0x0e 0xe7 i

sudo i2cset -f -y 2 0x38 0x40 0x0c 0x01 i
sudo i2cset -f -y 2 0x38 0x40 0x0d 0x08 i
sudo i2cset -f -y 2 0x38 0x40 0x0f 0xe7 i

sudo i2cset -f -y 2 0x39 0x40 0x0a 0x01 i
sudo i2cset -f -y 2 0x39 0x40 0x0b 0x08 i
sudo i2cset -f -y 2 0x39 0x40 0x0e 0xe7 i

sudo i2cset -f -y 2 0x39 0x40 0x0c 0x01 i
sudo i2cset -f -y 2 0x39 0x40 0x0d 0x08 i
sudo i2cset -f -y 2 0x39 0x40 0x0f 0xe7 i

sudo i2cset -f -y 2 0x3a 0x40 0x0a 0x01 i
sudo i2cset -f -y 2 0x3a 0x40 0x0b 0x08 i
sudo i2cset -f -y 2 0x3a 0x40 0x0e 0x97 i

sudo i2cset -f -y 2 0x3a 0x40 0x0c 0x01 i
sudo i2cset -f -y 2 0x3a 0x40 0x0d 0x08 i
sudo i2cset -f -y 2 0x3a 0x40 0x0f 0x97 i

#OUTPUT
sudo i2cset -f -y 2 0x38 0x40 0x23 0xBF i
sudo i2cset -f -y 2 0x39 0x40 0x23 0xBF i
sudo i2cset -f -y 2 0x3A 0x40 0x23 0xE7 i
sudo i2cset -f -y 2 0x38 0x40 0x24 0xE7 i
sudo i2cset -f -y 2 0x39 0x40 0x24 0xE7 i
sudo i2cset -f -y 2 0x3A 0x40 0x24 0xE7 i
