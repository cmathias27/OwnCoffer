BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "accounts" ADD COLUMN "regulatedKind" text;
ALTER TABLE "accounts" ADD COLUMN "interestRateBp" bigint;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "assets" (
    "id" bigserial PRIMARY KEY,
    "groupId" bigint NOT NULL,
    "name" text NOT NULL,
    "kind" text NOT NULL,
    "valueCents" bigint NOT NULL,
    "valuedAt" timestamp without time zone NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "assets_group_idx" ON "assets" USING btree ("groupId");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "categories" ADD COLUMN "taxRelevant" boolean NOT NULL DEFAULT false;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "event_operations" (
    "id" bigserial PRIMARY KEY,
    "eventId" bigint NOT NULL,
    "transactionId" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "event_operations_pair_idx" ON "event_operations" USING btree ("eventId", "transactionId");
CREATE INDEX "event_operations_transaction_idx" ON "event_operations" USING btree ("transactionId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "expected_refunds" (
    "id" bigserial PRIMARY KEY,
    "groupId" bigint NOT NULL,
    "createdBy" uuid NOT NULL,
    "label" text NOT NULL,
    "amountCents" bigint NOT NULL,
    "since" timestamp without time zone NOT NULL,
    "dueBy" timestamp without time zone,
    "accountId" bigint,
    "transactionId" bigint,
    "receivedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "expected_refunds_group_idx" ON "expected_refunds" USING btree ("groupId");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "groups" ADD COLUMN "closedUntil" timestamp without time zone;
ALTER TABLE "groups" ADD COLUMN "potMonthlyCents" bigint NOT NULL DEFAULT 0;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "life_events" (
    "id" bigserial PRIMARY KEY,
    "groupId" bigint NOT NULL,
    "name" text NOT NULL,
    "startDate" timestamp without time zone NOT NULL,
    "endDate" timestamp without time zone,
    "budgetCents" bigint,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "life_events_group_idx" ON "life_events" USING btree ("groupId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "pot_shares" (
    "id" bigserial PRIMARY KEY,
    "groupId" bigint NOT NULL,
    "authUserId" uuid NOT NULL,
    "incomeCents" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "pot_shares_member_idx" ON "pot_shares" USING btree ("groupId", "authUserId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "reminders" (
    "id" bigserial PRIMARY KEY,
    "groupId" bigint NOT NULL,
    "authUserId" uuid NOT NULL,
    "text" text NOT NULL,
    "dueDate" timestamp without time zone NOT NULL,
    "doneAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "reminders_group_idx" ON "reminders" USING btree ("groupId", "authUserId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "savings_projects" (
    "id" bigserial PRIMARY KEY,
    "groupId" bigint NOT NULL,
    "name" text NOT NULL,
    "targetCents" bigint NOT NULL,
    "savedCents" bigint NOT NULL DEFAULT 0,
    "targetDate" timestamp without time zone,
    "accountId" bigint,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "archivedAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "savings_projects_group_idx" ON "savings_projects" USING btree ("groupId");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "scheduled_transactions" ADD COLUMN "renewalDate" timestamp without time zone;
ALTER TABLE "scheduled_transactions" ADD COLUMN "noticeDays" bigint;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "shared_expenses" (
    "id" bigserial PRIMARY KEY,
    "groupId" bigint NOT NULL,
    "label" text NOT NULL,
    "date" timestamp without time zone NOT NULL,
    "amountCents" bigint NOT NULL,
    "paidBy" uuid NOT NULL,
    "participants" json NOT NULL,
    "repayment" boolean NOT NULL DEFAULT false,
    "createdBy" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "shared_expenses_group_idx" ON "shared_expenses" USING btree ("groupId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "assets"
    ADD CONSTRAINT "assets_fk_0"
    FOREIGN KEY("groupId")
    REFERENCES "groups"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "event_operations"
    ADD CONSTRAINT "event_operations_fk_0"
    FOREIGN KEY("eventId")
    REFERENCES "life_events"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "event_operations"
    ADD CONSTRAINT "event_operations_fk_1"
    FOREIGN KEY("transactionId")
    REFERENCES "transactions"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "expected_refunds"
    ADD CONSTRAINT "expected_refunds_fk_0"
    FOREIGN KEY("groupId")
    REFERENCES "groups"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "expected_refunds"
    ADD CONSTRAINT "expected_refunds_fk_1"
    FOREIGN KEY("accountId")
    REFERENCES "accounts"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "expected_refunds"
    ADD CONSTRAINT "expected_refunds_fk_2"
    FOREIGN KEY("transactionId")
    REFERENCES "transactions"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "life_events"
    ADD CONSTRAINT "life_events_fk_0"
    FOREIGN KEY("groupId")
    REFERENCES "groups"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "pot_shares"
    ADD CONSTRAINT "pot_shares_fk_0"
    FOREIGN KEY("groupId")
    REFERENCES "groups"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "reminders"
    ADD CONSTRAINT "reminders_fk_0"
    FOREIGN KEY("groupId")
    REFERENCES "groups"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "savings_projects"
    ADD CONSTRAINT "savings_projects_fk_0"
    FOREIGN KEY("groupId")
    REFERENCES "groups"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "savings_projects"
    ADD CONSTRAINT "savings_projects_fk_1"
    FOREIGN KEY("accountId")
    REFERENCES "accounts"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "shared_expenses"
    ADD CONSTRAINT "shared_expenses_fk_0"
    FOREIGN KEY("groupId")
    REFERENCES "groups"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR owncoffer
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('owncoffer', '20261114150144648', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261114150144648', "timestamp" = now();

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
