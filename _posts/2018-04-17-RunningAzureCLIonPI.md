---
layout: post
title: "Running azure cli on Raspberry Pi using docker containers"
---

Few days ago i was playing with my Pi 2 and wanted to execute [Azure CLI 2.0](https://github.com/Azure/azure-cli) commands to deploy some containers to Azure Container Registry. I knew i probably had to compile cli source code to target arm proccesor. 
I found that azure cli git-hub repository doesn't have proper build script support for arm target. I filled Bug [6092](https://github.com/Azure/azure-cli/issues/6092) and started to modified build scripts. After some altering i made it working, but when it striked me  - why just not use docker arm image and replicate cli docker file instructions.

So below is instructions how to run azure cli on raspberry Pi using docker containers.

## Prepare your Raspbery PI and run Azure CLI

### Install Git and Docker

#### Git installation command

`sudo apt-get install git` 

#### Docker installation command

`curl -sSL https://get.docker.com | sh`

### Clone and Build repository

`sudo git clone https://github.com/gtrifonov/raspberry-pi-alpine-azure-cli.git`

`cd .\raspberry-pi-alpine-azure-cli`

`sudo docker build . -t azure-cli`

This will build docker image with title 'azure-cli'

### Running commands in docker image

#### Starting Docker container in demon mode and giving it name 'cli'

`sudo docker run -d -it --rm --name cli azure-cli`

Docker container running as demon with bash shell opened

#### Verifiying that container running

`sudo docker ps`

Output 

| CONTAINER ID  |  IMAGE    | COMMAND                |  CREATED         |    STATUS         | PORTS  |  NAMES  |
| ------------- |---------- |----------------------- |----------------- | ----------------- | ------ | ------- |
| 17c2e621f9b4  | azure-cli | "/usr/bin/entry.sh /…" |  49 seconds ago  |    Up 46 seconds  |        |  cli    |


#### Executing command login to azure

Since docker container is running and waiting any command to be executed you can use docker exec command.
Command below will execute azure cli login.

`sudo docker exec cli az login`

Once you logged in please use [Azure Cli command refference](https://docs.microsoft.com/en-us/cli/azure/reference-index?view=azure-cli-latest) to see available commands and there parameters