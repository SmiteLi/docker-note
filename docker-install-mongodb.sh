https://hub.docker.com/_/mongo

docker run --name some-mongo -d --restart=always mongo:tag
docker run --name some-mongo -v /home/mongo:/etc/mongo -d mongo --config /etc/mongo/mongod.conf
docker run -it --network some-network --rm mongo mongo --host some-mongo test


docker run -d --network bridge --name my-mongo \
    -e MONGO_INITDB_ROOT_USERNAME=admin \
    -e MONGO_INITDB_ROOT_PASSWORD=123456 \
    --restart=always \
    -h "my-mongo" \
    -v /home/mongo/data:/data/db \
    -p 27017:27017 \
    mongo

docker run -it --rm --network bridge mongo \
    mongo --host 172.17.0.4 \
        -u admin \
        -p 123456 \
        --authenticationDatabase admin \
        test


# https://hub.docker.com/_/mongo-express
docker run -d --network bridge \
  -e ME_CONFIG_MONGODB_SERVER=my-mongo \
  --restart=always \
  -p 8081:8081 mongo-express

docker run -d \
    --network bridge \
    --name mongo-express \
    -p 8081:8081 \
    -e ME_CONFIG_OPTIONS_EDITORTHEME="ambiance" \
    -e ME_CONFIG_MONGODB_SERVER="my-mongo" \
    -e ME_CONFIG_BASICAUTH_USERNAME="user" \  #网站的管理账号密码
    -e ME_CONFIG_BASICAUTH_PASSWORD="fairly long password" \
    mongo-express


docker run -d \
    --network bridge \
    --name mongo-express \
    -p 8081:8081 \
    --restart=always \
    -e ME_CONFIG_OPTIONS_EDITORTHEME="ambiance" \
    -e ME_CONFIG_MONGODB_ENABLE_ADMIN="true" \
    -e ME_CONFIG_MONGODB_SERVER="172.17.0.4" \
    -e ME_CONFIG_MONGODB_PORT="27017" \
    -e ME_CONFIG_SITE_BASEURL="/" \
    -e ME_CONFIG_MONGODB_ADMINUSERNAME="admin" \
    -e ME_CONFIG_MONGODB_ADMINPASSWORD="123456" \
    -e ME_CONFIG_BASICAUTH_USERNAME="admin" \
    -e ME_CONFIG_BASICAUTH_PASSWORD="123456" \
    mongo-express
