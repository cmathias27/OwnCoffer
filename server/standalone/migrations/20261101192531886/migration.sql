BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "account_access" (
    "id" INTEGER PRIMARY KEY,
    "accountId" INTEGER NOT NULL,
    "authUserId" BLOB NOT NULL,
    CONSTRAINT "account_access_fk_0" FOREIGN KEY ("accountId") REFERENCES "accounts" ("id") ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT "account_access_fk_1" FOREIGN KEY ("authUserId") REFERENCES "serverpod_auth_core_user" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "account_access_account_user_idx" ON "account_access" ("accountId", "authUserId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "accounts" (
    "id" INTEGER PRIMARY KEY,
    "groupId" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "kind" TEXT NOT NULL,
    "bank" TEXT,
    "currency" TEXT NOT NULL DEFAULT ('EUR'),
    "initialBalanceCents" INTEGER NOT NULL DEFAULT (0),
    "initialBalanceDate" INTEGER,
    "alertThresholdCents" INTEGER NOT NULL DEFAULT (0),
    "visibility" TEXT NOT NULL DEFAULT ('shared'),
    "bankAccountKey" TEXT,
    "color" TEXT,
    "createdAt" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER)),
    "deletedAt" INTEGER,
    CONSTRAINT "accounts_fk_0" FOREIGN KEY ("groupId") REFERENCES "groups" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE INDEX "accounts_group_idx" ON "accounts" ("groupId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "action_proposals" (
    "id" INTEGER PRIMARY KEY,
    "groupId" INTEGER NOT NULL,
    "authUserId" BLOB NOT NULL,
    "origin" TEXT NOT NULL,
    "provider" TEXT,
    "model" TEXT,
    "kind" TEXT NOT NULL,
    "targetId" INTEGER NOT NULL,
    "currentValue" INTEGER,
    "proposedValue" INTEGER,
    "proposedData" TEXT,
    "reason" TEXT NOT NULL,
    "data" TEXT NOT NULL,
    "dataVersion" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "dedupKey" TEXT NOT NULL,
    "createdAt" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER)),
    "decidedAt" INTEGER,
    "decidedBy" BLOB,
    "executedAt" INTEGER,
    "resultId" INTEGER,
    CONSTRAINT "action_proposals_fk_0" FOREIGN KEY ("groupId") REFERENCES "groups" ("id") ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT "action_proposals_fk_1" FOREIGN KEY ("authUserId") REFERENCES "serverpod_auth_core_user" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE INDEX "action_proposals_user_idx" ON "action_proposals" ("authUserId", "groupId", "status");
CREATE UNIQUE INDEX "action_proposals_dedup_idx" ON "action_proposals" ("authUserId", "groupId", "dedupKey");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "ai_conversations" (
    "id" INTEGER PRIMARY KEY,
    "authUserId" BLOB NOT NULL,
    "groupId" INTEGER NOT NULL,
    "title" TEXT NOT NULL,
    "messages" TEXT NOT NULL,
    "createdAt" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER)),
    "updatedAt" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER)),
    CONSTRAINT "ai_conversations_fk_0" FOREIGN KEY ("authUserId") REFERENCES "serverpod_auth_core_user" ("id") ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT "ai_conversations_fk_1" FOREIGN KEY ("groupId") REFERENCES "groups" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE INDEX "ai_conversations_user_idx" ON "ai_conversations" ("authUserId", "groupId", "updatedAt");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "ai_memories" (
    "id" INTEGER PRIMARY KEY,
    "authUserId" BLOB NOT NULL,
    "groupId" INTEGER NOT NULL,
    "text" TEXT NOT NULL,
    "createdAt" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER)),
    CONSTRAINT "ai_memories_fk_0" FOREIGN KEY ("authUserId") REFERENCES "serverpod_auth_core_user" ("id") ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT "ai_memories_fk_1" FOREIGN KEY ("groupId") REFERENCES "groups" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE INDEX "ai_memories_user_idx" ON "ai_memories" ("authUserId", "groupId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "ai_preferences" (
    "id" INTEGER PRIMARY KEY,
    "authUserId" BLOB NOT NULL,
    "providerId" INTEGER,
    "model" TEXT,
    "enabled" INTEGER NOT NULL,
    CONSTRAINT "ai_preferences_fk_0" FOREIGN KEY ("authUserId") REFERENCES "serverpod_auth_core_user" ("id") ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT "ai_preferences_fk_1" FOREIGN KEY ("providerId") REFERENCES "ai_providers" ("id") ON DELETE SET NULL ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "ai_preferences_user_idx" ON "ai_preferences" ("authUserId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "ai_providers" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "kind" TEXT NOT NULL,
    "baseUrl" TEXT NOT NULL,
    "apiKeyBox" TEXT,
    "models" TEXT NOT NULL,
    "toolCalling" INTEGER NOT NULL,
    "vision" INTEGER NOT NULL,
    "monthlyCap" INTEGER NOT NULL,
    "enabled" INTEGER NOT NULL,
    "createdAt" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER))
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "ai_usage" (
    "id" INTEGER PRIMARY KEY,
    "authUserId" BLOB NOT NULL,
    "providerId" INTEGER NOT NULL,
    "month" INTEGER NOT NULL,
    "requests" INTEGER NOT NULL,
    CONSTRAINT "ai_usage_fk_0" FOREIGN KEY ("authUserId") REFERENCES "serverpod_auth_core_user" ("id") ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT "ai_usage_fk_1" FOREIGN KEY ("providerId") REFERENCES "ai_providers" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "ai_usage_idx" ON "ai_usage" ("authUserId", "providerId", "month");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "audit_log" (
    "id" INTEGER PRIMARY KEY,
    "groupId" INTEGER,
    "authUserId" BLOB,
    "action" TEXT NOT NULL,
    "entity" TEXT NOT NULL,
    "rowId" TEXT,
    "before" TEXT,
    "after" TEXT,
    "createdAt" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER))
) STRICT;

