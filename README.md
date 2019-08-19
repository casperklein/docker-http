# docker-http

## Share files in current directory via HTTP

    PORT=80
    docker run --rm -it -v $(pwd):/var/www/html -p $PORT:80 casperklein/http

### Alias

    alias httphere='docker run --rm -it -v $(pwd):/mnt -p 80:80 casperklein/http'

## Access files

    http://$HOST/
