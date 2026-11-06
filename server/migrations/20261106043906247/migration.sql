BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "pepite_badges" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "code" text NOT NULL,
    "earnedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "pepite_badges_user_code_idx" ON "pepite_badges" USING btree ("authUserId", "code");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "pepite_progress" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "seeds" bigint NOT NULL,
    "weeks" bigint NOT NULL,
    "lastWeek" timestamp without time zone,
    "firstRitualAt" timestamp without time zone,
    "lastRitualAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "pepite_progress_user_idx" ON "pepite_progress" USING btree ("authUserId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "pepite_badges"
    ADD CONSTRAINT "pepite_badges_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "pepite_progress"
    ADD CONSTRAINT "pepite_progress_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR owncoffer
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('owncoffer', '20261106043906247', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261106043906247', "timestamp" = now();

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
