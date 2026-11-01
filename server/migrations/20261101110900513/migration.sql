BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "action_proposals" (
    "id" bigserial PRIMARY KEY,
    "groupId" bigint NOT NULL,
    "authUserId" uuid NOT NULL,
    "origin" text NOT NULL,
    "provider" text,
    "model" text,
    "kind" text NOT NULL,
    "targetId" bigint NOT NULL,
    "currentValue" bigint,
    "proposedValue" bigint,
    "proposedData" text,
    "reason" text NOT NULL,
    "data" text NOT NULL,
    "dataVersion" text NOT NULL,
    "status" text NOT NULL,
    "dedupKey" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "decidedAt" timestamp without time zone,
    "decidedBy" uuid,
    "executedAt" timestamp without time zone,
    "resultId" bigint
);

-- Indexes
CREATE INDEX "action_proposals_user_idx" ON "action_proposals" USING btree ("authUserId", "groupId", "status");
CREATE UNIQUE INDEX "action_proposals_dedup_idx" ON "action_proposals" USING btree ("authUserId", "groupId", "dedupKey");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "action_proposals"
    ADD CONSTRAINT "action_proposals_fk_0"
    FOREIGN KEY("groupId")
    REFERENCES "groups"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "action_proposals"
    ADD CONSTRAINT "action_proposals_fk_1"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR owncoffer
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('owncoffer', '20261101110900513', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261101110900513', "timestamp" = now();

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
