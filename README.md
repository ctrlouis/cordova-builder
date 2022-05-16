# Docker cordova-builder

Docker image for cordova builds.

## How to use it ?

Build electron android :
```
docker run -it -v $PWD:/app cordova-builder:latest cordova run android
```

Build electron app :
```
docker run -it -v $PWD:/app cordova-builder:latest cordova run electron
```