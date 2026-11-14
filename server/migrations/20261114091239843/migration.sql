BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "ai_function_usage" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "providerId" bigint NOT NULL,
    "month" bigint NOT NULL,
    "feature" text NOT NULL,
    "requests" bigint NOT NULL,
    "inputTokens" bigint NOT NULL,
    "outputTokens" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "ai_function_usage_idx" ON "ai_function_usage" USING btree ("authUserId", "providerId", "month", "feature");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "ai_providers" ADD COLUMN "inputPricePerMillion" bigint;
ALTER TABLE "ai_providers" ADD COLUMN "outputPricePerMillion" bigint;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "ai_function_usage"
    ADD CONSTRAINT "ai_function_usage_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "ai_function_usage"
    ADD CONSTRAINT "ai_function_usage_fk_1"
    FOREIGN KEY("providerId")
    REFERENCES "ai_providers"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR owncoffer
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('owncoffer', '20261114091239843', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261114091239843', "timestamp" = now();

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