-- Indexes
CREATE INDEX "audit_log_group_created_idx" ON "audit_log" ("groupId", "createdAt");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "balance_checks" (
    "id" INTEGER PRIMARY KEY,
    "accountId" INTEGER NOT NULL,
    "date" INTEGER NOT NULL,
    "bankBalanceCents" INTEGER NOT NULL,
    "computedCents" INTEGER NOT NULL,
    "differenceCents" INTEGER NOT NULL,
    "unclearedManualCents" INTEGER NOT NULL,
    "lastImportedDate" INTEGER,
    "createdBy" BLOB,
    "createdAt" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER)),
    CONSTRAINT "balance_checks_fk_0" FOREIGN KEY ("accountId") REFERENCES "accounts" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE INDEX "balance_checks_account_idx" ON "balance_checks" ("accountId", "date");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "categories" (
    "id" INTEGER PRIMARY KEY,
    "groupId" INTEGER NOT NULL,
    "parentId" INTEGER,
    "name" TEXT,
    "kind" TEXT NOT NULL,
    "standardCode" TEXT,
    "icon" TEXT,
    "color" TEXT,
    "createdAt" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER)),
    "deletedAt" INTEGER,
    CONSTRAINT "categories_fk_0" FOREIGN KEY ("groupId") REFERENCES "groups" ("id") ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT "categories_fk_1" FOREIGN KEY ("parentId") REFERENCES "categories" ("id") ON DELETE SET NULL ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE INDEX "categories_group_idx" ON "categories" ("groupId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "community_rules" (
    "id" INTEGER PRIMARY KEY,
    "ruleKey" TEXT NOT NULL,
    "pattern" TEXT NOT NULL,
    "matchType" TEXT NOT NULL,
    "direction" TEXT NOT NULL DEFAULT ('any'),
    "standardCode" TEXT NOT NULL,
    "country" TEXT NOT NULL DEFAULT ('FR'),
    "confidence" INTEGER NOT NULL DEFAULT (50),
    "baseVersion" INTEGER NOT NULL
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "community_rules_key_idx" ON "community_rules" ("ruleKey");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "goals" (
    "id" INTEGER PRIMARY KEY,
    "groupId" INTEGER NOT NULL,
    "categoryId" INTEGER NOT NULL,
    "amountCents" INTEGER NOT NULL,
    "createdAt" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER)),
    "updatedAt" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER)),
    CONSTRAINT "goals_fk_0" FOREIGN KEY ("groupId") REFERENCES "groups" ("id") ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT "goals_fk_1" FOREIGN KEY ("categoryId") REFERENCES "categories" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "goals_category_idx" ON "goals" ("categoryId");
CREATE INDEX "goals_group_idx" ON "goals" ("groupId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "group_members" (
    "id" INTEGER PRIMARY KEY,
    "groupId" INTEGER NOT NULL,
    "authUserId" BLOB NOT NULL,
    "role" TEXT NOT NULL,
    "createdAt" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER)),
    CONSTRAINT "group_members_fk_0" FOREIGN KEY ("groupId") REFERENCES "groups" ("id") ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT "group_members_fk_1" FOREIGN KEY ("authUserId") REFERENCES "serverpod_auth_core_user" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "group_members_group_user_idx" ON "group_members" ("groupId", "authUserId");
CREATE INDEX "group_members_user_idx" ON "group_members" ("authUserId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "groups" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "aiEnabled" INTEGER NOT NULL DEFAULT (0),
    "standardCatalogVersion" INTEGER NOT NULL DEFAULT (1),
    "monthStartDay" INTEGER NOT NULL DEFAULT (1),
    "createdBy" BLOB NOT NULL,
    "createdAt" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER))
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "imports" (
    "id" INTEGER PRIMARY KEY,
    "accountId" INTEGER NOT NULL,
    "format" TEXT NOT NULL,
    "fileName" TEXT NOT NULL,
    "fileHash" TEXT NOT NULL,
    "encoding" TEXT NOT NULL,
    "readCount" INTEGER NOT NULL,
    "addedCount" INTEGER NOT NULL,
    "duplicateCount" INTEGER NOT NULL,
    "possibleDuplicateCount" INTEGER NOT NULL,
    "errorCount" INTEGER NOT NULL,
    "classifiedCount" INTEGER NOT NULL,
    "authorId" BLOB NOT NULL,
    "createdAt" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER)),
    "cancelledAt" INTEGER,
    CONSTRAINT "imports_fk_0" FOREIGN KEY ("accountId") REFERENCES "accounts" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE INDEX "imports_account_idx" ON "imports" ("accountId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "invitations" (
    "id" INTEGER PRIMARY KEY,
    "groupId" INTEGER,
    "email" TEXT NOT NULL,
    "role" TEXT NOT NULL,
    "serverAdmin" INTEGER NOT NULL DEFAULT (0),
    "tokenHash" TEXT NOT NULL,
    "expiresAt" INTEGER NOT NULL,
    "createdBy" BLOB,
    "createdAt" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER)),
    "acceptedAt" INTEGER,
    "acceptedBy" BLOB,
    "revokedAt" INTEGER,
    CONSTRAINT "invitations_fk_0" FOREIGN KEY ("groupId") REFERENCES "groups" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE INDEX "invitations_email_idx" ON "invitations" ("email");
CREATE UNIQUE INDEX "invitations_token_idx" ON "invitations" ("tokenHash");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "invoice_blobs" (
    "id" INTEGER PRIMARY KEY,
    "invoiceId" INTEGER NOT NULL,
    "content" BLOB NOT NULL,
    CONSTRAINT "invoice_blobs_fk_0" FOREIGN KEY ("invoiceId") REFERENCES "invoices" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "invoice_blobs_invoice_idx" ON "invoice_blobs" ("invoiceId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "invoices" (
    "id" INTEGER PRIMARY KEY,
    "groupId" INTEGER NOT NULL,
    "transactionId" INTEGER,
    "fileName" TEXT NOT NULL,
    "mimeType" TEXT NOT NULL,
    "sizeBytes" INTEGER NOT NULL,
    "label" TEXT,
    "warrantyUntil" INTEGER,
    "hintAmountCents" INTEGER,
    "hintDate" INTEGER,
    "hintMerchant" TEXT,
    "uploadedBy" BLOB,
    "createdAt" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER)),
    CONSTRAINT "invoices_fk_0" FOREIGN KEY ("groupId") REFERENCES "groups" ("id") ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT "invoices_fk_1" FOREIGN KEY ("transactionId") REFERENCES "transactions" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE INDEX "invoices_group_idx" ON "invoices" ("groupId", "createdAt");
