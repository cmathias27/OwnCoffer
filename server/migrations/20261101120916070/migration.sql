BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "mcp_tokens" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "groupId" bigint NOT NULL,
    "name" text NOT NULL,
    "tokenHash" text,
    "prefix" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastUsedAt" timestamp without time zone,
    "revokedAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "mcp_tokens_hash_idx" ON "mcp_tokens" USING btree ("tokenHash");
CREATE INDEX "mcp_tokens_user_idx" ON "mcp_tokens" USING btree ("authUserId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "mcp_tokens"
    ADD CONSTRAINT "mcp_tokens_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "mcp_tokens"
    ADD CONSTRAINT "mcp_tokens_fk_1"
    FOREIGN KEY("groupId")
    REFERENCES "groups"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR owncoffer
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('owncoffer', '20261101120916070', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261101120916070', "timestamp" = now();

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
