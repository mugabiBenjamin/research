# docker

A docker image is a read-only template with instructions for creating a Docker container

A container image is a lightweight, standalone, executable package of software that includes everything needed to run an application: code, runtime, system tools, libraries, and settings

Docker registry is a storage and distribution system for named Docker images

Docker Hub is a public registry that anyone can use, and Docker is configured to look for images on Docker Hub by default

## Pulling images and running containers

```bash
# Pull an image, with tag   (If no tag is specified, Docker uses the latest tag by default)
docker pull nginx:1.29

# List images
docker images
```

## Running containers

```bash
# Run a container in the background (detached mode)
docker run -d nginx:1.29

# List running containers
docker ps

# Print logs of a container
docker logs <container_id>

# Stop a running container
docker stop webserver || docker stop <container_id> || docker stop <container_name> || Ctrl+C
```

```bash
# Even when nginx:1.28-alpine image is not present locally, Docker will pull it from Docker Hub and then run it
docker run -d nginx:1.28-alpine
```

## Port binding

```bash
# Map port 80 in the container to port 9000 on the host
docker run -d -p 9000:80 nginx:1.28-alpine
```

## Startand stop containers

`docker run` creates a new container and starts it. It does not reuse an existing container.

```bash
# List all containers (whwether running or stopped)
docker ps -a

# Start a stopped container
docker start <container_id> || docker start <container_name>

# Start multiple stopped containers
docker start 7622b42383c6 36d6dcdbb917

# Stop a multiple running containers
docker stop 7622b42383c6 36d6dcdbb917

# Run a container in detached mode, map port 80 in the container to port 8080 on the host, and name the container "webserver"
docker run -d -p 8080:80 --name webserver nginx:1.29

docker logs webserver
```

## Private docker registry

A repoisitory is a collection of related Docker images, usually providing different versions of the same application or service e.g. nginx:1.29, nginx:1.28-alpine

A registry is a collection of repositories that can be public or private e.g. Docker Hub is a public registry that anyone can use to host their repositories

## Creating own images

```dockerfile
# Use a stable LTS version of Node.js
FROM node:18

# Set working directory inside the container
WORKDIR /usr/src/app

# Copy package.json and yarn.lock first (for layer caching)
COPY package.json yarn.lock ./

# Install dependencies
RUN yarn install

# Copy app source code
COPY . .

# Expose the port your app runs on
EXPOSE 3000

# Start the app
CMD ["yarn", "start"]
```

## Building an image

```bash
# Build the Docker image and tag it as my-node-app:1.0
docker build -t my-node-app:1.0 .

# Run a container from the image, mapping port 3000 in the container to port 3000 on the host
docker run -d -p 3000:3000 my-node-app:1.0

docker logs <container_id>
```

[Back to Top](#docker)
