-- App Roles
CREATE APPLICATION ROLE IF NOT EXISTS app_public;

-- App Schemas
CREATE OR ALTER VERSIONED SCHEMA core;
GRANT USAGE ON SCHEMA core TO APPLICATION ROLE app_public;

CREATE OR ALTER VERSIONED SCHEMA setup;

-- Streamlit
CREATE OR REPLACE STREAMLIT core.ui
     FROM '/streamlit/'
     MAIN_FILE = 'ui.py';

GRANT USAGE ON STREAMLIT core.ui TO APPLICATION ROLE app_public;

-- Create Services
CREATE OR REPLACE PROCEDURE setup.create_services(privileges ARRAY)
RETURNS VARCHAR 
LANGUAGE SQL
EXECUTE AS OWNER
AS $$
    BEGIN
        LET pool_name := (SELECT current_database()) || '_app_pool';

        create compute pool if not exists identifier(:pool_name)
            MIN_NODES = 1
            MAX_NODES = 1
            INSTANCE_FAMILY = CPU_X64_M;

     --    create service if not exists services.spcs_na_service
     --        in compute pool identifier(:pool_name)
     --        from spec='service_spec.yml';

     --    grant usage on service services.spcs_na_service
     --        to application role app_public;

     --    create or replace function services.echo(payload varchar)
     --        returns varchar
     --        service = services.spcs_na_service
     --        endpoint = 'my-endpoint'
     --        max_batch_rows = 50
     --        AS '/echo';

     --    grant usage on function services.echo(varchar)
     --        to application role app_public;

        return 'Done';
    end;
$$;
