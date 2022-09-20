youtube: 
	https://www.youtube.com/watch?v=bJwLE-R5o5M&list=PLd73yQk5Fd8JEsVD-lhwYRQKVu6glfDa8&index=42

	$ cd nuttx
	$ ./tools/configure.sh -l stm32f4discovery:nsh
	$ make menuconfig
	
		1. enable usb console:
			1. Build Setup > Build Host Platform > (Linux)
			2. System Type > STM32 Peripheral Support > [*] OTG FS		# FS : full speed
			3. Device Drivers > [*] USB Device Driver Support > [*] USB Modem (CDC/ACM) support > [*] CDC/ACM console device
			4. Device Drivers > [*] Serial Driver Support > Serial Console (USART2) > [*] No Serial Console
			5. Board Selection > [*] Enable boardctl() interface > [*] Enable USB device controls
			
		2. enable other peripherals (UART - GPS NEO-6M)
			1. System Type > STM32 Peripheral Support > [*] USART6
			2. Device Drivers > Serial Driver Support > USART6 Configuration > (9600) BAUD rate
			3. Library Routines > Standard C I/O > [*] Enable floating point in printf
			4. Applications configurations > examples > [*] GPS example

			5. save and exit

	$ make -j4

	connect micro-usb
	$ st-flash --reset write ./nuttx.bin 0x08000000

	in another terminal
	$ screen /dev/ttyACM0  115200

	nsh> ls /dev
		you will see : ttyS1 (that is the GPS)

	nsh> gps


		(Wiring)
	
	STM32F4discovery	(GPS NEO-6M)
	GND ------------------- GND
	V5 -------------------- VCC
	PC7 (RXD) ------------- TX
	PC6 (TXD) ------------- RX



