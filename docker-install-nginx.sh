https://hub.docker.com/_/nginx

$ docker run --name some-nginx -v /home/nginx/html:/usr/share/nginx/html:ro -d nginx
$ docker run --name some-nginx -d -p 8080:80 some-content-nginx
docker run --name my-custom-nginx-container -v /host/path/nginx.conf:/etc/nginx/nginx.conf:ro -d nginx

$ docker run --name tmp-nginx-container -d nginx
$ docker cp tmp-nginx-container:/etc/nginx/nginx.conf /home/nginx/nginx.conf
$ docker rm -f tmp-nginx-container

docker run -d \
  -v /home/nginx/html:/usr/share/nginx/html \
  -v /home/nginx/nginx.conf:/etc/nginx/nginx.conf \
  -v /etc/localtime:/etc/localtime:ro \
  -v /etc/timezone:/etc/timezone:ro \
  -v /home/nginx/log:/var/log/nginx \
  -p 80:80 \
  -p 443:443 \
  --restart=always \
  --name mynginx nginx:1.16
