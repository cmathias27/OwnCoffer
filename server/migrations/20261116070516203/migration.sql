BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "accounts" ADD COLUMN "statementCutoffDay" bigint;
ALTER TABLE "accounts" ADD COLUMN "statementDebitDay" bigint;
ALTER TABLE "accounts" ADD COLUMN "linkedAccountId" bigint;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "accounts"
    ADD CONSTRAINT "accounts_fk_1"
    FOREIGN KEY("linkedAccountId")
    REFERENCES "accounts"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- MIGRATION VERSION FOR owncoffer
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('owncoffer', '20261116070516203', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261116070516203', "timestamp" = now();

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
