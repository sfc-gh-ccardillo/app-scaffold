#############
# Variables #
#############

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
svc_schema_name = svc
svc_name_frontend = ${repository_db_name}.${svc_schema_name}.frontend
svc_name_backend = ${repository_db_name}.${svc_schema_name}.backend

##############
# Repo Login #
##############

repo-login:
	snow spcs image-registry token \
    --connection ${snow_conn_name} \
    --format=JSON | \
    docker login ${registry_host} \
      --username 0sessiontoken \
      --password-stdin

#################################
# Snowflake Objects and Compute #
#################################

create-objects:
	snow sql -q "CREATE DATABASE IF NOT EXISTS ${repository_db_name}"
	snow sql -q "CREATE SCHEMA IF NOT EXISTS ${repository_db_name}.${repository_schema_name}"
	snow sql -q "CREATE SCHEMA IF NOT EXISTS ${repository_db_name}.${svc_schema_name}"
	snow sql -q "CREATE IMAGE REPOSITORY IF NOT EXISTS ${repository_db_name}.${repository_schema_name}.${repository_name}"

create-compute:
	snow sql -q "CREATE COMPUTE POOL IF NOT EXISTS ${compute_pool_name} INSTANCE_FAMILY=CPU_X64_M MIN_NODES=1 MAX_NODES=1"
	snow sql -q "CREATE WAREHOUSE IF NOT EXISTS ${warehouse_name} WAREHOUSE_SIZE=MEDIUM"

##################
# Image Building #
##################

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

#################
# Image Pushing #
#################

push-frontend:
	docker push ${repository_url}/${img_tag_frontend}

push-nginx:
	docker push ${repository_url}/${img_tag_nginx}

push-backend:
	docker push ${repository_url}/${img_tag_backend}

push-all: repo-login push-frontend push-backend push-nginx

###################
# Deploy Services #
###################

deploy-frontend:
	snow spcs service create ${svc_name_frontend} --compute-pool ${compute_pool_name} --spec-path ./svc/frontend.yml

deploy-backend:
	snow spcs service create ${svc_name_backend} --compute-pool ${compute_pool_name} --spec-path ./svc/backend.yml

deploy-all: deploy-frontend deploy-backend

####################
# Upgrade Services #
####################

upgrade-frontend:
	snow spcs service upgrade ${svc_name_frontend} --spec-path ./svc/frontend.yml

upgrade-backend:
	snow spcs service upgrade ${svc_name_backend} --spec-path ./svc/backend.yml

upgrade-all: upgrade-frontend upgrade-backend

#############
# Endpoints #
#############

endpoints-frontend:
	snow spcs service list-endpoints ${svc_name_frontend}

##################
# App Development#
##################

app-dev-run:
	snow app run

app-dev-teardown:
	snow app teardown

############
# Teardown #
############

teardown-frontend:
	snow spcs service drop ${svc_name_frontend}

teardown-backend:
	snow spcs service drop ${svc_name_backend}

teardown-services: teardown-frontend teardown-backend

teardown-compute:
	snow sql -q "DROP COMPUTE POOL IF EXISTS ${compute_pool_name}"
	snow sql -q "DROP WAREHOUSE IF EXISTS ${warehouse_name}"
