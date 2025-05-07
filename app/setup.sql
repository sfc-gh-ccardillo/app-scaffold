-- App Roles
CREATE APPLICATION ROLE IF NOT EXISTS app_public;

-- App Schemas
CREATE SCHEMA IF NOT EXISTS core;
GRANT USAGE ON SCHEMA core TO APPLICATION ROLE app_public;

CREATE SCHEMA IF NOT EXISTS setup;

CREATE SCHEMA IF NOT EXISTS services;
GRANT USAGE ON SCHEMA services TO APPLICATION ROLE app_public;

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

        CALL setup.start_frontend(:pool_name);
        CALL setup.start_backend(:pool_name);

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

CREATE OR REPLACE PROCEDURE setup.start_frontend(pool_name VARCHAR)
    RETURNS string
    LANGUAGE sql
    AS $$
BEGIN
    CREATE SERVICE IF NOT EXISTS services.frontend
        IN COMPUTE POOL IDENTIFIER(:pool_name)
        FROM SPECIFICATION_FILE='svc/frontend.yml';
        -- EXTERNAL_ACCESS_INTEGRATIONS=( reference('WIKIPEDIA_EAI') );
    
    GRANT USAGE ON SERVICE services.frontend TO APPLICATION ROLE app_public;
    GRANT SERVICE ROLE services.frontend!ALL_ENDPOINTS_USAGE TO APPLICATION ROLE app_public;

    RETURN 'Service started. Check status, and when ready, get URL';
END
$$;

CREATE OR REPLACE PROCEDURE setup.start_backend(pool_name VARCHAR)
    RETURNS string
    LANGUAGE sql
    AS $$
BEGIN
    CREATE SERVICE IF NOT EXISTS services.backend
        IN COMPUTE POOL IDENTIFIER(:pool_name)
        FROM SPECIFICATION_FILE='svc/backend.yml';

    RETURN 'Service started.';
END
$$;
