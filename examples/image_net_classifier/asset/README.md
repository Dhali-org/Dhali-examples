# Efficient net classifier

An example Dhali asset.

## Prerequisite
1. Get the model:
```
wget -O efficient_net.tar.gz https://tfhub.dev/google/efficientnet/b3/classification/1?tf-hub-format=compressed
```
2. Decompress: 
```
mkdir efficient_net && tar -x -f efficient_net.tar.gz -C efficient_net
```

## Dhali deployment

```
cd asset
docker build -t im_net_classifier .
docker save --output /tmp/im_net_classifier.tar im_net_classifier
```
Then, enter [Dhali]() and upload `/tmp/im_net_classifier.tar`

## Testing

1. `docker build -t im_net_classifier .`
2. `docker run  -p 8080:8080 im_net_classifier`
3. `time curl -X PUT -F "input=@<Dhali-examples>/images/horse.jpg" http://127.0.0.1:8080/run/`