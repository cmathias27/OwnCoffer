# Importing statements

OwnCoffer does not connect to your bank: you download the statement from its website yourself, then give it to OwnCoffer.

## Formats

- **OFX** (recommended): holds the bank's balance, which can be compared, and recognises the account by itself.
- **QIF** and **CSV**: Caisse d'Épargne's CSV is recognised; for another CSV, you choose the columns (date, label, amount).

## Import

1. Choose the file, then the account if it is not recognised.
2. Read the **preview**: the new operations, the **duplicates left out** (already imported, even from another format), and the **possible duplicates** to tick if they really are different operations.
3. Save. The operations are classified at once by your rules, the common rules and your history.

You can import a statement that overlaps the previous one: what is already there is recognised and not counted twice.

## Several files at once

**"Several files"**: choose several statements (several months, several accounts). Each is read first; the account is recognised when the file says so (OFX), otherwise it is the one chosen, which can be changed file by file. Possible duplicates are left out: to check them one by one, import the file alone. A CSV whose columns are not recognised is imported alone.

## Cancel an import

**"Previous imports"** lists the files imported for an account; **"Cancel this import"** moves the operations it added to the trash. Your corrections on those operations are then lost.

## Privacy

The account number found in an OFX file is used to recognise the account; it is not stored.
