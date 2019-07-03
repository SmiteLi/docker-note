sudo apt-get update

sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update

echo 'start install docker!!!'
sleep 3

sudo apt-get -y install docker-ce docker-ce-cli containerd.io
sleep 3

echo 'finish install docker!!!'
sudo docker run hello-world
sleep 5

echo 'start redis!!!'

# -h ： 指定hostname
docker run --name my-redis \
  -v /home/redis/data:/data \
  --restart=always \
  -h "my-redis" \
  -p 6379:6379 \
  -d redis redis-server --appendonly yes

# docker run -it --network bridge --rm redis redis-cli -h 172.17.0.2

sleep 3

if [[ $?==0 ]]; then
  echo -e "finish start redis!\n"
  docker ps -a
fi

#docker run --rm -it -e REDIS_1_HOST=172.17.0.2 -e REDIS_1_NAME=my-redis -p 8080:80 erikdubbelboer/phpredisadmin
docker run -d --restart=always -e REDIS_1_HOST=172.17.0.2 -e REDIS_1_NAME=my-redis -p 8080:80 erikdubbelboer/phpredisadmin

docker exec -it my-redis bash
