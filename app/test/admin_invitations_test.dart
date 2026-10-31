import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/widgets/admin_invitations.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

void main() {
  testWidgets('invitations of every group, groups, invite dialog', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(380, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final groups = [
      AdminGroupInfo(id: 1, name: 'Maison', members: 3, accounts: 2),
      AdminGroupInfo(id: 2, name: 'Voisins', members: 1, accounts: 0),
    ];
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('fr'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: AdminInvitationsView(
            groups: groups,
            onChanged: () {},
            invitations: [
              AdminInvitationInfo(
                id: 7,
                groupId: 2,
                groupName: 'Voisins',
                email: 'eve@example.org',
                role: MemberRole.admin,
                serverAdmin: false,
                createdAt: DateTime.utc(2026, 10, 31),
                expiresAt: DateTime.utc(2026, 11, 7),
                invitedBy: 'admin@example.org',
              ),
            ],
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.text('eve@example.org'), findsOneWidget);
    expect(find.textContaining('Voisins (Administrateur)'), findsOneWidget);
    expect(
      find.textContaining('envoyée par admin@example.org'),
      findsOneWidget,
    );
    expect(find.textContaining('3 membre(s)'), findsOneWidget);
    await tester.tap(find.text('Inviter'));
    await tester.pumpAndSettle();
    expect(find.text('Inviter une personne'), findsOneWidget);
    expect(find.text('Maison'), findsWidgets);
  });
}
