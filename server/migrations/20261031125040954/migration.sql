BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "balance_checks" (
    "id" bigserial PRIMARY KEY,
    "accountId" bigint NOT NULL,
    "date" timestamp without time zone NOT NULL,
    "bankBalanceCents" bigint NOT NULL,
    "computedCents" bigint NOT NULL,
    "differenceCents" bigint NOT NULL,
    "unclearedManualCents" bigint NOT NULL,
    "lastImportedDate" timestamp without time zone,
    "createdBy" uuid,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "balance_checks_account_idx" ON "balance_checks" USING btree ("accountId", "date");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "transaction_splits" (
    "id" bigserial PRIMARY KEY,
    "transactionId" bigint NOT NULL,
    "categoryId" bigint,
    "amountCents" bigint NOT NULL,
    "note" text
);

-- Indexes
CREATE INDEX "transaction_splits_tx_idx" ON "transaction_splits" USING btree ("transactionId");
CREATE INDEX "transaction_splits_category_idx" ON "transaction_splits" USING btree ("categoryId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "balance_checks"
    ADD CONSTRAINT "balance_checks_fk_0"
    FOREIGN KEY("accountId")
    REFERENCES "accounts"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "transaction_splits"
    ADD CONSTRAINT "transaction_splits_fk_0"
    FOREIGN KEY("transactionId")
    REFERENCES "transactions"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "transaction_splits"
    ADD CONSTRAINT "transaction_splits_fk_1"
    FOREIGN KEY("categoryId")
    REFERENCES "categories"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR owncoffer
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('owncoffer', '20261031125040954', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261031125040954', "timestamp" = now();

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
