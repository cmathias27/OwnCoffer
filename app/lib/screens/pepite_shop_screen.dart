import 'package:flutter/material.dart';
import 'package:owncoffer_shared/owncoffer_shared.dart' as core;

import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../state/pepite.dart';
import '../state/pepite_messages.dart';
import '../widgets/pepite.dart';

/// The name and the line of an item of the shop.
(String, String) pepiteItemText(AppLocalizations l, String code) =>
    switch (code) {
      'scarf' => (l.pepiteItemScarf, l.pepiteItemScarfHelp),
      'glasses' => (l.pepiteItemGlasses, l.pepiteItemGlassesHelp),
      'beanie' => (l.pepiteItemBeanie, l.pepiteItemBeanieHelp),
      'cap' => (l.pepiteItemCap, l.pepiteItemCapHelp),
      'bowtie' => (l.pepiteItemBowtie, l.pepiteItemBowtieHelp),
      'flower' => (l.pepiteItemFlower, l.pepiteItemFlowerHelp),
      'backpack' => (l.pepiteItemBackpack, l.pepiteItemBackpackHelp),
      'cushion' => (l.pepiteItemCushion, l.pepiteItemCushionHelp),
      'sunflower' => (l.pepiteItemSunflower, l.pepiteItemSunflowerHelp),
      'wheel' => (l.pepiteItemWheel, l.pepiteItemWheelHelp),
      'hut' => (l.pepiteItemHut, l.pepiteItemHutHelp),
      'lantern' => (l.pepiteItemLantern, l.pepiteItemLanternHelp),
      'mat' => (l.pepiteItemMat, l.pepiteItemMatHelp),
      _ => (code, ''),
    };

/// Pépite's shop (decision 0028, points 4 and 5): the seeds left to spend
/// buy accessories, worn one at a time, and items for the burrow. Items of
/// the apps are bought in the Android or Windows app, and shown everywhere.
class PepiteShopScreen extends StatefulWidget {
  final Pepite? controller;

  const PepiteShopScreen({super.key, this.controller});

  @override
  State<PepiteShopScreen> createState() => _PepiteShopScreenState();
}

class _PepiteShopScreenState extends State<PepiteShopScreen> {
  Pepite get _p => widget.controller ?? pepite;

  /// The accessory tried on, before buying.
  String? _trying;
  var _busy = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.pepiteShopTitle)),
      body: ListenableBuilder(
        listenable: _p,
        builder: (context, _) {
          final s = _p.status;
          if (s == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: PepiteBurrow(
                  PepitePose.happy,
                  controller: _p,
                  wear: _trying,
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  l.pepiteShopToSpend(_p.seedsToSpend),
                  style: theme.textTheme.titleMedium,
                ),
              ),
              Center(
                child: Text(
                  l.pepiteShopEarned(s.seeds),
                  style: theme.textTheme.bodySmall,
                ),
              ),
              const SizedBox(height: 12),
              Text(l.pepiteShopIntro),
              const SizedBox(height: 24),
              ..._section(
                context,
                l,
                l.pepiteShopAccessories,
                l.pepiteShopAccessoriesHelp,
                core.PepiteItemCategory.accessory,
              ),
              const SizedBox(height: 24),
              ..._section(
                context,
                l,
                l.pepiteShopBurrow,
                l.pepiteShopBurrowHelp,
                core.PepiteItemCategory.burrow,
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _section(
    BuildContext context,
    AppLocalizations l,
    String title,
    String help,
    core.PepiteItemCategory category,
  ) {
    final theme = Theme.of(context);
    return [
      Text(title, style: theme.textTheme.titleMedium),
      Text(help, style: theme.textTheme.bodySmall),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final item in core.pepiteItemsByCategory(category))
            _item(context, l, item),
        ],
      ),
    ];
  }

  Widget _item(
    BuildContext context,
    AppLocalizations l,
    core.PepiteShopItem i,
  ) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final (name, help) = pepiteItemText(l, i.code);
    final owned = _p.owns(i.code);
    final worn = _p.wears(i.code);
    final accessory = i.category == core.PepiteItemCategory.accessory;
    final appsOnly = i.requiresApp && _p.browser && !owned;
    final missing = i.price - _p.seedsToSpend;
    final Widget action;
    if (owned) {
      action = worn
          ? OutlinedButton(
              onPressed: _busy ? null : () => _equip(context, i.code, false),
              child: Text(accessory ? l.pepiteShopTakeOff : l.pepiteShopStore),
            )
          : FilledButton.tonal(
              onPressed: _busy ? null : () => _equip(context, i.code, true),
              child: Text(accessory ? l.pepiteShopWear : l.pepiteShopPlace),
            );
    } else {
      action = FilledButton(
        onPressed: _busy || appsOnly || missing > 0
            ? null
            : () => _buy(context, l, i, name),
        child: Text(l.pepiteShopBuy),
      );
    }
    final preview = accessory
        ? PepiteImage(
            PepitePose.happy,
            size: 64,
            wear: i.code,
            controller: _p,
          )
        : PepiteItemImage(i.code);
    return SizedBox(
      width: 168,
      child: Card(
        color: worn ? const Color(0xFFE9A04B).withValues(alpha: 0.18) : null,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              accessory && !owned
                  ? InkWell(
                      onTap: () => setState(
                        () => _trying = _trying == i.code ? null : i.code,
                      ),
                      child: preview,
                    )
                  : preview,
              const SizedBox(height: 4),
              Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                help,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 6),
              if (owned)
                Text(
                  l.pepiteShopOwned,
                  style: TextStyle(color: scheme.primary),
                )
              else
                PepiteSeeds(i.price),
              if (!owned && missing > 0 && !appsOnly)
                Text(
                  l.pepiteShopMissing(missing),
                  style: theme.textTheme.bodySmall,
                ),
              if (appsOnly)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    l.pepiteShopAppsOnly,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.outline,
                    ),
                  ),
                ),
              const SizedBox(height: 6),
              action,
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _buy(
    BuildContext context,
    AppLocalizations l,
    core.PepiteShopItem i,
    String name,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(
          l.pepiteShopBuyConfirm(name, i.price, _p.seedsToSpend - i.price),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l.pepiteShopBuy),
          ),
        ],
      ),
    );
    if (ok != true) return;
    setState(() => _busy = true);
    try {
      await _p.buyItem(i.code);
      if (_trying == i.code) _trying = null;
      messenger.showSnackBar(SnackBar(content: Text(l.pepiteShopBought(name))));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(errorText(l, e))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _equip(BuildContext context, String code, bool on) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    try {
      await _p.equipItem(code, on);
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(errorText(l, e))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}
