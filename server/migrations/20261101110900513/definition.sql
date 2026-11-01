BEGIN;

--
-- Function: gen_random_uuid_v7()
-- Source: https://gist.github.com/kjmph/5bd772b2c2df145aa645b837da7eca74
-- License: MIT (copyright notice included on the generator source code).
--
create or replace function gen_random_uuid_v7()
returns uuid
as $$
begin
  -- use random v4 uuid as starting point (which has the same variant we need)
  -- then overlay timestamp
  -- then set version 7 by flipping the 2 and 1 bit in the version 4 string
  return encode(
    set_bit(
      set_bit(
        overlay(uuid_send(gen_random_uuid())
                placing substring(int8send(floor(extract(epoch from clock_timestamp()) * 1000)::bigint) from 3)
                from 1 for 6
        ),
        52, 1
      ),
      53, 1
    ),
    'hex')::uuid;
end
$$
language plpgsql
volatile;

--
-- Class AccountAccess as table account_access
--
CREATE TABLE "account_access" (
    "id" bigserial PRIMARY KEY,
    "accountId" bigint NOT NULL,
    "authUserId" uuid NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "account_access_account_user_idx" ON "account_access" USING btree ("accountId", "authUserId");

--
-- Class Account as table accounts
--
CREATE TABLE "accounts" (
    "id" bigserial PRIMARY KEY,
    "groupId" bigint NOT NULL,
    "name" text NOT NULL,
    "kind" text NOT NULL,
    "bank" text,
    "currency" text NOT NULL DEFAULT 'EUR'::text,
    "initialBalanceCents" bigint NOT NULL DEFAULT 0,
    "initialBalanceDate" timestamp without time zone,
    "alertThresholdCents" bigint NOT NULL DEFAULT 0,
    "visibility" text NOT NULL DEFAULT 'shared'::text,
    "bankAccountKey" text,
    "color" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "accounts_group_idx" ON "accounts" USING btree ("groupId");

--
-- Class ActionProposal as table action_proposals
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
-- Class AuditEntry as table audit_log
--
CREATE TABLE "audit_log" (
    "id" bigserial PRIMARY KEY,
    "groupId" bigint,
    "authUserId" uuid,
    "action" text NOT NULL,
    "entity" text NOT NULL,
    "rowId" text,
    "before" text,
    "after" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "audit_log_group_created_idx" ON "audit_log" USING btree ("groupId", "createdAt");

--
-- Class BalanceCheck as table balance_checks
--
CREATE TABLE "balance_checks" (
    "id" bigserial PRIMARY KEY,
    "accountId" bigint NOT NULL,
    "date" timestamp without time zone NOT NULL,
    "bankBalanceCents" bigint NOT NULL,
    "computedCents" bigint NOT NULL,
    "differenceCents" bigint NOT NULL,
    "unclearedManualCents" bigint NOT NULL,
    "lastImportedDate" timestamp without time zone,
    "createdBy" uuid,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "balance_checks_account_idx" ON "balance_checks" USING btree ("accountId", "date");

--
-- Class Category as table categories
--
CREATE TABLE "categories" (
    "id" bigserial PRIMARY KEY,
    "groupId" bigint NOT NULL,
    "parentId" bigint,
    "name" text,
    "kind" text NOT NULL,
    "standardCode" text,
    "icon" text,
    "color" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "categories_group_idx" ON "categories" USING btree ("groupId");

--
-- Class CommunityRule as table community_rules
--
CREATE TABLE "community_rules" (
    "id" bigserial PRIMARY KEY,
    "ruleKey" text NOT NULL,
    "pattern" text NOT NULL,
    "matchType" text NOT NULL,
    "direction" text NOT NULL DEFAULT 'any'::text,
    "standardCode" text NOT NULL,
    "country" text NOT NULL DEFAULT 'FR'::text,
    "confidence" bigint NOT NULL DEFAULT 50,
    "baseVersion" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "community_rules_key_idx" ON "community_rules" USING btree ("ruleKey");

--
-- Class Goal as table goals
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
-- Class GroupMember as table group_members
--
CREATE TABLE "group_members" (
    "id" bigserial PRIMARY KEY,
    "groupId" bigint NOT NULL,
    "authUserId" uuid NOT NULL,
    "role" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "group_members_group_user_idx" ON "group_members" USING btree ("groupId", "authUserId");
CREATE INDEX "group_members_user_idx" ON "group_members" USING btree ("authUserId");

--
-- Class FinanceGroup as table groups
--
CREATE TABLE "groups" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "aiEnabled" boolean NOT NULL DEFAULT false,
    "standardCatalogVersion" bigint NOT NULL DEFAULT 1,
    "monthStartDay" bigint NOT NULL DEFAULT 1,
    "createdBy" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--
-- Class StatementImport as table imports
--
CREATE TABLE "imports" (
    "id" bigserial PRIMARY KEY,
    "accountId" bigint NOT NULL,
    "format" text NOT NULL,
    "fileName" text NOT NULL,
    "fileHash" text NOT NULL,
    "encoding" text NOT NULL,
    "readCount" bigint NOT NULL,
    "addedCount" bigint NOT NULL,
    "duplicateCount" bigint NOT NULL,
    "possibleDuplicateCount" bigint NOT NULL,
    "errorCount" bigint NOT NULL,
    "classifiedCount" bigint NOT NULL,
    "authorId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "cancelledAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "imports_account_idx" ON "imports" USING btree ("accountId");

--
-- Class Invitation as table invitations
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
-- Class InvoiceBlob as table invoice_blobs
--
CREATE TABLE "invoice_blobs" (
    "id" bigserial PRIMARY KEY,
    "invoiceId" bigint NOT NULL,
    "content" bytea NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "invoice_blobs_invoice_idx" ON "invoice_blobs" USING btree ("invoiceId");

--
-- Class Invoice as table invoices
--
CREATE TABLE "invoices" (
    "id" bigserial PRIMARY KEY,
    "groupId" bigint NOT NULL,
    "transactionId" bigint,
    "fileName" text NOT NULL,
    "mimeType" text NOT NULL,
    "sizeBytes" bigint NOT NULL,
    "label" text,
    "warrantyUntil" timestamp without time zone,
    "hintAmountCents" bigint,
    "hintDate" timestamp without time zone,
    "hintMerchant" text,
    "uploadedBy" uuid,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "invoices_group_idx" ON "invoices" USING btree ("groupId", "createdAt");
CREATE INDEX "invoices_transaction_idx" ON "invoices" USING btree ("transactionId");

--
-- Class IpBan as table ip_bans
--
CREATE TABLE "ip_bans" (
    "id" bigserial PRIMARY KEY,
    "ip" text NOT NULL,
    "failures" bigint NOT NULL DEFAULT 0,
    "windowStart" timestamp without time zone NOT NULL,
    "lastFailureAt" timestamp without time zone NOT NULL,
    "lastFailureKind" text NOT NULL,
    "bannedUntil" timestamp without time zone,
    "banCount" bigint NOT NULL DEFAULT 0
);

-- Indexes
CREATE UNIQUE INDEX "ip_bans_ip_idx" ON "ip_bans" USING btree ("ip");

--
-- Class LoanDocumentBlob as table loan_document_blobs
--
CREATE TABLE "loan_document_blobs" (
    "id" bigserial PRIMARY KEY,
    "documentId" bigint NOT NULL,
    "content" bytea NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "loan_document_blobs_doc_idx" ON "loan_document_blobs" USING btree ("documentId");

--
-- Class LoanDocument as table loan_documents
--
CREATE TABLE "loan_documents" (
    "id" bigserial PRIMARY KEY,
    "loanId" bigint NOT NULL,
    "fileName" text NOT NULL,
    "mimeType" text NOT NULL,
    "sizeBytes" bigint NOT NULL,
    "uploadedBy" uuid,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "loan_documents_loan_idx" ON "loan_documents" USING btree ("loanId");

--
-- Class Loan as table loans
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
    "paymentCents" bigint,
    "firstDueDate" timestamp without time zone NOT NULL,
    "insuranceMonthlyCents" bigint NOT NULL DEFAULT 0,
    "feesCents" bigint NOT NULL DEFAULT 0,
    "categoryId" bigint,
    "scheduledId" bigint,
    "matchPattern" text,
    "ruleId" bigint,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "loans_group_idx" ON "loans" USING btree ("groupId");

--
-- Class AppNotification as table notifications
--
CREATE TABLE "notifications" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "groupId" bigint,
    "accountId" bigint,
    "type" text NOT NULL,
    "data" text NOT NULL,
    "dedupKey" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "readAt" timestamp without time zone,
    "emailedAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "notifications_user_key_idx" ON "notifications" USING btree ("authUserId", "dedupKey");
CREATE INDEX "notifications_user_created_idx" ON "notifications" USING btree ("authUserId", "createdAt");

--
-- Class Rule as table rules
--
CREATE TABLE "rules" (
    "id" bigserial PRIMARY KEY,
    "groupId" bigint NOT NULL,
    "categoryId" bigint NOT NULL,
    "matchType" text NOT NULL,
    "pattern" text NOT NULL,
    "direction" text NOT NULL DEFAULT 'any'::text,
    "minAbsCents" bigint,
    "maxAbsCents" bigint,
    "priority" bigint NOT NULL DEFAULT 100,
    "enabled" boolean NOT NULL DEFAULT true,
    "createdBy" uuid,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "rules_group_idx" ON "rules" USING btree ("groupId");

--
-- Class ScheduledTransaction as table scheduled_transactions
--
CREATE TABLE "scheduled_transactions" (
    "id" bigserial PRIMARY KEY,
    "accountId" bigint NOT NULL,
    "amountCents" bigint NOT NULL,
    "label" text NOT NULL,
    "categoryId" bigint,
    "frequency" text NOT NULL,
    "interval" bigint NOT NULL DEFAULT 1,
    "startDate" timestamp without time zone NOT NULL,
    "endDate" timestamp without time zone,
    "occurrenceCount" bigint,
    "nextDue" timestamp without time zone,
    "matchPattern" text NOT NULL DEFAULT ''::text,
    "dateToleranceDays" bigint NOT NULL DEFAULT 5,
    "amountTolerancePercent" bigint NOT NULL DEFAULT 0,
    "subscription" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "scheduled_account_idx" ON "scheduled_transactions" USING btree ("accountId");

--
-- Class BackupCode as table totp_backup_codes
--
CREATE TABLE "totp_backup_codes" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "codeHash" text NOT NULL,
    "usedAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "totp_backup_codes_user_idx" ON "totp_backup_codes" USING btree ("authUserId");

--
-- Class TotpSecret as table totp_secrets
--
CREATE TABLE "totp_secrets" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "secretBox" text NOT NULL,
    "enabled" boolean NOT NULL DEFAULT false,
    "lastUsedStep" bigint,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "enabledAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "totp_secrets_user_idx" ON "totp_secrets" USING btree ("authUserId");

--
-- Class TransactionSplit as table transaction_splits
--
CREATE TABLE "transaction_splits" (
    "id" bigserial PRIMARY KEY,
    "transactionId" bigint NOT NULL,
    "categoryId" bigint,
    "amountCents" bigint NOT NULL,
    "note" text
);

-- Indexes
CREATE INDEX "transaction_splits_tx_idx" ON "transaction_splits" USING btree ("transactionId");
CREATE INDEX "transaction_splits_category_idx" ON "transaction_splits" USING btree ("categoryId");

--
-- Class BankTransaction as table transactions
--
CREATE TABLE "transactions" (
    "id" bigserial PRIMARY KEY,
    "accountId" bigint NOT NULL,
    "date" timestamp without time zone NOT NULL,
    "amountCents" bigint NOT NULL,
    "rawLabel" text NOT NULL,
    "memo" text,
    "note" text,
    "cleanLabel" text NOT NULL,
    "operationKind" text NOT NULL,
    "reference" text,
    "bankId" text,
    "fingerprint" text,
    "trashedFingerprint" text,
    "importId" bigint,
    "categoryId" bigint,
    "categorySource" text NOT NULL DEFAULT 'none'::text,
    "categoryRuleRef" text,
    "cleared" boolean NOT NULL DEFAULT false,
    "scheduledId" bigint,
    "scheduledDueDate" timestamp without time zone,
    "transferPairId" bigint,
    "createdBy" uuid,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "transactions_account_date_idx" ON "transactions" USING btree ("accountId", "date");
CREATE UNIQUE INDEX "transactions_account_fingerprint_idx" ON "transactions" USING btree ("accountId", "fingerprint");
CREATE INDEX "transactions_import_idx" ON "transactions" USING btree ("importId");
CREATE INDEX "transactions_category_idx" ON "transactions" USING btree ("categoryId");

--
-- Class CloudStorageEntry as table serverpod_cloud_storage
--
CREATE TABLE "serverpod_cloud_storage" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "addedTime" timestamp without time zone NOT NULL,
    "expiration" timestamp without time zone,
    "byteData" bytea NOT NULL,
    "verified" boolean NOT NULL,
    "contentType" text,
    "cacheControl" text,
    "contentDisposition" text,
    "contentEncoding" text,
    "customMetadata" text
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_path_idx" ON "serverpod_cloud_storage" USING btree ("storageId", "path");
CREATE INDEX "serverpod_cloud_storage_expiration" ON "serverpod_cloud_storage" USING btree ("expiration");

--
-- Class CloudStorageDirectDownloadEntry as table serverpod_cloud_storage_direct_download
--
CREATE TABLE "serverpod_cloud_storage_direct_download" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "expiration" timestamp without time zone NOT NULL,
    "authKey" text NOT NULL,
    "downloadFileName" text,
    "contentType" text
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_direct_download_auth_key" ON "serverpod_cloud_storage_direct_download" USING btree ("authKey");
CREATE INDEX "serverpod_cloud_storage_direct_download_expiration" ON "serverpod_cloud_storage_direct_download" USING btree ("expiration");

--
-- Class CloudStorageDirectUploadEntry as table serverpod_cloud_storage_direct_upload
--
CREATE TABLE "serverpod_cloud_storage_direct_upload" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "expiration" timestamp without time zone NOT NULL,
    "authKey" text NOT NULL,
    "maxFileSize" bigint NOT NULL DEFAULT 10485760,
    "contentLength" bigint,
    "preventOverwrite" boolean NOT NULL DEFAULT false,
    "contentType" text,
    "cacheControl" text,
    "contentDisposition" text,
    "contentEncoding" text,
    "customMetadata" text
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_direct_upload_storage_path" ON "serverpod_cloud_storage_direct_upload" USING btree ("storageId", "path");

--
-- Class FutureCallEntry as table serverpod_future_call
--
CREATE TABLE "serverpod_future_call" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "serializedObject" text,
    "serverId" text NOT NULL,
    "identifier" text,
    "scheduling" json
);

-- Indexes
CREATE INDEX "serverpod_future_call_time_idx" ON "serverpod_future_call" USING btree ("time");
CREATE INDEX "serverpod_future_call_serverId_idx" ON "serverpod_future_call" USING btree ("serverId");
CREATE INDEX "serverpod_future_call_identifier_idx" ON "serverpod_future_call" USING btree ("identifier");

--
-- Class FutureCallClaimEntry as table serverpod_future_call_claim
--
CREATE TABLE "serverpod_future_call_claim" (
    "id" bigserial PRIMARY KEY,
    "futureCallId" bigint,
    "lastHeartbeatTime" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "future_call_unique_idx" ON "serverpod_future_call_claim" USING btree ("futureCallId");

--
-- Class ServerHealthConnectionInfo as table serverpod_health_connection_info
--
CREATE TABLE "serverpod_health_connection_info" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "active" bigint NOT NULL,
    "closing" bigint NOT NULL,
    "idle" bigint NOT NULL,
    "granularity" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_connection_info_timestamp_idx" ON "serverpod_health_connection_info" USING btree ("timestamp", "serverId", "granularity");

--
-- Class ServerHealthMetric as table serverpod_health_metric
--
CREATE TABLE "serverpod_health_metric" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "isHealthy" boolean NOT NULL,
    "value" double precision NOT NULL,
    "granularity" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_metric_timestamp_idx" ON "serverpod_health_metric" USING btree ("timestamp", "serverId", "name", "granularity");

--
-- Class LogEntry as table serverpod_log
--
CREATE TABLE "serverpod_log" (
    "id" bigserial PRIMARY KEY,
    "sessionLogId" bigint NOT NULL,
    "messageId" bigint,
    "reference" text,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "logLevel" bigint NOT NULL,
    "message" text NOT NULL,
    "error" text,
    "stackTrace" text,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_log_sessionLogId_idx" ON "serverpod_log" USING btree ("sessionLogId", "order");

--
-- Class MessageLogEntry as table serverpod_message_log
--
CREATE TABLE "serverpod_message_log" (
    "id" bigserial PRIMARY KEY,
    "sessionLogId" bigint NOT NULL,
    "serverId" text NOT NULL,
    "messageId" bigint NOT NULL,
    "endpoint" text NOT NULL,
    "messageName" text NOT NULL,
    "duration" double precision NOT NULL,
    "error" text,
    "stackTrace" text,
    "slow" boolean NOT NULL,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_message_log_sessionLogId_idx" ON "serverpod_message_log" USING btree ("sessionLogId", "order");

--
-- Class MethodInfo as table serverpod_method
--
CREATE TABLE "serverpod_method" (
    "id" bigserial PRIMARY KEY,
    "endpoint" text NOT NULL,
    "method" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_method_endpoint_method_idx" ON "serverpod_method" USING btree ("endpoint", "method");

--
-- Class DatabaseMigrationVersion as table serverpod_migrations
--
CREATE TABLE "serverpod_migrations" (
    "id" bigserial PRIMARY KEY,
    "module" text NOT NULL,
    "version" text NOT NULL,
    "timestamp" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_migrations_ids" ON "serverpod_migrations" USING btree ("module");

--
-- Class QueryLogEntry as table serverpod_query_log
--
CREATE TABLE "serverpod_query_log" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "sessionLogId" bigint NOT NULL,
    "messageId" bigint,
    "query" text NOT NULL,
    "duration" double precision NOT NULL,
    "numRows" bigint,
    "error" text,
    "stackTrace" text,
    "slow" boolean NOT NULL,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_query_log_sessionLogId_idx" ON "serverpod_query_log" USING btree ("sessionLogId", "order");

--
-- Class ReadWriteTestEntry as table serverpod_readwrite_test
--
CREATE TABLE "serverpod_readwrite_test" (
    "id" bigserial PRIMARY KEY,
    "number" bigint NOT NULL
);

--
-- Class RuntimeSettings as table serverpod_runtime_settings
--
CREATE TABLE "serverpod_runtime_settings" (
    "id" bigserial PRIMARY KEY,
    "logSettings" json NOT NULL,
    "logSettingsOverrides" json NOT NULL,
    "logServiceCalls" boolean NOT NULL,
    "logMalformedCalls" boolean NOT NULL
);

--
-- Class SessionLogEntry as table serverpod_session_log
--
CREATE TABLE "serverpod_session_log" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "module" text,
    "endpoint" text,
    "method" text,
    "duration" double precision,
    "numQueries" bigint,
    "slow" boolean,
    "error" text,
    "stackTrace" text,
    "authenticatedUserId" bigint,
    "userId" text,
    "isOpen" boolean,
    "touched" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_session_log_serverid_idx" ON "serverpod_session_log" USING btree ("serverId");
CREATE INDEX "serverpod_session_log_time_idx" ON "serverpod_session_log" USING btree ("time");
CREATE INDEX "serverpod_session_log_touched_idx" ON "serverpod_session_log" USING btree ("touched");
CREATE INDEX "serverpod_session_log_isopen_idx" ON "serverpod_session_log" USING btree ("isOpen");

--
-- Class AnonymousAccount as table serverpod_auth_idp_anonymous_account
--
CREATE TABLE "serverpod_auth_idp_anonymous_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- Class AppleAccount as table serverpod_auth_idp_apple_account
--
CREATE TABLE "serverpod_auth_idp_apple_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userIdentifier" text NOT NULL,
    "refreshToken" text NOT NULL,
    "refreshTokenRequestedWithBundleIdentifier" boolean NOT NULL,
    "lastRefreshedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "email" text,
    "isEmailVerified" boolean,
    "isPrivateEmail" boolean,
    "firstName" text,
    "lastName" text
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_apple_account_identifier" ON "serverpod_auth_idp_apple_account" USING btree ("userIdentifier");

--
-- Class EmailAccount as table serverpod_auth_idp_email_account
--
CREATE TABLE "serverpod_auth_idp_email_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "email" text NOT NULL,
    "passwordHash" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_idp_email_account_email" ON "serverpod_auth_idp_email_account" USING btree ("email");

--
-- Class EmailAccountPasswordResetRequest as table serverpod_auth_idp_email_account_password_reset_request
--
CREATE TABLE "serverpod_auth_idp_email_account_password_reset_request" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "emailAccountId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "challengeId" uuid NOT NULL,
    "setPasswordChallengeId" uuid
);

--
-- Class EmailAccountRequest as table serverpod_auth_idp_email_account_request
--
CREATE TABLE "serverpod_auth_idp_email_account_request" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "email" text NOT NULL,
    "challengeId" uuid NOT NULL,
    "createAccountChallengeId" uuid
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_idp_email_account_request_email" ON "serverpod_auth_idp_email_account_request" USING btree ("email");

--
-- Class FacebookAccount as table serverpod_auth_idp_facebook_account
--
CREATE TABLE "serverpod_auth_idp_facebook_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "userIdentifier" text NOT NULL,
    "email" text,
    "fullName" text,
    "firstName" text,
    "lastName" text
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_facebook_account_user_identifier" ON "serverpod_auth_idp_facebook_account" USING btree ("userIdentifier");

--
-- Class FirebaseAccount as table serverpod_auth_idp_firebase_account
--
CREATE TABLE "serverpod_auth_idp_firebase_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "created" timestamp without time zone NOT NULL,
    "email" text,
    "phone" text,
    "userIdentifier" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_firebase_account_user_identifier" ON "serverpod_auth_idp_firebase_account" USING btree ("userIdentifier");

--
-- Class GitHubAccount as table serverpod_auth_idp_github_account
--
CREATE TABLE "serverpod_auth_idp_github_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "userIdentifier" text NOT NULL,
    "email" text,
    "created" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_github_account_user_identifier" ON "serverpod_auth_idp_github_account" USING btree ("userIdentifier");

--
-- Class GoogleAccount as table serverpod_auth_idp_google_account
--
CREATE TABLE "serverpod_auth_idp_google_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "created" timestamp without time zone NOT NULL,
    "email" text NOT NULL,
    "userIdentifier" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_google_account_user_identifier" ON "serverpod_auth_idp_google_account" USING btree ("userIdentifier");

--
-- Class MicrosoftAccount as table serverpod_auth_idp_microsoft_account
--
CREATE TABLE "serverpod_auth_idp_microsoft_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "userIdentifier" text NOT NULL,
    "email" text,
    "created" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_microsoft_account_user_identifier" ON "serverpod_auth_idp_microsoft_account" USING btree ("userIdentifier");

--
-- Class PasskeyAccount as table serverpod_auth_idp_passkey_account
--
CREATE TABLE "serverpod_auth_idp_passkey_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "keyId" bytea NOT NULL,
    "keyIdBase64" text NOT NULL,
    "clientDataJSON" bytea NOT NULL,
    "attestationObject" bytea NOT NULL,
    "originalChallenge" bytea NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_idp_passkey_account_key_id_base64" ON "serverpod_auth_idp_passkey_account" USING btree ("keyIdBase64");

--
-- Class PasskeyChallenge as table serverpod_auth_idp_passkey_challenge
--
CREATE TABLE "serverpod_auth_idp_passkey_challenge" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "createdAt" timestamp without time zone NOT NULL,
    "challenge" bytea NOT NULL
);

--
-- Class RateLimitedRequestAttempt as table serverpod_auth_idp_rate_limited_request_attempt
--
CREATE TABLE "serverpod_auth_idp_rate_limited_request_attempt" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "domain" text NOT NULL,
    "source" text NOT NULL,
    "key" text NOT NULL,
    "ipAddress" text,
    "attemptedAt" timestamp without time zone NOT NULL,
    "extraData" json
);

-- Indexes
CREATE INDEX "serverpod_auth_idp_rate_limited_request_attempt_composite" ON "serverpod_auth_idp_rate_limited_request_attempt" USING btree ("domain", "source", "key", "attemptedAt");

--
-- Class SecretChallenge as table serverpod_auth_idp_secret_challenge
--
CREATE TABLE "serverpod_auth_idp_secret_challenge" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "challengeCodeHash" text NOT NULL
);

--
-- Class RefreshToken as table serverpod_auth_core_jwt_refresh_token
--
CREATE TABLE "serverpod_auth_core_jwt_refresh_token" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "scopeNames" json NOT NULL,
    "extraClaims" text,
    "method" text NOT NULL,
    "fixedSecret" bytea NOT NULL,
    "rotatingSecretHash" text NOT NULL,
    "lastUpdatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "serverpod_auth_core_jwt_refresh_token_last_updated_at" ON "serverpod_auth_core_jwt_refresh_token" USING btree ("lastUpdatedAt");

--
-- Class UserProfile as table serverpod_auth_core_profile
--
CREATE TABLE "serverpod_auth_core_profile" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "userName" text,
    "fullName" text,
    "email" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "imageId" uuid
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_profile_user_profile_email_auth_user_id" ON "serverpod_auth_core_profile" USING btree ("authUserId");

--
-- Class UserProfileImage as table serverpod_auth_core_profile_image
--
CREATE TABLE "serverpod_auth_core_profile_image" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userProfileId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "url" text NOT NULL
);

--
-- Class ServerSideSession as table serverpod_auth_core_session
--
CREATE TABLE "serverpod_auth_core_session" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "scopeNames" json NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastUsedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expiresAt" timestamp without time zone,
    "expireAfterUnusedFor" bigint,
    "sessionKeyHash" bytea NOT NULL,
    "sessionKeySalt" bytea NOT NULL,
    "method" text NOT NULL
);

--
-- Class AuthUser as table serverpod_auth_core_user
--
CREATE TABLE "serverpod_auth_core_user" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "createdAt" timestamp without time zone NOT NULL,
    "scopeNames" json NOT NULL,
    "blocked" boolean NOT NULL
);

--
-- Foreign relations for "account_access" table
--
ALTER TABLE ONLY "account_access"
    ADD CONSTRAINT "account_access_fk_0"
    FOREIGN KEY("accountId")
    REFERENCES "accounts"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "account_access"
    ADD CONSTRAINT "account_access_fk_1"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "accounts" table
--
ALTER TABLE ONLY "accounts"
    ADD CONSTRAINT "accounts_fk_0"
    FOREIGN KEY("groupId")
    REFERENCES "groups"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "action_proposals" table
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
-- Foreign relations for "balance_checks" table
--
ALTER TABLE ONLY "balance_checks"
    ADD CONSTRAINT "balance_checks_fk_0"
    FOREIGN KEY("accountId")
    REFERENCES "accounts"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "categories" table
--
ALTER TABLE ONLY "categories"
    ADD CONSTRAINT "categories_fk_0"
    FOREIGN KEY("groupId")
    REFERENCES "groups"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "categories"
    ADD CONSTRAINT "categories_fk_1"
    FOREIGN KEY("parentId")
    REFERENCES "categories"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- Foreign relations for "goals" table
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
-- Foreign relations for "group_members" table
--
ALTER TABLE ONLY "group_members"
    ADD CONSTRAINT "group_members_fk_0"
    FOREIGN KEY("groupId")
    REFERENCES "groups"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "group_members"
    ADD CONSTRAINT "group_members_fk_1"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "imports" table
--
ALTER TABLE ONLY "imports"
    ADD CONSTRAINT "imports_fk_0"
    FOREIGN KEY("accountId")
    REFERENCES "accounts"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "invitations" table
--
ALTER TABLE ONLY "invitations"
    ADD CONSTRAINT "invitations_fk_0"
    FOREIGN KEY("groupId")
    REFERENCES "groups"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "invoice_blobs" table
--
ALTER TABLE ONLY "invoice_blobs"
    ADD CONSTRAINT "invoice_blobs_fk_0"
    FOREIGN KEY("invoiceId")
    REFERENCES "invoices"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "invoices" table
--
ALTER TABLE ONLY "invoices"
    ADD CONSTRAINT "invoices_fk_0"
    FOREIGN KEY("groupId")
    REFERENCES "groups"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "invoices"
    ADD CONSTRAINT "invoices_fk_1"
    FOREIGN KEY("transactionId")
    REFERENCES "transactions"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "loan_document_blobs" table
--
ALTER TABLE ONLY "loan_document_blobs"
    ADD CONSTRAINT "loan_document_blobs_fk_0"
    FOREIGN KEY("documentId")
    REFERENCES "loan_documents"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "loan_documents" table
--
ALTER TABLE ONLY "loan_documents"
    ADD CONSTRAINT "loan_documents_fk_0"
    FOREIGN KEY("loanId")
    REFERENCES "loans"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "loans" table
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
ALTER TABLE ONLY "loans"
    ADD CONSTRAINT "loans_fk_4"
    FOREIGN KEY("ruleId")
    REFERENCES "rules"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- Foreign relations for "notifications" table
--
ALTER TABLE ONLY "notifications"
    ADD CONSTRAINT "notifications_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "rules" table
--
ALTER TABLE ONLY "rules"
    ADD CONSTRAINT "rules_fk_0"
    FOREIGN KEY("groupId")
    REFERENCES "groups"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "rules"
    ADD CONSTRAINT "rules_fk_1"
    FOREIGN KEY("categoryId")
    REFERENCES "categories"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "scheduled_transactions" table
--
ALTER TABLE ONLY "scheduled_transactions"
    ADD CONSTRAINT "scheduled_transactions_fk_0"
    FOREIGN KEY("accountId")
    REFERENCES "accounts"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "scheduled_transactions"
    ADD CONSTRAINT "scheduled_transactions_fk_1"
    FOREIGN KEY("categoryId")
    REFERENCES "categories"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- Foreign relations for "totp_backup_codes" table
--
ALTER TABLE ONLY "totp_backup_codes"
    ADD CONSTRAINT "totp_backup_codes_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "totp_secrets" table
--
ALTER TABLE ONLY "totp_secrets"
    ADD CONSTRAINT "totp_secrets_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "transaction_splits" table
--
ALTER TABLE ONLY "transaction_splits"
    ADD CONSTRAINT "transaction_splits_fk_0"
    FOREIGN KEY("transactionId")
    REFERENCES "transactions"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "transaction_splits"
    ADD CONSTRAINT "transaction_splits_fk_1"
    FOREIGN KEY("categoryId")
    REFERENCES "categories"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- Foreign relations for "transactions" table
--
ALTER TABLE ONLY "transactions"
    ADD CONSTRAINT "transactions_fk_0"
    FOREIGN KEY("accountId")
    REFERENCES "accounts"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "transactions"
    ADD CONSTRAINT "transactions_fk_1"
    FOREIGN KEY("importId")
    REFERENCES "imports"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "transactions"
    ADD CONSTRAINT "transactions_fk_2"
    FOREIGN KEY("categoryId")
    REFERENCES "categories"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "transactions"
    ADD CONSTRAINT "transactions_fk_3"
    FOREIGN KEY("scheduledId")
    REFERENCES "scheduled_transactions"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_future_call_claim" table
--
ALTER TABLE ONLY "serverpod_future_call_claim"
    ADD CONSTRAINT "serverpod_future_call_claim_fk_0"
    FOREIGN KEY("futureCallId")
    REFERENCES "serverpod_future_call"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_log" table
--
ALTER TABLE ONLY "serverpod_log"
    ADD CONSTRAINT "serverpod_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_message_log" table
--
ALTER TABLE ONLY "serverpod_message_log"
    ADD CONSTRAINT "serverpod_message_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_query_log" table
--
ALTER TABLE ONLY "serverpod_query_log"
    ADD CONSTRAINT "serverpod_query_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_anonymous_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_anonymous_account"
    ADD CONSTRAINT "serverpod_auth_idp_anonymous_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_apple_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_apple_account"
    ADD CONSTRAINT "serverpod_auth_idp_apple_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_email_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_email_account"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_email_account_password_reset_request" table
--
ALTER TABLE ONLY "serverpod_auth_idp_email_account_password_reset_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_password_reset_request_fk_0"
    FOREIGN KEY("emailAccountId")
    REFERENCES "serverpod_auth_idp_email_account"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "serverpod_auth_idp_email_account_password_reset_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_password_reset_request_fk_1"
    FOREIGN KEY("challengeId")
    REFERENCES "serverpod_auth_idp_secret_challenge"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "serverpod_auth_idp_email_account_password_reset_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_password_reset_request_fk_2"
    FOREIGN KEY("setPasswordChallengeId")
    REFERENCES "serverpod_auth_idp_secret_challenge"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_email_account_request" table
--
ALTER TABLE ONLY "serverpod_auth_idp_email_account_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_request_fk_0"
    FOREIGN KEY("challengeId")
    REFERENCES "serverpod_auth_idp_secret_challenge"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "serverpod_auth_idp_email_account_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_request_fk_1"
    FOREIGN KEY("createAccountChallengeId")
    REFERENCES "serverpod_auth_idp_secret_challenge"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_facebook_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_facebook_account"
    ADD CONSTRAINT "serverpod_auth_idp_facebook_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_firebase_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_firebase_account"
    ADD CONSTRAINT "serverpod_auth_idp_firebase_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_github_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_github_account"
    ADD CONSTRAINT "serverpod_auth_idp_github_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_google_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_google_account"
    ADD CONSTRAINT "serverpod_auth_idp_google_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_microsoft_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_microsoft_account"
    ADD CONSTRAINT "serverpod_auth_idp_microsoft_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_passkey_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_passkey_account"
    ADD CONSTRAINT "serverpod_auth_idp_passkey_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_core_jwt_refresh_token" table
--
ALTER TABLE ONLY "serverpod_auth_core_jwt_refresh_token"
    ADD CONSTRAINT "serverpod_auth_core_jwt_refresh_token_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_core_profile" table
--
ALTER TABLE ONLY "serverpod_auth_core_profile"
    ADD CONSTRAINT "serverpod_auth_core_profile_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "serverpod_auth_core_profile"
    ADD CONSTRAINT "serverpod_auth_core_profile_fk_1"
    FOREIGN KEY("imageId")
    REFERENCES "serverpod_auth_core_profile_image"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    DEFERRABLE INITIALLY DEFERRED;

--
-- Foreign relations for "serverpod_auth_core_profile_image" table
--
ALTER TABLE ONLY "serverpod_auth_core_profile_image"
    ADD CONSTRAINT "serverpod_auth_core_profile_image_fk_0"
    FOREIGN KEY("userProfileId")
    REFERENCES "serverpod_auth_core_profile"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_core_session" table
--
ALTER TABLE ONLY "serverpod_auth_core_session"
    ADD CONSTRAINT "serverpod_auth_core_session_fk_0"
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
