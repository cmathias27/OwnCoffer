import 'package:flutter/material.dart';

/// Indigo main colour (docs/MAQUETTES.md).
const brandColor = Color(0xFF3346C8);

/// The reduced palette of the figures (decision 0041, point 10): green for
/// money coming in or what is fine, red for what goes wrong, grey for the
/// explanations. Read with `context.money…`; light, dark and high contrast
/// values are checked against their background.
@immutable
class MoneyColors extends ThemeExtension<MoneyColors> {
  final Color positive;
  final Color negative;
  final Color muted;

  const MoneyColors({
    required this.positive,
    required this.negative,
    required this.muted,
  });

  static MoneyColors of(Brightness b, {bool highContrast = false}) =>
      b == Brightness.dark
      ? MoneyColors(
          positive: highContrast
              ? const Color(0xFFA6F2B1)
              : const Color(0xFF7BD88F),
          negative: highContrast
              ? const Color(0xFFFFC2BC)
              : const Color(0xFFFF8A80),
          muted: highContrast
              ? const Color(0xFFE0E0E6)
              : const Color(0xFFB4B4BE),
        )
      : MoneyColors(
          positive: highContrast
              ? const Color(0xFF0B4F1F)
              : const Color(0xFF1B7A35),
          negative: highContrast
              ? const Color(0xFF8C0E0E)
              : const Color(0xFFC62828),
          muted: highContrast
              ? const Color(0xFF2E2E36)
              : const Color(0xFF5F5F6B),
        );

  @override
  MoneyColors copyWith({Color? positive, Color? negative, Color? muted}) =>
      MoneyColors(
        positive: positive ?? this.positive,
        negative: negative ?? this.negative,
        muted: muted ?? this.muted,
      );

  @override
  MoneyColors lerp(MoneyColors? other, double t) => other == null
      ? this
      : MoneyColors(
          positive: Color.lerp(positive, other.positive, t)!,
          negative: Color.lerp(negative, other.negative, t)!,
          muted: Color.lerp(muted, other.muted, t)!,
        );
}

extension MoneyColorsOf on BuildContext {
  MoneyColors get moneyColors =>
      Theme.of(this).extension<MoneyColors>() ??
      MoneyColors.of(Theme.of(this).brightness);
}

/// The app's theme; [highContrast] raises the contrast of every colour
/// (decision 0041, point 18).
ThemeData buildAppTheme(Brightness brightness, {bool highContrast = false}) {
  final base = ThemeData(
    // `fidelity` keeps the brand indigo instead of a desaturated tone.
    colorScheme: ColorScheme.fromSeed(
      seedColor: brandColor,
      brightness: brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
      contrastLevel: highContrast ? 1.0 : 0.0,
    ),
    fontFamily: 'Inter',
  );
  final scheme = base.colorScheme;
  final soft = BorderRadius.circular(16);
  // Amounts line up in columns: tabular figures everywhere.
  const tabular = [FontFeature.tabularFigures()];
  TextStyle? figures(TextStyle? s, {bool title = false}) => s?.copyWith(
    fontFamily: title ? 'Manrope' : null,
    fontFeatures: tabular,
  );
  final t = base.textTheme;
  // Titles and figures in Manrope, text in Inter (docs/MAQUETTES.md). The
  // soft look: round cards without hard shadow, round dialogs, filled
  // fields, pill chips, floating messages.
  return base.copyWith(
    extensions: [MoneyColors.of(brightness, highContrast: highContrast)],
    cardTheme: CardThemeData(
      elevation: 0,
      color: scheme.surfaceContainer,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: highContrast
            ? BorderSide(color: scheme.outline)
            : BorderSide.none,
      ),
    ),
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
    ),
    chipTheme: base.chipTheme.copyWith(shape: const StadiumBorder()),
    listTileTheme: ListTileThemeData(
      shape: RoundedRectangleBorder(borderRadius: soft),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: soft),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
      border: OutlineInputBorder(
        borderRadius: soft,
        borderSide: highContrast
            ? BorderSide(color: scheme.outline)
            : BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: soft,
        borderSide: highContrast
            ? BorderSide(color: scheme.outline)
            : BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: soft,
        borderSide: BorderSide(color: scheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: soft,
        borderSide: BorderSide(color: scheme.error),
      ),
    ),
    textTheme: t.copyWith(
      displayLarge: figures(t.displayLarge, title: true),
      displayMedium: figures(t.displayMedium, title: true),
      displaySmall: figures(t.displaySmall, title: true),
      headlineLarge: figures(t.headlineLarge, title: true),
      headlineMedium: figures(t.headlineMedium, title: true),
      headlineSmall: figures(t.headlineSmall, title: true),
      titleLarge: figures(t.titleLarge, title: true),
      titleMedium: figures(t.titleMedium),
      titleSmall: figures(t.titleSmall),
      bodyLarge: figures(t.bodyLarge),
      bodyMedium: figures(t.bodyMedium),
      bodySmall: figures(t.bodySmall),
      labelLarge: figures(t.labelLarge),
      labelMedium: figures(t.labelMedium),
      labelSmall: figures(t.labelSmall),
    ),
  );
}
