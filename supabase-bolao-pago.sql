-- ============================================================
-- II COPA BABA DOS COROAS — Bolão PAGO por jogo
-- COMO APLICAR: Supabase Dashboard → SQL Editor → colar → Run.
-- (roda em cima das tabelas que já existem)
-- ============================================================

-- 1) Campos novos: contato e confirmação de pagamento
alter table public.copa_palpites
  add column if not exists whatsapp text,
  add column if not exists pago boolean not null default false;

-- 2) SEGURANÇA: visitante só consegue inserir palpite NÃO pago.
--    (impede alguém se marcar como pago sem pagar)
drop policy if exists copa_palpites_insert on public.copa_palpites;
create policy copa_palpites_insert on public.copa_palpites
  for insert with check (pago = false);

-- 3) Só o ADMIN confirma pagamento (update) e remove palpite (delete)
drop policy if exists copa_palpites_admin_update on public.copa_palpites;
create policy copa_palpites_admin_update on public.copa_palpites
  for all using (public.is_admin()) with check (public.is_admin());

-- 4) Índice para o painel carregar rápido
create index if not exists copa_palpites_pago_idx on public.copa_palpites (jogo_id, pago);
