# docker

- [Introduction](#introduction)
- [Pulling images and running containers](#pulling-images-and-running-containers)
- [Running containers](#running-containers)
- [Port binding](#port-binding)
- [Start and stop containers](#startand-stop-containers)
- [Private docker registry](#private-docker-registry)
- [Creating own images](#creating-own-images)
- [Building an image](#building-an-image)
- [Dangling images](#dangling-images)
- [Delete & Rebuild Workflow](#delete--rebuild-workflow)
- [Removing images in use by containers](#removing-images-in-use-by-containers)

## Introduction

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
# Use Alpine for smaller image size
FROM node:18-alpine

# Create app directory
WORKDIR /usr/src/app

# Copy package files first for better caching
COPY package.json yarn.lock ./

# Install dependencies
RUN yarn install --production --frozen-lockfile

# Copy app source
COPY . .

# Create non-root user for security
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nodejs -u 1001
USER nodejs

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD node -e "http.get('http://localhost:3000/', (res) => { process.exit(res.statusCode === 200 ? 0 : 1) })"

# Start app
CMD ["node", "src/server.js"]
```

## Building an image

```bash
# Build the Docker image and tag it as my-node-app:1.0
docker build -t my-node-app:1.0 .

# Run a container from the image, mapping port 3000 in the container to port 3000 on the host
docker run -d -p 3000:3000 my-node-app:1.0

docker logs <container_id>
```

## Dangling images

A dangling image is an image that is not tagged and is not referenced by any container.
These images are usually created during the build process when a new image is built and the previous image is no longer needed.

**When images become dangling:**

- Failed builds leave intermediate layers
- Rebuilding with same tag orphans old version
- Manually untagging: docker rmi `<tag>` (keeps image, removes tag)

```bash
docker images
# REPOSITORY   TAG     IMAGE ID     SIZE
# <none>      <none>   abc123def    500MB  ← Dangling
# myapp       latest   xyz789abc    200MB  ← Not dangling

docker image prune >> delete dangling images  # (safe)
docker image prune -a >> delete all images without at least one container associated to them  # (aggressive)
```

## Delete & Rebuild Workflow

```bash
# List images
docker images

# Delete specific image
docker rmi <image-id-or-name> || docker rmi image-name:tag

# Delete all unused images (careful!)
docker image prune -a
# What gets deleted:
    # - Images not referenced by any container
    # - All build cache layers
    # - Images from other projects you might want to keep

# Why "careful":
    # - You'll lose images for other projects
    # - Need to rebuild everything from scratch
    # - Can delete images you didn't mean to

# See what would be deleted first
docker images --filter "dangling=true"

# Delete dangling images
docker image prune

# Delete all images without at least one container associated to them
docker image prune -a

# Get help
docker image prune --help

# Rebuild with .dockerignore
docker build -t myapp .
```

## Removing images in use by containers

```bash
docker rmi my-node-app:1.0

# PS C:\Users\Admin\Desktop\Projects\research> docker rmi my-node-app:1.0
# Error response from daemon: conflict: unable to delete my-node-app:1.0 (must be forced) - container bb8bc331c77a is using its referenced image 3548ded0da23

# PS C:\Users\Admin\Desktop\Projects\research> docker ps
# CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

# PS C:\Users\Admin\Desktop\Projects\research> docker ps -a
# CONTAINER ID   IMAGE               COMMAND                  CREATED        STATUS                    PORTS     NAMES
# d2a93cdbb463   my-node-app:1.0     "docker-entrypoint.s…"   26 hours ago   Exited (1) 25 hours ago             competent_noyce
# bb8bc331c77a   my-node-app:1.0     "docker-entrypoint.s…"   26 hours ago   Exited (1) 26 hours ago             eager_fermat
# dd8f4d3b34df   nginx:1.29          "/docker-entrypoint.…"   28 hours ago   Exited (0) 25 hours ago             webserver
# 7622b42383c6   nginx:1.28-alpine   "/docker-entrypoint.…"   28 hours ago   Exited (0) 28 hours ago             nervous_meitner
# 36d6dcdbb917   nginx:1.28-alpine   "/docker-entrypoint.…"   28 hours ago   Exited (0) 28 hours ago             sad_wozniak
# a9a26168b8d1   nginx:1.29          "/docker-entrypoint.…"   28 hours ago   Exited (0) 28 hours ago             vibrant_gagarin
# 6584a17a7891   nginx:1.29          "/docker-entrypoint.…"   28 hours ago   Exited (0) 28 hours ago             cool_cohen

# Remove the two containers using your image
docker rm bb8bc331c77a d2a93cdbb463

# Now remove the image
docker rmi my-node-app:1.0

# PS C:\Users\Admin\Desktop\Projects\research> docker rmi my-node-app:1.0
# Untagged: my-node-app:1.0
# Deleted: sha256:3548ded0da232a16fe5b62acd7ac1c23fc15ee8d7c5a39c6638e7d54cec9c736

# ==========================================

# Or remove all stopped containers at once
docker container prune
docker rmi my-node-app:1.0
```

## Removing images in use by containers (Order matters)

```bash
# Order: Container first, then image

# docker rm <container_id>
# docker rmi <image_name:tag>

# Images can't be deleted while containers (even stopped ones) reference them. Docker will throw an error if you try.


# Delete specific container
docker rm <container_id>
# Example: docker rm 20fdce3280b9

# Delete specific image
docker rmi <image_name:tag>
# Example: docker rmi nginx:1.29

# Bulk operations
docker container prune    # Remove all stopped containers
docker image prune        # Remove dangling images
docker image prune -a      # Remove all unused images
```

[Back to Top](#docker)
