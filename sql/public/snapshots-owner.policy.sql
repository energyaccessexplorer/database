--
-- Name: snapshots owner; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY owner ON public.snapshots USING (( SELECT (EXISTS ( SELECT 1
           FROM public.sessions
          WHERE ((sessions."time" = snapshots.session_id) AND (sessions.user_id = public.current_user_id())))) AS "exists"));
