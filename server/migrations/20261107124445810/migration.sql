BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "pepite_items" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "code" text NOT NULL,
    "acquiredAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "equipped" boolean NOT NULL DEFAULT false
);

-- Indexes
CREATE UNIQUE INDEX "pepite_items_user_code_idx" ON "pepite_items" USING btree ("authUserId", "code");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "pepite_progress" ADD COLUMN "spentSeeds" bigint NOT NULL DEFAULT 0;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "pepite_items"
    ADD CONSTRAINT "pepite_items_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR owncoffer
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('owncoffer', '20261107124445810', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261107124445810', "timestamp" = now();

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
