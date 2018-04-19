---
layout: post
title: "GitHub Pages - run Jekyll using Docker container and deploy it using Azure Container Instances"
date:   2018-04-19 
categories: jekyll docker azure
---

Recently i migrate my blog to github pages which using [Jekyll](https://github.com/jekyll/jekyll) engine under a hood to convert markdown files to html and generate static site. After 12 years of hosting blog,  i found that i don't really need any server side execution or storing any data inputs it dbs. My blog simple static web site and serving static content make most sense from page load time perspective.
Beauty of github pages is that i can use familiar tools to publish my posts and git push work perfectly for me. One thing i wanted to have is to ability to stage content in develop branch, test it and maybe publish after few iterations of updates.

Github pages are using Jekyll for content generation and i had to install ruby enviroment on my local box to generate content locally and do some testing . I also wants to have ability to deploy it to cloud and preview it when its using fully qualified domain name. So to avoid dev dependencies i choose to have docker image which i can run in any devbox and create simple pipline to deploy blog to azure from my develop github branch before merging changes to master.

You can find docker file in my github with instructions and i am simply including copy o [Readme.md](https://github.com/gtrifonov/docker-jekyll-serve/blob/master/README.md) from this repo:
[https://github.com/gtrifonov/docker-jekyll-serve](https://github.com/gtrifonov/docker-jekyll-serve)

## Running your jekyll site locally and deploying to Azure Container Service

Building and running container locally. Change docker-compose.yml file to insert your git repo url an change container name, branch, ports if needed.

> `docker-compose up -d --build`

Lookup logs locally and at this point you can preview your website locally

> `docker logs gtrifonov.com --follow`

Assuming you have your azure registry created this command will publish image. You don't need to rebuild image and publish image with every new blog post (git push)

> `docker push gtrifonov.azurecr.io/jekyll-serve:latest`

Create container instance in azure

> `az container create --resource-group {YOUR_RESOURCE_GROUP} --name blog --image gtrifonov.azurecr.io/jekyll-serve --cpu 1 --memory 1 --registry-username {YOUR_USERNAME} --registry-password {YOUR_PASSWORD} --dns-name-label {YOUR_SUBDOMAIN} --ports 80`

See a staus of your container

> ` az container logs --resource-group DefaultWestUs --name gtrifonovcom --follow`

Once testing is done you can delete container to free resources

> `az container delete --resource-group {YOUR_RESOURCE_GROUP} --name gtrifonovcom`