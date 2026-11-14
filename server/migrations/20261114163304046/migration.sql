BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "categories" ADD COLUMN "excludedFromBalance" boolean NOT NULL DEFAULT false;
UPDATE "categories" SET "excludedFromBalance" = true WHERE "standardCode" = 'transfers.card_settlement';
--
-- ACTION ALTER TABLE
--
ALTER TABLE "transactions" ADD COLUMN "balanceOverride" boolean;

--
-- MIGRATION VERSION FOR owncoffer
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('owncoffer', '20261114163304046', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261114163304046', "timestamp" = now();

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
