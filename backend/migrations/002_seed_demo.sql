-- Migration 002: Demo seed data
-- Only run in development environments.
-- Password for demo accounts is 'demo1234' hashed with bcrypt.

BEGIN;

-- Demo tenant
INSERT INTO tenants (id, name, business_type, currency_code)
VALUES ('00000000-0000-0000-0000-000000000001', 'Negocio Demo', 'salon', 'DOP')
ON CONFLICT (id) DO NOTHING;

-- Demo user (password: demo1234)
-- The bcrypt hash below corresponds to 'demo1234'.
-- Generate with: DBCrypt().hashpw('demo1234', DBCrypt().gensalt())
-- Placeholder hash — will be generated at runtime by the seed script.
INSERT INTO users (id, tenant_id, name, email, password_hash, role)
VALUES (
  '00000000-0000-0000-0000-000000000002',
  '00000000-0000-0000-0000-000000000001',
  'Usuario Demo',
  'demo@negociolisto.pro',
  '$2b$10$placeholder_generate_at_runtime',
  'owner'
)
ON CONFLICT (tenant_id, email) DO NOTHING;

-- Demo customers
INSERT INTO customers (id, tenant_id, name, phone, points, tier) VALUES
  ('00000000-0000-0000-0000-c00000000001', '00000000-0000-0000-0000-000000000001', 'María Fernández', '809-555-0101', 1240, 'platinum'),
  ('00000000-0000-0000-0000-c00000000002', '00000000-0000-0000-0000-000000000001', 'Ana Lucía Peña', '829-555-0142', 860, 'gold'),
  ('00000000-0000-0000-0000-c00000000003', '00000000-0000-0000-0000-000000000001', 'Carlos Rodríguez', '849-555-0118', 520, 'gold'),
  ('00000000-0000-0000-0000-c00000000004', '00000000-0000-0000-0000-000000000001', 'Laura Jiménez', '809-555-0177', 640, 'gold'),
  ('00000000-0000-0000-0000-c00000000005', '00000000-0000-0000-0000-000000000001', 'Rosa Hernández', '829-555-0125', 310, 'silver'),
  ('00000000-0000-0000-0000-c00000000006', '00000000-0000-0000-0000-000000000001', 'Pedro Almonte', '809-555-0184', 60, 'bronze')
ON CONFLICT (id) DO NOTHING;

-- Demo coupons
INSERT INTO coupons (id, tenant_id, code, discount_type, value, max_uses, current_uses, expiration_date) VALUES
  ('00000000-0000-0000-0000-d00000000001', '00000000-0000-0000-0000-000000000001', 'BIENVENIDA15', 'percentage', 15, 100, 23, now() + interval '60 days'),
  ('00000000-0000-0000-0000-d00000000002', '00000000-0000-0000-0000-000000000001', 'REFIERE500', 'fixed_amount', 500, 30, 7, now() + interval '90 days')
ON CONFLICT (tenant_id, code) DO NOTHING;

COMMIT;
