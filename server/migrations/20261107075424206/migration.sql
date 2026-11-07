BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "pepite_marks" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "code" text NOT NULL,
    "key" text NOT NULL,
    "markedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "pepite_marks_user_code_key_idx" ON "pepite_marks" USING btree ("authUserId", "code", "key");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "pepite_marks"
    ADD CONSTRAINT "pepite_marks_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR owncoffer
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('owncoffer', '20261107075424206', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261107075424206', "timestamp" = now();

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
