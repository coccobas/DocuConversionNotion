for first steps of nuttx instructions: https://nuttx.apache.org/docs/latest/quickstart/install.html

notes:

	1. in order to use the micro-usb in the board, you need to enable the st-link (through the micro-usb). for doing than you have to use the 2 of the small jumpers in the st-link 4 pins on the board:
	
	illustration: (on one side, ST-LINK is written. on the other side NUCLEO is written)

	. 1
	. 2
	. 3
	. 4

	jump 1 with 2 
	jump 3 with 4


	2. in the third page on nuttx official website (quickstart) (where it mentions about openocd), if you had any problem with openocd, you can use st-flash. which is much easier and stright forward (and works !).

for st-flash instructions: https://www.youtube.com/watch?v=1cleO3mHjWw
	summary after installation:
		$ st-flash --reset write ./nuttx.bin 0x08000000


	3. watch tutorial (series): https://www.youtube.com/watch?v=heSkSd-_70g&list=PLd73yQk5Fd8JEsVD-lhwYRQKVu6glfDa8&index=2
		youtube: 001 - Setting the Development Environment for NuttX

	4. Summary:
		$ cd ~/Developers/nuttxspace/nuttx
		$ make distclean
		$ ./tools/configure.sh -l nucleo-f446re:pwm
		$ make menuconfig (STM32F446re - pwm)
			go to : 
				1. Build Setup > Build Host Platform (Linux)
				2. System Type > STM32 Peripheral Support > [*] CRC
									    [*] OTG FS
									    [*] PWR
									    [*] SYSCFG
									    [*] TIM3
									    [*] USART2
				3. System Type > Timer Configuration > [*] TIM3 PWM
                                                                        (0) TIM3 Mode
                                                                        (1) TIM3 PWM Output channel
                                                                    	
								       [*] TIM3 Channel 1 Output
                                                                        (6) TIM3 Channel Mode
				4. System Type > U[S]ART Configuration > USART2 Driver Configuration (Standard serial driver)

				5. Device Driver > [*] Serial Device Support > [*] Enable standard upper-half serial driver
										(4) Number of poll threads

				6. Device Drivers > Timer Driver Support > [*] PWM Driver Support
				
				7. Application Configuration > Examples > [*] "Hello, Rust!" Example 
								        [*] pulse width modulation example
									(/dev/pwm2)
								       	(100)
									(5)
									(50)
				




		save the configuration tool as .config
		exit the configuration tool
		$ make -j4	
			: be sure that there is not Error after this (check the last few lines)
		
		$st-flash --reset write ./nuttx.bin 0x08000000

		Wiring:
			Check the following:
				1. stm32 board specific pins : https://os.mbed.com/platforms/ST-Nucleo-F446RE/
				2. (see above)
					menuconfig > System Type > Timer Configuration
									these setting are the ones we need to know
									to properly wire the servo motor (PWM)
					in this example:
						
						      |- Gnd ------ Gnd
						Servo |- 5v  ------  5v
						      |- pwm ------ (PWM3/1) (PA_6) 
						      			PWM 3 
									channel 1
		On another terminal :
			$ screen /dev/ttyACM0 115200




Heirarchy of folders:
	|- ~/Developers/nuttxspace
				|- tools
				|
				|- openocd (not used yet)
				|
				|- nuttx
					|- arch/arm/src/stm32
					|		 		|- stm32_pwm.c
					|				|- stm32_pwm.h
					|
					|- boards/arm/stm32/nucleo-f446re
									|- Kconfig
									|- README.txt
									|- configs
									|	 |- pwm
									|	 |      |- defconfig
									|	 |     
									|	 |- can
									|	 |      |- defconfig
									|	 |
									|	 |- gpio
									|	 |      |- defconfig
									|	 |....
									|	
									|- include
									|	 |- include.h
									|	 
									|- scripts
									|	 |- f446re.ld
									|	 |- Make.defs
									|
									|- src
									         |- Make.defs
									      	 |- nucleo-f446re.h
									      	 |- stm32_pwm.c
									      	 |- stm32_can.c
									   	 |- stm32_spi.c
				

				|- apps
					|-examples
						|- pwm
							|- pwm_main.c
							|- pwm.h
							|- Make.defs
							|- Kconfig
							
