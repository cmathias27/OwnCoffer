BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "notification_settings" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "overdraftApp" boolean NOT NULL DEFAULT true,
    "overdraftEmail" boolean NOT NULL DEFAULT true,
    "goalWarning" boolean NOT NULL DEFAULT true,
    "goalOver" boolean NOT NULL DEFAULT true,
    "goalForecast" boolean NOT NULL DEFAULT true,
    "warrantyApp" boolean NOT NULL DEFAULT true,
    "warrantyEmail" boolean NOT NULL DEFAULT true,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "notification_settings_user_idx" ON "notification_settings" USING btree ("authUserId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "notification_settings"
    ADD CONSTRAINT "notification_settings_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR owncoffer
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('owncoffer', '20261101141419822', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261101141419822', "timestamp" = now();

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
