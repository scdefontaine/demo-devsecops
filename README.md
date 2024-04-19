# demo-devsecops

1) load the project into github
2) configure the github environment in the settings with the listed variables in the workflow files
3) package-image and deploy-infrastructure workflows only work assuming the default values and properly set environment variables. I did not have enough time to build out a py2 or r-base image but set the groundwork in the Dockerfile using ARGs and ENVs
4) I wanted to go a step further and build out some bash scripts to ssh into the nodes and configure a small dev cluster but I just didn't have enough time
5) If running a local kube cluster (i.e. docker desktop kubernetes, minikue, etc) and helm is installed, the demo-app helm charts can be deployed using `helm upgrade -i demo-app ./demo-app/helm`