CREATE INDEX "invoices_transaction_idx" ON "invoices" ("transactionId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "ip_bans" (
    "id" INTEGER PRIMARY KEY,
    "ip" TEXT NOT NULL,
    "failures" INTEGER NOT NULL DEFAULT (0),
    "windowStart" INTEGER NOT NULL,
    "lastFailureAt" INTEGER NOT NULL,
    "lastFailureKind" TEXT NOT NULL,
    "bannedUntil" INTEGER,
    "banCount" INTEGER NOT NULL DEFAULT (0)
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "ip_bans_ip_idx" ON "ip_bans" ("ip");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "loan_document_blobs" (
    "id" INTEGER PRIMARY KEY,
    "documentId" INTEGER NOT NULL,
    "content" BLOB NOT NULL,
    CONSTRAINT "loan_document_blobs_fk_0" FOREIGN KEY ("documentId") REFERENCES "loan_documents" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "loan_document_blobs_doc_idx" ON "loan_document_blobs" ("documentId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "loan_documents" (
    "id" INTEGER PRIMARY KEY,
    "loanId" INTEGER NOT NULL,
    "fileName" TEXT NOT NULL,
    "mimeType" TEXT NOT NULL,
    "sizeBytes" INTEGER NOT NULL,
    "uploadedBy" BLOB,
    "createdAt" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER)),
    CONSTRAINT "loan_documents_fk_0" FOREIGN KEY ("loanId") REFERENCES "loans" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE INDEX "loan_documents_loan_idx" ON "loan_documents" ("loanId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "loans" (
    "id" INTEGER PRIMARY KEY,
    "groupId" INTEGER NOT NULL,
    "accountId" INTEGER,
    "kind" TEXT NOT NULL,
    "lender" TEXT NOT NULL,
    "label" TEXT,
    "principalCents" INTEGER NOT NULL,
    "annualRateMilli" INTEGER NOT NULL,
    "aprMilli" INTEGER,
    "durationMonths" INTEGER NOT NULL,
    "paymentCents" INTEGER,
    "firstDueDate" INTEGER NOT NULL,
    "insuranceMonthlyCents" INTEGER NOT NULL DEFAULT (0),
    "feesCents" INTEGER NOT NULL DEFAULT (0),
    "categoryId" INTEGER,
    "scheduledId" INTEGER,
    "matchPattern" TEXT,
    "ruleId" INTEGER,
    "creditLimitCents" INTEGER,
    "events" TEXT,
    "createdAt" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER)),
    "deletedAt" INTEGER,
    CONSTRAINT "loans_fk_0" FOREIGN KEY ("groupId") REFERENCES "groups" ("id") ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT "loans_fk_1" FOREIGN KEY ("accountId") REFERENCES "accounts" ("id") ON DELETE SET NULL ON UPDATE NO ACTION,
    CONSTRAINT "loans_fk_2" FOREIGN KEY ("categoryId") REFERENCES "categories" ("id") ON DELETE SET NULL ON UPDATE NO ACTION,
    CONSTRAINT "loans_fk_3" FOREIGN KEY ("scheduledId") REFERENCES "scheduled_transactions" ("id") ON DELETE SET NULL ON UPDATE NO ACTION,
    CONSTRAINT "loans_fk_4" FOREIGN KEY ("ruleId") REFERENCES "rules" ("id") ON DELETE SET NULL ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE INDEX "loans_group_idx" ON "loans" ("groupId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "mcp_tokens" (
    "id" INTEGER PRIMARY KEY,
    "authUserId" BLOB NOT NULL,
    "groupId" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "tokenHash" TEXT,
    "prefix" TEXT NOT NULL,
    "createdAt" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER)),
    "lastUsedAt" INTEGER,
    "revokedAt" INTEGER,
    CONSTRAINT "mcp_tokens_fk_0" FOREIGN KEY ("authUserId") REFERENCES "serverpod_auth_core_user" ("id") ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT "mcp_tokens_fk_1" FOREIGN KEY ("groupId") REFERENCES "groups" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "mcp_tokens_hash_idx" ON "mcp_tokens" ("tokenHash");
CREATE INDEX "mcp_tokens_user_idx" ON "mcp_tokens" ("authUserId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "notification_settings" (
    "id" INTEGER PRIMARY KEY,
    "authUserId" BLOB NOT NULL,
    "overdraftApp" INTEGER NOT NULL DEFAULT (1),
    "overdraftEmail" INTEGER NOT NULL DEFAULT (1),
    "goalWarning" INTEGER NOT NULL DEFAULT (1),
    "goalOver" INTEGER NOT NULL DEFAULT (1),
    "goalForecast" INTEGER NOT NULL DEFAULT (1),
    "warrantyApp" INTEGER NOT NULL DEFAULT (1),
    "warrantyEmail" INTEGER NOT NULL DEFAULT (1),
    "updatedAt" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER)),
    CONSTRAINT "notification_settings_fk_0" FOREIGN KEY ("authUserId") REFERENCES "serverpod_auth_core_user" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "notification_settings_user_idx" ON "notification_settings" ("authUserId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "notifications" (
    "id" INTEGER PRIMARY KEY,
    "authUserId" BLOB NOT NULL,
    "groupId" INTEGER,
    "accountId" INTEGER,
    "type" TEXT NOT NULL,
    "data" TEXT NOT NULL,
    "dedupKey" TEXT NOT NULL,
    "createdAt" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER)),
    "readAt" INTEGER,
    "emailedAt" INTEGER,
    CONSTRAINT "notifications_fk_0" FOREIGN KEY ("authUserId") REFERENCES "serverpod_auth_core_user" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "notifications_user_key_idx" ON "notifications" ("authUserId", "dedupKey");
