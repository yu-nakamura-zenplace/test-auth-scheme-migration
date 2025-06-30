/*
 JWT から user_id を取得する
 */
CREATE OR REPLACE FUNCTION auth.user_id() RETURNS int8 AS $$
  --- JWT の claims から "user" キーのオブジェクト内の "user_id" の値を取得
  SELECT (cast(((current_setting('request.jwt.claims'::text, true))::json #>> '{user, user_id}')::text as int8));
$$ language SQL stable;

/*
 JWT から user_type_code を取得する
 */
CREATE OR REPLACE FUNCTION auth.user_type_code() RETURNS text AS $$
  --- JWT の claims から "user" キーのオブジェクト内の "user_type_code" の値を取得
  SELECT (((current_setting('request.jwt.claims'::text, true))::json #>> '{user, user_type_code}')::text);
$$ language SQL stable;

/*
 JWT から member かどうかを判定する関数
 */
CREATE OR REPLACE FUNCTION auth.is_member() RETURNS boolean AS $$
  --- JWT の claims から "user" キーのオブジェクト内の "user_type_code" の値を取得
  SELECT CASE
    WHEN ((auth.jwt()::jsonb #>> '{user, user_type_code}')::text) IN
         ('member', 'guest') THEN TRUE
    ELSE FALSE
  END;
$$ language SQL stable;

/*
 JWT から employee かどうかを判定する関数
 */
CREATE OR REPLACE FUNCTION auth.is_employee() RETURNS boolean AS $$
  --- JWT の claims から "user" キーのオブジェクト内の "user_type_code" の値を取得
  SELECT CASE
    WHEN ((auth.jwt()::jsonb #>> '{user, user_type_code}')::text) IN
         ('system_manager', 'supervisor', 'management_staff', 'general_staff', 'system_user', 'analysis_system_user') THEN TRUE
    ELSE FALSE
  END;
$$ language SQL stable;
