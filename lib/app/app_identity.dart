abstract final class AppIdentity {
  static const name = 'UI Templates';
  static const privacyPolicyUrl = String.fromEnvironment(
    'PRIVACY_POLICY_URL',
    defaultValue: 'https://example.com/privacy',
  );
  static const supportUrl = String.fromEnvironment('SUPPORT_URL', defaultValue: 'https://example.com');
  static const supportEmail = String.fromEnvironment('SUPPORT_EMAIL', defaultValue: 'support@example.com');
  static const sourceUrl = 'https://github.com/nohli/flutter_templates';
  static final privacyPolicyUri = Uri.parse(privacyPolicyUrl);
  static final supportUri = Uri.parse(supportUrl);
  static final sourceUri = Uri.parse(sourceUrl);
}
