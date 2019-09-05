# docker-http

Quick way to share files with a [Fancy Index Listing](https://github.com/Vestride/fancy-index/) via HTTP.

## Parameters

| Parameters | Description |
| - | - |
| -p 8080:80 | Map host port 8080 |
| -e user="foo" | Username for authentication |
| -e pass="CHANGE-ME" | Password for authentication |
| -e auth="random" | Generate random user/pass for authentication |
| -e TZ="Europe/Berlin" | Specify a timezone to use |
| -v $(pwd):/html | Mount current dirctory for file sharing |

## Share files in current directory via HTTP

    docker run --rm -it -v $(pwd):/html -p 8080:80 casperklein/http

### with authentication
    docker run --rm -it -v $(pwd):/html -p 8080:80 -e user="foo" -e pass="CHANGE-ME" casperklein/http

### authentication with random credentials
    docker run --rm -it -v $(pwd):/html -p 8080:80 -e auth="random" casperklein/http

## Aliases

    alias httphere='docker run --rm -it -v $(pwd):/html -p 8080:80 casperklein/http'
    alias httphere='docker run --rm -it -v $(pwd):/html -p 8080:80 -e user="foo" -e pass="CHANGE-ME" casperklein/http'
    alias httphere='docker run --rm -it -v $(pwd):/html -p 8080:80 -e auth="random" casperklein/http'

## Access files

    http://$HOST:8080/

![Fancy Directory Listing](/docker-http.png)
