# Variables you will need to change
snow_conn_name = svc_cc
registry_host = sfsenorthamerica-demo-ccardillo.registry.snowflakecomputing.com

# Variables that do not need to change
repository_db_name = dev
repository_schema_name = devops
repository_name = img
repository_url = ${registry_host}/${repository_db_name}/${repository_schema_name}/${repository_name}
img_tag_nginx = nginx:latest
img_tag_frontend = frontend:latest
img_tag_backend = backend:latest
compute_pool_name = pool
warehouse_name = wh

repo-login:
	snow spcs image-registry token \
    --connection ${snow_conn_name} \
    --format=JSON | \
    docker login ${registry_host} \
      --username 0sessiontoken \
      --password-stdin

create-objects:
	snow sql -q "CREATE DATABASE IF NOT EXISTS ${repository_db_name}"
	snow sql -q "CREATE SCHEMA IF NOT EXISTS ${repository_db_name}.${repository_schema_name}"
	snow sql -q "CREATE IMAGE REPOSITORY IF NOT EXISTS ${repository_db_name}.${repository_schema_name}.${repository_name}"

create-compute:
	snow sql -q "CREATE COMPUTE POOL IF NOT EXISTS ${compute_pool_name} INSTANCE_FAMILY=CPU_X64_M MIN_NODES=1 MAX_NODES=1"
	snow sql -q "CREATE WAREHOUSE IF NOT EXISTS ${warehouse_name} WAREHOUSE_SIZE=MEDIUM"

build-frontend:
	docker build --platform=linux/amd64 -t ${img_tag_frontend} ./img/frontend
	docker tag ${img_tag_frontend} ${repository_url}/${img_tag_frontend}

build-nginx:
	docker build --platform=linux/amd64 -t ${img_tag_nginx} ./img/nginx
	docker tag ${img_tag_nginx} ${repository_url}/${img_tag_nginx}

build-backend:
	docker build --platform=linux/amd64 -t ${img_tag_backend} ./img/backend
	docker tag ${img_tag_backend} ${repository_url}/${img_tag_backend}

build-all: build-frontend build-backend build-nginx

push-frontend:
	docker push ${repository_url}/${img_tag_frontend}

push-nginx:
	docker push ${repository_url}/${img_tag_nginx}

push-backend:
	docker push ${repository_url}/${img_tag_backend}

push-all: repo-login push-frontend push-backend push-nginx

teardown-compute:
	snow sql -q "DROP COMPUTE POOL IF EXISTS ${compute_pool_name}"
	snow sql -q "DROP WAREHOUSE IF EXISTS ${warehouse_name}"

