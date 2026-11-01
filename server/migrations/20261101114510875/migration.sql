BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "ai_preferences" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "providerId" bigint,
    "model" text,
    "enabled" boolean NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "ai_preferences_user_idx" ON "ai_preferences" USING btree ("authUserId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "ai_providers" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "kind" text NOT NULL,
    "baseUrl" text NOT NULL,
    "apiKeyBox" text,
    "models" text NOT NULL,
    "toolCalling" boolean NOT NULL,
    "vision" boolean NOT NULL,
    "monthlyCap" bigint NOT NULL,
    "enabled" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "ai_usage" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "providerId" bigint NOT NULL,
    "month" bigint NOT NULL,
    "requests" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "ai_usage_idx" ON "ai_usage" USING btree ("authUserId", "providerId", "month");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "ai_preferences"
    ADD CONSTRAINT "ai_preferences_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "ai_preferences"
    ADD CONSTRAINT "ai_preferences_fk_1"
    FOREIGN KEY("providerId")
    REFERENCES "ai_providers"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "ai_usage"
    ADD CONSTRAINT "ai_usage_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "ai_usage"
    ADD CONSTRAINT "ai_usage_fk_1"
    FOREIGN KEY("providerId")
    REFERENCES "ai_providers"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR owncoffer
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('owncoffer', '20261101114510875', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261101114510875', "timestamp" = now();

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
