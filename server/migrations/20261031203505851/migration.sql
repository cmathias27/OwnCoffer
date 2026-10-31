BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "invoice_blobs" (
    "id" bigserial PRIMARY KEY,
    "invoiceId" bigint NOT NULL,
    "content" bytea NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "invoice_blobs_invoice_idx" ON "invoice_blobs" USING btree ("invoiceId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "invoices" (
    "id" bigserial PRIMARY KEY,
    "groupId" bigint NOT NULL,
    "transactionId" bigint,
    "fileName" text NOT NULL,
    "mimeType" text NOT NULL,
    "sizeBytes" bigint NOT NULL,
    "label" text,
    "warrantyUntil" timestamp without time zone,
    "uploadedBy" uuid,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "invoices_group_idx" ON "invoices" USING btree ("groupId", "createdAt");
CREATE INDEX "invoices_transaction_idx" ON "invoices" USING btree ("transactionId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "invoice_blobs"
    ADD CONSTRAINT "invoice_blobs_fk_0"
    FOREIGN KEY("invoiceId")
    REFERENCES "invoices"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "invoices"
    ADD CONSTRAINT "invoices_fk_0"
    FOREIGN KEY("groupId")
    REFERENCES "groups"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "invoices"
    ADD CONSTRAINT "invoices_fk_1"
    FOREIGN KEY("transactionId")
    REFERENCES "transactions"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR owncoffer
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('owncoffer', '20261031203505851', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261031203505851', "timestamp" = now();

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
