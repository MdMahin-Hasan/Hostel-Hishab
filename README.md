# HostelHisab (Flutter + Provider)

## Run
1. `flutter create hostel_hisab`   (use package name `hostel_hisab`)
2. Delete the generated `lib/` and `test/widget_test.dart`
3. Copy this `lib/` and `test/` into the project
4. `flutter pub add provider google_fonts`
5. `flutter run`  - login with any phone + a password of 4+ characters

## Folder structure (data / domain / presentation)
lib/
  main.dart
  app/            app.dart, routes.dart, app_providers.dart (all wiring)
  core/           theme, utils, errors, base (BaseProvider), shared widgets
  features/<name>/        auth, members, meals, finance, ...
    domain/               PURE Dart - the business. Imports nothing from data/presentation
      entities/           Member, TxItem, FinanceSummary
      repositories/       abstract contracts (what the app needs)
      usecases/           one class per action: AddDeposit, CalculateSummary ...
    data/                 talks to the outside world (mock now, Node.js later)
      models/             Entity + fromJson/toJson (MemberModel, TxModel)
      datasources/        abstract + Mock*DataSource (JSON maps, like your API)
      repositories/       *RepositoryImpl: JSON -> models -> entities
    presentation/
      providers/          ChangeNotifier: calls usecases, holds UI state
      screens/ widgets/

## Data flow
Screen -> Provider -> UseCase -> Repository (abstract) -> RepositoryImpl -> DataSource -> (Mock | Node API)
Dependencies point INWARD: presentation and data both depend on domain; domain depends on nothing.

## Where does my code go?
- Calculation or business rule        -> domain/usecases
- "What does the app need?" contract  -> domain/repositories
- JSON <-> object conversion          -> data/models
- HTTP / mock data                    -> data/datasources
- Loading flags, filters, UI state    -> presentation/providers
- Widgets                             -> presentation/screens|widgets

## Add a new feature (checklist, e.g. bazar)
1. domain/entities/bazar_item.dart
2. domain/repositories/bazar_repository.dart (abstract)
3. domain/usecases/get_bazar_items.dart, add_bazar_item.dart
4. data/models/bazar_model.dart (fromJson/toJson)
5. data/datasources/bazar_remote_datasource.dart + mock_bazar_datasource.dart
6. data/repositories/bazar_repository_impl.dart
7. presentation/providers/bazar_provider.dart (extends BaseProvider)
8. presentation/screens/bazar_screen.dart
9. register in app/app_providers.dart and app/routes.dart

## Rule: a feature may import core/, never another feature's presentation/.

## Connect Node.js later
1. Add `core/network/api_client.dart` (dio/http, base URL, JWT header)
2. Write `ApiMembersDataSource implements MembersRemoteDataSource` (returns the same JSON maps)
3. In `app/app_providers.dart` change `MockMembersDataSource()` to `ApiMembersDataSource(...)`
Models, repositories, usecases, providers and screens do not change.

## Practice (build these yourself, copy the members feature)
1. Bazar screen  2. Reports screen  3. Notifications screen
4. Member detail  5. Manager approve/reject for pending deposits

## Production checklist
- Bundle the Bangla font as an asset instead of google_fonts download
- Money as int (done). Never double.
- Store JWT with flutter_secure_storage
- Add flavors (dev/prod) and a real error logger when you go live
- Keep writing tests: usecases (test/usecases_test.dart) and providers (test/finance_provider_test.dart)
