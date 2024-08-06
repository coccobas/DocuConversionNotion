# gimbal_device_nucleo

### Description


### How to get the latest version



### How to deploy the img to Nucleo

If Nucleo is connected through USB, you can open a terminator and flash it

```
st-flash --serial /dev/ttyACM0 write zephyr.bin 0x08000000
```

if the command st-flash is not found, you can install it through

```
git clone https://github.com/stlink-org/stlink.git
cd stlink
cmake .
make

cd bin
sudo cp st-* /usr/local/bin
cd ../lib
sudo cp *.so* /lib32
```


### How to setup the local develop environment

For developers