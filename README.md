# app-scaffold
Starter template for Snowflake Native Applications with SPCS

# Requirements

Ensure you have installed:

- [The Snowflake CLI](https://docs.snowflake.com/en/developer-guide/snowflake-cli/installation/installation)
- [Docker](https://docs.docker.com/engine/install/)

Ensure you have [set up a connection in the Snowflake CLI](https://docs.snowflake.com/en/developer-guide/snowflake-cli/connecting/configure-connections#manage-or-add-your-connections-to-snowflake-with-the-snow-connection-commands).

Find your [image registry host name](https://docs.snowflake.com/en/developer-guide/snowpark-container-services/working-with-registry-repository#image-registry-hostname).

Input your connection name and registry host name to the [Makefile](https://github.com/sfc-gh-ccardillo/app-scaffold/blob/a4d0845ccad447b3a78b2ed36c0ef9fdc2b45218/Makefile#L2-L3) under the `snow_conn_name` and `registry_host` variables, respectively.
