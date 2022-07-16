# Docker image for http://www.sql-ex.ru/ exercises

This repository contains Dockerfile to build an image based on `mcr.microsoft.com/mssql/server:2022` and apply sql-ex databases creation scripts. You can use the image to solve sql-ex exercises locally and get benefits from syntax highlighting in your IDE.

## Prerequisites

You need to install [Docker](https://www.docker.com/)

## How to build an image

1. Clone this repository.
2. Build an image:

    ```bash
    cd sql-ex-docker
    docker build --rm --tag sql-ex .
    ```

You have to build it once and then you may use it on daily basis.

## How to run and connect to SQL Server in the container

1. You have to run the container first:

    ```bash
    docker run --rm -p 14330:1433 --name sql-ex -d sql-ex
    ```

2. Now you can connect to SQL Server: 
   - Host: localhost
   - Port: 14330
   - Login: sa
   - Password: Pa$$w0rd

To stop the running container with SQL Server you may use command:

```bash
docker stop sql-ex
```