CREATE INDEX "notifications_user_created_idx" ON "notifications" ("authUserId", "createdAt");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "rules" (
    "id" INTEGER PRIMARY KEY,
    "groupId" INTEGER NOT NULL,
    "categoryId" INTEGER NOT NULL,
    "matchType" TEXT NOT NULL,
    "pattern" TEXT NOT NULL,
    "direction" TEXT NOT NULL DEFAULT ('any'),
    "minAbsCents" INTEGER,
    "maxAbsCents" INTEGER,
    "priority" INTEGER NOT NULL DEFAULT (100),
    "enabled" INTEGER NOT NULL DEFAULT (1),
    "createdBy" BLOB,
    "createdAt" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER)),
    CONSTRAINT "rules_fk_0" FOREIGN KEY ("groupId") REFERENCES "groups" ("id") ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT "rules_fk_1" FOREIGN KEY ("categoryId") REFERENCES "categories" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE INDEX "rules_group_idx" ON "rules" ("groupId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "scheduled_transactions" (
    "id" INTEGER PRIMARY KEY,
    "accountId" INTEGER NOT NULL,
    "amountCents" INTEGER NOT NULL,
    "label" TEXT NOT NULL,
    "categoryId" INTEGER,
    "frequency" TEXT NOT NULL,
    "interval" INTEGER NOT NULL DEFAULT (1),
    "startDate" INTEGER NOT NULL,
    "endDate" INTEGER,
    "occurrenceCount" INTEGER,
    "nextDue" INTEGER,
    "matchPattern" TEXT NOT NULL DEFAULT (''),
    "dateToleranceDays" INTEGER NOT NULL DEFAULT (5),
    "amountTolerancePercent" INTEGER NOT NULL DEFAULT (0),
    "subscription" INTEGER NOT NULL DEFAULT (0),
    "createdAt" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER)),
    "deletedAt" INTEGER,
    CONSTRAINT "scheduled_transactions_fk_0" FOREIGN KEY ("accountId") REFERENCES "accounts" ("id") ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT "scheduled_transactions_fk_1" FOREIGN KEY ("categoryId") REFERENCES "categories" ("id") ON DELETE SET NULL ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE INDEX "scheduled_account_idx" ON "scheduled_transactions" ("accountId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "totp_backup_codes" (
    "id" INTEGER PRIMARY KEY,
    "authUserId" BLOB NOT NULL,
    "codeHash" TEXT NOT NULL,
    "usedAt" INTEGER,
    CONSTRAINT "totp_backup_codes_fk_0" FOREIGN KEY ("authUserId") REFERENCES "serverpod_auth_core_user" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE INDEX "totp_backup_codes_user_idx" ON "totp_backup_codes" ("authUserId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "totp_secrets" (
    "id" INTEGER PRIMARY KEY,
    "authUserId" BLOB NOT NULL,
    "secretBox" TEXT NOT NULL,
    "enabled" INTEGER NOT NULL DEFAULT (0),
    "lastUsedStep" INTEGER,
    "createdAt" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER)),
    "enabledAt" INTEGER,
    CONSTRAINT "totp_secrets_fk_0" FOREIGN KEY ("authUserId") REFERENCES "serverpod_auth_core_user" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "totp_secrets_user_idx" ON "totp_secrets" ("authUserId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "transaction_splits" (
    "id" INTEGER PRIMARY KEY,
    "transactionId" INTEGER NOT NULL,
    "categoryId" INTEGER,
    "amountCents" INTEGER NOT NULL,
    "note" TEXT,
    CONSTRAINT "transaction_splits_fk_0" FOREIGN KEY ("transactionId") REFERENCES "transactions" ("id") ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT "transaction_splits_fk_1" FOREIGN KEY ("categoryId") REFERENCES "categories" ("id") ON DELETE SET NULL ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE INDEX "transaction_splits_tx_idx" ON "transaction_splits" ("transactionId");
CREATE INDEX "transaction_splits_category_idx" ON "transaction_splits" ("categoryId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "transactions" (
    "id" INTEGER PRIMARY KEY,
    "accountId" INTEGER NOT NULL,
    "date" INTEGER NOT NULL,
    "amountCents" INTEGER NOT NULL,
    "rawLabel" TEXT NOT NULL,
    "memo" TEXT,
    "note" TEXT,
    "cleanLabel" TEXT NOT NULL,
    "operationKind" TEXT NOT NULL,
    "reference" TEXT,
    "bankId" TEXT,
    "fingerprint" TEXT,
    "trashedFingerprint" TEXT,
    "importId" INTEGER,
    "categoryId" INTEGER,
    "categorySource" TEXT NOT NULL DEFAULT ('none'),
    "categoryRuleRef" TEXT,
    "cleared" INTEGER NOT NULL DEFAULT (0),
    "scheduledId" INTEGER,
    "scheduledDueDate" INTEGER,
    "transferPairId" INTEGER,
    "createdBy" BLOB,
    "createdAt" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER)),
    "updatedAt" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER)),
    "deletedAt" INTEGER,
    CONSTRAINT "transactions_fk_0" FOREIGN KEY ("accountId") REFERENCES "accounts" ("id") ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT "transactions_fk_1" FOREIGN KEY ("importId") REFERENCES "imports" ("id") ON DELETE SET NULL ON UPDATE NO ACTION,
    CONSTRAINT "transactions_fk_2" FOREIGN KEY ("categoryId") REFERENCES "categories" ("id") ON DELETE SET NULL ON UPDATE NO ACTION,
    CONSTRAINT "transactions_fk_3" FOREIGN KEY ("scheduledId") REFERENCES "scheduled_transactions" ("id") ON DELETE SET NULL ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE INDEX "transactions_account_date_idx" ON "transactions" ("accountId", "date");
