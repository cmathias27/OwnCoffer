BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "ip_bans" (
    "id" bigserial PRIMARY KEY,
    "ip" text NOT NULL,
    "failures" bigint NOT NULL DEFAULT 0,
    "windowStart" timestamp without time zone NOT NULL,
    "lastFailureAt" timestamp without time zone NOT NULL,
    "lastFailureKind" text NOT NULL,
    "bannedUntil" timestamp without time zone,
    "banCount" bigint NOT NULL DEFAULT 0
);

-- Indexes
CREATE UNIQUE INDEX "ip_bans_ip_idx" ON "ip_bans" USING btree ("ip");


--
-- MIGRATION VERSION FOR owncoffer
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('owncoffer', '20261030184521708', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261030184521708', "timestamp" = now();

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
