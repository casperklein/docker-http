# docker-http

## Share files in current directory via HTTP

    PORT=8080
    docker run --rm -it -v $(pwd):/var/www/html -p $PORT:80 casperklein/http

### Alias

    alias httphere='docker run --rm -it -v $(pwd):/var/www/html -p 8080:80 casperklein/http'

## Share files in current directory via HTTP (with authentication)

    PORT=8080
    USER=foo
    PASS=CHANGE-ME
    docker run --rm -it -v $(pwd):/var/www/html -p $PORT:80 --env user="$USER" --env pass="$PASS" casperklein/http

### Alias (with authentication)
    
    alias httphere='docker run --rm -it -v $(pwd):/var/www/html -p 8080:80 --env user="foo" --env pass="CHANGE-ME" casperklein/http'

## Share files in current directory via HTTP (with random authentication)

    PORT=8080
    docker run --rm -it -v $(pwd):/var/www/html -p $PORT:80 --env auth="random" casperklein/http

### Alias (with random authentication)

    alias httphere='docker run --rm -it -v $(pwd):/var/www/html -p 8080:80 --env auth="random" casperklein/http'

## Access files

    http://$HOST:$PORT/
