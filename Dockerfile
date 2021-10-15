FROM crcastle/heroku-app-builder:20 AS build

# The build image will perform the following steps
# 1. Copy the contents of the directory containing this Dockerfile to a Docker image
# 2. Within a container, detect the language and build the app using the appropriate Heroku buildpack

# For running the app, we use a clean base image and also one without Ubuntu development packages
# https://devcenter.heroku.com/articles/heroku-20-stack#heroku-20-docker-image
FROM crcastle/heroku-app-runner:20 AS run

# Copy build artifacts to runtime image
COPY --from=build --chown=1000:1000 /render /render/
COPY --from=build --chown=1000:1000 /app /app/

# Switch to non-root user
USER 1000:1000
WORKDIR /app

# Source all /app/.profile.d/*.sh files before process start
# https://devcenter.heroku.com/articles/buildpack-api#profile-d-scripts
ENTRYPOINT [ "/render/start" ]

# 3. By default, run the 'web' process type defined in the app's Procfile
# You may override the process type that is run by replacing 'web' with another
# process type name in the CMD line below. That process type must
# be defined in the app's Procfile.
CMD [ "/render/process/web" ]