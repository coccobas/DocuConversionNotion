# Docs for BeagleSystems

### How to build the docs

Follow the guide inside this repo : [Compile_Documentation](./source/howtos/compile_documentation.rst)



### How to deploy

1. Create folder with permission on the server

```
cd /var/www/
sudo mkdir docs
sudo chown ubuntu:www-data docs
```

1. Copy all built html file into server folder: /var/www/docs/html

```
sudo pscp -i beagleserver.ppk -r ~/Development/docs/_build/html ubuntu@18.196.92.225:/var/www/docs
```

1. Enable the default Nginx server conf to

```
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/docs/html;

    index index.html;

    server_name _;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

