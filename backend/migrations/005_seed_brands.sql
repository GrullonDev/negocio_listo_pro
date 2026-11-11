-- Migration 005: Seed default brand presets (idempotent)

BEGIN;

INSERT INTO brands (brand_key, display_name, tagline, primary_color, secondary_color, currency_code, currency_symbol)
VALUES
  ('default', 'NegocioListo Pro', 'Tu negocio, organizado y en crecimiento', '#00236F', '#006C49', 'GTQ', 'Q'),
  ('salon', 'Studio Bella', 'Belleza y cuidado personal', '#6D1B5E', '#B5838D', 'GTQ', 'Q'),
  ('barberia', 'Barbería El Clásico', 'Estilo desde 1998', '#1F1F1F', '#B8860B', 'GTQ', 'Q'),
  ('clinica', 'Clínica Dental Sonrisa', 'Tu sonrisa en buenas manos', '#006D77', '#83C5BE', 'GTQ', 'Q')
ON CONFLICT (brand_key) DO NOTHING;

COMMIT;