CREATE UNIQUE INDEX "transactions_account_fingerprint_idx" ON "transactions" ("accountId", "fingerprint");
CREATE INDEX "transactions_import_idx" ON "transactions" ("importId");
CREATE INDEX "transactions_category_idx" ON "transactions" ("categoryId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "user_feedbacks" (
    "id" INTEGER PRIMARY KEY,
    "authUserId" BLOB,
    "kind" TEXT NOT NULL,
    "text" TEXT NOT NULL,
    "page" TEXT,
    "appVersion" TEXT,
    "status" TEXT NOT NULL,
    "createdAt" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER)),
    CONSTRAINT "user_feedbacks_fk_0" FOREIGN KEY ("authUserId") REFERENCES "serverpod_auth_core_user" ("id") ON DELETE SET NULL ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE INDEX "user_feedbacks_created_idx" ON "user_feedbacks" ("createdAt");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_cloud_storage" (
    "id" INTEGER PRIMARY KEY,
    "storageId" TEXT NOT NULL,
    "path" TEXT NOT NULL,
    "addedTime" INTEGER NOT NULL,
    "expiration" INTEGER,
    "byteData" BLOB NOT NULL,
    "verified" INTEGER NOT NULL,
    "contentType" TEXT,
    "cacheControl" TEXT,
    "contentDisposition" TEXT,
    "contentEncoding" TEXT,
    "customMetadata" TEXT
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_path_idx" ON "serverpod_cloud_storage" ("storageId", "path");
CREATE INDEX "serverpod_cloud_storage_expiration" ON "serverpod_cloud_storage" ("expiration");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_cloud_storage_direct_download" (
    "id" INTEGER PRIMARY KEY,
    "storageId" TEXT NOT NULL,
    "path" TEXT NOT NULL,
    "expiration" INTEGER NOT NULL,
    "authKey" TEXT NOT NULL,
    "downloadFileName" TEXT,
    "contentType" TEXT
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_direct_download_auth_key" ON "serverpod_cloud_storage_direct_download" ("authKey");
CREATE INDEX "serverpod_cloud_storage_direct_download_expiration" ON "serverpod_cloud_storage_direct_download" ("expiration");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_cloud_storage_direct_upload" (
    "id" INTEGER PRIMARY KEY,
    "storageId" TEXT NOT NULL,
    "path" TEXT NOT NULL,
    "expiration" INTEGER NOT NULL,
    "authKey" TEXT NOT NULL,
    "maxFileSize" INTEGER NOT NULL DEFAULT (10485760),
    "contentLength" INTEGER,
    "preventOverwrite" INTEGER NOT NULL DEFAULT (0),
    "contentType" TEXT,
    "cacheControl" TEXT,
    "contentDisposition" TEXT,
    "contentEncoding" TEXT,
    "customMetadata" TEXT
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_direct_upload_storage_path" ON "serverpod_cloud_storage_direct_upload" ("storageId", "path");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_future_call" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "time" INTEGER NOT NULL,
    "serializedObject" TEXT,
    "serverId" TEXT NOT NULL,
    "identifier" TEXT,
    "scheduling" TEXT
) STRICT;

