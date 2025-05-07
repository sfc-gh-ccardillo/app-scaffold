# app-scaffold
Starter template for Snowflake Native Applications with SPCS

# Requirements

Ensure you have installed:

- [The Snowflake CLI](https://docs.snowflake.com/en/developer-guide/snowflake-cli/installation/installation)
- [Docker](https://docs.docker.com/engine/install/)

Ensure you have [set up a connection in the Snowflake CLI](https://docs.snowflake.com/en/developer-guide/snowflake-cli/connecting/configure-connections#manage-or-add-your-connections-to-snowflake-with-the-snow-connection-commands).

Find your [image registry host name](https://docs.snowflake.com/en/developer-guide/snowpark-container-services/working-with-registry-repository#image-registry-hostname).

Input your connection name and registry host name to the [Makefile](https://github.com/sfc-gh-ccardillo/app-scaffold/blob/04cb2a5671cc15a43e2eb29e829dcec9c2c906b3/Makefile#L6-L7) under the `snow_conn_name` and `registry_host` variables, respectively.

You can test that the above is set correctly by opening a terminal in the root of this projet and running the Make command `make repo-login`. After a few seconds, you should see `Login Succeeded`.

# Create Objects

Regardless of whether you will be developing a native application with SPCS containers or pure SPCS, you will need somewhere to house your images. In Snowflake, an image repository is stored in a database schema.

To create a database, schema, and image repository, run the `make create-objects` command in your terminal.

# SPCS Development

## Creating Compute

A compute pool is required to deploy your containers/services. Sometimes, if your containers interact with data that lives in Snowflake, a compute warehouse may also be required.

To create a compute pool and compute warehouse for development, run the `make create-compute` command in your terminal.

## Image Overview

There are three images in the `img` folder:

- `nginx` - A router that will act as the single point of ingress for both the frontend and backend containers. The frontend container will never call the backend container directly. Instead the frontend will ping the router to get responses back from the backend.
- `frontend` - A Flask server to which where requests are routed by the router. This frontend could easily run React, Vue, etc. instead.
- `backend` - A Flask server that is receiving requests from the frontend/router. It also illustrates how to connect and query underlying Snowflake data.

## Building Images
**`make build-all`**

To build all images in the `img` folder, run the `make build-all` command in your terminal.

There are also per-image build commands if you need (e.g. `make build-frontend`).

## Pushing Images
**`make push-all`**

To push images in the `img` folder after building them, run the `make push-all` command in your terminal.

There are also per-image push commands if you need (e.g. `make push-frontend`).

## Deploying Services
**`make deploy-all`**

Service definition files are located in the `svc` folder. These service definitions used to specify which images should be associated with which services and specify endpoints for each service. Service specifications can cover a lot, and you can see the [full reference docs](https://docs.snowflake.com/en/developer-guide/snowpark-container-services/specification-reference) for more details. 

Now that the images are in the repository because `make build-all` and `make push-all` have been ran, run `make deploy-all` to deploy the frontend service (which includes both the nginx and frontend containers) and the backend service (which contains just the backend container).

## Endpoints
**`make endpoints-frontend`**

To get URL for the nginx container, run the `make endpoints-frontend` command in your terminal.

You can use this URL in your browser to access this container.

## Routes

Upon signing in, you will receive a "hello" message from the frontend container.

To have the frontend call the backend, you can use one of two routes:

- `/hello` - This [provides a "hello" message](https://github.com/sfc-gh-ccardillo/app-scaffold/blob/f76373c80458c494cbe062dea889b2743e30d55c/img/backend/app.py#L21) from the backend container.
- `/query` - This [provides the result](https://github.com/sfc-gh-ccardillo/app-scaffold/blob/f76373c80458c494cbe062dea889b2743e30d55c/img/backend/app.py#L25-L26) of a `SELECT CURRENT_USER() query` executed by the backend container. (The backend container [uses this code](https://github.com/sfc-gh-ccardillo/app-scaffold/blob/f76373c80458c494cbe062dea889b2743e30d55c/img/backend/app.py#L6-L15) to establish a connection with the underlying Snowflake account)

## Upgrading Services
**`make upgrade all`**

If you make changes to an image or your images, you can build (`make build-all`), push (`make push-all`), and finally upgrade (`make upgrade-all`) to reflect the changes. Note that you don't have to upgrade the image tag (currently set to `latest`) to have the changes reflected.

## Teardown
**`make teardown-services`**

**`make teardown-compute`**

To drop the frontend and backend services, run the `make teardown-services` command in your terminal.

To drop the compute resources previously created, run the `make teardown-compute` command in your terminal.

# App Development

## Run/Upgrade App
**`make app-dev-run`**

To create the application for development purposes, you can run `make app-dev-run`. After the application is running, the same command can be used to futher iterate on the application. For example, if you launch the app and change the Streamlit, you can just run `make app-dev-run` again and see your changes reflected in the existing application.

## Teardown App
**`make app-dev-teardown`**

To teardown the app, you can run `make app-dev-teardown`. For consistency's sake, `make teardown-app` is also an available command for tearing down the application.
