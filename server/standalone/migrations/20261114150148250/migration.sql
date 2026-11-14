BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "accounts" ADD COLUMN "regulatedKind" TEXT;
ALTER TABLE "accounts" ADD COLUMN "interestRateBp" INTEGER;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "assets" (
    "id" INTEGER PRIMARY KEY,
    "groupId" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "kind" TEXT NOT NULL,
    "valueCents" INTEGER NOT NULL,
    "valuedAt" INTEGER NOT NULL,
    "createdAt" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER)),
    CONSTRAINT "assets_fk_0" FOREIGN KEY ("groupId") REFERENCES "groups" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE INDEX "assets_group_idx" ON "assets" ("groupId");

--
-- ACTION ALTER TABLE
--
CREATE TABLE "new_categories" (
    "id" INTEGER PRIMARY KEY,
    "groupId" INTEGER NOT NULL,
    "parentId" INTEGER,
    "name" TEXT,
    "kind" TEXT NOT NULL,
    "standardCode" TEXT,
    "icon" TEXT,
    "color" TEXT,
    "taxRelevant" INTEGER NOT NULL DEFAULT (0),
    "createdAt" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER)),
    "deletedAt" INTEGER,
    CONSTRAINT "categories_fk_0" FOREIGN KEY ("groupId") REFERENCES "groups" ("id") ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT "categories_fk_1" FOREIGN KEY ("parentId") REFERENCES "categories" ("id") ON DELETE SET NULL ON UPDATE NO ACTION
) STRICT;

INSERT INTO "new_categories" ("id", "groupId", "parentId", "name", "kind", "standardCode", "icon", "color", "createdAt", "deletedAt") SELECT "id", "groupId", "parentId", "name", "kind", "standardCode", "icon", "color", "createdAt", "deletedAt" FROM "categories";
DROP TABLE "categories";
ALTER TABLE "new_categories" RENAME TO "categories";

-- Indexes
CREATE INDEX "categories_group_idx" ON "categories" ("groupId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "event_operations" (
    "id" INTEGER PRIMARY KEY,
    "eventId" INTEGER NOT NULL,
    "transactionId" INTEGER NOT NULL,
    CONSTRAINT "event_operations_fk_0" FOREIGN KEY ("eventId") REFERENCES "life_events" ("id") ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT "event_operations_fk_1" FOREIGN KEY ("transactionId") REFERENCES "transactions" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "event_operations_pair_idx" ON "event_operations" ("eventId", "transactionId");
CREATE INDEX "event_operations_transaction_idx" ON "event_operations" ("transactionId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "expected_refunds" (
    "id" INTEGER PRIMARY KEY,
    "groupId" INTEGER NOT NULL,
    "createdBy" BLOB NOT NULL,
    "label" TEXT NOT NULL,
    "amountCents" INTEGER NOT NULL,
    "since" INTEGER NOT NULL,
    "dueBy" INTEGER,
    "accountId" INTEGER,
    "transactionId" INTEGER,
    "receivedAt" INTEGER,
    "createdAt" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER)),
    CONSTRAINT "expected_refunds_fk_0" FOREIGN KEY ("groupId") REFERENCES "groups" ("id") ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT "expected_refunds_fk_1" FOREIGN KEY ("accountId") REFERENCES "accounts" ("id") ON DELETE SET NULL ON UPDATE NO ACTION,
    CONSTRAINT "expected_refunds_fk_2" FOREIGN KEY ("transactionId") REFERENCES "transactions" ("id") ON DELETE SET NULL ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE INDEX "expected_refunds_group_idx" ON "expected_refunds" ("groupId");

--
-- ACTION ALTER TABLE
--
CREATE TABLE "new_groups" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "aiEnabled" INTEGER NOT NULL DEFAULT (0),
    "standardCatalogVersion" INTEGER NOT NULL DEFAULT (1),
    "monthStartDay" INTEGER NOT NULL DEFAULT (1),
    "closedUntil" INTEGER,
    "potMonthlyCents" INTEGER NOT NULL DEFAULT (0),
    "createdBy" BLOB NOT NULL,
    "createdAt" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER))
) STRICT;

INSERT INTO "new_groups" ("id", "name", "aiEnabled", "standardCatalogVersion", "monthStartDay", "createdBy", "createdAt") SELECT "id", "name", "aiEnabled", "standardCatalogVersion", "monthStartDay", "createdBy", "createdAt" FROM "groups";
DROP TABLE "groups";
ALTER TABLE "new_groups" RENAME TO "groups";

