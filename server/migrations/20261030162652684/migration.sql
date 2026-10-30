BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "account_access" (
    "id" bigserial PRIMARY KEY,
    "accountId" bigint NOT NULL,
    "authUserId" uuid NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "account_access_account_user_idx" ON "account_access" USING btree ("accountId", "authUserId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "accounts" (
    "id" bigserial PRIMARY KEY,
    "groupId" bigint NOT NULL,
    "name" text NOT NULL,
    "kind" text NOT NULL,
    "bank" text,
    "currency" text NOT NULL DEFAULT 'EUR'::text,
    "initialBalanceCents" bigint NOT NULL DEFAULT 0,
    "initialBalanceDate" timestamp without time zone,
    "alertThresholdCents" bigint NOT NULL DEFAULT 0,
    "visibility" text NOT NULL DEFAULT 'shared'::text,
    "color" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "accounts_group_idx" ON "accounts" USING btree ("groupId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "audit_log" (
    "id" bigserial PRIMARY KEY,
    "groupId" bigint,
    "authUserId" uuid,
    "action" text NOT NULL,
    "entity" text NOT NULL,
    "rowId" text,
    "before" text,
    "after" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "audit_log_group_created_idx" ON "audit_log" USING btree ("groupId", "createdAt");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "categories" (
    "id" bigserial PRIMARY KEY,
    "groupId" bigint NOT NULL,
    "parentId" bigint,
    "name" text NOT NULL,
    "kind" text NOT NULL,
    "standardCode" text,
    "icon" text,
    "color" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "categories_group_idx" ON "categories" USING btree ("groupId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "community_rules" (
    "id" bigserial PRIMARY KEY,
    "ruleKey" text NOT NULL,
    "pattern" text NOT NULL,
    "matchType" text NOT NULL,
    "direction" text NOT NULL DEFAULT 'any'::text,
    "standardCode" text NOT NULL,
    "country" text NOT NULL DEFAULT 'FR'::text,
    "confidence" bigint NOT NULL DEFAULT 50,
    "baseVersion" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "community_rules_key_idx" ON "community_rules" USING btree ("ruleKey");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "group_members" (
    "id" bigserial PRIMARY KEY,
    "groupId" bigint NOT NULL,
    "authUserId" uuid NOT NULL,
    "role" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "group_members_group_user_idx" ON "group_members" USING btree ("groupId", "authUserId");
CREATE INDEX "group_members_user_idx" ON "group_members" USING btree ("authUserId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "groups" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "aiEnabled" boolean NOT NULL DEFAULT false,
    "createdBy" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "imports" (
    "id" bigserial PRIMARY KEY,
    "accountId" bigint NOT NULL,
    "format" text NOT NULL,
    "fileName" text NOT NULL,
    "fileHash" text NOT NULL,
    "encoding" text NOT NULL,
    "readCount" bigint NOT NULL,
    "addedCount" bigint NOT NULL,
    "duplicateCount" bigint NOT NULL,
    "possibleDuplicateCount" bigint NOT NULL,
    "errorCount" bigint NOT NULL,
    "classifiedCount" bigint NOT NULL,
    "authorId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "cancelledAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "imports_account_idx" ON "imports" USING btree ("accountId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "rules" (
    "id" bigserial PRIMARY KEY,
    "groupId" bigint NOT NULL,
    "categoryId" bigint NOT NULL,
    "matchType" text NOT NULL,
    "pattern" text NOT NULL,
    "direction" text NOT NULL DEFAULT 'any'::text,
    "minAbsCents" bigint,
    "maxAbsCents" bigint,
    "priority" bigint NOT NULL DEFAULT 100,
    "enabled" boolean NOT NULL DEFAULT true,
    "createdBy" uuid,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "rules_group_idx" ON "rules" USING btree ("groupId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "scheduled_transactions" (
    "id" bigserial PRIMARY KEY,
    "accountId" bigint NOT NULL,
    "amountCents" bigint NOT NULL,
    "label" text NOT NULL,
    "categoryId" bigint,
    "frequency" text NOT NULL,
    "interval" bigint NOT NULL DEFAULT 1,
    "startDate" timestamp without time zone NOT NULL,
    "endDate" timestamp without time zone,
    "occurrenceCount" bigint,
    "nextDue" timestamp without time zone,
    "matchPattern" text NOT NULL DEFAULT ''::text,
    "dateToleranceDays" bigint NOT NULL DEFAULT 5,
    "amountTolerancePercent" bigint NOT NULL DEFAULT 0,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "scheduled_account_idx" ON "scheduled_transactions" USING btree ("accountId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "standard_categories" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "parentCode" text,
    "kind" text NOT NULL,
    "nameFr" text NOT NULL,
    "nameEn" text NOT NULL,
    "icon" text,
    "deprecated" boolean NOT NULL DEFAULT false,
    "catalogVersion" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "standard_categories_code_idx" ON "standard_categories" USING btree ("code");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "transactions" (
    "id" bigserial PRIMARY KEY,
    "accountId" bigint NOT NULL,
    "date" timestamp without time zone NOT NULL,
    "amountCents" bigint NOT NULL,
    "rawLabel" text NOT NULL,
    "memo" text,
    "cleanLabel" text NOT NULL,
    "operationKind" text NOT NULL,
    "reference" text,
    "bankId" text,
    "fingerprint" text,
    "trashedFingerprint" text,
    "importId" bigint,
    "categoryId" bigint,
    "categorySource" text NOT NULL DEFAULT 'none'::text,
    "categoryRuleRef" text,
    "cleared" boolean NOT NULL DEFAULT false,
    "scheduledId" bigint,
    "scheduledDueDate" timestamp without time zone,
    "transferPairId" bigint,
    "createdBy" uuid,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "transactions_account_date_idx" ON "transactions" USING btree ("accountId", "date");
CREATE UNIQUE INDEX "transactions_account_fingerprint_idx" ON "transactions" USING btree ("accountId", "fingerprint");
CREATE INDEX "transactions_import_idx" ON "transactions" USING btree ("importId");
CREATE INDEX "transactions_category_idx" ON "transactions" USING btree ("categoryId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "account_access"
    ADD CONSTRAINT "account_access_fk_0"
    FOREIGN KEY("accountId")
    REFERENCES "accounts"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "account_access"
    ADD CONSTRAINT "account_access_fk_1"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "accounts"
    ADD CONSTRAINT "accounts_fk_0"
    FOREIGN KEY("groupId")
    REFERENCES "groups"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "categories"
    ADD CONSTRAINT "categories_fk_0"
    FOREIGN KEY("groupId")
    REFERENCES "groups"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "categories"
    ADD CONSTRAINT "categories_fk_1"
    FOREIGN KEY("parentId")
    REFERENCES "categories"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "group_members"
    ADD CONSTRAINT "group_members_fk_0"
    FOREIGN KEY("groupId")
    REFERENCES "groups"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "group_members"
    ADD CONSTRAINT "group_members_fk_1"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "imports"
    ADD CONSTRAINT "imports_fk_0"
    FOREIGN KEY("accountId")
    REFERENCES "accounts"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "rules"
    ADD CONSTRAINT "rules_fk_0"
    FOREIGN KEY("groupId")
    REFERENCES "groups"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "rules"
    ADD CONSTRAINT "rules_fk_1"
    FOREIGN KEY("categoryId")
    REFERENCES "categories"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "scheduled_transactions"
    ADD CONSTRAINT "scheduled_transactions_fk_0"
    FOREIGN KEY("accountId")
    REFERENCES "accounts"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "scheduled_transactions"
    ADD CONSTRAINT "scheduled_transactions_fk_1"
    FOREIGN KEY("categoryId")
    REFERENCES "categories"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "transactions"
    ADD CONSTRAINT "transactions_fk_0"
    FOREIGN KEY("accountId")
    REFERENCES "accounts"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "transactions"
    ADD CONSTRAINT "transactions_fk_1"
    FOREIGN KEY("importId")
    REFERENCES "imports"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "transactions"
    ADD CONSTRAINT "transactions_fk_2"
    FOREIGN KEY("categoryId")
    REFERENCES "categories"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "transactions"
    ADD CONSTRAINT "transactions_fk_3"
    FOREIGN KEY("scheduledId")
    REFERENCES "scheduled_transactions"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR owncoffer
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('owncoffer', '20261030162652684', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261030162652684', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260924105404509', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105404509', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260924105232991', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105232991', "timestamp" = now();


COMMIT;
