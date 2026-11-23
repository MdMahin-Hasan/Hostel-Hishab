import 'package:hostel_hisab/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:hostel_hisab/features/auth/data/datasources/mock_auth_datasource.dart';
import 'package:hostel_hisab/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:hostel_hisab/features/auth/domain/repositories/auth_repository.dart';
import 'package:hostel_hisab/features/auth/domain/usecases/login_usecase.dart';
import 'package:hostel_hisab/features/auth/domain/usecases/logout_usecase.dart';
import 'package:hostel_hisab/features/auth/presentation/providers/auth_provider.dart';
import 'package:hostel_hisab/features/finance/data/datasources/finance_remote_datasource.dart';
import 'package:hostel_hisab/features/finance/data/datasources/mock_finance_datasource.dart';
import 'package:hostel_hisab/features/finance/data/repositories/finance_repository_impl.dart';
import 'package:hostel_hisab/features/finance/domain/repositories/finance_repository.dart';
import 'package:hostel_hisab/features/finance/domain/usecases/add_deposit.dart';
import 'package:hostel_hisab/features/finance/domain/usecases/approve_deposit.dart';
import 'package:hostel_hisab/features/finance/domain/usecases/calculate_meal_rate.dart';
import 'package:hostel_hisab/features/finance/domain/usecases/calculate_summary.dart';
import 'package:hostel_hisab/features/finance/domain/usecases/get_transactions.dart';
import 'package:hostel_hisab/features/finance/presentation/providers/finance_provider.dart';
import 'package:hostel_hisab/features/meals/data/datasources/meals_remote_datasource.dart';
import 'package:hostel_hisab/features/meals/data/datasources/mock_meals_datasource.dart';
import 'package:hostel_hisab/features/meals/data/repositories/meals_repository_impl.dart';
import 'package:hostel_hisab/features/meals/domain/repositories/meals_repository.dart';
import 'package:hostel_hisab/features/meals/domain/usecases/get_today_meals.dart';
import 'package:hostel_hisab/features/meals/domain/usecases/save_today_meals.dart';
import 'package:hostel_hisab/features/meals/presentation/providers/meals_provider.dart';
import 'package:hostel_hisab/features/members/data/datasources/members_remote_datasource.dart';
import 'package:hostel_hisab/features/members/data/datasources/mock_members_datasource.dart';
import 'package:hostel_hisab/features/members/data/repositories/members_repository_impl.dart';
import 'package:hostel_hisab/features/members/domain/repositories/members_repository.dart';
import 'package:hostel_hisab/features/members/domain/usecases/add_member.dart';
import 'package:hostel_hisab/features/members/domain/usecases/get_members.dart';
import 'package:hostel_hisab/features/members/presentation/providers/members_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// Dependency wiring, in 3 steps (bottom of the chain first):
///   DataSource  ->  Repository  ->  UseCases  ->  Provider (UI state)
///
/// To go live: replace each Mock*DataSource with an Api*DataSource.
/// Nothing else in the app changes.
final List<SingleChildWidget> appProviders = [
  // 1) Data sources
  Provider<AuthRemoteDataSource>(create: (_) => MockAuthDataSource()),
  Provider<MembersRemoteDataSource>(create: (_) => MockMembersDataSource()),
  Provider<MealsRemoteDataSource>(create: (_) => MockMealsDataSource()),
  Provider<FinanceRemoteDataSource>(create: (_) => MockFinanceDataSource()),

  // 2) Repositories (typed as the abstract domain contract)
  Provider<AuthRepository>(create: (c) => AuthRepositoryImpl(c.read())),
  Provider<MembersRepository>(create: (c) => MembersRepositoryImpl(c.read())),
  Provider<MealsRepository>(create: (c) => MealsRepositoryImpl(c.read())),
  Provider<FinanceRepository>(create: (c) => FinanceRepositoryImpl(c.read())),

  // 3) Providers, built from usecases
  ChangeNotifierProvider<AuthProvider>(
    create: (c) {
      final repo = c.read<AuthRepository>();
      return AuthProvider(login: LoginUseCase(repo), logout: LogoutUseCase(repo));
    },
  ),
  ChangeNotifierProvider<MembersProvider>(
    create: (c) {
      final repo = c.read<MembersRepository>();
      return MembersProvider(getMembers: GetMembers(repo), addMember: AddMember(repo))..load();
    },
  ),
  ChangeNotifierProvider<MealsProvider>(
    create: (c) {
      final repo = c.read<MealsRepository>();
      return MealsProvider(
        getTodayMeals: GetTodayMeals(repo),
        saveTodayMeals: SaveTodayMeals(repo),
      )..load();
    },
  ),
  ChangeNotifierProvider<FinanceProvider>(
    create: (c) {
      final repo = c.read<FinanceRepository>();
      return FinanceProvider(
        getTransactions: GetTransactions(repo),
        addDeposit: AddDeposit(repo),
        approveDeposit: ApproveDeposit(repo),
        calculateSummary: const CalculateSummary(),
        calculateMealRate: const CalculateMealRate(),
      )..load();
    },
  ),
];
