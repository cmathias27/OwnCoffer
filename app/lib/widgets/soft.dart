import 'package:flutter/material.dart';

/// The soft look of OwnCoffer: sheets floating above the page, rounded on
/// every side, content grouped in rounded tonal cards, actions as tiles
/// with an icon and their name.

/// Opens [builder] in a sheet floating above the page. With [scroll], the
/// sheet can be resized by dragging and its content scrolls with the
/// controller given to [builder]; otherwise it takes its content's height.
Future<T?> showSoftSheet<T>(
  BuildContext context, {
  required Widget Function(BuildContext context, ScrollController? scroll)
  builder,
  bool scroll = false,
  double initialSize = 0.7,
}) => showModalBottomSheet<T>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  backgroundColor: Colors.transparent,
  elevation: 0,
  builder: (context) => scroll
      ? DraggableScrollableSheet(
          expand: false,
          initialChildSize: initialSize,
          minChildSize: 0.3,
          maxChildSize: 1,
          builder: (context, controller) => SoftFrame(
            child: Column(
              children: [
                const SoftHandle(),
                Expanded(child: builder(context, controller)),
              ],
            ),
          ),
        )
      : SoftFrame(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SoftHandle(),
              Flexible(child: builder(context, null)),
            ],
          ),
        ),
);

/// The floating card of a sheet: a margin from the screen's edges, every
/// corner rounded.
class SoftFrame extends StatelessWidget {
  final Widget child;
  const SoftFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(
      8,
      0,
      8,
      8 + MediaQuery.of(context).padding.bottom,
    ),
    child: Material(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      elevation: 6,
      shadowColor: Colors.black38,
      borderRadius: BorderRadius.circular(32),
      clipBehavior: Clip.antiAlias,
      child: child,
    ),
  );
}

/// The small bar on top of a sheet, telling it can be dragged.
class SoftHandle extends StatelessWidget {
  const SoftHandle({super.key});

  @override
  Widget build(BuildContext context) => Center(
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      width: 36,
      height: 4,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(2),
      ),
    ),
  );
}

/// One group of a page or sheet: a rounded tonal card with a small title.
/// A Material, not a coloured box, so that the rows' ink shows.
class SoftSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Widget> children;

  const SoftSection({
    super.key,
    required this.icon,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Material(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(icon, size: 18, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(title, style: theme.textTheme.titleSmall),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}

/// An action as a tile: a round icon above its name, easy to spot and to
/// touch on a phone.
class ActionTile extends StatelessWidget {
  final Widget icon;
  final Widget label;
  final VoidCallback? onPressed;

  const ActionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return SizedBox(
      width: 108,
      child: Material(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 10),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: scheme.primaryContainer,
                  ),
                  child: IconTheme.merge(
                    data: IconThemeData(
                      size: 22,
                      color: scheme.onPrimaryContainer,
                    ),
                    child: icon,
                  ),
                ),
                const SizedBox(height: 8),
                DefaultTextStyle.merge(
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium,
                  child: label,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
