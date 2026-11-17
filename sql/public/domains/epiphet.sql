create domain "public"."epiphet" as name constraint "epiphet_check"
  check ((VALUE ~ '^[a-z][a-z0-9\-]+$'::text));
