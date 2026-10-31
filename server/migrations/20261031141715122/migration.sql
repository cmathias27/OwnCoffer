BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "loan_document_blobs" (
    "id" bigserial PRIMARY KEY,
    "documentId" bigint NOT NULL,
    "content" bytea NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "loan_document_blobs_doc_idx" ON "loan_document_blobs" USING btree ("documentId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "loan_documents" (
    "id" bigserial PRIMARY KEY,
    "loanId" bigint NOT NULL,
    "fileName" text NOT NULL,
    "mimeType" text NOT NULL,
    "sizeBytes" bigint NOT NULL,
    "uploadedBy" uuid,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "loan_documents_loan_idx" ON "loan_documents" USING btree ("loanId");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "loans" ADD COLUMN "paymentCents" bigint;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "loan_document_blobs"
    ADD CONSTRAINT "loan_document_blobs_fk_0"
    FOREIGN KEY("documentId")
    REFERENCES "loan_documents"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "loan_documents"
    ADD CONSTRAINT "loan_documents_fk_0"
    FOREIGN KEY("loanId")
    REFERENCES "loans"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR owncoffer
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('owncoffer', '20261031141715122', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261031141715122', "timestamp" = now();

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
