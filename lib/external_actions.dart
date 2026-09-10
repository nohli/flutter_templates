import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_identity.dart';

typedef ExternalUriLauncher = Future<bool> Function(Uri uri);
typedef TextSharer = Future<void> Function(String text, Rect origin);

Future<bool> launchExternalUri(Uri uri) => launchUrl(uri);

Future<void> shareText(String text, Rect origin) async {
  await SharePlus.instance.share(ShareParams(text: text, title: AppIdentity.name, sharePositionOrigin: origin));
}

Uri appEmailUri({required String subject, String? body}) {
  final parameters = <String, String>{'subject': subject, 'body': ?body};
  final query = parameters.entries
      .map((MapEntry<String, String> entry) => '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value)}')
      .join('&');

  return Uri(scheme: 'mailto', path: AppIdentity.supportEmail, query: query);
}

Uri supportEmailUri() => appEmailUri(subject: '${AppIdentity.name} support');

final developerPortfolioUri = AppIdentity.supportUri;

const inviteText = 'Explore ${AppIdentity.name} at ${AppIdentity.sourceUrl}';
