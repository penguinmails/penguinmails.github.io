CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE "users" (
  "id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
  "email" text NOT NULL,
  "name" text,
  "family_name" text,
  "given_name" text,
  "picture" text,
  "email_verified" timestamp with time zone,
  "created" timestamp with time zone DEFAULT now() NOT NULL,
  "updated" timestamp with time zone DEFAULT now() NOT NULL,
  "deleted" timestamp with time zone
);

CREATE TABLE "tenants" (
  "id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
  "name" text NOT NULL,
  "compute_id" uuid,
  "created" timestamp with time zone DEFAULT now() NOT NULL,
  "updated" timestamp with time zone DEFAULT now() NOT NULL,
  "deleted" timestamp with time zone
);

CREATE TABLE "tenant_users" (
  "tenant_id" uuid NOT NULL,
  "user_id" uuid NOT NULL,
  "roles" text[] DEFAULT '{member}'::text[] NOT NULL,
  "email" text,
  "created" timestamp with time zone DEFAULT now() NOT NULL,
  "updated" timestamp with time zone DEFAULT now() NOT NULL,
  "deleted" timestamp with time zone,
  CONSTRAINT "tenant_users_tenant_id_user_id_pk" PRIMARY KEY("tenant_id","user_id"),
  CONSTRAINT "tenant_users_tenant_id_tenants_id_fk" FOREIGN KEY ("tenant_id") REFERENCES "public"."tenants"("id") ON DELETE cascade ON UPDATE no action,
  CONSTRAINT "tenant_users_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action
);

CREATE UNIQUE INDEX "users_email_unique_idx" ON "users" USING btree ("email");
CREATE INDEX "users_email_idx" ON "users" USING btree ("email");
CREATE INDEX "tenant_users_tenant_id_idx" ON "tenant_users" USING btree ("tenant_id");
CREATE INDEX "tenant_users_user_id_idx" ON "tenant_users" USING btree ("user_id");
