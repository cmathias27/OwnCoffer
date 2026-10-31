BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "goals" (
    "id" bigserial PRIMARY KEY,
    "groupId" bigint NOT NULL,
    "categoryId" bigint NOT NULL,
    "amountCents" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "goals_category_idx" ON "goals" USING btree ("categoryId");
CREATE INDEX "goals_group_idx" ON "goals" USING btree ("groupId");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "groups" ADD COLUMN "monthStartDay" bigint NOT NULL DEFAULT 1;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "loans" (
    "id" bigserial PRIMARY KEY,
    "groupId" bigint NOT NULL,
    "accountId" bigint,
    "kind" text NOT NULL,
    "lender" text NOT NULL,
    "label" text,
    "principalCents" bigint NOT NULL,
    "annualRateMilli" bigint NOT NULL,
    "aprMilli" bigint,
    "durationMonths" bigint NOT NULL,
    "firstDueDate" timestamp without time zone NOT NULL,
    "insuranceMonthlyCents" bigint NOT NULL DEFAULT 0,
    "feesCents" bigint NOT NULL DEFAULT 0,
    "categoryId" bigint,
    "scheduledId" bigint,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "loans_group_idx" ON "loans" USING btree ("groupId");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "scheduled_transactions" ADD COLUMN "subscription" boolean NOT NULL DEFAULT false;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "goals"
    ADD CONSTRAINT "goals_fk_0"
    FOREIGN KEY("groupId")
    REFERENCES "groups"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "goals"
    ADD CONSTRAINT "goals_fk_1"
    FOREIGN KEY("categoryId")
    REFERENCES "categories"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "loans"
    ADD CONSTRAINT "loans_fk_0"
    FOREIGN KEY("groupId")
    REFERENCES "groups"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "loans"
    ADD CONSTRAINT "loans_fk_1"
    FOREIGN KEY("accountId")
    REFERENCES "accounts"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "loans"
    ADD CONSTRAINT "loans_fk_2"
    FOREIGN KEY("categoryId")
    REFERENCES "categories"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "loans"
    ADD CONSTRAINT "loans_fk_3"
    FOREIGN KEY("scheduledId")
    REFERENCES "scheduled_transactions"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR owncoffer
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('owncoffer', '20261031093642614', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261031093642614', "timestamp" = now();

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
