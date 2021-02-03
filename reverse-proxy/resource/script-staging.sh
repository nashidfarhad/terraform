#!/usr/bin/bash

sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y
sudo apt install nginx -y

sudo cat > /etc/nginx/conf.d/reverse-proxy.conf << EOF
server {
	listen 80;
	listen [::]:80;
	
	server_name example.com.au;
	
	location ^~ /repairs/ {
		resolver 8.8.8.8;
		set \$lux_endpoint https://istaging.longtailux.com;
		rewrite ^/repairs/(.*) /\$1 break;
		proxy_pass \$lux_endpoint;
		proxy_set_header SERVER_NAME "https://example.com.au/repairs";
		proxy_pass_request_headers on;
	}
	
	location ^~ /ltux/ {
		resolver 8.8.8.8;
		set \$lux_endpoint https://istaging.longtailux.com;
		rewrite ^/ltux/(.*) /\$1 break;
		proxy_pass \$lux_endpoint;
		proxy_set_header SERVER_NAME "https://example.com.au/ltux";
		proxy_pass_request_headers on;
	}

	location / {
		proxy_pass http://172.31.15.175:80;
		proxy_set_header Host \$host;
	}
}
EOF

sudo nginx -s reload