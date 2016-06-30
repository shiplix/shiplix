# Docker

### Build base ruby image

```
docker build --rm -t shiplix/ruby:2.3.1 -f docker/images/ruby/Dockerfile .
docker push shiplix/ruby:2.3.1
```

## Development

### Setup

```
./docker/bin/compose build app
./docker/bin/compose make setup
``
