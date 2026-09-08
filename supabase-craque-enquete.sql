-- ============================================================
-- II COPA BABA DOS COROAS — Craque da Rodada + Enquete do Campeão
-- COMO APLICAR: Supabase Dashboard → SQL Editor → colar → Run.
-- ============================================================

-- 1) CRAQUE DA RODADA — 1 voto por aparelho POR RODADA
create table if not exists public.copa_craque_votos (
  id bigint generated always as identity primary key,
  device_id text not null,
  rodada int not null,
  jogador text not null,
  time text not null,
  created_at timestamptz not null default now(),
  unique (device_id, rodada)  -- trava: mesmo aparelho vota 1x por rodada
);
create index if not exists copa_craque_rodada_idx on public.copa_craque_votos (rodada);

-- 2) ENQUETE "QUEM VAI SER O CAMPEÃO" — 1 voto por aparelho (total)
create table if not exists public.copa_enquete_campeao (
  device_id text primary key,            -- trava: 1 voto por aparelho
  time text not null,
  created_at timestamptz not null default now()
);

-- ---------- Segurança (RLS) ----------
alter table public.copa_craque_votos enable row level security;
alter table public.copa_enquete_campeao enable row level security;

-- Todo mundo pode LER (para mostrar os resultados ao vivo)
drop policy if exists copa_craque_select on public.copa_craque_votos;
create policy copa_craque_select on public.copa_craque_votos
  for select using (true);

drop policy if exists copa_enquete_select on public.copa_enquete_campeao;
create policy copa_enquete_select on public.copa_enquete_campeao
  for select using (true);

-- Qualquer visitante pode VOTAR (a trava de 1x é o índice único acima)
drop policy if exists copa_craque_insert on public.copa_craque_votos;
create policy copa_craque_insert on public.copa_craque_votos
  for insert with check (true);

drop policy if exists copa_enquete_insert on public.copa_enquete_campeao;
create policy copa_enquete_insert on public.copa_enquete_campeao
  for insert with check (true);