--
-- ACTION CREATE TABLE
--
CREATE TABLE "life_events" (
    "id" INTEGER PRIMARY KEY,
    "groupId" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "startDate" INTEGER NOT NULL,
    "endDate" INTEGER,
    "budgetCents" INTEGER,
    "createdAt" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER)),
    CONSTRAINT "life_events_fk_0" FOREIGN KEY ("groupId") REFERENCES "groups" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE INDEX "life_events_group_idx" ON "life_events" ("groupId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "pot_shares" (
    "id" INTEGER PRIMARY KEY,
    "groupId" INTEGER NOT NULL,
    "authUserId" BLOB NOT NULL,
    "incomeCents" INTEGER NOT NULL,
    CONSTRAINT "pot_shares_fk_0" FOREIGN KEY ("groupId") REFERENCES "groups" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "pot_shares_member_idx" ON "pot_shares" ("groupId", "authUserId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "reminders" (
    "id" INTEGER PRIMARY KEY,
    "groupId" INTEGER NOT NULL,
    "authUserId" BLOB NOT NULL,
    "text" TEXT NOT NULL,
    "dueDate" INTEGER NOT NULL,
    "doneAt" INTEGER,
    "createdAt" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER)),
    CONSTRAINT "reminders_fk_0" FOREIGN KEY ("groupId") REFERENCES "groups" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE INDEX "reminders_group_idx" ON "reminders" ("groupId", "authUserId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "savings_projects" (
    "id" INTEGER PRIMARY KEY,
    "groupId" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "targetCents" INTEGER NOT NULL,
    "savedCents" INTEGER NOT NULL DEFAULT (0),
    "targetDate" INTEGER,
    "accountId" INTEGER,
    "createdAt" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER)),
    "archivedAt" INTEGER,
    CONSTRAINT "savings_projects_fk_0" FOREIGN KEY ("groupId") REFERENCES "groups" ("id") ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT "savings_projects_fk_1" FOREIGN KEY ("accountId") REFERENCES "accounts" ("id") ON DELETE SET NULL ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE INDEX "savings_projects_group_idx" ON "savings_projects" ("groupId");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "scheduled_transactions" ADD COLUMN "renewalDate" INTEGER;
ALTER TABLE "scheduled_transactions" ADD COLUMN "noticeDays" INTEGER;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "shared_expenses" (
    "id" INTEGER PRIMARY KEY,
    "groupId" INTEGER NOT NULL,
    "label" TEXT NOT NULL,
    "date" INTEGER NOT NULL,
    "amountCents" INTEGER NOT NULL,
    "paidBy" BLOB NOT NULL,
    "participants" TEXT NOT NULL,
    "repayment" INTEGER NOT NULL DEFAULT (0),
    "createdBy" BLOB NOT NULL,
    "createdAt" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER)),
    CONSTRAINT "shared_expenses_fk_0" FOREIGN KEY ("groupId") REFERENCES "groups" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE INDEX "shared_expenses_group_idx" ON "shared_expenses" ("groupId");

--
-- STORE COLUMN TYPES FOR MIGRATIONS
--
DROP TABLE IF EXISTS "serverpod_sqlite_schema";

CREATE TABLE "serverpod_sqlite_schema" (
    "table_name" TEXT NOT NULL,
    "column_name" TEXT NOT NULL,
    "column_type" TEXT NOT NULL,
    "column_vector_dimension" INTEGER,
    PRIMARY KEY ("table_name", "column_name")
);

