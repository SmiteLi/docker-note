https://hacpai.com/article/1492881378588

1. nginx:
docker run -d \
  -v /home/nginx/html:/usr/share/nginx/html \
  -v /home/nginx/nginx.conf:/etc/nginx/nginx.conf \
  -v /home/nginx/smite.site.key:/etc/nginx/smite.site.key \
  -v /home/nginx/smite.site.pem:/etc/nginx/smite.site.pem \
  -v /etc/localtime:/etc/localtime:ro \
  -v /etc/timezone:/etc/timezone:ro \
  -v /home/nginx/log:/var/log/nginx \
  -p 80:80 \
  -p 443:443 \
  --restart=always \
  --name mynginx nginx:1.16

配置文件：nginx.conf

2. mysql
使用：
docker run -d \
  --name my-mysql \
  --restart=always \
  -v /home/mysql/data:/var/lib/mysql \
  -v /home/mysql/log:/var/log/mysql \
  -v /etc/localtime:/etc/localtime:ro \
  -v /etc/timezone:/etc/timezone:ro \
  -e MYSQL_ROOT_PASSWORD=2Akp10tZ \
  -p 3306:3306 \
  mysql:5.7

管理：
docker run -it --network bridge --rm mysql:5.7 mysql -h172.17.0.2 -uroot -p


1.先手动建库（库名 solo，字符集使用 utf8mb4，排序规则 utf8mb4_general_ci），然后启动容器：

# mysql -uroot -p
password
mysql> create database solo character set utf8mb4 collate utf8mb4_general_ci;
mysql> grant all privileges on solo.* to solo@'%' identified by '2Akp10tZ';
mysql> flush privileges;
mysql> quit;


3. solo
下面的不建议docker环境使用：
docker run --detach --name solo --network=host \
    --restart=always \
    -v /etc/localtime:/etc/localtime:ro \
    -v /etc/timezone:/etc/timezone:ro \
    --env RUNTIME_DB="MYSQL" \
    --env JDBC_USERNAME="solo" \
    --env JDBC_PASSWORD="2Akp10tZ" \
    --env JDBC_DRIVER="com.mysql.cj.jdbc.Driver" \
    --env JDBC_URL="jdbc:mysql://172.17.0.3:3306/solo?useUnicode=yes&characterEncoding=UTF-8&useSSL=false&serverTimezone=UTC" \
    b3log/solo --listen_port=8080 --server_scheme=https --server_host=smite.site

下面建议docker环境使用：
docker run --detach --name solo \
    --restart=always \
    -v /etc/localtime:/etc/localtime:ro \
    -v /etc/timezone:/etc/timezone:ro \
    --env RUNTIME_DB="MYSQL" \
    --env JDBC_USERNAME="solo" \
    --env JDBC_PASSWORD="2Akp10tZ" \
    --env JDBC_DRIVER="com.mysql.cj.jdbc.Driver" \
    --env JDBC_URL="jdbc:mysql://172.17.0.2:3306/solo?useUnicode=yes&characterEncoding=UTF-8&useSSL=false&serverTimezone=UTC" \
    b3log/solo --listen_port=8080 --server_scheme=https --server_host=smite.site



4. 自动升级
vim /home/solo/update.sh

#!/bin/bash

#
# Solo docker 更新重启脚本
#
# 1. 请注意修改参数
# 2. 可将该脚本加入 crontab，每日凌晨运行来实现自动更新
#

docker pull b3log/solo
docker stop solo
docker rm solo
docker run --detach --name solo \
    --restart=always \
    -v /etc/localtime:/etc/localtime:ro \
    -v /etc/timezone:/etc/timezone:ro \
    --env RUNTIME_DB="MYSQL" \
    --env JDBC_USERNAME="solo" \
    --env JDBC_PASSWORD="2Akp10tZ" \
    --env JDBC_DRIVER="com.mysql.cj.jdbc.Driver" \
    --env JDBC_URL="jdbc:mysql://172.17.0.2:3306/solo?useUnicode=yes&characterEncoding=UTF-8&useSSL=false&serverTimezone=UTC" \
    b3log/solo --listen_port=8080 --server_scheme=https --server_host=smite.site

5. crontab -e

# m h  dom mon dow   command
0 3 * * 5 /bin/bash /home/solo/update.sh
