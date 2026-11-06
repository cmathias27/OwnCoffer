BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "session_device" (
    "id" bigserial PRIMARY KEY,
    "sessionId" text NOT NULL,
    "authUserId" uuid NOT NULL,
    "platform" text NOT NULL,
    "appVersion" text,
    "deviceLabel" text,
    "ip" text,
    "city" text,
    "country" text,
    "firstSeenAt" timestamp without time zone NOT NULL,
    "lastSeenAt" timestamp without time zone NOT NULL,
    "endedAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "session_device_session_idx" ON "session_device" USING btree ("sessionId");
CREATE INDEX "session_device_user_idx" ON "session_device" USING btree ("authUserId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "session_device"
    ADD CONSTRAINT "session_device_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR owncoffer
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('owncoffer', '20261106205507455', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261106205507455', "timestamp" = now();

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
