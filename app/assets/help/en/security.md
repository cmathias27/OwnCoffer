# Security

## Two-factor authentication

Turn it on: on top of the password, a 6-digit code given by an authenticator app (Aegis, Google Authenticator, 1Password…) is asked at sign-in.

1. Scan the QR code with the app.
2. Enter the code shown to confirm.
3. **Keep the backup codes** somewhere safe: they help if you lose your phone. Each one works only once.

## Automatic lock

Off at first: turn it on in **Security**. After some time without use (15 minutes by default, or 5, 30, 60), the app locks: the screen is hidden, but the session stays open and whatever was running goes on.

- **Unlock**: your password, or on Android the fingerprint (or phone PIN), on Windows Windows Hello, if you chose it. It is offered after the first unlock with the password.
- **Lock now**: a button in the menu, to leave at once.
- After **5 wrong passwords** or **8 hours** locked, the app signs out: sign in again with password and two-factor code.
- Standalone version: only the device's lock unlocks it, so a PIN or fingerprint must be set up on the device.
- **Hide the screen when in the background** (option): hides the content in the list of open apps; on Android, also blocks screenshots.

The settings apply to this device only. After 30 days without use, a device has to sign in again.

## My sessions
Every device or browser where you are signed in: Android app, Windows app or browser, its version, the IP address, since when and the last activity.
- **Close** a session you do not recognise: the device is signed out within 30 seconds. Then change your password.
- **Close all the others**: only this device stays signed in.
- **Rename** a device ("Lea's phone") to recognise it.
- These details are kept 30 days after the session ends, then erased; they are part of your export. The server administrator sees your sessions with the IP address masked and can close them; you are told by a notification.
- Standalone version: one device only, nothing is shown.

## What OwnCoffer does for you

- An IP address that fails to sign in too often is **blocked automatically**.
- Every request checks your household, your role and the accounts you may see.
- Sensitive actions are written to a log.

## Good habits

- A password you use nowhere else.
- Sign out on a shared device.
