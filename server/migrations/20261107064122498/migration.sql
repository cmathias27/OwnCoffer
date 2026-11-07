BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "pepite_tips_seen" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "code" text NOT NULL,
    "seenAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "pepite_tips_seen_user_code_idx" ON "pepite_tips_seen" USING btree ("authUserId", "code");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "pepite_tips_seen"
    ADD CONSTRAINT "pepite_tips_seen_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR owncoffer
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('owncoffer', '20261107064122498', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261107064122498', "timestamp" = now();

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