INSERT INTO "serverpod_sqlite_schema" VALUES
    ('account_access', 'authUserId', 'uuid', NULL),
    ('accounts', 'initialBalanceDate', 'timestampWithoutTimeZone', NULL),
    ('accounts', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('accounts', 'deletedAt', 'timestampWithoutTimeZone', NULL),
    ('action_proposals', 'authUserId', 'uuid', NULL),
    ('action_proposals', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('action_proposals', 'decidedAt', 'timestampWithoutTimeZone', NULL),
    ('action_proposals', 'decidedBy', 'uuid', NULL),
    ('action_proposals', 'executedAt', 'timestampWithoutTimeZone', NULL),
    ('ai_conversations', 'authUserId', 'uuid', NULL),
    ('ai_conversations', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('ai_conversations', 'updatedAt', 'timestampWithoutTimeZone', NULL),
    ('ai_function_usage', 'authUserId', 'uuid', NULL),
    ('ai_memories', 'authUserId', 'uuid', NULL),
    ('ai_memories', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('ai_preferences', 'authUserId', 'uuid', NULL),
    ('ai_preferences', 'enabled', 'boolean', NULL),
    ('ai_providers', 'toolCalling', 'boolean', NULL),
    ('ai_providers', 'vision', 'boolean', NULL),
    ('ai_providers', 'enabled', 'boolean', NULL),
    ('ai_providers', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('ai_server_settings', 'updatedAt', 'timestampWithoutTimeZone', NULL),
    ('ai_usage', 'authUserId', 'uuid', NULL),
    ('assets', 'valuedAt', 'timestampWithoutTimeZone', NULL),
    ('assets', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('audit_log', 'authUserId', 'uuid', NULL),
    ('audit_log', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('balance_checks', 'date', 'timestampWithoutTimeZone', NULL),
    ('balance_checks', 'lastImportedDate', 'timestampWithoutTimeZone', NULL),
    ('balance_checks', 'createdBy', 'uuid', NULL),
    ('balance_checks', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('categories', 'taxRelevant', 'boolean', NULL),
    ('categories', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('categories', 'deletedAt', 'timestampWithoutTimeZone', NULL),
    ('expected_refunds', 'createdBy', 'uuid', NULL),
    ('expected_refunds', 'since', 'timestampWithoutTimeZone', NULL),
    ('expected_refunds', 'dueBy', 'timestampWithoutTimeZone', NULL),
    ('expected_refunds', 'receivedAt', 'timestampWithoutTimeZone', NULL),
    ('expected_refunds', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('goals', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('goals', 'updatedAt', 'timestampWithoutTimeZone', NULL),
    ('group_members', 'authUserId', 'uuid', NULL),
    ('group_members', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('groups', 'aiEnabled', 'boolean', NULL),
    ('groups', 'closedUntil', 'timestampWithoutTimeZone', NULL),
    ('groups', 'createdBy', 'uuid', NULL),
    ('groups', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('imports', 'authorId', 'uuid', NULL),
    ('imports', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('imports', 'cancelledAt', 'timestampWithoutTimeZone', NULL),
    ('invitations', 'serverAdmin', 'boolean', NULL),
    ('invitations', 'expiresAt', 'timestampWithoutTimeZone', NULL),
    ('invitations', 'createdBy', 'uuid', NULL),
    ('invitations', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('invitations', 'acceptedAt', 'timestampWithoutTimeZone', NULL),
    ('invitations', 'acceptedBy', 'uuid', NULL),
    ('invitations', 'revokedAt', 'timestampWithoutTimeZone', NULL),
    ('invoices', 'warrantyUntil', 'timestampWithoutTimeZone', NULL),
    ('invoices', 'hintDate', 'timestampWithoutTimeZone', NULL),
    ('invoices', 'uploadedBy', 'uuid', NULL),
    ('invoices', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('ip_bans', 'windowStart', 'timestampWithoutTimeZone', NULL),
    ('ip_bans', 'lastFailureAt', 'timestampWithoutTimeZone', NULL),
    ('ip_bans', 'bannedUntil', 'timestampWithoutTimeZone', NULL),
    ('life_events', 'startDate', 'timestampWithoutTimeZone', NULL),
    ('life_events', 'endDate', 'timestampWithoutTimeZone', NULL),
    ('life_events', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('loan_documents', 'uploadedBy', 'uuid', NULL),
    ('loan_documents', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('loans', 'firstDueDate', 'timestampWithoutTimeZone', NULL),
    ('loans', 'disbursementDate', 'timestampWithoutTimeZone', NULL),
    ('loans', 'events', 'json', NULL),
    ('loans', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('loans', 'deletedAt', 'timestampWithoutTimeZone', NULL),
    ('mcp_tokens', 'authUserId', 'uuid', NULL),
    ('mcp_tokens', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('mcp_tokens', 'lastUsedAt', 'timestampWithoutTimeZone', NULL),
    ('mcp_tokens', 'revokedAt', 'timestampWithoutTimeZone', NULL),
    ('notification_settings', 'authUserId', 'uuid', NULL),
    ('notification_settings', 'overdraftApp', 'boolean', NULL),
    ('notification_settings', 'overdraftEmail', 'boolean', NULL),
    ('notification_settings', 'goalWarning', 'boolean', NULL),
    ('notification_settings', 'goalOver', 'boolean', NULL),
    ('notification_settings', 'goalForecast', 'boolean', NULL),
    ('notification_settings', 'warrantyApp', 'boolean', NULL),
    ('notification_settings', 'warrantyEmail', 'boolean', NULL),
    ('notification_settings', 'updatedAt', 'timestampWithoutTimeZone', NULL),
    ('notifications', 'authUserId', 'uuid', NULL),
    ('notifications', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('notifications', 'readAt', 'timestampWithoutTimeZone', NULL),
    ('notifications', 'emailedAt', 'timestampWithoutTimeZone', NULL),
    ('pepite_badges', 'authUserId', 'uuid', NULL),
    ('pepite_badges', 'earnedAt', 'timestampWithoutTimeZone', NULL),
    ('pepite_challenges', 'authUserId', 'uuid', NULL),
    ('pepite_challenges', 'chosenAt', 'timestampWithoutTimeZone', NULL),
    ('pepite_challenges', 'doneAt', 'timestampWithoutTimeZone', NULL),
    ('pepite_items', 'authUserId', 'uuid', NULL),
    ('pepite_items', 'acquiredAt', 'timestampWithoutTimeZone', NULL),
    ('pepite_items', 'equipped', 'boolean', NULL),
    ('pepite_marks', 'authUserId', 'uuid', NULL),
    ('pepite_marks', 'markedAt', 'timestampWithoutTimeZone', NULL),
    ('pepite_progress', 'authUserId', 'uuid', NULL),
    ('pepite_progress', 'lastWeek', 'timestampWithoutTimeZone', NULL),
    ('pepite_progress', 'firstRitualAt', 'timestampWithoutTimeZone', NULL),
    ('pepite_progress', 'lastRitualAt', 'timestampWithoutTimeZone', NULL),
    ('pepite_tips_seen', 'authUserId', 'uuid', NULL),
    ('pepite_tips_seen', 'seenAt', 'timestampWithoutTimeZone', NULL),
    ('pot_shares', 'authUserId', 'uuid', NULL),
    ('reminders', 'authUserId', 'uuid', NULL),
    ('reminders', 'dueDate', 'timestampWithoutTimeZone', NULL),
    ('reminders', 'doneAt', 'timestampWithoutTimeZone', NULL),
    ('reminders', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('rules', 'enabled', 'boolean', NULL),
    ('rules', 'createdBy', 'uuid', NULL),
    ('rules', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('savings_projects', 'targetDate', 'timestampWithoutTimeZone', NULL),
    ('savings_projects', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('savings_projects', 'archivedAt', 'timestampWithoutTimeZone', NULL),
    ('scheduled_transactions', 'startDate', 'timestampWithoutTimeZone', NULL),
    ('scheduled_transactions', 'endDate', 'timestampWithoutTimeZone', NULL),
    ('scheduled_transactions', 'nextDue', 'timestampWithoutTimeZone', NULL),
    ('scheduled_transactions', 'subscription', 'boolean', NULL),
    ('scheduled_transactions', 'priceRiseDate', 'timestampWithoutTimeZone', NULL),
    ('scheduled_transactions', 'renewalDate', 'timestampWithoutTimeZone', NULL),
    ('scheduled_transactions', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('scheduled_transactions', 'deletedAt', 'timestampWithoutTimeZone', NULL),
    ('session_device', 'authUserId', 'uuid', NULL),
    ('session_device', 'firstSeenAt', 'timestampWithoutTimeZone', NULL),
    ('session_device', 'lastSeenAt', 'timestampWithoutTimeZone', NULL),
    ('session_device', 'endedAt', 'timestampWithoutTimeZone', NULL),
    ('shared_expenses', 'date', 'timestampWithoutTimeZone', NULL),
    ('shared_expenses', 'paidBy', 'uuid', NULL),
    ('shared_expenses', 'participants', 'json', NULL),
    ('shared_expenses', 'repayment', 'boolean', NULL),
    ('shared_expenses', 'createdBy', 'uuid', NULL),
    ('shared_expenses', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('totp_backup_codes', 'authUserId', 'uuid', NULL),
    ('totp_backup_codes', 'usedAt', 'timestampWithoutTimeZone', NULL),
    ('totp_secrets', 'authUserId', 'uuid', NULL),
    ('totp_secrets', 'enabled', 'boolean', NULL),
    ('totp_secrets', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('totp_secrets', 'enabledAt', 'timestampWithoutTimeZone', NULL),
    ('transactions', 'date', 'timestampWithoutTimeZone', NULL),
    ('transactions', 'cleared', 'boolean', NULL),
    ('transactions', 'scheduledDueDate', 'timestampWithoutTimeZone', NULL),
    ('transactions', 'createdBy', 'uuid', NULL),
    ('transactions', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('transactions', 'updatedAt', 'timestampWithoutTimeZone', NULL),
    ('transactions', 'deletedAt', 'timestampWithoutTimeZone', NULL),
    ('user_feedbacks', 'authUserId', 'uuid', NULL),
    ('user_feedbacks', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('serverpod_cloud_storage', 'addedTime', 'timestampWithoutTimeZone', NULL),
    ('serverpod_cloud_storage', 'expiration', 'timestampWithoutTimeZone', NULL),
    ('serverpod_cloud_storage', 'verified', 'boolean', NULL),
    ('serverpod_cloud_storage_direct_download', 'expiration', 'timestampWithoutTimeZone', NULL),
    ('serverpod_cloud_storage_direct_upload', 'expiration', 'timestampWithoutTimeZone', NULL),
    ('serverpod_cloud_storage_direct_upload', 'preventOverwrite', 'boolean', NULL),
    ('serverpod_future_call', 'time', 'timestampWithoutTimeZone', NULL),
    ('serverpod_future_call', 'scheduling', 'json', NULL),
    ('serverpod_future_call_claim', 'lastHeartbeatTime', 'timestampWithoutTimeZone', NULL),
    ('serverpod_health_connection_info', 'timestamp', 'timestampWithoutTimeZone', NULL),
    ('serverpod_health_metric', 'timestamp', 'timestampWithoutTimeZone', NULL),
    ('serverpod_health_metric', 'isHealthy', 'boolean', NULL),
    ('serverpod_log', 'time', 'timestampWithoutTimeZone', NULL),
    ('serverpod_message_log', 'slow', 'boolean', NULL),
    ('serverpod_migrations', 'timestamp', 'timestampWithoutTimeZone', NULL),
    ('serverpod_query_log', 'slow', 'boolean', NULL),
    ('serverpod_runtime_settings', 'logSettings', 'json', NULL),
    ('serverpod_runtime_settings', 'logSettingsOverrides', 'json', NULL),
    ('serverpod_runtime_settings', 'logServiceCalls', 'boolean', NULL),
    ('serverpod_runtime_settings', 'logMalformedCalls', 'boolean', NULL),
    ('serverpod_session_log', 'time', 'timestampWithoutTimeZone', NULL),
    ('serverpod_session_log', 'slow', 'boolean', NULL),
    ('serverpod_session_log', 'isOpen', 'boolean', NULL),
    ('serverpod_session_log', 'touched', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_idp_anonymous_account', 'id', 'uuid', NULL),
    ('serverpod_auth_idp_anonymous_account', 'authUserId', 'uuid', NULL),
    ('serverpod_auth_idp_anonymous_account', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_idp_apple_account', 'id', 'uuid', NULL),
    ('serverpod_auth_idp_apple_account', 'refreshTokenRequestedWithBundleIdentifier', 'boolean', NULL),
    ('serverpod_auth_idp_apple_account', 'lastRefreshedAt', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_idp_apple_account', 'authUserId', 'uuid', NULL),
    ('serverpod_auth_idp_apple_account', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_idp_apple_account', 'isEmailVerified', 'boolean', NULL),
    ('serverpod_auth_idp_apple_account', 'isPrivateEmail', 'boolean', NULL),
    ('serverpod_auth_idp_email_account', 'id', 'uuid', NULL),
    ('serverpod_auth_idp_email_account', 'authUserId', 'uuid', NULL),
    ('serverpod_auth_idp_email_account', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_idp_email_account_password_reset_request', 'id', 'uuid', NULL),
    ('serverpod_auth_idp_email_account_password_reset_request', 'emailAccountId', 'uuid', NULL),
    ('serverpod_auth_idp_email_account_password_reset_request', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_idp_email_account_password_reset_request', 'challengeId', 'uuid', NULL),
    ('serverpod_auth_idp_email_account_password_reset_request', 'setPasswordChallengeId', 'uuid', NULL),
    ('serverpod_auth_idp_email_account_request', 'id', 'uuid', NULL),
    ('serverpod_auth_idp_email_account_request', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_idp_email_account_request', 'challengeId', 'uuid', NULL),
    ('serverpod_auth_idp_email_account_request', 'createAccountChallengeId', 'uuid', NULL),
    ('serverpod_auth_idp_facebook_account', 'id', 'uuid', NULL),
    ('serverpod_auth_idp_facebook_account', 'authUserId', 'uuid', NULL),
    ('serverpod_auth_idp_facebook_account', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_idp_firebase_account', 'id', 'uuid', NULL),
    ('serverpod_auth_idp_firebase_account', 'authUserId', 'uuid', NULL),
    ('serverpod_auth_idp_firebase_account', 'created', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_idp_github_account', 'id', 'uuid', NULL),
    ('serverpod_auth_idp_github_account', 'authUserId', 'uuid', NULL),
    ('serverpod_auth_idp_github_account', 'created', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_idp_google_account', 'id', 'uuid', NULL),
    ('serverpod_auth_idp_google_account', 'authUserId', 'uuid', NULL),
    ('serverpod_auth_idp_google_account', 'created', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_idp_microsoft_account', 'id', 'uuid', NULL),
    ('serverpod_auth_idp_microsoft_account', 'authUserId', 'uuid', NULL),
    ('serverpod_auth_idp_microsoft_account', 'created', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_idp_passkey_account', 'id', 'uuid', NULL),
    ('serverpod_auth_idp_passkey_account', 'authUserId', 'uuid', NULL),
    ('serverpod_auth_idp_passkey_account', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_idp_passkey_challenge', 'id', 'uuid', NULL),
    ('serverpod_auth_idp_passkey_challenge', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_idp_rate_limited_request_attempt', 'id', 'uuid', NULL),
    ('serverpod_auth_idp_rate_limited_request_attempt', 'attemptedAt', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_idp_rate_limited_request_attempt', 'extraData', 'json', NULL),
    ('serverpod_auth_idp_secret_challenge', 'id', 'uuid', NULL),
    ('serverpod_auth_core_jwt_refresh_token', 'id', 'uuid', NULL),
    ('serverpod_auth_core_jwt_refresh_token', 'authUserId', 'uuid', NULL),
    ('serverpod_auth_core_jwt_refresh_token', 'scopeNames', 'json', NULL),
    ('serverpod_auth_core_jwt_refresh_token', 'lastUpdatedAt', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_core_jwt_refresh_token', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_core_profile', 'id', 'uuid', NULL),
    ('serverpod_auth_core_profile', 'authUserId', 'uuid', NULL),
    ('serverpod_auth_core_profile', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_core_profile', 'imageId', 'uuid', NULL),
    ('serverpod_auth_core_profile_image', 'id', 'uuid', NULL),
    ('serverpod_auth_core_profile_image', 'userProfileId', 'uuid', NULL),
    ('serverpod_auth_core_profile_image', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_core_session', 'id', 'uuid', NULL),
    ('serverpod_auth_core_session', 'authUserId', 'uuid', NULL),
    ('serverpod_auth_core_session', 'scopeNames', 'json', NULL),
    ('serverpod_auth_core_session', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_core_session', 'lastUsedAt', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_core_session', 'expiresAt', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_core_user', 'id', 'uuid', NULL),
    ('serverpod_auth_core_user', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_core_user', 'scopeNames', 'json', NULL),
    ('serverpod_auth_core_user', 'blocked', 'boolean', NULL);

--
-- MIGRATION VERSION FOR owncoffer
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('owncoffer', '20261114150148250', (unixepoch('now', 'subsecond') * 1000))
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261114150148250', "timestamp" = (unixepoch('now', 'subsecond') * 1000);

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', (unixepoch('now', 'subsecond') * 1000))
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = (unixepoch('now', 'subsecond') * 1000);

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260924105404509', (unixepoch('now', 'subsecond') * 1000))
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105404509', "timestamp" = (unixepoch('now', 'subsecond') * 1000);

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260924105232991', (unixepoch('now', 'subsecond') * 1000))
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105232991', "timestamp" = (unixepoch('now', 'subsecond') * 1000);


COMMIT;
