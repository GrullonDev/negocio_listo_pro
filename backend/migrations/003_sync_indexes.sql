-- Migration 003: Add indexes for cursor-based sync pulls
-- Run with: psql -U negociolisto -d negociolisto_dev -f migrations/003_sync_indexes.sql

BEGIN;

CREATE INDEX IF NOT EXISTS idx_transactions_updated ON transactions(tenant_id, updated_at ASC);
CREATE INDEX IF NOT EXISTS idx_bookings_updated ON bookings(tenant_id, updated_at ASC);
CREATE INDEX IF NOT EXISTS idx_customers_updated ON customers(tenant_id, updated_at ASC);
CREATE INDEX IF NOT EXISTS idx_coupons_updated ON coupons(tenant_id, updated_at ASC);

COMMIT;
