/// Caisse d'Épargne specifics (decision 0003). Everything that only applies
/// to this bank lives here, so other banks can be added as separate modules.
///
/// To check against real (anonymised) exports before the alpha: label
/// prefixes below are based on publicly documented label formats.
library;

import '../labels/label_cleaner.dart';

final BankLabelProfile caisseEpargneProfile = BankLabelProfile(
  prefixes: [
    ...genericFrenchProfile.prefixes,
    const LabelPrefix('PRLV EUROPEEN', OperationKind.directDebit),
    const LabelPrefix('PRELEVEMENT EUROPEEN', OperationKind.directDebit),
    const LabelPrefix('VIR EUROPEEN EMIS', OperationKind.transferOut),
    const LabelPrefix('VIR EUROPEEN RECU', OperationKind.transferIn),
    const LabelPrefix('VIR EUROPEEN', OperationKind.transfer),
    const LabelPrefix('VIREMENT INSTANTANE EMIS', OperationKind.transferOut),
    const LabelPrefix('VIREMENT INSTANTANE RECU', OperationKind.transferIn),
    const LabelPrefix('RETRAIT DAB ETRANGER', OperationKind.withdrawal),
    const LabelPrefix('COTIS', OperationKind.fee),
    const LabelPrefix('F COTIS', OperationKind.fee),
    const LabelPrefix('ECH PRET CAP IN', OperationKind.loan),
    const LabelPrefix('REMBOURSEMENT PRET', OperationKind.loan),
    const LabelPrefix('FORMULE', OperationKind.fee),
    const LabelPrefix('OFFRE', OperationKind.fee),
    const LabelPrefix('REM OFFRE', OperationKind.fee),
    const LabelPrefix('MIN FORFAIT', OperationKind.fee),
    const LabelPrefix('COM', OperationKind.fee),
  ],
  noise: genericFrenchProfile.noise,
  cutMarkers: genericFrenchProfile.cutMarkers,
);

/// Cleans a Caisse d'Épargne label.
CleanedLabel cleanCaisseEpargneLabel(String raw) =>
    cleanLabel(raw, profile: caisseEpargneProfile);
