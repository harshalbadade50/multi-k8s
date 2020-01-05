# build the below images
# these images will be built with two tag names
# one with :latest tag and another having :SHA id
# $SHA is a global variable declcared in .travis.yml file
docker build -t harshalbadade/multi-client:latest -t harshalbadade/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t harshalbadade/multi-server:latest -t harshalbadade/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t harshalbadade/multi-worker:latest -t harshalbadade/multi-worker:$SHA -f ./worker/Dockerfile ./worker

# push the above built images to docker hub. Push the images with both the tags
docker push harshalbadade/multi-client:latest
docker push harshalbadade/multi-server:latest
docker push harshalbadade/multi-worker:latest

docker push harshalbadade/multi-client:$SHA
docker push harshalbadade/multi-server:$SHA
docker push harshalbadade/multi-worker:$SHA

# apply all the config files inside k8s directory
kubectl apply -f k8s

# set latest images on each deployment
kubectl set image deployments/server-deployment server=harshalbadade/multi-server:$SHA
kubectl set image deployments/client-deployment client=harshalbadade/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=harshalbadade/multi-worker:$SHA
