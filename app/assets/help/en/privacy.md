# Your data

## It stays at home

- OwnCoffer runs on **your server**. Your statements, operations, invoices and documents are stored there, and nowhere else.
- It **never connects to your bank**: you give it the statements yourself.
- **No telemetry**: OwnCoffer sends nothing to anyone unless you ask.
- On a phone, the installed app does not keep your financial data in cache. Neither do the Windows and Android apps: they keep only your server's address and your session.

## When something leaves the server

- **Emails** for alerts, invitations or invoices, if sending is set up.
- **"Search this label on Google"** opens a web search with the cleaned label only.
- **The AI assistant**, only if you turn it on: with an online provider, your questions and the useful figures are sent to it, and the documents you have it read (after your agreement), which is shown with each answer. With Ollama on your network, nothing leaves.

## Backups

The server backs up the database every night, **encrypted**, and checks right away that it restores. In standalone mode (Windows, Android), turn on "Device backups": one encrypted backup a day in the folder you choose. Remember to copy one elsewhere: a backup on the same disk does not protect against that disk failing.

## Take your data with you

**"Export my data"** (account menu, or the icon at the top on a large screen) downloads everything you can see: a complete **JSON** file, or your operations as **CSV** for a spreadsheet. The file is made by your server and goes only to your device.

## Free software

OwnCoffer is free software (AGPL-3.0) and free of charge: its code is public and can be checked.
