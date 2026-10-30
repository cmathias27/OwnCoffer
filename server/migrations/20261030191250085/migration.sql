BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "totp_backup_codes" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "codeHash" text NOT NULL,
    "usedAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "totp_backup_codes_user_idx" ON "totp_backup_codes" USING btree ("authUserId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "totp_secrets" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "secretBox" text NOT NULL,
    "enabled" boolean NOT NULL DEFAULT false,
    "lastUsedStep" bigint,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "enabledAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "totp_secrets_user_idx" ON "totp_secrets" USING btree ("authUserId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "totp_backup_codes"
    ADD CONSTRAINT "totp_backup_codes_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "totp_secrets"
    ADD CONSTRAINT "totp_secrets_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR owncoffer
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('owncoffer', '20261030191250085', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261030191250085', "timestamp" = now();

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
