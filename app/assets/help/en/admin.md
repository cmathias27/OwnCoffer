# Server administration

This page is only visible to the **server administrator**. It never shows a household's financial data.

## The tabs

- **Health and figures**: version, uptime, database, disk space, email sending (with a test email), server figures and automatic classification rate.
- **Users**: accounts, households and roles. An account can be **blocked**: it is signed out and can no longer sign in, nothing is deleted.
- **Invitations**: all pending invitations, to revoke; invite into any household.
- **Blocked IPs** after too many failed sign-ins, to unblock.
- **Log** of the latest sensitive actions: who, what, when.
- **Backups**: nightly backup, "Back up now", list. Restoring is done on the server only: backups hold all the bank data.
- **Updates**: running version, latest published, automatic updates or not. Installing backs up first and rolls back if the new version does not start.
- **AI**: the AI providers offered to the users.

## Add an AI provider

Choose **Google Gemini**, **OpenAI ChatGPT** or **Anthropic Claude** and paste the API key: the list of models is asked to the provider, which also checks the key. For **Ollama**, enter the machine's address. The key is encrypted and never shown again. A monthly cap of requests per user can be set.
