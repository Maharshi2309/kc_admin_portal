import 'package:kc_admin_portal/features/organization/data/models/organization_models.dart';
import 'package:kc_admin_portal/shared/mock/mock_catalogs.dart';
import 'package:kc_admin_portal/shared/mock/mock_session.dart';
import 'package:kc_admin_portal/shared/models/named_ref.dart';

/// Keshav Clothing's sample department [name], e.g. `dept('Tailor')`.
NamedRef dept(String name) =>
    MockCatalogs.ref(MockSession.keshavId, CatalogKind.departments, name);

/// Keshav Clothing's sample position [name].
NamedRef post(String name) =>
    MockCatalogs.ref(MockSession.keshavId, CatalogKind.positions, name);
