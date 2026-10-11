
-- ============================================================
-- ZIC Mart POS - Database Schema Clone (structure only)
-- Source project: ivczucpqxwwthhyzphix
-- Generated: 2026-10-11 (from live database catalog)
-- Run top-to-bottom in a NEW Supabase project's SQL editor.
-- Supabase provides the `auth` schema; do NOT create it.
-- ============================================================

create extension if not exists pgcrypto;

-- ------------------------------------------------------------
-- Types / enums
-- ------------------------------------------------------------
create type public.app_role as enum ('admin', 'cashier');

-- ------------------------------------------------------------
-- Tables
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.bill_sequences (
  date_key text NOT NULL,
  prefix text NOT NULL,
  last_seq integer DEFAULT 0 NOT NULL
);

CREATE TABLE IF NOT EXISTS public.cash_sessions (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  user_id uuid NOT NULL,
  user_name text DEFAULT ''::text NOT NULL,
  opening_cash numeric DEFAULT 0 NOT NULL,
  closing_cash numeric,
  cash_sales numeric DEFAULT 0 NOT NULL,
  expected_cash numeric DEFAULT 0 NOT NULL,
  difference numeric,
  status text DEFAULT 'open'::text NOT NULL,
  opened_at timestamp with time zone DEFAULT now() NOT NULL,
  closed_at timestamp with time zone,
  online_sales numeric DEFAULT 0 NOT NULL,
  cash_paid_out numeric DEFAULT 0 NOT NULL,
  expenses numeric DEFAULT 0 NOT NULL
);

