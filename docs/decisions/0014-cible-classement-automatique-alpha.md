# 0014 — Cible de classement automatique pour l'alpha : 70 %

**Statut** : Décidé (30 octobre 2026)

## Contexte

La validation de la phase 3 exige d'atteindre une « cible de classement automatique ». Sans chiffre, impossible de savoir si le classement par règles (sans IA, décision 0006) est assez bon pour un usage quotidien.

## Décision

À la fin de la phase 3, **au moins 70 % des opérations importées sont classées sans intervention** de l'utilisateur.

- **Mesure** : sur les relevés Caisse d'Épargne anonymisés (un à trois mois), part des opérations qui reçoivent une catégorie dès l'import, par les règles du groupe, les règles communautaires ou l'historique — **IA désactivée**.
- **Point de départ** : un groupe sans règle personnelle ni historique, pour mesurer l'apport des règles communautaires seules ; le chiffre avec règles et historique accumulés est relevé en complément.
- Une opération classée puis corrigée par l'utilisateur ne compte pas comme classée automatiquement.

## Conséquences

- Le taux est calculé par un test automatique sur les fixtures anonymisées et affiché dans le bilan d'import.
- Si la cible n'est pas atteinte, on enrichit d'abord les règles communautaires v0 avant d'élargir le périmètre.
- La cible sera revue après le mois d'usage de l'alpha (issue #20), avec les vrais relevés.
