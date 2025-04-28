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
