BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "invitations" (
    "id" bigserial PRIMARY KEY,
    "groupId" bigint,
    "email" text NOT NULL,
    "role" text NOT NULL,
    "serverAdmin" boolean NOT NULL DEFAULT false,
    "tokenHash" text NOT NULL,
    "expiresAt" timestamp without time zone NOT NULL,
    "createdBy" uuid,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "acceptedAt" timestamp without time zone,
    "acceptedBy" uuid,
    "revokedAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "invitations_email_idx" ON "invitations" USING btree ("email");
CREATE UNIQUE INDEX "invitations_token_idx" ON "invitations" USING btree ("tokenHash");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "invitations"
    ADD CONSTRAINT "invitations_fk_0"
    FOREIGN KEY("groupId")
    REFERENCES "groups"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR owncoffer
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('owncoffer', '20261030175816525', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261030175816525', "timestamp" = now();

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
