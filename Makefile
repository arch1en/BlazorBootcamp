PROJECT_NAME=blazor_bootcamp
IMAGE_NAME=blazor_bootcamp
PRIMARY_PORT=8069
SECONDARY_PORT=443
# Image Mode: 0 - Publish; 1 - Development
IMAGE_MODE=0
MKFILE_PATH := $(abspath $(MAKEFILE_LIST))
CURRENT_DIR := $(patsubst %/,%,$(dir $(MKFILE_PATH)))

init:
	dotnet new blazorserver -o data/${PROJECT_NAME} --no-https -f net6.0

build_pub:
# required name and a tag (testing:1.0) and directory of docker file (.)
	docker build --build-arg IMAGE_MODE=0 -t ${PROJECT_NAME} -f Dockerfile_Pub .

build_dev:
	docker build --build-arg IMAGE_MODE=1 -t ${PROJECT_NAME} -f Dockerfile_Dev .

rm:
	docker stop ${PROJECT_NAME}
	docker rm ${PROJECT_NAME}
rmi:
	docker rmi ${PROJECT_NAME}
wipe:
	docker stop ${PROJECT_NAME}
	docker rm ${PROJECT_NAME}
	docker rmi ${PROJECT_NAME}
run:
	docker run \
		--name ${PROJECT_NAME} \
		--mount type=bind,src=${CURRENT_DIR}/data/${PROJECT_NAME},dst=/app/src \
		-p ${PRIMARY_PORT}:5000 \
		-p ${SECONDARY_PORT}:443 \
		${IMAGE_NAME}
start:
	docker start -a ${PROJECT_NAME}
stop:
	docker stop ${PROJECT_NAME}
restart:
	make stop
	make start
reload:
	docker exec -it ${PROJECT_NAME} dotnet build "./data/blazor_bootcamp/blazor_bootcamp.csproj" -c Development -o /app/build
sh:
	docker exec -it ${PROJECT_NAME} /bin/sh
rebuild:
	make rm
	make rmi
	make build_dev
	make run