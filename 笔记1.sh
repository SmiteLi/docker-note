docker pull 192.168.1.100:8080/app1:001

docker run -it --rm \
ubuntu:16.04 \
bash

docker image ls
docker system df

查看虚悬镜像：
docker image ls -f dangling=true
删除虚悬镜像：
docker image prune

列出容器id
docker image ls -q

docker image ls --digests
镜像的唯一标签是ID和摘要（digest)

容器依赖镜像，要先停容器，再删除镜像，否则无法删除

删除名为redis的镜像：
docker image rm $(docker image ls -q redis)

删除mongo:3.2前的镜像
docker image rm $(docker image ls -q -f before=mongo:3.2)

docker exec -it app1 bash
