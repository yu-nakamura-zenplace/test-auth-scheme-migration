-- Create app_auth schema for custom authentication functions
-- CREATE SCHEMA IF NOT EXISTS app_auth;

-- Grant usage on schema to authenticated and anon roles
-- GRANT USAGE ON SCHEMA app_auth TO authenticated, anon;

-- Create user_id function in auth schema
CREATE OR REPLACE FUNCTION auth.user_id() RETURNS int8 AS $$
  --- JWT の claims から "user" キーのオブジェクト内の "user_id" の値を取得
  SELECT (cast(((current_setting('request.jwt.claims'::text, true))::json #>> '{user, user_id}')::text as int8));
$$ language SQL stable;

-- Create user_type_code function in auth schema
CREATE OR REPLACE FUNCTION auth.user_type_code() RETURNS text AS $$
  --- JWT の claims から "user" キーのオブジェクト内の "user_type_code" の値を取得
  SELECT (((current_setting('request.jwt.claims'::text, true))::json #>> '{user, user_type_code}')::text);
$$ language SQL stable;

-- Create is_member function in auth schema
CREATE OR REPLACE FUNCTION auth.is_member() RETURNS boolean AS $$
  --- JWT の claims から "user" キーのオブジェクト内の "user_type_code" の値を取得
  SELECT CASE
    WHEN ((auth.jwt()::jsonb #>> '{user, user_type_code}')::text) IN
         ('member', 'guest') THEN TRUE
    ELSE FALSE
  END;
$$ language SQL stable;

-- Create is_employee function in auth schema
CREATE OR REPLACE FUNCTION auth.is_employee() RETURNS boolean AS $$
  --- JWT の claims から "user" キーのオブジェクト内の "user_type_code" の値を取得
  SELECT CASE
    WHEN ((auth.jwt()::jsonb #>> '{user, user_type_code}')::text) IN
         ('system_manager', 'supervisor', 'management_staff', 'general_staff', 'system_user', 'analysis_system_user') THEN TRUE
    ELSE FALSE
  END;
$$ language SQL stable;

