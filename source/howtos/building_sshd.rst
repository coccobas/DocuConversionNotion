Building SSHd
=============

For example for EH2000.

.. code-block:: sh

   sudo apt install binutils-arm-linux-gnueabi
   git clone https://github.com/madler/zlib -b v1.2.12
   cd zlib
   CC=arm-linux-gnueabi-gcc ./configure --prefix=$HOME/Development/zlib-arm --static
   make -j8
   make install
   cd ../
   git clone https://github.com/openssl/openssl -b openssl-3.0.5
   cd openssl
   ./Configure linux-armv4 --cross-compile-prefix=arm-linux-gnueabi- --prefix=$HOME/Development/openssl-arm no-shared
   make -j8
   make install_sw
   cd ..

   curl http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-9.0p1.tar.gz | tar -xz
   cd openssh-9.0p1
   ./configure --host=arm-linux-gnueabi --disable-strip --with-libs --with-zlib=$HOME/Development/zlib-arm --with-ssl-dir=$HOME/Development/openssl-arm --disable-etc-default-login CC=arm-linux-gnueabi-gcc AR=arm-linux-gnueabi-ar LD=arm-linux-gnueabi-ld
   make -j8

   cd ..