-- Indexes
CREATE INDEX "serverpod_future_call_time_idx" ON "serverpod_future_call" ("time");
CREATE INDEX "serverpod_future_call_serverId_idx" ON "serverpod_future_call" ("serverId");
CREATE INDEX "serverpod_future_call_identifier_idx" ON "serverpod_future_call" ("identifier");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_future_call_claim" (
    "id" INTEGER PRIMARY KEY,
    "futureCallId" INTEGER,
    "lastHeartbeatTime" INTEGER NOT NULL,
    CONSTRAINT "serverpod_future_call_claim_fk_0" FOREIGN KEY ("futureCallId") REFERENCES "serverpod_future_call" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "future_call_unique_idx" ON "serverpod_future_call_claim" ("futureCallId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_health_connection_info" (
    "id" INTEGER PRIMARY KEY,
    "serverId" TEXT NOT NULL,
    "timestamp" INTEGER NOT NULL,
    "active" INTEGER NOT NULL,
    "closing" INTEGER NOT NULL,
    "idle" INTEGER NOT NULL,
    "granularity" INTEGER NOT NULL
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_connection_info_timestamp_idx" ON "serverpod_health_connection_info" ("timestamp", "serverId", "granularity");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_health_metric" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "serverId" TEXT NOT NULL,
    "timestamp" INTEGER NOT NULL,
    "isHealthy" INTEGER NOT NULL,
    "value" REAL NOT NULL,
    "granularity" INTEGER NOT NULL
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_metric_timestamp_idx" ON "serverpod_health_metric" ("timestamp", "serverId", "name", "granularity");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_log" (
    "id" INTEGER PRIMARY KEY,
    "sessionLogId" INTEGER NOT NULL,
    "messageId" INTEGER,
    "reference" TEXT,
    "serverId" TEXT NOT NULL,
    "time" INTEGER NOT NULL,
    "logLevel" INTEGER NOT NULL,
    "message" TEXT NOT NULL,
    "error" TEXT,
    "stackTrace" TEXT,
    "order" INTEGER NOT NULL,
    CONSTRAINT "serverpod_log_fk_0" FOREIGN KEY ("sessionLogId") REFERENCES "serverpod_session_log" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE INDEX "serverpod_log_sessionLogId_idx" ON "serverpod_log" ("sessionLogId", "order");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_message_log" (
    "id" INTEGER PRIMARY KEY,
    "sessionLogId" INTEGER NOT NULL,
    "serverId" TEXT NOT NULL,
    "messageId" INTEGER NOT NULL,
    "endpoint" TEXT NOT NULL,
    "messageName" TEXT NOT NULL,
    "duration" REAL NOT NULL,
    "error" TEXT,
    "stackTrace" TEXT,
    "slow" INTEGER NOT NULL,
    "order" INTEGER NOT NULL,
    CONSTRAINT "serverpod_message_log_fk_0" FOREIGN KEY ("sessionLogId") REFERENCES "serverpod_session_log" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE INDEX "serverpod_message_log_sessionLogId_idx" ON "serverpod_message_log" ("sessionLogId", "order");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_method" (
    "id" INTEGER PRIMARY KEY,
    "endpoint" TEXT NOT NULL,
    "method" TEXT NOT NULL
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "serverpod_method_endpoint_method_idx" ON "serverpod_method" ("endpoint", "method");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_migrations" (
    "id" INTEGER PRIMARY KEY,
    "module" TEXT NOT NULL,
    "version" TEXT NOT NULL,
    "timestamp" INTEGER
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "serverpod_migrations_ids" ON "serverpod_migrations" ("module");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_query_log" (
    "id" INTEGER PRIMARY KEY,
    "serverId" TEXT NOT NULL,
    "sessionLogId" INTEGER NOT NULL,
    "messageId" INTEGER,
    "query" TEXT NOT NULL,
    "duration" REAL NOT NULL,
    "numRows" INTEGER,
    "error" TEXT,
    "stackTrace" TEXT,
    "slow" INTEGER NOT NULL,
    "order" INTEGER NOT NULL,
    CONSTRAINT "serverpod_query_log_fk_0" FOREIGN KEY ("sessionLogId") REFERENCES "serverpod_session_log" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE INDEX "serverpod_query_log_sessionLogId_idx" ON "serverpod_query_log" ("sessionLogId", "order");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_readwrite_test" (
    "id" INTEGER PRIMARY KEY,
    "number" INTEGER NOT NULL
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_runtime_settings" (
    "id" INTEGER PRIMARY KEY,
    "logSettings" TEXT NOT NULL,
    "logSettingsOverrides" TEXT NOT NULL,
    "logServiceCalls" INTEGER NOT NULL,
    "logMalformedCalls" INTEGER NOT NULL
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_session_log" (
    "id" INTEGER PRIMARY KEY,
    "serverId" TEXT NOT NULL,
    "time" INTEGER NOT NULL,
    "module" TEXT,
    "endpoint" TEXT,
    "method" TEXT,
    "duration" REAL,
    "numQueries" INTEGER,
    "slow" INTEGER,
    "error" TEXT,
    "stackTrace" TEXT,
    "authenticatedUserId" INTEGER,
    "userId" TEXT,
    "isOpen" INTEGER,
    "touched" INTEGER NOT NULL
) STRICT;

-- Indexes
CREATE INDEX "serverpod_session_log_serverid_idx" ON "serverpod_session_log" ("serverId");
CREATE INDEX "serverpod_session_log_time_idx" ON "serverpod_session_log" ("time");
CREATE INDEX "serverpod_session_log_touched_idx" ON "serverpod_session_log" ("touched");
CREATE INDEX "serverpod_session_log_isopen_idx" ON "serverpod_session_log" ("isOpen");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_idp_anonymous_account" (
    "id" BLOB PRIMARY KEY DEFAULT (unhex(printf('%012x', CAST(unixepoch('now', 'subsecond') * 1000 AS INTEGER)) || '7' || substr(hex(randomblob(2)), 2, 3) || substr('89AB', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15))),
    "authUserId" BLOB NOT NULL,
    "createdAt" INTEGER NOT NULL,
    CONSTRAINT "serverpod_auth_idp_anonymous_account_fk_0" FOREIGN KEY ("authUserId") REFERENCES "serverpod_auth_core_user" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_idp_apple_account" (
    "id" BLOB PRIMARY KEY DEFAULT (unhex(printf('%012x', CAST(unixepoch('now', 'subsecond') * 1000 AS INTEGER)) || '7' || substr(hex(randomblob(2)), 2, 3) || substr('89AB', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15))),
    "userIdentifier" TEXT NOT NULL,
    "refreshToken" TEXT NOT NULL,
    "refreshTokenRequestedWithBundleIdentifier" INTEGER NOT NULL,
    "lastRefreshedAt" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER)),
    "authUserId" BLOB NOT NULL,
    "createdAt" INTEGER NOT NULL,
    "email" TEXT,
    "isEmailVerified" INTEGER,
    "isPrivateEmail" INTEGER,
    "firstName" TEXT,
    "lastName" TEXT,
    CONSTRAINT "serverpod_auth_idp_apple_account_fk_0" FOREIGN KEY ("authUserId") REFERENCES "serverpod_auth_core_user" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_apple_account_identifier" ON "serverpod_auth_idp_apple_account" ("userIdentifier");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_idp_email_account" (
    "id" BLOB PRIMARY KEY DEFAULT (unhex(printf('%012x', CAST(unixepoch('now', 'subsecond') * 1000 AS INTEGER)) || '7' || substr(hex(randomblob(2)), 2, 3) || substr('89AB', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15))),
    "authUserId" BLOB NOT NULL,
    "createdAt" INTEGER NOT NULL,
    "email" TEXT NOT NULL,
    "passwordHash" TEXT NOT NULL,
    CONSTRAINT "serverpod_auth_idp_email_account_fk_0" FOREIGN KEY ("authUserId") REFERENCES "serverpod_auth_core_user" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_idp_email_account_email" ON "serverpod_auth_idp_email_account" ("email");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_idp_email_account_password_reset_request" (
    "id" BLOB PRIMARY KEY DEFAULT (unhex(printf('%012x', CAST(unixepoch('now', 'subsecond') * 1000 AS INTEGER)) || '7' || substr(hex(randomblob(2)), 2, 3) || substr('89AB', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15))),
    "emailAccountId" BLOB NOT NULL,
    "createdAt" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER)),
    "challengeId" BLOB NOT NULL,
    "setPasswordChallengeId" BLOB,
    CONSTRAINT "serverpod_auth_idp_email_account_password_reset_request_fk_0" FOREIGN KEY ("emailAccountId") REFERENCES "serverpod_auth_idp_email_account" ("id") ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT "serverpod_auth_idp_email_account_password_reset_request_fk_1" FOREIGN KEY ("challengeId") REFERENCES "serverpod_auth_idp_secret_challenge" ("id") ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT "serverpod_auth_idp_email_account_password_reset_request_fk_2" FOREIGN KEY ("setPasswordChallengeId") REFERENCES "serverpod_auth_idp_secret_challenge" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_idp_email_account_request" (
    "id" BLOB PRIMARY KEY DEFAULT (unhex(printf('%012x', CAST(unixepoch('now', 'subsecond') * 1000 AS INTEGER)) || '7' || substr(hex(randomblob(2)), 2, 3) || substr('89AB', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15))),
    "createdAt" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER)),
    "email" TEXT NOT NULL,
    "challengeId" BLOB NOT NULL,
    "createAccountChallengeId" BLOB,
    CONSTRAINT "serverpod_auth_idp_email_account_request_fk_0" FOREIGN KEY ("challengeId") REFERENCES "serverpod_auth_idp_secret_challenge" ("id") ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT "serverpod_auth_idp_email_account_request_fk_1" FOREIGN KEY ("createAccountChallengeId") REFERENCES "serverpod_auth_idp_secret_challenge" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_idp_email_account_request_email" ON "serverpod_auth_idp_email_account_request" ("email");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_idp_facebook_account" (
    "id" BLOB PRIMARY KEY DEFAULT (unhex(printf('%012x', CAST(unixepoch('now', 'subsecond') * 1000 AS INTEGER)) || '7' || substr(hex(randomblob(2)), 2, 3) || substr('89AB', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15))),
    "authUserId" BLOB NOT NULL,
    "createdAt" INTEGER NOT NULL,
    "userIdentifier" TEXT NOT NULL,
    "email" TEXT,
    "fullName" TEXT,
    "firstName" TEXT,
    "lastName" TEXT,
    CONSTRAINT "serverpod_auth_idp_facebook_account_fk_0" FOREIGN KEY ("authUserId") REFERENCES "serverpod_auth_core_user" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_facebook_account_user_identifier" ON "serverpod_auth_idp_facebook_account" ("userIdentifier");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_idp_firebase_account" (
    "id" BLOB PRIMARY KEY DEFAULT (unhex(printf('%012x', CAST(unixepoch('now', 'subsecond') * 1000 AS INTEGER)) || '7' || substr(hex(randomblob(2)), 2, 3) || substr('89AB', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15))),
    "authUserId" BLOB NOT NULL,
    "created" INTEGER NOT NULL,
    "email" TEXT,
    "phone" TEXT,
    "userIdentifier" TEXT NOT NULL,
    CONSTRAINT "serverpod_auth_idp_firebase_account_fk_0" FOREIGN KEY ("authUserId") REFERENCES "serverpod_auth_core_user" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_firebase_account_user_identifier" ON "serverpod_auth_idp_firebase_account" ("userIdentifier");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_idp_github_account" (
    "id" BLOB PRIMARY KEY DEFAULT (unhex(printf('%012x', CAST(unixepoch('now', 'subsecond') * 1000 AS INTEGER)) || '7' || substr(hex(randomblob(2)), 2, 3) || substr('89AB', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15))),
    "authUserId" BLOB NOT NULL,
    "userIdentifier" TEXT NOT NULL,
    "email" TEXT,
    "created" INTEGER NOT NULL,
    CONSTRAINT "serverpod_auth_idp_github_account_fk_0" FOREIGN KEY ("authUserId") REFERENCES "serverpod_auth_core_user" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_github_account_user_identifier" ON "serverpod_auth_idp_github_account" ("userIdentifier");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_idp_google_account" (
    "id" BLOB PRIMARY KEY DEFAULT (unhex(printf('%012x', CAST(unixepoch('now', 'subsecond') * 1000 AS INTEGER)) || '7' || substr(hex(randomblob(2)), 2, 3) || substr('89AB', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15))),
    "authUserId" BLOB NOT NULL,
    "created" INTEGER NOT NULL,
    "email" TEXT NOT NULL,
    "userIdentifier" TEXT NOT NULL,
    CONSTRAINT "serverpod_auth_idp_google_account_fk_0" FOREIGN KEY ("authUserId") REFERENCES "serverpod_auth_core_user" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_google_account_user_identifier" ON "serverpod_auth_idp_google_account" ("userIdentifier");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_idp_microsoft_account" (
    "id" BLOB PRIMARY KEY DEFAULT (unhex(printf('%012x', CAST(unixepoch('now', 'subsecond') * 1000 AS INTEGER)) || '7' || substr(hex(randomblob(2)), 2, 3) || substr('89AB', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15))),
    "authUserId" BLOB NOT NULL,
    "userIdentifier" TEXT NOT NULL,
    "email" TEXT,
    "created" INTEGER NOT NULL,
    CONSTRAINT "serverpod_auth_idp_microsoft_account_fk_0" FOREIGN KEY ("authUserId") REFERENCES "serverpod_auth_core_user" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_microsoft_account_user_identifier" ON "serverpod_auth_idp_microsoft_account" ("userIdentifier");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_idp_passkey_account" (
    "id" BLOB PRIMARY KEY DEFAULT (unhex(printf('%012x', CAST(unixepoch('now', 'subsecond') * 1000 AS INTEGER)) || '7' || substr(hex(randomblob(2)), 2, 3) || substr('89AB', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15))),
    "authUserId" BLOB NOT NULL,
    "createdAt" INTEGER NOT NULL,
    "keyId" BLOB NOT NULL,
    "keyIdBase64" TEXT NOT NULL,
    "clientDataJSON" BLOB NOT NULL,
    "attestationObject" BLOB NOT NULL,
    "originalChallenge" BLOB NOT NULL,
    CONSTRAINT "serverpod_auth_idp_passkey_account_fk_0" FOREIGN KEY ("authUserId") REFERENCES "serverpod_auth_core_user" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_idp_passkey_account_key_id_base64" ON "serverpod_auth_idp_passkey_account" ("keyIdBase64");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_idp_passkey_challenge" (
    "id" BLOB PRIMARY KEY DEFAULT (unhex(printf('%012x', CAST(unixepoch('now', 'subsecond') * 1000 AS INTEGER)) || '7' || substr(hex(randomblob(2)), 2, 3) || substr('89AB', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15))),
    "createdAt" INTEGER NOT NULL,
    "challenge" BLOB NOT NULL
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_idp_rate_limited_request_attempt" (
    "id" BLOB PRIMARY KEY DEFAULT (unhex(printf('%012x', CAST(unixepoch('now', 'subsecond') * 1000 AS INTEGER)) || '7' || substr(hex(randomblob(2)), 2, 3) || substr('89AB', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15))),
    "domain" TEXT NOT NULL,
    "source" TEXT NOT NULL,
    "key" TEXT NOT NULL,
    "ipAddress" TEXT,
    "attemptedAt" INTEGER NOT NULL,
    "extraData" TEXT
) STRICT;

-- Indexes
CREATE INDEX "serverpod_auth_idp_rate_limited_request_attempt_composite" ON "serverpod_auth_idp_rate_limited_request_attempt" ("domain", "source", "key", "attemptedAt");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_idp_secret_challenge" (
    "id" BLOB PRIMARY KEY DEFAULT (unhex(printf('%012x', CAST(unixepoch('now', 'subsecond') * 1000 AS INTEGER)) || '7' || substr(hex(randomblob(2)), 2, 3) || substr('89AB', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15))),
    "challengeCodeHash" TEXT NOT NULL
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_core_jwt_refresh_token" (
    "id" BLOB PRIMARY KEY DEFAULT (unhex(printf('%012x', CAST(unixepoch('now', 'subsecond') * 1000 AS INTEGER)) || '7' || substr(hex(randomblob(2)), 2, 3) || substr('89AB', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15))),
    "authUserId" BLOB NOT NULL,
    "scopeNames" TEXT NOT NULL,
    "extraClaims" TEXT,
    "method" TEXT NOT NULL,
    "fixedSecret" BLOB NOT NULL,
    "rotatingSecretHash" TEXT NOT NULL,
    "lastUpdatedAt" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER)),
    "createdAt" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER)),
    CONSTRAINT "serverpod_auth_core_jwt_refresh_token_fk_0" FOREIGN KEY ("authUserId") REFERENCES "serverpod_auth_core_user" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE INDEX "serverpod_auth_core_jwt_refresh_token_last_updated_at" ON "serverpod_auth_core_jwt_refresh_token" ("lastUpdatedAt");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_core_profile" (
    "id" BLOB PRIMARY KEY DEFAULT (unhex(printf('%012x', CAST(unixepoch('now', 'subsecond') * 1000 AS INTEGER)) || '7' || substr(hex(randomblob(2)), 2, 3) || substr('89AB', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15))),
    "authUserId" BLOB NOT NULL,
    "userName" TEXT,
    "fullName" TEXT,
    "email" TEXT,
    "createdAt" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER)),
    "imageId" BLOB,
    CONSTRAINT "serverpod_auth_core_profile_fk_0" FOREIGN KEY ("authUserId") REFERENCES "serverpod_auth_core_user" ("id") ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT "serverpod_auth_core_profile_fk_1" FOREIGN KEY ("imageId") REFERENCES "serverpod_auth_core_profile_image" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION DEFERRABLE INITIALLY DEFERRED
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_profile_user_profile_email_auth_user_id" ON "serverpod_auth_core_profile" ("authUserId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_core_profile_image" (
    "id" BLOB PRIMARY KEY DEFAULT (unhex(printf('%012x', CAST(unixepoch('now', 'subsecond') * 1000 AS INTEGER)) || '7' || substr(hex(randomblob(2)), 2, 3) || substr('89AB', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15))),
    "userProfileId" BLOB NOT NULL,
    "createdAt" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER)),
    "storageId" TEXT NOT NULL,
    "path" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    CONSTRAINT "serverpod_auth_core_profile_image_fk_0" FOREIGN KEY ("userProfileId") REFERENCES "serverpod_auth_core_profile" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_core_session" (
    "id" BLOB PRIMARY KEY DEFAULT (unhex(printf('%012x', CAST(unixepoch('now', 'subsecond') * 1000 AS INTEGER)) || '7' || substr(hex(randomblob(2)), 2, 3) || substr('89AB', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15))),
    "authUserId" BLOB NOT NULL,
    "scopeNames" TEXT NOT NULL,
    "createdAt" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER)),
    "lastUsedAt" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER)),
    "expiresAt" INTEGER,
    "expireAfterUnusedFor" INTEGER,
    "sessionKeyHash" BLOB NOT NULL,
    "sessionKeySalt" BLOB NOT NULL,
    "method" TEXT NOT NULL,
    CONSTRAINT "serverpod_auth_core_session_fk_0" FOREIGN KEY ("authUserId") REFERENCES "serverpod_auth_core_user" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_core_user" (
    "id" BLOB PRIMARY KEY DEFAULT (unhex(printf('%012x', CAST(unixepoch('now', 'subsecond') * 1000 AS INTEGER)) || '7' || substr(hex(randomblob(2)), 2, 3) || substr('89AB', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15))),
    "createdAt" INTEGER NOT NULL,
    "scopeNames" TEXT NOT NULL,
    "blocked" INTEGER NOT NULL
) STRICT;

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
    ('ai_memories', 'authUserId', 'uuid', NULL),
    ('ai_memories', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('ai_preferences', 'authUserId', 'uuid', NULL),
    ('ai_preferences', 'enabled', 'boolean', NULL),
    ('ai_providers', 'toolCalling', 'boolean', NULL),
    ('ai_providers', 'vision', 'boolean', NULL),
    ('ai_providers', 'enabled', 'boolean', NULL),
    ('ai_providers', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('ai_usage', 'authUserId', 'uuid', NULL),
    ('audit_log', 'authUserId', 'uuid', NULL),
    ('audit_log', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('balance_checks', 'date', 'timestampWithoutTimeZone', NULL),
    ('balance_checks', 'lastImportedDate', 'timestampWithoutTimeZone', NULL),
    ('balance_checks', 'createdBy', 'uuid', NULL),
    ('balance_checks', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('categories', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('categories', 'deletedAt', 'timestampWithoutTimeZone', NULL),
    ('goals', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('goals', 'updatedAt', 'timestampWithoutTimeZone', NULL),
    ('group_members', 'authUserId', 'uuid', NULL),
    ('group_members', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('groups', 'aiEnabled', 'boolean', NULL),
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
    ('loan_documents', 'uploadedBy', 'uuid', NULL),
    ('loan_documents', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('loans', 'firstDueDate', 'timestampWithoutTimeZone', NULL),
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
    ('rules', 'enabled', 'boolean', NULL),
    ('rules', 'createdBy', 'uuid', NULL),
    ('rules', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('scheduled_transactions', 'startDate', 'timestampWithoutTimeZone', NULL),
    ('scheduled_transactions', 'endDate', 'timestampWithoutTimeZone', NULL),
    ('scheduled_transactions', 'nextDue', 'timestampWithoutTimeZone', NULL),
    ('scheduled_transactions', 'subscription', 'boolean', NULL),
    ('scheduled_transactions', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('scheduled_transactions', 'deletedAt', 'timestampWithoutTimeZone', NULL),
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
    VALUES ('owncoffer', '20261101192531886', (unixepoch('now', 'subsecond') * 1000))
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261101192531886', "timestamp" = (unixepoch('now', 'subsecond') * 1000);

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
