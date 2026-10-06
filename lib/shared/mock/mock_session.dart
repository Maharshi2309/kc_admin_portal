import 'package:kc_admin_portal/shared/models/organization_model.dart';

/// DEV ONLY (`USE_MOCK_API=true`): the server side of the session in the dev
/// mock: who is signed in, and to which organization. Like the real backend
/// (docs/ARCHITECTURE_MULTI_ORG.md §C), the organization comes from the
/// session, never from the request.
class MockSession {
  MockSession({
    this.userId = defaultUserId,
    this.organizationId = defaultOrganizationId,
  });

  /// Signed in before the dev login runs (and in tests that skip it): the
  /// dev admin, in Keshav Clothing.
  static const String defaultUserId = 'u1';
  static const String defaultOrganizationId = keshavId;

  static const String keshavId = 'org-keshav';
  static const String sunriseId = 'org-sunrise';

  /// The sample organizations (seeded into [MockDirectory]). Keshav
  /// Clothing holds the original sample data; Sunrise Garments is a second,
  /// separate company, so the app is always tried against two isolated
  /// organizations.
  static const List<OrganizationModel> sampleOrganizations = [
    OrganizationModel(
      id: keshavId,
      name: 'Keshav Clothing',
      // The bundled KC logo stands in for the uploaded one.
      logoUrl: 'asset:assets/brand/kc_logo.png',
      timezone: 'Asia/Kolkata',
    ),
    OrganizationModel(
      id: sunriseId,
      name: 'Sunrise Garments',
      timezone: 'Asia/Kolkata',
    ),
  ];

  /// The signed-in user; null when signed out.
  String? userId;

  /// The organization the session works in; null when signed out, and for
  /// a new account that hasn't created or joined one yet.
  String? organizationId;

  /// Signed in and working in an organization.
  bool get isSignedIn => userId != null && organizationId != null;

  void start(String userId, String? organizationId) {
    this.userId = userId;
    this.organizationId = organizationId;
  }

  void end() {
    userId = null;
    organizationId = null;
  }
}
