#!/bin/bash
source ~/.env
branch=$(git branch --show-current)



docker build -t dcwiz-nginx .

docker image tag dcwiz-nginx registry.admin.rda.ai/dcwiz-nginx:$branch

~/trivy/trivy image --ignore-unfixed dcwiz-nginx

docker login -u admin -p $REGISTRY_PW registry.admin.rda.ai
docker push registry.admin.rda.ai/dcwiz-nginx:$branch
