create table images (
  id bigserial primary key not null,
  label string not null,
  tags jsonb,
  pass text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);