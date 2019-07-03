https://hub.docker.com/_/mysql

docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:tag

connect:
docker run -it --network some-network --rm mysql mysql -hsome-mysql -uexample-user -p
docker run -it --rm mysql mysql -hsome.mysql.host -usome-mysql-user -p
docker exec -it some-mysql bash
docker logs some-mysql

docker run --name some-mysql -v /home/mysql/conf.d:/etc/mysql/conf.d -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:tag
docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:tag --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
docker run -it --rm mysql:tag --verbose --help

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
docker run -it --network bridge --rm mysql:5.7 mysql -h172.17.0.3 -uroot -p

Creating database dumps:
docker exec some-mysql sh -c 'exec mysqldump --all-databases -uroot -p"$MYSQL_ROOT_PASSWORD"' > /some/path/on/your/host/all-databases.sql

Restoring data from dump files:
docker exec -i some-mysql sh -c 'exec mysql -uroot -p"$MYSQL_ROOT_PASSWORD"' < /some/path/on/your/host/all-databases.sql



管理工具：
https://hub.docker.com/r/phpmyadmin/phpmyadmin

docker run -it --rm phpmyadmin/phpmyadmin bash
复制文件：docker cp friendly_yonath:/etc/phpmyadmin/config.user.inc.php ~
docker run -it --rm --name myadmin -d --link mysql_db_server:db -p 8080:80 phpmyadmin/phpmyadmin

用法一：
docker run --name phpmysqladmin \
  --restart=always -d \
  -e PMA_HOST=172.17.0.7 \
  -e PMA_PORT=3306 \
  -e PMA_ARBITRARY=1 \
  -e PMA_USER="root" \
  -e PMA_PASSWORD="123456" \
  -e PMA_ABSOLUTE_URI="/" \
  -p 8082:80 \
  phpmyadmin/phpmyadmin

二、连接任意mysql服务器：
docker run --name phpmysqladmin \
  --restart=always -d \
  -e PMA_ARBITRARY=1 \
  -p 8082:80 \
  phpmyadmin/phpmyadmin
