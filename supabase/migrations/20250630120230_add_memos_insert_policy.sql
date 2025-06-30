create policy "自分のレコードのみINSERT可能"
on "public"."memos"
as permissive
for insert
to public
with check ((user_id = auth.user_id()));



