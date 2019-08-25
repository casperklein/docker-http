# docker-http

## Share files in current directory via HTTP

    PORT=8080
    docker run --rm -it -v $(pwd):/var/www/html -p $PORT:80 casperklein/http

### Alias

    alias httphere='docker run --rm -it -v $(pwd):/var/www/html -p 8080:80 casperklein/http'

## Access files

    http://$HOST/
