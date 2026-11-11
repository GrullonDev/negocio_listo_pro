-- Migration 004: Global Super Admin and platform management tables
-- Adds platform_users, brands, platform_audit_logs; extends tenants.

BEGIN;

-- Platform-level users (global admins, separate from tenant users)
CREATE TABLE IF NOT EXISTS platform_users (
  id                   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name                 TEXT NOT NULL,
  email                TEXT NOT NULL UNIQUE,
  password_hash        TEXT NOT NULL,
  role                 TEXT NOT NULL DEFAULT 'super_admin'
                         CHECK (role IN ('super_admin')),
  is_active            BOOLEAN NOT NULL DEFAULT true,
  must_change_password BOOLEAN NOT NULL DEFAULT false,
  created_at           TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at           TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Brands (white-label configurations stored in DB)
CREATE TABLE IF NOT EXISTS brands (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  brand_key        TEXT NOT NULL UNIQUE,
  display_name     TEXT NOT NULL,
  tagline          TEXT NOT NULL DEFAULT '',
  primary_color    TEXT NOT NULL DEFAULT '#00236F',
  secondary_color  TEXT NOT NULL DEFAULT '#006C49',
  background_color TEXT NOT NULL DEFAULT '#FFFFFF',
  currency_code    TEXT NOT NULL DEFAULT 'GTQ',
  currency_symbol  TEXT NOT NULL DEFAULT 'Q',
  logo_reference   TEXT,
  is_active        BOOLEAN NOT NULL DEFAULT true,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Extend tenants with brand association and management fields
ALTER TABLE tenants
  ADD COLUMN IF NOT EXISTS brand_id    UUID REFERENCES brands(id),
  ADD COLUMN IF NOT EXISTS status      TEXT NOT NULL DEFAULT 'active'
    CHECK (status IN ('active', 'suspended', 'inactive')),
  ADD COLUMN IF NOT EXISTS created_by  UUID REFERENCES platform_users(id);

-- Platform audit log
CREATE TABLE IF NOT EXISTS platform_audit_logs (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  actor_id    UUID NOT NULL REFERENCES platform_users(id),
  action      TEXT NOT NULL,
  target_type TEXT NOT NULL,
  target_id   TEXT,
  metadata    JSONB,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_platform_audit_logs_actor
  ON platform_audit_logs(actor_id);
CREATE INDEX IF NOT EXISTS idx_platform_audit_logs_created
  ON platform_audit_logs(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_brands_key
  ON brands(brand_key);
CREATE INDEX IF NOT EXISTS idx_tenants_status
  ON tenants(status);

COMMIT;