CREATE TABLE IF NOT EXISTS public.categories (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  name text NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.customer_feedback (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  name text,
  contact text,
  rating smallint,
  category text DEFAULT 'general'::text NOT NULL,
  message text NOT NULL,
  status text DEFAULT 'new'::text NOT NULL,
  admin_notes text,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.daily_expenses (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  entry_date date NOT NULL,
  cash_junaid numeric DEFAULT 0 NOT NULL,
  cash_usama numeric DEFAULT 0 NOT NULL,
  others numeric DEFAULT 0 NOT NULL,
  counter_cash numeric DEFAULT 0 NOT NULL,
  today_expenses numeric DEFAULT 0 NOT NULL,
  created_by uuid,
  created_by_name text DEFAULT ''::text NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.inventory_movements (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  product_id uuid NOT NULL,
  unit_id uuid,
  unit_name text DEFAULT ''::text NOT NULL,
  qty_in_unit numeric NOT NULL,
  qty_in_base integer NOT NULL,
  kind text NOT NULL,
  ref_id uuid,
  user_id uuid,
  user_name text DEFAULT ''::text NOT NULL,
  notes text DEFAULT ''::text NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.manual_sale_days (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  entry_date date NOT NULL,
  cash_junaid numeric DEFAULT 0 NOT NULL,
  cash_usama numeric DEFAULT 0 NOT NULL,
  cash_zahid numeric DEFAULT 0 NOT NULL,
  others numeric DEFAULT 0 NOT NULL,
  counter_cash numeric DEFAULT 0 NOT NULL,
  today_expenses_override numeric,
  previous_expense_override numeric,
  notes text DEFAULT ''::text NOT NULL,
  cash_by_person jsonb DEFAULT '{}'::jsonb NOT NULL,
  counter_cash_by text,
  created_by uuid,
  created_by_name text DEFAULT ''::text NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL,
  cash_with_junaid numeric DEFAULT 0 NOT NULL
);

CREATE TABLE IF NOT EXISTS public.manual_sale_persons (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  name text NOT NULL,
  sort_order integer DEFAULT 0 NOT NULL,
  is_active boolean DEFAULT true NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.operating_expenses (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  expense_date date NOT NULL,
  category text DEFAULT 'Miscellaneous'::text NOT NULL,
  description text DEFAULT ''::text NOT NULL,
  amount numeric DEFAULT 0 NOT NULL,
  paid_to text DEFAULT ''::text NOT NULL,
  payment_method text DEFAULT 'cash'::text NOT NULL,
  recorded_by uuid,
  recorded_by_name text DEFAULT ''::text NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.person_payments (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  payment_date date NOT NULL,
  person_name text DEFAULT ''::text NOT NULL,
  amount numeric DEFAULT 0 NOT NULL,
  payment_method text DEFAULT 'cash'::text NOT NULL,
  notes text DEFAULT ''::text NOT NULL,
  recorded_by uuid,
  recorded_by_name text DEFAULT ''::text NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.person_starting_balances (
  person_name text NOT NULL,
  balance numeric DEFAULT 0 NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.price_change_requests (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  product_id uuid NOT NULL,
  product_name text DEFAULT ''::text NOT NULL,
  current_purchase_price numeric DEFAULT 0 NOT NULL,
  current_sale_price numeric DEFAULT 0 NOT NULL,
  requested_purchase_price numeric NOT NULL,
  requested_sale_price numeric NOT NULL,
  reason text DEFAULT ''::text NOT NULL,
  status text DEFAULT 'pending'::text NOT NULL,
  requested_by uuid,
  requested_by_name text DEFAULT ''::text NOT NULL,
  reviewed_by uuid,
  reviewed_by_name text,
  reviewed_at timestamp with time zone,
  review_notes text,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.product_units (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  product_id uuid NOT NULL,
  name text NOT NULL,
  equals_base integer NOT NULL,
  is_base boolean DEFAULT false NOT NULL,
  is_default_sale boolean DEFAULT false NOT NULL,
  sku text,
  barcode text,
  purchase_price numeric DEFAULT 0 NOT NULL,
  sale_price numeric DEFAULT 0 NOT NULL,
  sort_order integer DEFAULT 0 NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.products (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  barcode text NOT NULL,
  name text NOT NULL,
  category_id uuid,
  purchase_price numeric(12,2) DEFAULT 0 NOT NULL,
  sale_price numeric(12,2) DEFAULT 0 NOT NULL,
  stock integer DEFAULT 0 NOT NULL,
  min_stock_alert integer DEFAULT 5 NOT NULL,
  is_active boolean DEFAULT true NOT NULL,
  image_url text,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL,
  base_unit_id uuid
);

CREATE TABLE IF NOT EXISTS public.profiles (
  id uuid NOT NULL,
  full_name text DEFAULT ''::text NOT NULL,
  username text,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  is_active boolean DEFAULT true NOT NULL
);

CREATE TABLE IF NOT EXISTS public.return_items (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  return_id uuid NOT NULL,
  product_id uuid,
  product_name text NOT NULL,
  barcode text DEFAULT ''::text NOT NULL,
  qty integer NOT NULL,
  unit_price numeric NOT NULL,
  subtotal numeric NOT NULL
);

CREATE TABLE IF NOT EXISTS public.returns (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  return_no text NOT NULL,
  original_sale_id uuid NOT NULL,
  original_bill_no text NOT NULL,
  cashier_id uuid NOT NULL,
  cashier_name text DEFAULT ''::text NOT NULL,
  reason text DEFAULT ''::text NOT NULL,
  refund_amount numeric DEFAULT 0 NOT NULL,
  items_count integer DEFAULT 0 NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  status text DEFAULT 'pending'::text NOT NULL,
  approved_by uuid,
  approved_by_name text,
  approved_at timestamp with time zone,
  voided_by uuid,
  voided_by_name text,
  voided_at timestamp with time zone,
  void_reason text
);

CREATE TABLE IF NOT EXISTS public.sale_items (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  sale_id uuid NOT NULL,
  product_id uuid,
  product_name text NOT NULL,
  barcode text DEFAULT ''::text NOT NULL,
  qty integer NOT NULL,
  unit_price numeric(12,2) NOT NULL,
  purchase_price numeric(12,2) DEFAULT 0 NOT NULL,
  subtotal numeric(12,2) NOT NULL,
  unit_id uuid,
  unit_name text,
  qty_in_unit numeric
);

CREATE TABLE IF NOT EXISTS public.sales (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  bill_no text NOT NULL,
  cashier_id uuid NOT NULL,
  cashier_name text DEFAULT ''::text NOT NULL,
  subtotal numeric(12,2) DEFAULT 0 NOT NULL,
  tax_amount numeric(12,2) DEFAULT 0 NOT NULL,
  discount numeric(12,2) DEFAULT 0 NOT NULL,
  total numeric(12,2) DEFAULT 0 NOT NULL,
  cash_received numeric(12,2) DEFAULT 0 NOT NULL,
  change_returned numeric(12,2) DEFAULT 0 NOT NULL,
  payment_type text DEFAULT 'cash'::text NOT NULL,
  items_count integer DEFAULT 0 NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  session_id uuid,
  payment_method text DEFAULT 'cash'::text NOT NULL
);

CREATE TABLE IF NOT EXISTS public.shift_expenses (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  session_id uuid,
  cashier_id uuid,
  cashier_name text DEFAULT ''::text NOT NULL,
  amount numeric DEFAULT 0 NOT NULL,
  description text DEFAULT ''::text NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.stock_entries (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  product_id uuid NOT NULL,
  cashier_id uuid NOT NULL,
  cashier_name text DEFAULT ''::text NOT NULL,
  qty integer NOT NULL,
  notes text,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  status text DEFAULT 'pending'::text NOT NULL,
  approved_by uuid,
  approved_by_name text,
  approved_at timestamp with time zone,
  rejected_by uuid,
  rejected_by_name text,
  rejected_at timestamp with time zone,
  rejection_reason text,
  unit_id uuid,
  unit_name text,
  qty_in_unit numeric
);

CREATE TABLE IF NOT EXISTS public.stock_reconciliations (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  product_id uuid NOT NULL,
  unit_id uuid,
  system_stock numeric DEFAULT 0 NOT NULL,
  physical_stock numeric DEFAULT 0 NOT NULL,
  difference numeric DEFAULT 0 NOT NULL,
  cost_price numeric DEFAULT 0 NOT NULL,
  cost_impact numeric DEFAULT 0 NOT NULL,
  notes text,
  status text DEFAULT 'pending'::text NOT NULL,
  created_by uuid,
  created_by_name text,
  reviewed_by uuid,
  reviewed_by_name text,
  reviewed_at timestamp with time zone,
  review_notes text,
  applied_at timestamp with time zone,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.store_settings (
  id integer DEFAULT 1 NOT NULL,
  store_name text DEFAULT 'ZIC Mart'::text NOT NULL,
  address text DEFAULT 'ZIC Petrol Pump, Murree Road, Abbottabad'::text NOT NULL,
  phone text DEFAULT '0313-5881633'::text NOT NULL,
  tax_rate numeric(5,2) DEFAULT 0 NOT NULL,
  currency text DEFAULT 'Rs.'::text NOT NULL,
  footer_message text DEFAULT 'Thank you for shopping at ZIC Mart!'::text NOT NULL,
  logo_url text,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.supplier_payments (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  supplier_id uuid NOT NULL,
  amount numeric DEFAULT 0 NOT NULL,
  method text DEFAULT 'cash'::text NOT NULL,
  notes text DEFAULT ''::text NOT NULL,
  payment_date date DEFAULT CURRENT_DATE NOT NULL,
  created_by uuid,
  created_by_name text DEFAULT ''::text NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  session_id uuid
);

CREATE TABLE IF NOT EXISTS public.supplier_purchases (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  supplier_id uuid NOT NULL,
  bill_no text DEFAULT ''::text NOT NULL,
  amount numeric DEFAULT 0 NOT NULL,
  description text DEFAULT ''::text NOT NULL,
  purchase_date date DEFAULT CURRENT_DATE NOT NULL,
  created_by uuid,
  created_by_name text DEFAULT ''::text NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.suppliers (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  name text NOT NULL,
  phone text DEFAULT ''::text NOT NULL,
  address text DEFAULT ''::text NOT NULL,
  notes text DEFAULT ''::text NOT NULL,
  is_active boolean DEFAULT true NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.user_audit_log (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  actor_id uuid,
  actor_name text DEFAULT ''::text NOT NULL,
  target_user_id uuid,
  target_user_name text DEFAULT ''::text NOT NULL,
  action text NOT NULL,
  details jsonb DEFAULT '{}'::jsonb NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.user_roles (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  user_id uuid NOT NULL,
  role app_role NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

-- ------------------------------------------------------------
-- Primary keys, unique, check and foreign key constraints
-- ------------------------------------------------------------
ALTER TABLE public.bill_sequences ADD CONSTRAINT bill_sequences_pkey PRIMARY KEY (date_key);
ALTER TABLE public.cash_sessions ADD CONSTRAINT cash_sessions_pkey PRIMARY KEY (id);
ALTER TABLE public.categories ADD CONSTRAINT categories_pkey PRIMARY KEY (id);
ALTER TABLE public.categories ADD CONSTRAINT categories_name_key UNIQUE (name);
ALTER TABLE public.customer_feedback ADD CONSTRAINT customer_feedback_rating_check CHECK (((rating >= 1) AND (rating <= 5)));
ALTER TABLE public.customer_feedback ADD CONSTRAINT customer_feedback_pkey PRIMARY KEY (id);
ALTER TABLE public.daily_expenses ADD CONSTRAINT daily_expenses_pkey PRIMARY KEY (id);
ALTER TABLE public.inventory_movements ADD CONSTRAINT inventory_movements_kind_check CHECK ((kind = ANY (ARRAY['sale'::text, 'return'::text, 'restock'::text, 'initial'::text, 'adjustment'::text])));
ALTER TABLE public.inventory_movements ADD CONSTRAINT inventory_movements_product_id_fkey FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE;
ALTER TABLE public.inventory_movements ADD CONSTRAINT inventory_movements_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES product_units(id) ON DELETE SET NULL;
ALTER TABLE public.inventory_movements ADD CONSTRAINT inventory_movements_pkey PRIMARY KEY (id);
ALTER TABLE public.manual_sale_days ADD CONSTRAINT manual_sale_days_pkey PRIMARY KEY (id);
ALTER TABLE public.manual_sale_days ADD CONSTRAINT manual_sale_days_entry_date_key UNIQUE (entry_date);
ALTER TABLE public.manual_sale_persons ADD CONSTRAINT manual_sale_persons_pkey PRIMARY KEY (id);
ALTER TABLE public.manual_sale_persons ADD CONSTRAINT manual_sale_persons_name_key UNIQUE (name);
ALTER TABLE public.operating_expenses ADD CONSTRAINT operating_expenses_pkey PRIMARY KEY (id);
ALTER TABLE public.person_payments ADD CONSTRAINT person_payments_pkey PRIMARY KEY (id);
ALTER TABLE public.person_starting_balances ADD CONSTRAINT person_starting_balances_pkey PRIMARY KEY (person_name);
ALTER TABLE public.price_change_requests ADD CONSTRAINT price_change_requests_product_id_fkey FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE;
ALTER TABLE public.price_change_requests ADD CONSTRAINT price_change_requests_pkey PRIMARY KEY (id);
ALTER TABLE public.product_units ADD CONSTRAINT product_units_equals_base_check CHECK ((equals_base > 0));
ALTER TABLE public.product_units ADD CONSTRAINT product_units_purchase_price_check CHECK ((purchase_price >= (0)::numeric));
ALTER TABLE public.product_units ADD CONSTRAINT product_units_sale_price_check CHECK ((sale_price >= (0)::numeric));
ALTER TABLE public.product_units ADD CONSTRAINT product_units_product_id_fkey FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE;
ALTER TABLE public.product_units ADD CONSTRAINT product_units_pkey PRIMARY KEY (id);
ALTER TABLE public.products ADD CONSTRAINT products_base_unit_id_fkey FOREIGN KEY (base_unit_id) REFERENCES product_units(id);
ALTER TABLE public.products ADD CONSTRAINT products_category_id_fkey FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL;
ALTER TABLE public.products ADD CONSTRAINT products_pkey PRIMARY KEY (id);
ALTER TABLE public.products ADD CONSTRAINT products_barcode_key UNIQUE (barcode);
ALTER TABLE public.profiles ADD CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;
ALTER TABLE public.profiles ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);
ALTER TABLE public.profiles ADD CONSTRAINT profiles_username_key UNIQUE (username);
ALTER TABLE public.return_items ADD CONSTRAINT return_items_return_id_fkey FOREIGN KEY (return_id) REFERENCES returns(id) ON DELETE CASCADE;
ALTER TABLE public.return_items ADD CONSTRAINT return_items_pkey PRIMARY KEY (id);
ALTER TABLE public.returns ADD CONSTRAINT returns_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'approved'::text, 'voided'::text])));
ALTER TABLE public.returns ADD CONSTRAINT returns_original_sale_id_fkey FOREIGN KEY (original_sale_id) REFERENCES sales(id) ON DELETE RESTRICT;
ALTER TABLE public.returns ADD CONSTRAINT returns_pkey PRIMARY KEY (id);
ALTER TABLE public.returns ADD CONSTRAINT returns_return_no_key UNIQUE (return_no);
ALTER TABLE public.sale_items ADD CONSTRAINT sale_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE SET NULL;
ALTER TABLE public.sale_items ADD CONSTRAINT sale_items_sale_id_fkey FOREIGN KEY (sale_id) REFERENCES sales(id) ON DELETE CASCADE;
ALTER TABLE public.sale_items ADD CONSTRAINT sale_items_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES product_units(id) ON DELETE SET NULL;
ALTER TABLE public.sale_items ADD CONSTRAINT sale_items_pkey PRIMARY KEY (id);
ALTER TABLE public.sales ADD CONSTRAINT sales_cashier_id_fkey FOREIGN KEY (cashier_id) REFERENCES auth.users(id);
ALTER TABLE public.sales ADD CONSTRAINT sales_session_id_fkey FOREIGN KEY (session_id) REFERENCES cash_sessions(id);
ALTER TABLE public.sales ADD CONSTRAINT sales_pkey PRIMARY KEY (id);
ALTER TABLE public.sales ADD CONSTRAINT sales_bill_no_key UNIQUE (bill_no);
ALTER TABLE public.shift_expenses ADD CONSTRAINT shift_expenses_session_id_fkey FOREIGN KEY (session_id) REFERENCES cash_sessions(id);
ALTER TABLE public.shift_expenses ADD CONSTRAINT shift_expenses_pkey PRIMARY KEY (id);
ALTER TABLE public.stock_entries ADD CONSTRAINT stock_entries_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'approved'::text, 'rejected'::text])));
ALTER TABLE public.stock_entries ADD CONSTRAINT stock_entries_cashier_id_fkey FOREIGN KEY (cashier_id) REFERENCES auth.users(id);
ALTER TABLE public.stock_entries ADD CONSTRAINT stock_entries_product_id_fkey FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE;
ALTER TABLE public.stock_entries ADD CONSTRAINT stock_entries_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES product_units(id);
ALTER TABLE public.stock_entries ADD CONSTRAINT stock_entries_pkey PRIMARY KEY (id);
ALTER TABLE public.stock_reconciliations ADD CONSTRAINT stock_reconciliations_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id) ON DELETE SET NULL;
ALTER TABLE public.stock_reconciliations ADD CONSTRAINT stock_reconciliations_product_id_fkey FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE;
ALTER TABLE public.stock_reconciliations ADD CONSTRAINT stock_reconciliations_reviewed_by_fkey FOREIGN KEY (reviewed_by) REFERENCES auth.users(id) ON DELETE SET NULL;
ALTER TABLE public.stock_reconciliations ADD CONSTRAINT stock_reconciliations_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES product_units(id) ON DELETE SET NULL;
ALTER TABLE public.stock_reconciliations ADD CONSTRAINT stock_reconciliations_pkey PRIMARY KEY (id);
ALTER TABLE public.store_settings ADD CONSTRAINT single_row CHECK ((id = 1));
ALTER TABLE public.store_settings ADD CONSTRAINT store_settings_pkey PRIMARY KEY (id);
ALTER TABLE public.supplier_payments ADD CONSTRAINT supplier_payments_session_id_fkey FOREIGN KEY (session_id) REFERENCES cash_sessions(id);
ALTER TABLE public.supplier_payments ADD CONSTRAINT supplier_payments_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES suppliers(id) ON DELETE CASCADE;
ALTER TABLE public.supplier_payments ADD CONSTRAINT supplier_payments_pkey PRIMARY KEY (id);
ALTER TABLE public.supplier_purchases ADD CONSTRAINT supplier_purchases_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES suppliers(id) ON DELETE CASCADE;
ALTER TABLE public.supplier_purchases ADD CONSTRAINT supplier_purchases_pkey PRIMARY KEY (id);
ALTER TABLE public.suppliers ADD CONSTRAINT suppliers_pkey PRIMARY KEY (id);
ALTER TABLE public.user_audit_log ADD CONSTRAINT user_audit_log_pkey PRIMARY KEY (id);
ALTER TABLE public.user_roles ADD CONSTRAINT user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;
ALTER TABLE public.user_roles ADD CONSTRAINT user_roles_pkey PRIMARY KEY (id);
ALTER TABLE public.user_roles ADD CONSTRAINT user_roles_user_id_role_key UNIQUE (user_id, role);

-- ------------------------------------------------------------
-- Indexes
-- ------------------------------------------------------------
CREATE UNIQUE INDEX cash_sessions_one_open_per_user ON public.cash_sessions USING btree (user_id) WHERE (status = 'open'::text);
CREATE INDEX customer_feedback_created_at_idx ON public.customer_feedback USING btree (created_at DESC);
CREATE INDEX customer_feedback_status_idx ON public.customer_feedback USING btree (status);
CREATE INDEX daily_expenses_entry_date_idx ON public.daily_expenses USING btree (entry_date);
CREATE INDEX inv_mov_product_idx ON public.inventory_movements USING btree (product_id, created_at DESC);
CREATE INDEX operating_expenses_date_idx ON public.operating_expenses USING btree (expense_date);
CREATE INDEX person_payments_date_idx ON public.person_payments USING btree (payment_date);
CREATE UNIQUE INDEX product_units_barcode_uniq ON public.product_units USING btree (barcode) WHERE (barcode IS NOT NULL);
CREATE UNIQUE INDEX product_units_name_uniq ON public.product_units USING btree (product_id, lower(name));
CREATE INDEX product_units_product_idx ON public.product_units USING btree (product_id);
CREATE INDEX idx_products_barcode ON public.products USING btree (barcode);
CREATE INDEX idx_products_name ON public.products USING btree (name);
CREATE INDEX idx_returns_status_approved_created ON public.returns USING btree (status, approved_at DESC, created_at DESC);
CREATE INDEX idx_sale_items_product_name ON public.sale_items USING btree (product_name);
CREATE INDEX idx_sale_items_sale ON public.sale_items USING btree (sale_id);
CREATE INDEX idx_sales_created ON public.sales USING btree (created_at DESC);
CREATE INDEX sales_session_id_idx ON public.sales USING btree (session_id);
CREATE INDEX shift_expenses_session_id_idx ON public.shift_expenses USING btree (session_id);
CREATE INDEX idx_stock_entries_cashier ON public.stock_entries USING btree (cashier_id);
CREATE INDEX idx_stock_entries_created ON public.stock_entries USING btree (created_at DESC);
CREATE INDEX idx_stock_entries_product ON public.stock_entries USING btree (product_id);
CREATE INDEX idx_stock_reconciliations_created_at ON public.stock_reconciliations USING btree (created_at DESC);
CREATE INDEX idx_stock_reconciliations_product ON public.stock_reconciliations USING btree (product_id);
CREATE INDEX idx_stock_reconciliations_status ON public.stock_reconciliations USING btree (status);
CREATE INDEX idx_supplier_payments_supplier ON public.supplier_payments USING btree (supplier_id);
CREATE INDEX supplier_payments_session_id_idx ON public.supplier_payments USING btree (session_id);
CREATE INDEX idx_supplier_purchases_supplier ON public.supplier_purchases USING btree (supplier_id);

-- ------------------------------------------------------------
-- Row Level Security
-- ------------------------------------------------------------
alter table public.bill_sequences enable row level security;
alter table public.cash_sessions enable row level security;
alter table public.categories enable row level security;
alter table public.customer_feedback enable row level security;
alter table public.daily_expenses enable row level security;
alter table public.inventory_movements enable row level security;
alter table public.manual_sale_days enable row level security;
alter table public.manual_sale_persons enable row level security;
alter table public.operating_expenses enable row level security;
alter table public.person_payments enable row level security;
alter table public.person_starting_balances enable row level security;
alter table public.price_change_requests enable row level security;
alter table public.product_units enable row level security;
alter table public.products enable row level security;
alter table public.profiles enable row level security;
alter table public.return_items enable row level security;
alter table public.returns enable row level security;
alter table public.sale_items enable row level security;
alter table public.sales enable row level security;
alter table public.shift_expenses enable row level security;
alter table public.stock_entries enable row level security;
alter table public.stock_reconciliations enable row level security;
alter table public.store_settings enable row level security;
alter table public.supplier_payments enable row level security;
alter table public.supplier_purchases enable row level security;
alter table public.suppliers enable row level security;
alter table public.user_audit_log enable row level security;
alter table public.user_roles enable row level security;



-- ------------------------------------------------------------
-- Functions (from live database) [part 1/4]
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.add_stock_entry(_product_id uuid, _qty integer, _notes text DEFAULT NULL::text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
  _cashier_name text;
  _entry_id uuid;
BEGIN
  IF auth.uid() IS NULL THEN RAISE EXCEPTION 'Not authenticated'; END IF;
  IF _qty <= 0 THEN RAISE EXCEPTION 'Quantity must be positive'; END IF;

  SELECT coalesce(full_name, username, 'Cashier') INTO _cashier_name
  FROM public.profiles WHERE id = auth.uid();

  -- Create stock entry record (pending approval, no stock change yet)
  INSERT INTO public.stock_entries(product_id, cashier_id, cashier_name, qty, notes, status)
  VALUES (_product_id, auth.uid(), coalesce(_cashier_name, ''), _qty, _notes, 'pending')
  RETURNING id INTO _entry_id;

  RETURN jsonb_build_object(
    'entry_id', _entry_id,
    'message', 'Stock entry submitted for admin approval',
    'status', 'pending'
  );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.add_stock_entry_v2(_product_id uuid, _unit_id uuid, _qty integer, _notes text DEFAULT NULL::text)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
  _uid uuid := auth.uid();
  _name text;
  _unit_equals int;
  _unit_name text;
  _entry_id uuid;
  _qty_base int;
BEGIN
  IF _uid IS NULL THEN RAISE EXCEPTION 'Not authenticated'; END IF;
  IF NOT (has_role(_uid, 'cashier'::app_role) OR has_role(_uid, 'admin'::app_role)) THEN
    RAISE EXCEPTION 'Not authorized';
  END IF;
  IF _qty IS NULL OR _qty <= 0 THEN RAISE EXCEPTION 'Quantity must be positive'; END IF;

  IF _unit_id IS NOT NULL THEN
    SELECT equals_base, name INTO _unit_equals, _unit_name FROM public.product_units WHERE id = _unit_id AND product_id = _product_id;
  END IF;
  IF _unit_equals IS NULL THEN
    SELECT pu.equals_base, pu.name INTO _unit_equals, _unit_name
    FROM public.products p LEFT JOIN public.product_units pu ON pu.id = p.base_unit_id WHERE p.id = _product_id;
    _unit_equals := COALESCE(_unit_equals, 1); _unit_name := COALESCE(_unit_name, 'Piece');
  END IF;
  _qty_base := _qty * _unit_equals;

  SELECT full_name INTO _name FROM public.profiles WHERE id = _uid;

  INSERT INTO public.stock_entries (product_id, cashier_id, cashier_name, qty, unit_id, unit_name, qty_in_unit, notes, status)
  VALUES (_product_id, _uid, COALESCE(_name,''), _qty_base, _unit_id, _unit_name, _qty, COALESCE(_notes,''), 'pending')
  RETURNING id INTO _entry_id;

  RETURN _entry_id;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.admin_create_user(_email text, _password text, _full_name text, _username text, _role app_role)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public', 'auth', 'extensions'
AS $function$
DECLARE
  _caller_id uuid;
  _caller_name text;
  _new_user_id uuid;
BEGIN
  _caller_id := auth.uid();
  IF _caller_id IS NULL OR NOT public.has_role(_caller_id, 'admin') THEN
    RAISE EXCEPTION 'Only admins can create users';
  END IF;

  SELECT coalesce(full_name, username, 'Admin') INTO _caller_name FROM public.profiles WHERE id = _caller_id;

  IF _email IS NULL OR length(trim(_email)) = 0 THEN
    RAISE EXCEPTION 'Email is required';
  END IF;
  IF _password IS NULL OR length(_password) < 6 THEN
    RAISE EXCEPTION 'Password must be at least 6 characters';
  END IF;

  IF EXISTS (SELECT 1 FROM auth.users WHERE lower(email) = lower(trim(_email))) THEN
    RAISE EXCEPTION 'A user with this email already exists';
  END IF;
  IF EXISTS (SELECT 1 FROM public.profiles WHERE lower(username) = lower(trim(_username))) THEN
    RAISE EXCEPTION 'A user with this username already exists';
  END IF;

  _new_user_id := gen_random_uuid();

  INSERT INTO auth.users (
    id,
    instance_id,
    aud,
    role,
    email,
    encrypted_password,
    email_confirmed_at,
    confirmation_sent_at,
    confirmation_token,
    recovery_token,
    email_change_token_new,
    email_change,
    phone_change,
    phone_change_token,
    email_change_token_current,
    reauthentication_token,
    raw_app_meta_data,
    raw_user_meta_data,
    is_super_admin,
    is_sso_user,
    is_anonymous,
    created_at,
    updated_at
  ) VALUES (
    _new_user_id,
    '00000000-0000-0000-0000-000000000000',
    'authenticated',
    'authenticated',
    lower(trim(_email)),
    extensions.crypt(_password, extensions.gen_salt('bf')),
    now(),
    now(),
    '', '', '', '', '', '', '', '',
    '{"provider":"email","providers":["email"]}'::jsonb,
    jsonb_build_object('full_name', trim(_full_name), 'username', trim(_username)),
    false, false, false,
    now(), now()
  );

  INSERT INTO auth.identities (
    id,
    user_id,
    identity_data,
    provider,
    provider_id,
    last_sign_in_at,
    created_at,
    updated_at
  ) VALUES (
    _new_user_id,
    _new_user_id,
    jsonb_build_object('sub', _new_user_id::text, 'email', lower(trim(_email))),
    'email',
    _new_user_id::text,
    now(), now(), now()
  );

  INSERT INTO public.profiles (id, full_name, username, is_active, created_at)
  VALUES (_new_user_id, trim(_full_name), trim(_username), true, now())
  ON CONFLICT (id) DO UPDATE SET full_name = EXCLUDED.full_name, username = EXCLUDED.username, is_active = true;

  INSERT INTO public.user_roles (user_id, role, created_at)
  VALUES (_new_user_id, _role, now())
  ON CONFLICT (user_id, role) DO NOTHING;

  INSERT INTO public.user_audit_log (actor_id, actor_name, target_user_id, target_user_name, action, details)
  VALUES (_caller_id, _caller_name, _new_user_id, trim(_full_name), 'user_created', jsonb_build_object('email', _email, 'role', _role));

  RETURN _new_user_id;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.admin_delete_user(_target_user_id uuid)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public', 'auth'
AS $function$
DECLARE
  _caller_id uuid;
  _caller_name text;
  _target_name text;
BEGIN
  _caller_id := auth.uid();
  IF _caller_id IS NULL OR NOT public.has_role(_caller_id, 'admin') THEN
    RAISE EXCEPTION 'Only admins can delete users';
  END IF;

  IF _caller_id = _target_user_id THEN
    RAISE EXCEPTION 'You cannot delete yourself';
  END IF;

  SELECT coalesce(full_name, username, 'User') INTO _target_name FROM public.profiles WHERE id = _target_user_id;
  SELECT coalesce(full_name, username, 'Admin') INTO _caller_name FROM public.profiles WHERE id = _caller_id;

  INSERT INTO public.user_audit_log (actor_id, actor_name, target_user_id, target_user_name, action, details)
  VALUES (_caller_id, _caller_name, _target_user_id, _target_name, 'user_deleted', '{}'::jsonb);

  DELETE FROM auth.users WHERE id = _target_user_id;

  RETURN true;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.admin_update_shift(_session_id uuid, _opening_cash numeric DEFAULT NULL::numeric, _closing_cash numeric DEFAULT NULL::numeric, _cash_sales numeric DEFAULT NULL::numeric, _expected_cash numeric DEFAULT NULL::numeric, _difference numeric DEFAULT NULL::numeric, _user_name text DEFAULT NULL::text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  _existing record;
begin
  if not public.has_role(auth.uid(), 'admin') then
    raise exception 'Only admins can edit shifts';
  end if;

  select * into _existing from public.cash_sessions where id = _session_id;
  if _existing.id is null then raise exception 'Shift not found'; end if;

  update public.cash_sessions
    set opening_cash = coalesce(_opening_cash, _existing.opening_cash),
        closing_cash = coalesce(_closing_cash, _existing.closing_cash),
        cash_sales = coalesce(_cash_sales, _existing.cash_sales),
        expected_cash = coalesce(_expected_cash, _existing.expected_cash),
        difference = coalesce(_difference, _existing.difference),
        user_name = coalesce(_user_name, _existing.user_name)
    where id = _session_id;

  return jsonb_build_object('session_id', _session_id, 'status', 'updated');
end;
$function$
;

CREATE OR REPLACE FUNCTION public.admin_update_shift(_session_id uuid, _opening_cash numeric DEFAULT NULL::numeric, _closing_cash numeric DEFAULT NULL::numeric, _cash_sales numeric DEFAULT NULL::numeric, _expected_cash numeric DEFAULT NULL::numeric, _difference numeric DEFAULT NULL::numeric, _user_name text DEFAULT NULL::text, _online_sales numeric DEFAULT NULL::numeric, _cash_paid_out numeric DEFAULT NULL::numeric)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE _existing record;
BEGIN
  IF NOT public.has_role(auth.uid(),'admin') THEN RAISE EXCEPTION 'Only admins can edit shifts'; END IF;
  SELECT * INTO _existing FROM public.cash_sessions WHERE id = _session_id;
  IF _existing.id IS NULL THEN RAISE EXCEPTION 'Shift not found'; END IF;
  UPDATE public.cash_sessions
     SET opening_cash =coalesce(_opening_cash,_existing.opening_cash),
         closing_cash =coalesce(_closing_cash,_existing.closing_cash),
         cash_sales   =coalesce(_cash_sales,_existing.cash_sales),
         online_sales =coalesce(_online_sales,_existing.online_sales),
         cash_paid_out=coalesce(_cash_paid_out,_existing.cash_paid_out),
         expected_cash=coalesce(_expected_cash,_existing.expected_cash),
         difference   =coalesce(_difference,_existing.difference),
         user_name    =coalesce(_user_name,_existing.user_name)
    WHERE id = _session_id;
  RETURN jsonb_build_object('session_id',_session_id,'status','updated');
END; $function$
;

CREATE OR REPLACE FUNCTION public.admin_update_user(_target_user_id uuid, _full_name text, _username text, _password text DEFAULT NULL::text)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public', 'auth', 'extensions'
AS $function$
DECLARE
  _caller_id uuid;
  _caller_name text;
BEGIN
  _caller_id := auth.uid();
  IF _caller_id IS NULL OR NOT public.has_role(_caller_id, 'admin') THEN
    RAISE EXCEPTION 'Only admins can update users';
  END IF;

  SELECT coalesce(full_name, username, 'Admin') INTO _caller_name FROM public.profiles WHERE id = _caller_id;

  IF EXISTS (SELECT 1 FROM public.profiles WHERE lower(username) = lower(trim(_username)) AND id <> _target_user_id) THEN
    RAISE EXCEPTION 'A user with this username already exists';
  END IF;

  UPDATE public.profiles
  SET full_name = trim(_full_name), username = trim(_username)
  WHERE id = _target_user_id;

  UPDATE auth.users
  SET 
    raw_user_meta_data = jsonb_build_object('full_name', trim(_full_name), 'username', trim(_username)),
    updated_at = now()
  WHERE id = _target_user_id;

  IF _password IS NOT NULL AND length(trim(_password)) > 0 THEN
    IF length(trim(_password)) < 6 THEN
      RAISE EXCEPTION 'Password must be at least 6 characters';
    END IF;

    UPDATE auth.users
    SET encrypted_password = extensions.crypt(trim(_password), extensions.gen_salt('bf')),
        updated_at = now()
    WHERE id = _target_user_id;

    INSERT INTO public.user_audit_log (actor_id, actor_name, target_user_id, target_user_name, action, details)
    VALUES (_caller_id, _caller_name, _target_user_id, trim(_full_name), 'password_reset', '{}'::jsonb);
  END IF;

  INSERT INTO public.user_audit_log (actor_id, actor_name, target_user_id, target_user_name, action, details)
  VALUES (_caller_id, _caller_name, _target_user_id, trim(_full_name), 'profile_updated', jsonb_build_object('full_name', _full_name, 'username', _username));

  RETURN true;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.approve_price_change(_request_id uuid, _notes text DEFAULT ''::text)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE _r record; _reviewer text;
BEGIN
  IF NOT public.has_role(auth.uid(),'admin') THEN RAISE EXCEPTION 'Only admins can approve'; END IF;
  SELECT * INTO _r FROM public.price_change_requests WHERE id = _request_id FOR UPDATE;
  IF _r.id IS NULL THEN RAISE EXCEPTION 'Request not found'; END IF;
  IF _r.status <> 'pending' THEN RAISE EXCEPTION 'Only pending requests can be approved'; END IF;

  SELECT coalesce(full_name, username, 'Admin') INTO _reviewer FROM public.profiles WHERE id = auth.uid();

  UPDATE public.products
     SET purchase_price = _r.requested_purchase_price,
         sale_price     = _r.requested_sale_price,
         updated_at     = now()
   WHERE id = _r.product_id;

  UPDATE public.product_units
     SET purchase_price = _r.requested_purchase_price,
         sale_price     = _r.requested_sale_price,
         updated_at     = now()
   WHERE product_id = _r.product_id AND is_base = true;

  UPDATE public.price_change_requests
     SET status = 'approved', reviewed_by = auth.uid(),
         reviewed_by_name = _reviewer, reviewed_at = now(),
         review_notes = coalesce(_notes,'')
   WHERE id = _request_id;
END; $function$
;

CREATE OR REPLACE FUNCTION public.approve_return(_return_id uuid)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  _status text;
  _approver text;
  _it record;
begin
  if not public.has_role(auth.uid(), 'admin') then
    raise exception 'Only admins can approve returns';
  end if;

  select status into _status from public.returns where id = _return_id for update;
  if _status is null then raise exception 'Return not found'; end if;
  if _status <> 'pending' then raise exception 'Only pending returns can be approved'; end if;

  select coalesce(full_name, username, 'Admin') into _approver
  from public.profiles where id = auth.uid();

  for _it in select product_id, qty from public.return_items where return_id = _return_id loop
    if _it.product_id is not null then
      update public.products
        set stock = stock + _it.qty, updated_at = now()
        where id = _it.product_id;
    end if;
  end loop;

  update public.returns
    set status = 'approved',
        approved_by = auth.uid(),
        approved_by_name = coalesce(_approver,''),
        approved_at = now()
    where id = _return_id;

  return jsonb_build_object('return_id', _return_id, 'status', 'approved');
end;
$function$
;

CREATE OR REPLACE FUNCTION public.approve_stock_entry(_entry_id uuid)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
  _status text;
  _approver text;
  _product_id uuid;
  _qty integer;
  _qty_in_unit numeric;
  _unit_id uuid;
  _unit_name text;
BEGIN
  IF NOT public.has_role(auth.uid(), 'admin') THEN
    RAISE EXCEPTION 'Only admins can approve stock entries';
  END IF;

  SELECT status, product_id, qty, unit_id, unit_name, qty_in_unit
    INTO _status, _product_id, _qty, _unit_id, _unit_name, _qty_in_unit
  FROM public.stock_entries WHERE id = _entry_id FOR UPDATE;
  IF _status IS NULL THEN RAISE EXCEPTION 'Stock entry not found'; END IF;
  IF _status <> 'pending' THEN RAISE EXCEPTION 'Only pending entries can be approved'; END IF;

  SELECT coalesce(full_name, username, 'Admin') INTO _approver FROM public.profiles WHERE id = auth.uid();

  UPDATE public.products SET stock = stock + _qty, updated_at = now() WHERE id = _product_id;

  INSERT INTO public.inventory_movements(product_id, unit_id, unit_name, qty_in_unit, qty_in_base, kind, ref_id, user_id, user_name, notes)
  VALUES (_product_id, _unit_id, COALESCE(_unit_name,'restock'), COALESCE(_qty_in_unit, _qty), _qty, 'restock', _entry_id, auth.uid(), _approver, 'Approved stock entry');

  UPDATE public.stock_entries
    SET status = 'approved', approved_by = auth.uid(), approved_by_name = coalesce(_approver, ''), approved_at = now()
    WHERE id = _entry_id;

  RETURN jsonb_build_object('entry_id', _entry_id, 'status', 'approved');
END;
$function$
;

CREATE OR REPLACE FUNCTION public.approve_stock_reconciliation(_id uuid, _notes text DEFAULT ''::text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
  _r record;
  _reviewer text;
  _current_stock numeric;
  _delta numeric;
BEGIN
  IF NOT public.has_role(auth.uid(), 'admin') THEN
    RAISE EXCEPTION 'Only admins can approve reconciliations';
  END IF;

  SELECT * INTO _r FROM public.stock_reconciliations WHERE id = _id FOR UPDATE;
  IF _r.id IS NULL THEN RAISE EXCEPTION 'Reconciliation not found'; END IF;
  IF _r.status <> 'pending' THEN RAISE EXCEPTION 'Only pending reconciliations can be approved'; END IF;

  SELECT COALESCE(full_name, username, 'Admin') INTO _reviewer FROM public.profiles WHERE id = auth.uid();

  SELECT stock INTO _current_stock FROM public.products WHERE id = _r.product_id FOR UPDATE;
  IF _current_stock IS NULL THEN RAISE EXCEPTION 'Product not found'; END IF;

  _delta := _r.physical_stock - _current_stock;

  UPDATE public.products
     SET stock = _r.physical_stock, updated_at = now()
   WHERE id = _r.product_id;

  INSERT INTO public.inventory_movements(product_id, unit_id, unit_name, qty_in_unit, qty_in_base, kind, ref_id, user_id, user_name, notes)
  VALUES (_r.product_id, _r.unit_id, 'reconciliation', _delta, _delta, 'adjustment', _r.id, auth.uid(), _reviewer,
          'Approved reconciliation: system=' || _current_stock || ' physical=' || _r.physical_stock ||
          CASE WHEN COALESCE(_notes,'') <> '' THEN ' â€” ' || _notes ELSE '' END);

  UPDATE public.stock_reconciliations
     SET status = 'approved', reviewed_by = auth.uid(), reviewed_by_name = _reviewer,
         reviewed_at = now(), review_notes = COALESCE(_notes,''), applied_at = now()
   WHERE id = _id;

  RETURN jsonb_build_object('id', _id, 'status', 'approved', 'delta', _delta);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.change_sale_payment(_sale_id uuid, _new_payment text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
  s RECORD;
  is_cash_old boolean;
  is_cash_new boolean;
BEGIN
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'Not authenticated';
  END IF;

  IF _new_payment NOT IN ('cash','card','easypasa','jazzcash') THEN
    RAISE EXCEPTION 'Invalid payment type: %', _new_payment;
  END IF;

  SELECT * INTO s FROM public.sales WHERE id = _sale_id;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Sale not found';
  END IF;

  IF s.cashier_id <> auth.uid() AND NOT public.has_role(auth.uid(), 'admin') THEN
    RAISE EXCEPTION 'Not allowed to modify this sale';
  END IF;

  IF s.session_id IS NULL THEN
    RAISE EXCEPTION 'Sale is not linked to a shift';
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM (
      SELECT id FROM public.sales
      WHERE cashier_id = s.cashier_id
        AND session_id = s.session_id
      ORDER BY created_at DESC
      LIMIT 5
    ) t
    WHERE t.id = _sale_id
  ) THEN
    RAISE EXCEPTION 'Only the last 5 bills of this shift can be changed';
  END IF;

  is_cash_old := (s.payment_type = 'cash');
  is_cash_new := (_new_payment = 'cash');

  UPDATE public.sales
     SET payment_type   = _new_payment,
         payment_method = _new_payment,
         cash_received  = CASE WHEN is_cash_new THEN total ELSE 0 END,
         change_returned = 0
   WHERE id = _sale_id;

  IF is_cash_old <> is_cash_new THEN
    IF is_cash_new THEN
      UPDATE public.cash_sessions
         SET cash_sales    = cash_sales   + s.total,
             online_sales  = GREATEST(online_sales - s.total, 0),
             expected_cash = expected_cash + s.total
        WHERE id = s.session_id;
    ELSE
      UPDATE public.cash_sessions
         SET cash_sales    = GREATEST(cash_sales - s.total, 0),
             online_sales  = online_sales + s.total,
             expected_cash = GREATEST(expected_cash - s.total, 0)
        WHERE id = s.session_id;
    END IF;
  END IF;

  RETURN jsonb_build_object('ok', true, 'sale_id', _sale_id, 'payment_type', _new_payment);
END;
$function$
;



-- ------------------------------------------------------------
-- Functions (from live database) [part 2/4]
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.close_shift(_closing_cash numeric)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare _session_id uuid; _opening numeric; _cash_sales numeric;
        _online_sales numeric; _paid_out numeric; _expenses numeric; _expected numeric; _diff numeric;
begin
  if auth.uid() is null then raise exception 'Not authenticated'; end if;
  select id, opening_cash into _session_id, _opening from public.cash_sessions
   where user_id = auth.uid() and status = 'open' for update;
  if _session_id is null then raise exception 'No open shift'; end if;

  select
    coalesce(sum(total) filter (where lower(trim(coalesce(payment_type,'cash'))) =  'cash'), 0),
    coalesce(sum(total) filter (where lower(trim(coalesce(payment_type,'cash'))) <> 'cash'), 0)
  into _cash_sales, _online_sales
  from public.sales where session_id = _session_id;

  select coalesce(sum(amount), 0) into _paid_out
  from public.supplier_payments
   where session_id = _session_id and lower(trim(coalesce(method,'cash'))) = 'cash';

  select coalesce(sum(amount), 0) into _expenses
  from public.shift_expenses where session_id = _session_id;

  _expected := _opening + _cash_sales - _paid_out - _expenses;
  _diff     := _closing_cash - _expected;

  if _closing_cash < _expected then
    raise exception 'Closing cash is short by Rs. %. It must be at least Rs. %.',
      round(_expected - _closing_cash, 2), round(_expected, 2);
  end if;

  update public.cash_sessions
     set closing_cash=_closing_cash, cash_sales=_cash_sales, online_sales=_online_sales,
         cash_paid_out=_paid_out, expenses=_expenses, expected_cash=_expected, difference=_diff,
         status='closed', closed_at=now()
   where id = _session_id;

  return jsonb_build_object('session_id',_session_id,'opening_cash',_opening,
    'cash_sales',_cash_sales,'online_sales',_online_sales,'cash_paid_out',_paid_out,
    'expenses',_expenses,'expected_cash',_expected,'closing_cash',_closing_cash,'difference',_diff);
end; $function$
;

CREATE OR REPLACE FUNCTION public.debug_dashboard(_start_at timestamp with time zone, _days integer, _end_at timestamp with time zone DEFAULT NULL::timestamp with time zone)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public', 'auth'
AS $function$
DECLARE
  _end timestamptz;
  _count int;
  _uid uuid;
  _is_admin boolean;
BEGIN
  _uid := auth.uid();
  _is_admin := public.has_role(_uid, 'admin');
  _end := coalesce(_end_at, now());
  
  SELECT count(*) INTO _count 
  FROM public.sales 
  WHERE created_at >= _start_at AND created_at <= _end;

  RETURN jsonb_build_object(
    '_start_at', _start_at,
    '_end_at', _end_at,
    '_end_resolved', _end,
    '_days', _days,
    'uid', _uid,
    'is_admin', _is_admin,
    'sales_count_in_range', _count
  );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_admin_dashboard_summary(_start_at timestamp with time zone, _days integer, _end_at timestamp with time zone DEFAULT NULL::timestamp with time zone)
 RETURNS jsonb
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public', 'auth'
AS $function$
  SELECT public.get_admin_dashboard_summary(
    jsonb_build_object(
      '_start_at', _start_at,
      '_days', _days,
      '_end_at', _end_at
    )
  );
$function$
;

CREATE OR REPLACE FUNCTION public.get_admin_dashboard_summary(payload jsonb)
 RETURNS jsonb
 LANGUAGE plpgsql
 STABLE SECURITY DEFINER
 SET search_path TO 'public', 'auth'
AS $function$
DECLARE
  _start_at timestamptz;
  _end_at timestamptz;
  _days int;
  _end timestamptz;
  _gross numeric := 0; _bills integer := 0; _refunds numeric := 0; _returns_count integer := 0;
  _cash numeric := 0; _online numeric := 0; _profit numeric := 0;
  _daily jsonb := '[]'::jsonb; _top_products jsonb := '[]'::jsonb;
  _margin jsonb := '[]'::jsonb; _top_cashiers jsonb := '[]'::jsonb; _hourly jsonb := '[]'::jsonb;
  _prev_start timestamptz; _prev_end timestamptz;
  _p_gross numeric := 0; _p_bills integer := 0; _p_refunds numeric := 0; _p_profit numeric := 0;
BEGIN
  IF NOT public.has_role(auth.uid(), 'admin') THEN
    RAISE EXCEPTION 'Only admins can view dashboard analytics';
  END IF;

  _start_at := (payload->>'_start_at')::timestamptz;
  _days := coalesce((payload->>'_days')::int, 7);
  _end_at := (payload->>'_end_at')::timestamptz;
  
  _end := coalesce(_end_at, now());
  _days := greatest(1, least(coalesce(_days, 7), 366));
  _prev_end := _start_at;
  _prev_start := _start_at - (_end - _start_at);

  SELECT coalesce(sum(total),0), count(*)::int,
         coalesce(sum(total) filter (where lower(trim(coalesce(payment_type,'cash'))) = 'cash'), 0),
         coalesce(sum(total) filter (where lower(trim(coalesce(payment_type,'cash'))) <> 'cash'), 0)
  INTO _gross, _bills, _cash, _online
  FROM public.sales WHERE created_at >= _start_at AND created_at <= _end;

  SELECT coalesce(sum(refund_amount),0), count(*)::int
  INTO _refunds, _returns_count
  FROM public.returns
  WHERE status='approved'
    AND coalesce(approved_at, created_at) >= _start_at
    AND coalesce(approved_at, created_at) <= _end;

  SELECT coalesce(sum(si.subtotal - (si.purchase_price * si.qty)), 0)
  INTO _profit
  FROM public.sale_items si JOIN public.sales s ON s.id=si.sale_id
  WHERE s.created_at >= _start_at AND s.created_at <= _end;

  WITH day_series AS (
    SELECT generate_series(date_trunc('day',_start_at), date_trunc('day',_end), interval '1 day')::date AS day
  ), sales_by_day AS (
    SELECT date_trunc('day',created_at)::date AS day, sum(total) AS sales
    FROM public.sales WHERE created_at >= _start_at AND created_at <= _end GROUP BY 1
  ), returns_by_day AS (
    SELECT date_trunc('day', coalesce(approved_at, created_at))::date AS day, sum(refund_amount) AS refunds
    FROM public.returns
    WHERE status='approved' AND coalesce(approved_at, created_at) >= _start_at AND coalesce(approved_at, created_at) <= _end
    GROUP BY 1
  )
  SELECT coalesce(jsonb_agg(jsonb_build_object(
    'day', CASE WHEN _days = 1 THEN 'Today' ELSE to_char(ds.day, 'MM-DD') END,
    'sales', round(coalesce(s.sales,0)),
    'refunds', round(coalesce(r.refunds,0))
  ) ORDER BY ds.day), '[]'::jsonb)
  INTO _daily
  FROM day_series ds LEFT JOIN sales_by_day s ON s.day=ds.day LEFT JOIN returns_by_day r ON r.day=ds.day;

  WITH product_totals AS (
    SELECT si.product_name AS name, sum(si.qty)::int AS qty, sum(si.subtotal) AS revenue
    FROM public.sale_items si JOIN public.sales s ON s.id=si.sale_id
    WHERE s.created_at >= _start_at AND s.created_at <= _end
    GROUP BY si.product_name ORDER BY sum(si.qty) DESC LIMIT 7
  )
  SELECT coalesce(jsonb_agg(jsonb_build_object('name',name,'qty',qty,'revenue',revenue)), '[]'::jsonb)
  INTO _top_products FROM product_totals;

  WITH margin_buckets AS (
    SELECT CASE
      WHEN si.subtotal>0 AND (((si.subtotal-(si.purchase_price*si.qty))/si.subtotal)*100) < 10 THEN 'Low (<10%)'
      WHEN si.subtotal>0 AND (((si.subtotal-(si.purchase_price*si.qty))/si.subtotal)*100) < 30 THEN 'Mid (10-30%)'
      ELSE 'High (>30%)' END AS name,
      round(sum(si.subtotal)) AS value
    FROM public.sale_items si JOIN public.sales s ON s.id=si.sale_id
    WHERE s.created_at >= _start_at AND s.created_at <= _end AND si.subtotal>0
    GROUP BY 1
  )
  SELECT coalesce(jsonb_agg(jsonb_build_object('name',name,'value',value)), '[]'::jsonb)
  INTO _margin FROM margin_buckets WHERE value>0;

  WITH cashier_totals AS (
    SELECT coalesce(nullif(cashier_name,''),'Unknown') AS name, sum(total) AS sales, count(*)::int AS bills
    FROM public.sales WHERE created_at >= _start_at AND created_at <= _end
    GROUP BY 1 ORDER BY sum(total) DESC LIMIT 5
  )
  SELECT coalesce(jsonb_agg(jsonb_build_object('name',name,'sales',round(sales),'bills',bills) ORDER BY sales DESC), '[]'::jsonb)
  INTO _top_cashiers FROM cashier_totals;

  WITH hours AS (SELECT generate_series(0,23) AS hour),
  sales_by_hour AS (
    SELECT extract(hour FROM (created_at AT TIME ZONE 'Asia/Karachi'))::int AS hour, sum(total) AS sales
    FROM public.sales WHERE created_at >= _start_at AND created_at <= _end GROUP BY 1
  )
  SELECT coalesce(jsonb_agg(jsonb_build_object('hour',h.hour,'sales',round(coalesce(sh.sales,0))) ORDER BY h.hour), '[]'::jsonb)
  INTO _hourly FROM hours h LEFT JOIN sales_by_hour sh ON sh.hour=h.hour;

  SELECT coalesce(sum(total),0), count(*)::int
  INTO _p_gross, _p_bills
  FROM public.sales WHERE created_at >= _prev_start AND created_at < _prev_end;

  SELECT coalesce(sum(refund_amount),0) INTO _p_refunds
  FROM public.returns WHERE status='approved'
    AND coalesce(approved_at, created_at) >= _prev_start AND coalesce(approved_at, created_at) < _prev_end;

  SELECT coalesce(sum(si.subtotal-(si.purchase_price*si.qty)),0) INTO _p_profit
  FROM public.sale_items si JOIN public.sales s ON s.id=si.sale_id
  WHERE s.created_at >= _prev_start AND s.created_at < _prev_end;

  RETURN jsonb_build_object(
    'grossSales',_gross,'bills',_bills,'refunds',_refunds,
    'net', _gross - _refunds, 'rate', CASE WHEN _gross>0 THEN (_refunds/_gross)*100 ELSE 0 END,
    'returnsCount',_returns_count,'cashSales',_cash,'onlineSales',_online,'grossProfit',_profit,
    'daily',_daily,'topProducts',_top_products,'margin',_margin,'topCashiers',_top_cashiers,'hourly',_hourly,
    'prev', jsonb_build_object('grossSales',_p_gross,'bills',_p_bills,'net',_p_gross-_p_refunds,'grossProfit',_p_profit)
  );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_admin_inventory_summary()
 RETURNS jsonb
 LANGUAGE sql
 STABLE
 SET search_path TO 'public'
AS $function$
  select case
    when not public.has_role(auth.uid(), 'admin') then
      jsonb_build_object('products', 0, 'lowStock', 0, 'lowStockItems', '[]'::jsonb)
    else (
      select jsonb_build_object(
        'products', count(*)::int,
        'lowStock', count(*) filter (where stock <= min_stock_alert)::int,
        'lowStockItems', coalesce(jsonb_agg(
          jsonb_build_object(
            'id', id,
            'name', name,
            'stock', stock,
            'min_stock_alert', min_stock_alert
          ) order by stock asc
        ) filter (where stock <= min_stock_alert), '[]'::jsonb)
      )
      from public.products
    )
  end
$function$
;

CREATE OR REPLACE FUNCTION public.get_credit_customers()
 RETURNS TABLE(person_name text, balance numeric)
 LANGUAGE plpgsql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
BEGIN
  RETURN QUERY
  WITH ledger_start AS (SELECT DATE '2026-06-30' AS d),
  received AS (
    SELECT btrim(se.description) AS nm, SUM(se.amount)::numeric AS amt
    FROM public.shift_expenses se, ledger_start
    WHERE se.created_at >= (ledger_start.d::text || 'T00:00:00+05:00')::timestamptz
      AND btrim(coalesce(se.description,'')) <> ''
    GROUP BY btrim(se.description)
  ),
  paid_pp AS (
    SELECT btrim(pp.person_name) AS nm, SUM(pp.amount)::numeric AS amt
    FROM public.person_payments pp, ledger_start
    WHERE pp.payment_date >= ledger_start.d
    GROUP BY btrim(pp.person_name)
  ),
  paid_op AS (
    SELECT btrim(oe.paid_to) AS nm, SUM(oe.amount)::numeric AS amt
    FROM public.operating_expenses oe, ledger_start
    WHERE oe.expense_date >= ledger_start.d
      AND btrim(coalesce(oe.paid_to,'')) <> ''
    GROUP BY btrim(oe.paid_to)
  ),
  starting AS (
    SELECT btrim(psb.person_name) AS nm, psb.balance::numeric AS amt
    FROM public.person_starting_balances psb
  ),
  all_names AS (
    SELECT nm FROM received
    UNION SELECT nm FROM paid_pp
    UNION SELECT nm FROM paid_op
    UNION SELECT nm FROM starting
  ),
  computed AS (
    SELECT
      n.nm AS nm,
      (COALESCE((SELECT amt FROM starting s WHERE s.nm = n.nm), 0)
       + COALESCE((SELECT amt FROM received r WHERE r.nm = n.nm), 0)
       - COALESCE((SELECT amt FROM paid_pp p WHERE p.nm = n.nm), 0)
       - COALESCE((SELECT amt FROM paid_op o WHERE o.nm = n.nm), 0))::numeric AS bal
    FROM all_names n
    WHERE lower(n.nm) NOT IN ('junaid','usama')
      AND n.nm <> ''
  )
  SELECT c.nm AS person_name, c.bal AS balance
  FROM computed c
  WHERE c.bal > 0
  ORDER BY c.bal DESC;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_online_by_method(_from timestamp with time zone, _to timestamp with time zone)
 RETURNS jsonb
 LANGUAGE plpgsql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare _r jsonb;
begin
  if not public.has_role(auth.uid(), 'admin') then
    raise exception 'Only admins can view sales analytics';
  end if;
  select coalesce(jsonb_object_agg(pt, amt), '{}'::jsonb) into _r
  from (
    select lower(trim(coalesce(payment_type, 'cash'))) as pt, sum(total) as amt
    from public.sales
    where created_at >= _from and created_at <= _to
    group by 1
  ) s;
  return _r;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.get_open_session()
 RETURNS jsonb
 LANGUAGE plpgsql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare _s record; _cash_sales numeric; _online_sales numeric; _paid_out numeric; _expenses numeric;
begin
  if auth.uid() is null then return null; end if;
  select * into _s from public.cash_sessions where user_id = auth.uid() and status = 'open' limit 1;
  if _s.id is null then return null; end if;

  select
    coalesce(sum(total) filter (where lower(trim(coalesce(payment_type,'cash'))) =  'cash'), 0),
    coalesce(sum(total) filter (where lower(trim(coalesce(payment_type,'cash'))) <> 'cash'), 0)
  into _cash_sales, _online_sales
  from public.sales where session_id = _s.id;

  select coalesce(sum(amount), 0) into _paid_out
  from public.supplier_payments
   where session_id = _s.id and lower(trim(coalesce(method,'cash'))) = 'cash';

  select coalesce(sum(amount), 0) into _expenses
  from public.shift_expenses where session_id = _s.id;

  return jsonb_build_object(
    'id', _s.id, 'opening_cash', _s.opening_cash,
    'cash_sales', _cash_sales, 'online_sales', _online_sales,
    'cash_paid_out', _paid_out, 'expenses', _expenses,
    'expected_cash', _s.opening_cash + _cash_sales - _paid_out - _expenses,
    'opened_at', _s.opened_at);
end; $function$
;

CREATE OR REPLACE FUNCTION public.get_period_extras(_from timestamp with time zone)
 RETURNS jsonb
 LANGUAGE plpgsql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare _r jsonb;
begin
  if not public.has_role(auth.uid(), 'admin') then
    raise exception 'Only admins can view dashboard analytics';
  end if;
  select jsonb_build_object(
    'discounts',          coalesce((select sum(discount) from public.sales where created_at >= _from), 0),
    'stockPurchased',     coalesce((select sum(amount)   from public.supplier_payments where created_at >= _from), 0),
    'operatingExpenses',  coalesce((select sum(amount)   from public.operating_expenses where created_at >= _from), 0)
  ) into _r;
  return _r;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.get_period_extras(_from timestamp with time zone, _to timestamp with time zone DEFAULT NULL::timestamp with time zone)
 RETURNS jsonb
 LANGUAGE plpgsql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare _r jsonb; _end timestamptz;
begin
  if not public.has_role(auth.uid(), 'admin') then
    raise exception 'Only admins can view dashboard analytics';
  end if;
  _end := coalesce(_to, now());
  select jsonb_build_object(
    'discounts',         coalesce((select sum(discount) from public.sales where created_at >= _from and created_at <= _end), 0),
    'stockPurchased',    coalesce((select sum(amount)   from public.supplier_payments where created_at >= _from and created_at <= _end), 0),
    'operatingExpenses', coalesce((select sum(amount)   from public.operating_expenses where created_at >= _from and created_at <= _end), 0)
  ) into _r;
  return _r;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.get_profit_report(_from timestamp with time zone, _to timestamp with time zone)
 RETURNS jsonb
 LANGUAGE plpgsql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
BEGIN
  IF NOT public.has_role(auth.uid(), 'admin') THEN
    RAISE EXCEPTION 'Only admins can access the profit report';
  END IF;

  RETURN (
    WITH sale_line AS (
      SELECT
        si.sale_id,
        coalesce(nullif(si.product_name,''),'Unknown') AS name,
        ((s.created_at AT TIME ZONE 'UTC')::date)     AS d,
        coalesce(si.qty,0)                             AS qty,
        coalesce(si.qty,0) * coalesce(si.unit_price,0) AS gross_revenue,
        coalesce(si.qty,0) * coalesce(si.purchase_price,0) AS cost,
        (coalesce(si.purchase_price,0) = 0)            AS zero_cost,
        coalesce(s.subtotal,0)                         AS sale_subtotal,
        coalesce(s.discount,0)                         AS sale_discount
      FROM public.sale_items si
      JOIN public.sales s ON s.id = si.sale_id
      WHERE s.created_at >= _from AND s.created_at <= _to
    ),
    li AS (
      SELECT
        name, d, qty,
        gross_revenue
          - CASE WHEN sale_subtotal > 0
                 THEN sale_discount * (gross_revenue / sale_subtotal)
                 ELSE 0 END AS revenue,
        cost, zero_cost
      FROM sale_line
    ),
    ret AS (
      SELECT
        coalesce(nullif(ri.product_name,''),'Unknown')                        AS name,
        ((coalesce(r.approved_at, r.created_at) AT TIME ZONE 'UTC')::date)    AS d,
        coalesce(ri.qty,0)                                                    AS qty,
        coalesce(ri.qty,0) * coalesce(ri.unit_price,0)                        AS revenue_ret,
        coalesce(ri.qty,0) * coalesce(si.purchase_price,0)                    AS cost_ret
      FROM public.returns r
      JOIN public.return_items ri ON ri.return_id = r.id
      LEFT JOIN public.sale_items si
        ON si.sale_id = r.original_sale_id AND si.product_id = ri.product_id
      WHERE r.status = 'approved'
        AND coalesce(r.approved_at, r.created_at) >= _from
        AND coalesce(r.approved_at, r.created_at) <= _to
    ),
    combined AS (
      SELECT name, d, qty, revenue, cost, zero_cost FROM li
      UNION ALL
      SELECT name, d, -qty, -revenue_ret, -cost_ret, false FROM ret
    ),
    by_product AS (
      SELECT name,
             sum(qty)     AS qty,
             sum(revenue) AS revenue,
             sum(cost)    AS cost,
             sum(revenue) - sum(cost) AS profit,
             bool_or(zero_cost) AS has_zero_cost
      FROM combined
      GROUP BY name
    ),
    by_day AS (
      SELECT d,
             sum(revenue) - sum(cost) AS profit,
             sum(revenue)             AS sales
    FROM combined
      GROUP BY d
    ),
    tot AS (
      SELECT coalesce(sum(revenue),0) AS revenue,
             coalesce(sum(cost),0)    AS cost,
             coalesce(sum(CASE WHEN zero_cost THEN 1 ELSE 0 END),0) AS zero_count
      FROM combined
    )
    SELECT jsonb_build_object(
      'total_revenue', (SELECT revenue FROM tot),
      'total_cost',    (SELECT cost FROM tot),
      'total_profit',  (SELECT revenue - cost FROM tot),
      'zero_count',    (SELECT zero_count FROM tot),
      'by_product', coalesce((
        SELECT jsonb_agg(jsonb_build_object(
          'name',      name,
          'qty',       qty,
          'revenue',   revenue,
          'cost',      cost,
          'profit',    profit,
          'margin',    CASE WHEN revenue > 0 THEN (profit / revenue) * 100 ELSE NULL END,
          'zero_cost', has_zero_cost
        ) ORDER BY profit DESC)
        FROM by_product), '[]'::jsonb),
      'daily', coalesce((
        SELECT jsonb_agg(jsonb_build_object(
          'date',   to_char(d,'YYYY-MM-DD'),
          'profit', round(profit),
          'sales',  round(sales)
        ) ORDER BY d)
        FROM by_day), '[]'::jsonb)
    )
  );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_suppliers_summary()
 RETURNS jsonb
 LANGUAGE sql
 STABLE
 SET search_path TO 'public'
AS $function$
  SELECT coalesce(jsonb_agg(row_to_json(t) ORDER BY t.name), '[]'::jsonb)
  FROM (
    SELECT s.id, s.name, s.phone, s.address, s.notes,
      coalesce((SELECT sum(amount) FROM public.supplier_purchases WHERE supplier_id = s.id), 0) AS total_purchases,
      coalesce((SELECT sum(amount) FROM public.supplier_payments WHERE supplier_id = s.id), 0) AS total_paid,
      coalesce((SELECT sum(amount) FROM public.supplier_purchases WHERE supplier_id = s.id), 0)
        - coalesce((SELECT sum(amount) FROM public.supplier_payments WHERE supplier_id = s.id), 0) AS balance
    FROM public.suppliers s
    WHERE s.is_active = true
  ) t;
$function$
;



-- ------------------------------------------------------------
-- Functions (from live database) [part 3/4]
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.get_unit_breakdown(_product_id uuid)
 RETURNS jsonb
 LANGUAGE plpgsql
 STABLE
 SET search_path TO 'public'
AS $function$
DECLARE
  _stock int;
  _u record;
  _count int;
  _result jsonb := '[]'::jsonb;
BEGIN
  SELECT stock INTO _stock FROM public.products WHERE id = _product_id;
  IF _stock IS NULL THEN RETURN _result; END IF;
  FOR _u IN
    SELECT id, name, equals_base FROM public.product_units
    WHERE product_id = _product_id ORDER BY equals_base DESC, sort_order ASC
  LOOP
    _count := _stock / _u.equals_base;
    _stock := _stock - _count * _u.equals_base;
    IF _count > 0 OR _u.equals_base = 1 THEN
      _result := _result || jsonb_build_object('unit_id', _u.id, 'name', _u.name, 'equals_base', _u.equals_base, 'count', _count);
    END IF;
  END LOOP;
  RETURN _result;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_user_role(_user_id uuid)
 RETURNS app_role
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
  select role from public.user_roles where user_id = _user_id limit 1
$function$
;

CREATE OR REPLACE FUNCTION public.handle_new_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare _is_first boolean;
begin
  insert into public.profiles(id, full_name, username)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'full_name', ''),
    coalesce(new.raw_user_meta_data->>'username', split_part(new.email,'@',1))
  )
  on conflict (id) do nothing;

  select count(*) = 0 into _is_first from public.user_roles;
  insert into public.user_roles(user_id, role)
  values (new.id, case when _is_first then 'admin'::app_role else 'cashier'::app_role end)
  on conflict do nothing;

  return new;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.has_role(_user_id uuid, _role app_role)
 RETURNS boolean
 LANGUAGE plpgsql
 STABLE SECURITY DEFINER
 SET search_path TO 'public', 'auth'
AS $function$
DECLARE
  _has boolean;
BEGIN
  IF _user_id IS NULL THEN
    RETURN false;
  END IF;
  SELECT EXISTS (
    SELECT 1 FROM public.user_roles WHERE user_id = _user_id AND role = _role
  ) INTO _has;
  RETURN coalesce(_has, false);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.next_bill_no(_prefix text)
 RETURNS text
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  _date_key text := to_char(now(), 'YYYYMMDD');
  _key text := _prefix || '-' || _date_key;
  _seq integer;
  _max_existing integer;
begin
  -- Find max existing seq for today (handles imported data)
  SELECT COALESCE(MAX(NULLIF(regexp_replace(bill_no, '^' || _prefix || '-' || _date_key || '-', ''), '')::int), 0)
    INTO _max_existing
  FROM public.sales
  WHERE bill_no LIKE _prefix || '-' || _date_key || '-%';

  insert into public.bill_sequences(date_key, prefix, last_seq)
  values (_key, _prefix, _max_existing + 1)
  on conflict (date_key) do update set last_seq = GREATEST(bill_sequences.last_seq + 1, _max_existing + 1)
  returning last_seq into _seq;

  return _prefix || '-' || _date_key || '-' || lpad(_seq::text, 4, '0');
end;
$function$
;

CREATE OR REPLACE FUNCTION public.open_shift(_opening_cash numeric)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
  _user_name text;
  _session_id uuid;
BEGIN
  IF auth.uid() IS NULL THEN RAISE EXCEPTION 'Not authenticated'; END IF;

  IF EXISTS (SELECT 1 FROM public.cash_sessions WHERE user_id = auth.uid() AND status = 'open') THEN
    RAISE EXCEPTION 'You already have an open shift';
  END IF;

  SELECT coalesce(full_name, username, 'Cashier') INTO _user_name
  FROM public.profiles WHERE id = auth.uid();

  INSERT INTO public.cash_sessions(user_id, user_name, opening_cash, expected_cash, status)
  VALUES (auth.uid(), coalesce(_user_name, ''), _opening_cash, _opening_cash, 'open')
  RETURNING id INTO _session_id;

  RETURN jsonb_build_object('session_id', _session_id);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.process_return(_sale_id uuid, _items jsonb, _reason text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  _return_no text;
  _return_id uuid;
  _cashier_name text;
  _bill_no text;
  _item jsonb;
  _items_count integer := 0;
  _refund numeric := 0;
begin
  if auth.uid() is null then raise exception 'Not authenticated'; end if;

  select coalesce(full_name, username, 'Cashier') into _cashier_name
  from public.profiles where id = auth.uid();

  select bill_no into _bill_no from public.sales where id = _sale_id;
  if _bill_no is null then raise exception 'Sale not found'; end if;

  _return_no := public.next_bill_no('RET');

  insert into public.returns(return_no, original_sale_id, original_bill_no, cashier_id, cashier_name, reason, refund_amount, items_count, status)
  values (_return_no, _sale_id, _bill_no, auth.uid(), coalesce(_cashier_name,''), coalesce(_reason,''), 0, 0, 'pending')
  returning id into _return_id;

  for _item in select * from jsonb_array_elements(_items) loop
    insert into public.return_items(return_id, product_id, product_name, barcode, qty, unit_price, subtotal)
    values (
      _return_id,
      nullif(_item->>'product_id','')::uuid,
      _item->>'product_name',
      coalesce(_item->>'barcode',''),
      (_item->>'qty')::int,
      (_item->>'unit_price')::numeric,
      (_item->>'subtotal')::numeric
    );

    _items_count := _items_count + (_item->>'qty')::int;
    _refund := _refund + (_item->>'subtotal')::numeric;
  end loop;

  update public.returns set items_count = _items_count, refund_amount = _refund where id = _return_id;

  return jsonb_build_object('return_id', _return_id, 'return_no', _return_no, 'refund', _refund, 'status', 'pending');
end;
$function$
;

CREATE OR REPLACE FUNCTION public.process_sale(_items jsonb, _subtotal numeric, _tax_amount numeric, _discount numeric, _total numeric, _cash_received numeric, _change_returned numeric, _payment_type text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
  _bill_no text;
  _sale_id uuid;
  _cashier_name text;
  _session_id uuid;
  _payment_method text;
  _item jsonb;
  _items_count integer := 0;
BEGIN
  IF auth.uid() IS NULL THEN RAISE EXCEPTION 'Not authenticated'; END IF;

  SELECT id INTO _session_id FROM public.cash_sessions
  WHERE user_id = auth.uid() AND status = 'open' LIMIT 1;

  IF _session_id IS NULL THEN
    RAISE EXCEPTION 'No open shift. Please start a shift before making sales.';
  END IF;

  _payment_method := CASE WHEN lower(coalesce(_payment_type,'cash')) = 'card' THEN 'card' ELSE 'cash' END;

  SELECT coalesce(full_name, username, 'Cashier') INTO _cashier_name
  FROM public.profiles WHERE id = auth.uid();

  _bill_no := public.next_bill_no('ZIC');

  INSERT INTO public.sales(bill_no, cashier_id, cashier_name, subtotal, tax_amount, discount, total,
    cash_received, change_returned, payment_type, items_count, session_id, payment_method)
  VALUES (_bill_no, auth.uid(), coalesce(_cashier_name,''), _subtotal, _tax_amount, _discount, _total,
    _cash_received, _change_returned, _payment_type, 0, _session_id, _payment_method)
  RETURNING id INTO _sale_id;

  FOR _item IN SELECT * FROM jsonb_array_elements(_items) LOOP
    INSERT INTO public.sale_items(sale_id, product_id, product_name, barcode, qty, unit_price, purchase_price, subtotal)
    VALUES (
      _sale_id,
      (_item->>'product_id')::uuid,
      _item->>'product_name',
      coalesce(_item->>'barcode',''),
      (_item->>'qty')::int,
      (_item->>'unit_price')::numeric,
      coalesce((_item->>'purchase_price')::numeric, 0),
      (_item->>'subtotal')::numeric
    );

    UPDATE public.products
      SET stock = stock - (_item->>'qty')::int, updated_at = now()
      WHERE id = (_item->>'product_id')::uuid;

    _items_count := _items_count + (_item->>'qty')::int;
  END LOOP;

  UPDATE public.sales SET items_count = _items_count WHERE id = _sale_id;

  RETURN jsonb_build_object('sale_id', _sale_id, 'bill_no', _bill_no);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.process_sale_v2(_items jsonb, _subtotal numeric, _tax_amount numeric, _discount numeric, _total numeric, _cash_received numeric, _change_returned numeric, _payment_type text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
  _bill_no text;
  _sale_id uuid;
  _cashier_name text;
  _session_id uuid;
  _payment_method text;
  _item jsonb;
  _items_count int := 0;
  _unit_equals int;
  _unit_name text;
  _qty_base int;
BEGIN
  IF auth.uid() IS NULL THEN RAISE EXCEPTION 'Not authenticated'; END IF;
  SELECT id INTO _session_id FROM public.cash_sessions WHERE user_id = auth.uid() AND status = 'open' LIMIT 1;
  IF _session_id IS NULL THEN RAISE EXCEPTION 'No open shift. Please start a shift before making sales.'; END IF;

  _payment_method := CASE WHEN lower(coalesce(_payment_type,'cash')) = 'card' THEN 'card' ELSE 'cash' END;
  SELECT coalesce(full_name, username, 'Cashier') INTO _cashier_name FROM public.profiles WHERE id = auth.uid();
  _bill_no := public.next_bill_no('ZIC');

  INSERT INTO public.sales(bill_no, cashier_id, cashier_name, subtotal, tax_amount, discount, total,
    cash_received, change_returned, payment_type, items_count, session_id, payment_method)
  VALUES (_bill_no, auth.uid(), coalesce(_cashier_name,''), _subtotal, _tax_amount, _discount, _total,
    _cash_received, _change_returned, _payment_type, 0, _session_id, _payment_method)
  RETURNING id INTO _sale_id;

  FOR _item IN SELECT * FROM jsonb_array_elements(_items) LOOP
    IF NULLIF(_item->>'unit_id','') IS NOT NULL THEN
      SELECT equals_base, name INTO _unit_equals, _unit_name
      FROM public.product_units WHERE id = (_item->>'unit_id')::uuid;
    END IF;
    IF _unit_equals IS NULL THEN
      SELECT pu.equals_base, pu.name INTO _unit_equals, _unit_name
      FROM public.products p LEFT JOIN public.product_units pu ON pu.id = p.base_unit_id
      WHERE p.id = (_item->>'product_id')::uuid;
      _unit_equals := COALESCE(_unit_equals, 1);
      _unit_name := COALESCE(_unit_name, 'Piece');
    END IF;
    _qty_base := (_item->>'qty')::int * _unit_equals;

    INSERT INTO public.sale_items(sale_id, product_id, product_name, barcode, qty, unit_price, purchase_price, subtotal,
                                  unit_id, unit_name, qty_in_unit)
    VALUES (
      _sale_id, (_item->>'product_id')::uuid, _item->>'product_name', coalesce(_item->>'barcode',''),
      _qty_base,
      (_item->>'unit_price')::numeric / _unit_equals,
      coalesce((_item->>'purchase_price')::numeric, 0) / _unit_equals,
      (_item->>'subtotal')::numeric,
      NULLIF(_item->>'unit_id','')::uuid, _unit_name, (_item->>'qty')::numeric
    );

    UPDATE public.products SET stock = stock - _qty_base, updated_at = now()
    WHERE id = (_item->>'product_id')::uuid;

    INSERT INTO public.inventory_movements(product_id, unit_id, unit_name, qty_in_unit, qty_in_base, kind, ref_id, user_id, user_name)
    VALUES ((_item->>'product_id')::uuid, NULLIF(_item->>'unit_id','')::uuid, _unit_name,
            (_item->>'qty')::numeric, -_qty_base, 'sale', _sale_id, auth.uid(), coalesce(_cashier_name,''));

    _items_count := _items_count + _qty_base;
    _unit_equals := NULL;
  END LOOP;

  UPDATE public.sales SET items_count = _items_count WHERE id = _sale_id;
  RETURN jsonb_build_object('sale_id', _sale_id, 'bill_no', _bill_no);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.record_credit_repayment(_amount numeric, _person text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare _uid uuid := auth.uid(); _name text; _session_id uuid; _id uuid; _p text;
begin
  if _uid is null then raise exception 'Not authenticated'; end if;
  if not (has_role(_uid, 'cashier'::app_role) or has_role(_uid, 'admin'::app_role)) then
    raise exception 'Not authorized'; end if;
  if _amount is null or _amount <= 0 then raise exception 'Amount must be positive'; end if;
  _p := coalesce(trim(_person), '');
  if _p = '' then raise exception 'Select who is paying back'; end if;

  select id into _session_id from public.cash_sessions
   where user_id = _uid and status = 'open' limit 1;
  if _session_id is null then raise exception 'No open shift â€” start a shift first'; end if;

  select coalesce(full_name, username, 'Cashier') into _name from public.profiles where id = _uid;

  insert into public.shift_expenses(session_id, cashier_id, cashier_name, amount, description)
  values (_session_id, _uid, coalesce(_name, ''), -1 * _amount, _p)
  returning id into _id;

  return jsonb_build_object('expense_id', _id, 'session_id', _session_id);
end; $function$
;

CREATE OR REPLACE FUNCTION public.record_expense(_amount numeric, _description text DEFAULT ''::text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare _uid uuid := auth.uid(); _name text; _session_id uuid; _id uuid;
begin
  if _uid is null then raise exception 'Not authenticated'; end if;
  if not (has_role(_uid, 'cashier'::app_role) or has_role(_uid, 'admin'::app_role)) then
    raise exception 'Not authorized'; end if;
  if _amount is null or _amount <= 0 then raise exception 'Amount must be positive'; end if;

  select id into _session_id from public.cash_sessions
   where user_id = _uid and status = 'open' limit 1;
  if _session_id is null then raise exception 'No open shift â€” start a shift first'; end if;

  select coalesce(full_name, username, 'Cashier') into _name from public.profiles where id = _uid;

  insert into public.shift_expenses(session_id, cashier_id, cashier_name, amount, description)
  values (_session_id, _uid, coalesce(_name, ''), _amount, coalesce(_description, ''))
  returning id into _id;

  return jsonb_build_object('expense_id', _id, 'session_id', _session_id);
end; $function$
;

CREATE OR REPLACE FUNCTION public.record_supplier_payment(_supplier_id uuid, _amount numeric, _method text DEFAULT 'cash'::text, _notes text DEFAULT ''::text, _payment_date date DEFAULT CURRENT_DATE)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE _uid uuid := auth.uid(); _name text; _session_id uuid; _payment_id uuid; _supplier_name text; _m text; _ml text; _person text;
BEGIN
  IF _uid IS NULL THEN RAISE EXCEPTION 'Not authenticated'; END IF;
  IF NOT (has_role(_uid,'cashier'::app_role) OR has_role(_uid,'admin'::app_role)) THEN
    RAISE EXCEPTION 'Not authorized'; END IF;
  IF _amount IS NULL OR _amount <= 0 THEN RAISE EXCEPTION 'Amount must be positive'; END IF;
  SELECT name INTO _supplier_name FROM public.suppliers WHERE id = _supplier_id;
  IF _supplier_name IS NULL THEN RAISE EXCEPTION 'Supplier not found'; END IF;

  SELECT coalesce(full_name, username, 'Cashier') INTO _name FROM public.profiles WHERE id = _uid;
  SELECT id INTO _session_id FROM public.cash_sessions
   WHERE user_id = _uid AND status = 'open' LIMIT 1;

  _m := coalesce(_method,'cash');
  _ml := lower(trim(_m));

  INSERT INTO public.supplier_payments
    (supplier_id, amount, method, notes, payment_date, created_by, created_by_name, session_id)
  VALUES (_supplier_id, _amount, _m, coalesce(_notes,''),
          coalesce(_payment_date,CURRENT_DATE), _uid, coalesce(_name,''), _session_id)
  RETURNING id INTO _payment_id;

  _person := CASE
    WHEN _m = 'Junaid' OR _ml IN ('easypaisa','online') THEN 'Junaid'
    WHEN _m = 'Usama'  OR _ml = 'jazzcash'              THEN 'Usama'
    WHEN _m = 'Others'                                  THEN 'Others'
    ELSE NULL
  END;

  IF _person IS NOT NULL THEN
    INSERT INTO public.person_payments
      (payment_date, person_name, amount, payment_method, notes, recorded_by, recorded_by_name)
    VALUES (coalesce(_payment_date,CURRENT_DATE), _person, _amount, _m,
            'Supplier payment: ' || _supplier_name || CASE WHEN coalesce(_notes,'') <> '' THEN ' â€” ' || _notes ELSE '' END,
            _uid, coalesce(_name,''));
  END IF;

  RETURN jsonb_build_object('payment_id',_payment_id,'session_id',_session_id);
END; $function$
;



-- ------------------------------------------------------------
-- Functions (from live database) [part 4/4]
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.reject_price_change(_request_id uuid, _notes text DEFAULT ''::text)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE _status text; _reviewer text;
BEGIN
  IF NOT public.has_role(auth.uid(),'admin') THEN RAISE EXCEPTION 'Only admins can reject'; END IF;
  SELECT status INTO _status FROM public.price_change_requests WHERE id = _request_id FOR UPDATE;
  IF _status IS NULL THEN RAISE EXCEPTION 'Request not found'; END IF;
  IF _status <> 'pending' THEN RAISE EXCEPTION 'Only pending requests can be rejected'; END IF;

  SELECT coalesce(full_name, username, 'Admin') INTO _reviewer FROM public.profiles WHERE id = auth.uid();

  UPDATE public.price_change_requests
     SET status = 'rejected', reviewed_by = auth.uid(),
         reviewed_by_name = _reviewer, reviewed_at = now(),
         review_notes = coalesce(_notes,'')
   WHERE id = _request_id;
END; $function$
;

CREATE OR REPLACE FUNCTION public.reject_stock_entry(_entry_id uuid, _reason text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
  _status text;
  _rejecter text;
BEGIN
  IF NOT public.has_role(auth.uid(), 'admin') THEN
    RAISE EXCEPTION 'Only admins can reject stock entries';
  END IF;

  SELECT status INTO _status FROM public.stock_entries WHERE id = _entry_id FOR UPDATE;
  IF _status IS NULL THEN RAISE EXCEPTION 'Stock entry not found'; END IF;
  IF _status <> 'pending' THEN RAISE EXCEPTION 'Only pending entries can be rejected'; END IF;

  SELECT coalesce(full_name, username, 'Admin') INTO _rejecter FROM public.profiles WHERE id = auth.uid();

  UPDATE public.stock_entries
    SET status = 'rejected', rejected_by = auth.uid(), rejected_by_name = coalesce(_rejecter, ''),
        rejected_at = now(), rejection_reason = coalesce(_reason, '')
    WHERE id = _entry_id;

  RETURN jsonb_build_object('entry_id', _entry_id, 'status', 'rejected');
END;
$function$
;

CREATE OR REPLACE FUNCTION public.reject_stock_reconciliation(_id uuid, _reason text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE _r record; _reviewer text;
BEGIN
  IF NOT public.has_role(auth.uid(), 'admin') THEN
    RAISE EXCEPTION 'Only admins can reject reconciliations';
  END IF;
  SELECT * INTO _r FROM public.stock_reconciliations WHERE id = _id FOR UPDATE;
  IF _r.id IS NULL THEN RAISE EXCEPTION 'Reconciliation not found'; END IF;
  IF _r.status <> 'pending' THEN RAISE EXCEPTION 'Only pending reconciliations can be rejected'; END IF;

  SELECT COALESCE(full_name, username, 'Admin') INTO _reviewer FROM public.profiles WHERE id = auth.uid();

  UPDATE public.stock_reconciliations
     SET status = 'rejected', reviewed_by = auth.uid(), reviewed_by_name = _reviewer,
         reviewed_at = now(), review_notes = COALESCE(_reason,'')
   WHERE id = _id;

  RETURN jsonb_build_object('id', _id, 'status', 'rejected');
END;
$function$
;

CREATE OR REPLACE FUNCTION public.request_price_change(_product_id uuid, _requested_purchase numeric, _requested_sale numeric, _reason text DEFAULT ''::text)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE _uid uuid := auth.uid(); _name text; _pname text; _cp numeric; _cs numeric; _id uuid;
BEGIN
  IF _uid IS NULL THEN RAISE EXCEPTION 'Not authenticated'; END IF;
  IF NOT (public.has_role(_uid,'cashier'::app_role) OR public.has_role(_uid,'admin'::app_role)) THEN
    RAISE EXCEPTION 'Not authorized'; END IF;
  IF _requested_purchase IS NULL OR _requested_purchase < 0
     OR _requested_sale IS NULL OR _requested_sale < 0 THEN
    RAISE EXCEPTION 'Prices must be non-negative'; END IF;

  SELECT name, purchase_price, sale_price INTO _pname, _cp, _cs
    FROM public.products WHERE id = _product_id;
  IF _pname IS NULL THEN RAISE EXCEPTION 'Product not found'; END IF;

  SELECT coalesce(full_name, username, 'Cashier') INTO _name FROM public.profiles WHERE id = _uid;

  INSERT INTO public.price_change_requests(
    product_id, product_name,
    current_purchase_price, current_sale_price,
    requested_purchase_price, requested_sale_price,
    reason, requested_by, requested_by_name, status
  ) VALUES (
    _product_id, _pname, _cp, _cs,
    _requested_purchase, _requested_sale,
    coalesce(_reason,''), _uid, coalesce(_name,''), 'pending'
  ) RETURNING id INTO _id;

  RETURN _id;
END; $function$
;

CREATE OR REPLACE FUNCTION public.save_product_with_units(_product jsonb, _units jsonb, _initial_stock jsonb DEFAULT NULL::jsonb)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
  _pid uuid;
  _is_new boolean := false;
  _is_admin boolean;
  _base_id uuid;
  _u jsonb;
  _new_unit_id uuid;
  _bases_count int;
  _init_unit uuid;
  _init_qty int;
  _init_base int;
  _init_equals int;
  _name text;
BEGIN
  _is_admin := has_role(auth.uid(), 'admin'::app_role);
  IF NOT (_is_admin OR has_role(auth.uid(), 'cashier'::app_role)) THEN
    RAISE EXCEPTION 'Not authorized';
  END IF;

  _pid := NULLIF(_product->>'id','')::uuid;

  IF _units IS NULL OR jsonb_array_length(_units) = 0 THEN
    RAISE EXCEPTION 'At least one unit is required';
  END IF;
  SELECT count(*) INTO _bases_count FROM jsonb_array_elements(_units) u WHERE (u->>'is_base')::boolean = true;
  IF _bases_count <> 1 THEN RAISE EXCEPTION 'Exactly one base unit is required'; END IF;

  IF _pid IS NULL THEN
    _is_new := true;
    INSERT INTO public.products (name, barcode, category_id, purchase_price, sale_price, stock, min_stock_alert, is_active)
    VALUES (
      _product->>'name',
      _product->>'barcode',
      NULLIF(_product->>'category_id','')::uuid,
      COALESCE((_product->>'purchase_price')::numeric, 0),
      COALESCE((_product->>'sale_price')::numeric, 0),
      0,
      COALESCE((_product->>'min_stock_alert')::int, 5),
      COALESCE((_product->>'is_active')::boolean, true)
    ) RETURNING id INTO _pid;
  ELSE
    UPDATE public.products SET
      name = _product->>'name',
      barcode = _product->>'barcode',
      category_id = NULLIF(_product->>'category_id','')::uuid,
      purchase_price = CASE WHEN _is_admin THEN COALESCE((_product->>'purchase_price')::numeric, purchase_price) ELSE purchase_price END,
      sale_price = CASE WHEN _is_admin THEN COALESCE((_product->>'sale_price')::numeric, sale_price) ELSE sale_price END,
      min_stock_alert = COALESCE((_product->>'min_stock_alert')::int, min_stock_alert),
      is_active = COALESCE((_product->>'is_active')::boolean, is_active),
      updated_at = now()
    WHERE id = _pid;
  END IF;

  DELETE FROM public.product_units
  WHERE product_id = _pid
    AND id NOT IN (
      SELECT NULLIF(x->>'id','')::uuid FROM jsonb_array_elements(_units) x
      WHERE NULLIF(x->>'id','') IS NOT NULL
    );

  FOR _u IN SELECT * FROM jsonb_array_elements(_units) LOOP
    IF NULLIF(_u->>'id','') IS NOT NULL THEN
      UPDATE public.product_units SET
        name = _u->>'name',
        equals_base = (_u->>'equals_base')::int,
        is_base = (_u->>'is_base')::boolean,
        is_default_sale = COALESCE((_u->>'is_default_sale')::boolean, false),
        sku = NULLIF(_u->>'sku',''),
        barcode = NULLIF(_u->>'barcode',''),
        purchase_price = CASE WHEN _is_admin THEN COALESCE((_u->>'purchase_price')::numeric, 0) ELSE purchase_price END,
        sale_price = CASE WHEN _is_admin THEN COALESCE((_u->>'sale_price')::numeric, 0) ELSE sale_price END,
        sort_order = COALESCE((_u->>'sort_order')::int, 0),
        updated_at = now()
      WHERE id = (_u->>'id')::uuid AND product_id = _pid
      RETURNING id INTO _new_unit_id;
    ELSE
      INSERT INTO public.product_units(product_id, name, equals_base, is_base, is_default_sale, sku, barcode, purchase_price, sale_price, sort_order)
      VALUES (
        _pid, _u->>'name', (_u->>'equals_base')::int,
        (_u->>'is_base')::boolean, COALESCE((_u->>'is_default_sale')::boolean, false),
        NULLIF(_u->>'sku',''), NULLIF(_u->>'barcode',''),
        COALESCE((_u->>'purchase_price')::numeric, 0),
        COALESCE((_u->>'sale_price')::numeric, 0),
        COALESCE((_u->>'sort_order')::int, 0)
      ) RETURNING id INTO _new_unit_id;
    END IF;

    IF (_u->>'is_base')::boolean THEN _base_id := _new_unit_id; END IF;
  END LOOP;

  UPDATE public.products SET base_unit_id = _base_id WHERE id = _pid;

  IF _initial_stock IS NOT NULL AND (_initial_stock->>'qty') IS NOT NULL THEN
    _init_unit := (_initial_stock->>'unit_id')::uuid;
    _init_qty := (_initial_stock->>'qty')::int;
    IF _init_qty > 0 AND _init_unit IS NOT NULL THEN
      SELECT equals_base, name INTO _init_equals, _name FROM public.product_units WHERE id = _init_unit;
      IF _init_equals IS NULL THEN RAISE EXCEPTION 'Initial stock unit not found'; END IF;
      _init_base := _init_qty * _init_equals;
      UPDATE public.products SET stock = stock + _init_base, updated_at = now() WHERE id = _pid;
      INSERT INTO public.inventory_movements(product_id, unit_id, unit_name, qty_in_unit, qty_in_base, kind, user_id, user_name)
      VALUES (_pid, _init_unit, _name, _init_qty, _init_base, 'initial', auth.uid(),
        COALESCE((SELECT full_name FROM public.profiles WHERE id = auth.uid()), ''));
    END IF;
  END IF;

  RETURN _pid;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.sync_base_unit_prices()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
BEGIN
  IF NEW.purchase_price IS DISTINCT FROM OLD.purchase_price
     OR NEW.sale_price IS DISTINCT FROM OLD.sale_price THEN
    UPDATE public.product_units
       SET purchase_price = NEW.purchase_price,
           sale_price     = NEW.sale_price,
           updated_at     = now()
     WHERE product_id = NEW.id AND is_base = true;
  END IF;
  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.test_sales_range(_start_at timestamp with time zone, _end_at timestamp with time zone)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public', 'auth'
AS $function$
DECLARE
  _c int;
  _s numeric;
  _min timestamptz;
  _max timestamptz;
BEGIN
  SELECT count(*), coalesce(sum(total), 0), min(created_at), max(created_at)
  INTO _c, _s, _min, _max
  FROM public.sales
  WHERE created_at >= _start_at AND created_at <= _end_at;

  RETURN jsonb_build_object(
    'count', _c,
    'sum', _s,
    'min_in_range', _min,
    'max_in_range', _max,
    'passed_start', _start_at,
    'passed_end', _end_at
  );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.touch_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO 'public'
AS $function$
begin new.updated_at = now(); return new; end;
$function$
;

CREATE OR REPLACE FUNCTION public.update_product_prices(_product_id uuid, _purchase_price numeric, _sale_price numeric)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
BEGIN
  IF NOT public.has_role(auth.uid(), 'admin'::app_role) THEN
    RAISE EXCEPTION 'Only admins can change prices. Please submit a price change request.';
  END IF;
  IF _purchase_price IS NULL OR _purchase_price < 0 OR _sale_price IS NULL OR _sale_price < 0 THEN
    RAISE EXCEPTION 'Prices must be non-negative';
  END IF;
  UPDATE public.products
     SET purchase_price = _purchase_price,
         sale_price = _sale_price,
         updated_at = now()
   WHERE id = _product_id;

  UPDATE public.product_units
     SET purchase_price = _purchase_price,
         sale_price     = _sale_price,
         updated_at     = now()
   WHERE product_id = _product_id AND is_base = true;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.void_return(_return_id uuid, _reason text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  _status text;
  _voider text;
  _it record;
begin
  if not public.has_role(auth.uid(), 'admin') then
    raise exception 'Only admins can void returns';
  end if;

  select status into _status from public.returns where id = _return_id for update;
  if _status is null then raise exception 'Return not found'; end if;
  if _status = 'voided' then raise exception 'Return already voided'; end if;

  select coalesce(full_name, username, 'Admin') into _voider
  from public.profiles where id = auth.uid();

  if _status = 'approved' then
    for _it in select product_id, qty from public.return_items where return_id = _return_id loop
      if _it.product_id is not null then
        update public.products
          set stock = stock - _it.qty, updated_at = now()
          where id = _it.product_id;
      end if;
    end loop;
  end if;

  update public.returns
    set status = 'voided',
        voided_by = auth.uid(),
        voided_by_name = coalesce(_voider,''),
        voided_at = now(),
        void_reason = coalesce(_reason,'')
    where id = _return_id;

  return jsonb_build_object('return_id', _return_id, 'status', 'voided');
end;
$function$
;

CREATE OR REPLACE FUNCTION public.who_am_i()
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public', 'auth'
AS $function$
DECLARE
  _uid uuid;
  _role text;
  _claims jsonb;
  _is_admin boolean;
BEGIN
  _uid := auth.uid();
  _role := auth.role();
  _claims := nullif(current_setting('request.jwt.claims', true), '')::jsonb;
  _is_admin := public.has_role(_uid, 'admin');

  RETURN jsonb_build_object(
    'uid', _uid,
    'role', _role,
    'claims', _claims,
    'is_admin', _is_admin
  );
END;
$function$
;



-- ------------------------------------------------------------
-- Triggers
-- ------------------------------------------------------------
CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
CREATE TRIGGER trg_manual_sale_days_touch BEFORE UPDATE ON public.manual_sale_days FOR EACH ROW EXECUTE FUNCTION public.touch_updated_at();
CREATE TRIGGER pcr_touch BEFORE UPDATE ON public.price_change_requests FOR EACH ROW EXECUTE FUNCTION public.touch_updated_at();
CREATE TRIGGER product_units_touch BEFORE UPDATE ON public.product_units FOR EACH ROW EXECUTE FUNCTION public.touch_updated_at();
CREATE TRIGGER products_touch BEFORE UPDATE ON public.products FOR EACH ROW EXECUTE FUNCTION public.touch_updated_at();
CREATE TRIGGER trg_sync_base_unit_prices AFTER UPDATE OF purchase_price, sale_price ON public.products FOR EACH ROW EXECUTE FUNCTION public.sync_base_unit_prices();
CREATE TRIGGER trg_suppliers_updated BEFORE UPDATE ON public.suppliers FOR EACH ROW EXECUTE FUNCTION public.touch_updated_at();

-- ------------------------------------------------------------
-- Row Level Security policies
-- ------------------------------------------------------------
CREATE POLICY "billseq admin read" ON public.bill_sequences AS PERMISSIVE FOR SELECT TO public USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "billseq authenticated read" ON public.bill_sequences AS PERMISSIVE FOR SELECT TO authenticated USING (true);
CREATE POLICY "sessions admin read" ON public.cash_sessions AS PERMISSIVE FOR SELECT TO public USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "sessions admin update" ON public.cash_sessions AS PERMISSIVE FOR UPDATE TO public USING (has_role(auth.uid(), 'admin'::app_role)) WITH CHECK (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "sessions own insert" ON public.cash_sessions AS PERMISSIVE FOR INSERT TO authenticated WITH CHECK ((auth.uid() = user_id));
CREATE POLICY "sessions own read" ON public.cash_sessions AS PERMISSIVE FOR SELECT TO public USING ((auth.uid() = user_id));
CREATE POLICY "sessions own update" ON public.cash_sessions AS PERMISSIVE FOR UPDATE TO authenticated USING ((auth.uid() = user_id)) WITH CHECK ((auth.uid() = user_id));
CREATE POLICY "cat admin write" ON public.categories AS PERMISSIVE FOR ALL TO public USING (has_role(auth.uid(), 'admin'::app_role)) WITH CHECK (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "cat read" ON public.categories AS PERMISSIVE FOR SELECT TO authenticated USING (true);
CREATE POLICY "Admins can delete feedback" ON public.customer_feedback AS PERMISSIVE FOR DELETE TO authenticated USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Admins can update feedback" ON public.customer_feedback AS PERMISSIVE FOR UPDATE TO authenticated USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Admins can view all feedback" ON public.customer_feedback AS PERMISSIVE FOR SELECT TO authenticated USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Anyone can submit feedback" ON public.customer_feedback AS PERMISSIVE FOR INSERT TO anon, authenticated WITH CHECK ((((char_length(message) >= 1) AND (char_length(message) <= 2000)) AND ((name IS NULL) OR (char_length(name) <= 100)) AND ((contact IS NULL) OR (char_length(contact) <= 150)) AND (category = ANY (ARRAY['general'::text, 'suggestion'::text, 'complaint'::text, 'compliment'::text, 'product'::text, 'service'::text]))));
CREATE POLICY "daily_expenses admin all" ON public.daily_expenses AS PERMISSIVE FOR ALL TO public USING (has_role(auth.uid(), 'admin'::app_role)) WITH CHECK (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "inv_mov admin read" ON public.inventory_movements AS PERMISSIVE FOR SELECT TO public USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "inv_mov insert" ON public.inventory_movements AS PERMISSIVE FOR INSERT TO authenticated WITH CHECK (((auth.uid() = user_id) AND (has_role(auth.uid(), 'cashier'::app_role) OR has_role(auth.uid(), 'admin'::app_role))));
CREATE POLICY "inv_mov own read" ON public.inventory_movements AS PERMISSIVE FOR SELECT TO public USING ((auth.uid() = user_id));
CREATE POLICY "Admins manage manual sale days" ON public.manual_sale_days AS PERMISSIVE FOR ALL TO authenticated USING (has_role(auth.uid(), 'admin'::app_role)) WITH CHECK (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Cashiers can enter counter cash" ON public.manual_sale_days AS PERMISSIVE FOR INSERT TO authenticated WITH CHECK ((has_role(auth.uid(), 'cashier'::app_role) OR has_role(auth.uid(), 'admin'::app_role)));
CREATE POLICY "Cashiers can read manual sale days" ON public.manual_sale_days AS PERMISSIVE FOR SELECT TO authenticated USING ((has_role(auth.uid(), 'cashier'::app_role) OR has_role(auth.uid(), 'admin'::app_role)));
CREATE POLICY "Cashiers can update counter cash" ON public.manual_sale_days AS PERMISSIVE FOR UPDATE TO authenticated USING ((has_role(auth.uid(), 'cashier'::app_role) OR has_role(auth.uid(), 'admin'::app_role))) WITH CHECK ((has_role(auth.uid(), 'cashier'::app_role) OR has_role(auth.uid(), 'admin'::app_role)));
CREATE POLICY "Admins manage persons" ON public.manual_sale_persons AS PERMISSIVE FOR ALL TO authenticated USING (has_role(auth.uid(), 'admin'::app_role)) WITH CHECK (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Authenticated read persons" ON public.manual_sale_persons AS PERMISSIVE FOR SELECT TO authenticated USING (true);
CREATE POLICY "operating_expenses admin all" ON public.operating_expenses AS PERMISSIVE FOR ALL TO public USING (has_role(auth.uid(), 'admin'::app_role)) WITH CHECK (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "person_payments admin all" ON public.person_payments AS PERMISSIVE FOR ALL TO public USING (has_role(auth.uid(), 'admin'::app_role)) WITH CHECK (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Admins manage starting balances" ON public.person_starting_balances AS PERMISSIVE FOR ALL TO authenticated USING (has_role(auth.uid(), 'admin'::app_role)) WITH CHECK (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Admins read starting balances" ON public.person_starting_balances AS PERMISSIVE FOR SELECT TO authenticated USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Authenticated can create own price requests" ON public.price_change_requests AS PERMISSIVE FOR INSERT TO authenticated WITH CHECK ((requested_by = auth.uid()));
CREATE POLICY "pcr admin write" ON public.price_change_requests AS PERMISSIVE FOR ALL TO authenticated USING (has_role(auth.uid(), 'admin'::app_role)) WITH CHECK (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "pcr read" ON public.price_change_requests AS PERMISSIVE FOR SELECT TO authenticated USING ((has_role(auth.uid(), 'admin'::app_role) OR (requested_by = auth.uid())));
CREATE POLICY "punits admin write" ON public.product_units AS PERMISSIVE FOR ALL TO public USING (has_role(auth.uid(), 'admin'::app_role)) WITH CHECK (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "punits cashier insert" ON public.product_units AS PERMISSIVE FOR INSERT TO authenticated WITH CHECK ((has_role(auth.uid(), 'cashier'::app_role) OR has_role(auth.uid(), 'admin'::app_role)));
CREATE POLICY "punits read" ON public.product_units AS PERMISSIVE FOR SELECT TO authenticated USING (true);
CREATE POLICY "prod admin write" ON public.products AS PERMISSIVE FOR ALL TO public USING (has_role(auth.uid(), 'admin'::app_role)) WITH CHECK (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "prod cashier insert" ON public.products AS PERMISSIVE FOR INSERT TO authenticated WITH CHECK ((has_role(auth.uid(), 'cashier'::app_role) OR has_role(auth.uid(), 'admin'::app_role)));
CREATE POLICY "prod read" ON public.products AS PERMISSIVE FOR SELECT TO authenticated USING (true);
CREATE POLICY "profiles admin manage" ON public.profiles AS PERMISSIVE FOR ALL TO public USING (has_role(auth.uid(), 'admin'::app_role)) WITH CHECK (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "profiles admin read all" ON public.profiles AS PERMISSIVE FOR SELECT TO public USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "profiles self read" ON public.profiles AS PERMISSIVE FOR SELECT TO public USING ((auth.uid() = id));
CREATE POLICY "profiles self update" ON public.profiles AS PERMISSIVE FOR UPDATE TO public USING ((auth.uid() = id));
CREATE POLICY "return_items own insert" ON public.return_items AS PERMISSIVE FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM returns r
  WHERE ((r.id = return_items.return_id) AND (r.cashier_id = auth.uid())))));
CREATE POLICY "return_items read own" ON public.return_items AS PERMISSIVE FOR SELECT TO public USING ((EXISTS ( SELECT 1
   FROM returns r
  WHERE ((r.id = return_items.return_id) AND ((r.cashier_id = auth.uid()) OR has_role(auth.uid(), 'admin'::app_role))))));
CREATE POLICY "returns admin read" ON public.returns AS PERMISSIVE FOR SELECT TO public USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "returns own insert" ON public.returns AS PERMISSIVE FOR INSERT TO authenticated WITH CHECK ((auth.uid() = cashier_id));
CREATE POLICY "returns own read" ON public.returns AS PERMISSIVE FOR SELECT TO public USING ((auth.uid() = cashier_id));
CREATE POLICY "returns own update" ON public.returns AS PERMISSIVE FOR UPDATE TO authenticated USING ((auth.uid() = cashier_id)) WITH CHECK ((auth.uid() = cashier_id));
CREATE POLICY "sale_items own insert" ON public.sale_items AS PERMISSIVE FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM sales s
  WHERE ((s.id = sale_items.sale_id) AND (s.cashier_id = auth.uid())))));
CREATE POLICY "sale_items read policy" ON public.sale_items AS PERMISSIVE FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM sales s
  WHERE ((s.id = sale_items.sale_id) AND ((s.cashier_id = auth.uid()) OR has_role(auth.uid(), 'admin'::app_role))))));
CREATE POLICY "sales own insert" ON public.sales AS PERMISSIVE FOR INSERT TO authenticated WITH CHECK ((auth.uid() = cashier_id));
CREATE POLICY "sales read policy" ON public.sales AS PERMISSIVE FOR SELECT TO authenticated USING (((auth.uid() = cashier_id) OR has_role(auth.uid(), 'admin'::app_role)));
CREATE POLICY "shift_expenses admin all" ON public.shift_expenses AS PERMISSIVE FOR ALL TO public USING (has_role(auth.uid(), 'admin'::app_role)) WITH CHECK (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "shift_expenses own insert" ON public.shift_expenses AS PERMISSIVE FOR INSERT TO authenticated WITH CHECK ((cashier_id = auth.uid()));
CREATE POLICY "shift_expenses select own" ON public.shift_expenses AS PERMISSIVE FOR SELECT TO public USING (((cashier_id = auth.uid()) OR has_role(auth.uid(), 'admin'::app_role)));
CREATE POLICY "Admins can view all stock entries" ON public.stock_entries AS PERMISSIVE FOR SELECT TO public USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Cashiers can create stock entries" ON public.stock_entries AS PERMISSIVE FOR INSERT TO public WITH CHECK ((auth.uid() = cashier_id));
CREATE POLICY "Cashiers can view their own stock entries" ON public.stock_entries AS PERMISSIVE FOR SELECT TO public USING ((auth.uid() = cashier_id));
CREATE POLICY "stock_entries admin delete" ON public.stock_entries AS PERMISSIVE FOR DELETE TO authenticated USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "stock_entries admin read" ON public.stock_entries AS PERMISSIVE FOR SELECT TO public USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "stock_entries admin update" ON public.stock_entries AS PERMISSIVE FOR UPDATE TO authenticated USING (has_role(auth.uid(), 'admin'::app_role)) WITH CHECK (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "stock_entries cashier insert" ON public.stock_entries AS PERMISSIVE FOR INSERT TO public WITH CHECK (((auth.uid() = cashier_id) AND (has_role(auth.uid(), 'cashier'::app_role) OR has_role(auth.uid(), 'admin'::app_role))));
CREATE POLICY "stock_entries own read" ON public.stock_entries AS PERMISSIVE FOR SELECT TO public USING ((auth.uid() = cashier_id));
CREATE POLICY "Admins can view all reconciliations" ON public.stock_reconciliations AS PERMISSIVE FOR SELECT TO authenticated USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Users can insert their own reconciliations" ON public.stock_reconciliations AS PERMISSIVE FOR INSERT TO authenticated WITH CHECK ((auth.uid() = created_by));
CREATE POLICY "Users can view their own reconciliations" ON public.stock_reconciliations AS PERMISSIVE FOR SELECT TO authenticated USING ((auth.uid() = created_by));
CREATE POLICY "settings admin write" ON public.store_settings AS PERMISSIVE FOR ALL TO public USING (has_role(auth.uid(), 'admin'::app_role)) WITH CHECK (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "settings read" ON public.store_settings AS PERMISSIVE FOR SELECT TO authenticated USING (true);
CREATE POLICY "supplier_payments admin all" ON public.supplier_payments AS PERMISSIVE FOR ALL TO public USING (has_role(auth.uid(), 'admin'::app_role)) WITH CHECK (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "supplier_payments cashier select" ON public.supplier_payments AS PERMISSIVE FOR SELECT TO public USING (has_role(auth.uid(), 'cashier'::app_role));
CREATE POLICY "supplier_payments own read" ON public.supplier_payments AS PERMISSIVE FOR SELECT TO authenticated USING (((created_by = auth.uid()) OR has_role(auth.uid(), 'admin'::app_role)));
CREATE POLICY "supplier_purchases admin all" ON public.supplier_purchases AS PERMISSIVE FOR ALL TO public USING (has_role(auth.uid(), 'admin'::app_role)) WITH CHECK (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "supplier_purchases cashier select" ON public.supplier_purchases AS PERMISSIVE FOR SELECT TO public USING (has_role(auth.uid(), 'cashier'::app_role));
CREATE POLICY "supplier_purchases own read" ON public.supplier_purchases AS PERMISSIVE FOR SELECT TO authenticated USING (((created_by = auth.uid()) OR has_role(auth.uid(), 'admin'::app_role)));
CREATE POLICY "suppliers admin all" ON public.suppliers AS PERMISSIVE FOR ALL TO public USING (has_role(auth.uid(), 'admin'::app_role)) WITH CHECK (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "suppliers authenticated read" ON public.suppliers AS PERMISSIVE FOR SELECT TO authenticated USING (true);
CREATE POLICY "suppliers cashier select" ON public.suppliers AS PERMISSIVE FOR SELECT TO public USING (has_role(auth.uid(), 'cashier'::app_role));
CREATE POLICY "audit admin insert" ON public.user_audit_log AS PERMISSIVE FOR INSERT TO public WITH CHECK (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "audit admin read" ON public.user_audit_log AS PERMISSIVE FOR SELECT TO public USING (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "admin manage user_roles" ON public.user_roles AS PERMISSIVE FOR ALL TO authenticated USING (has_role(auth.uid(), 'admin'::app_role)) WITH CHECK (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "allow read user_roles" ON public.user_roles AS PERMISSIVE FOR SELECT TO authenticated USING (true);

-- ------------------------------------------------------------
-- Grants (match Supabase defaults for anon/authenticated/service_role)
-- ------------------------------------------------------------
grant usage on schema public to anon, authenticated, service_role;
grant all on all tables in schema public to anon, authenticated, service_role;
grant all on all sequences in schema public to anon, authenticated, service_role;
grant all on all functions in schema public to anon, authenticated, service_role;

-- ------------------------------------------------------------
-- Seed: default store settings row (optional)
-- ------------------------------------------------------------
insert into public.store_settings (id) values (1) on conflict (id) do nothing;



