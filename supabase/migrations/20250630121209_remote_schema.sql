create policy "自分のレコードのみDELETE可能"
on "public"."memos"
as permissive
for delete
to public
using ((user_id = auth.user_id()));


create policy "自分のレコードのみUPDATE可能"
on "public"."memos"
as permissive
for update
to public
using ((user_id = auth.user_id()));



