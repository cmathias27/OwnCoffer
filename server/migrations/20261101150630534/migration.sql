BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "ai_conversations" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "groupId" bigint NOT NULL,
    "title" text NOT NULL,
    "messages" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "ai_conversations_user_idx" ON "ai_conversations" USING btree ("authUserId", "groupId", "updatedAt");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "ai_memories" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "groupId" bigint NOT NULL,
    "text" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "ai_memories_user_idx" ON "ai_memories" USING btree ("authUserId", "groupId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "ai_conversations"
    ADD CONSTRAINT "ai_conversations_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "ai_conversations"
    ADD CONSTRAINT "ai_conversations_fk_1"
    FOREIGN KEY("groupId")
    REFERENCES "groups"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "ai_memories"
    ADD CONSTRAINT "ai_memories_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "ai_memories"
    ADD CONSTRAINT "ai_memories_fk_1"
    FOREIGN KEY("groupId")
    REFERENCES "groups"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR owncoffer
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('owncoffer', '20261101150630534', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261101150630534', "timestamp" = now();

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
