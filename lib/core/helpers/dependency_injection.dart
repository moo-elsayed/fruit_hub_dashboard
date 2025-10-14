import 'package:fruit_hub_dashboard/core/services/firestore_service.dart';
import 'package:fruit_hub_dashboard/features/product/data/firebase/product_firebase.dart';
import 'package:fruit_hub_dashboard/features/product/data/repo_imp/data_sources/remote/product_remote_data_source_imp.dart';
import 'package:fruit_hub_dashboard/features/product/data/repo_imp/repo/product_repo_imp.dart';
import 'package:fruit_hub_dashboard/features/product/data/supabase/product_supabase.dart';
import 'package:fruit_hub_dashboard/features/product/domain/use_cases/add_product_use_case.dart';
import 'package:get_it/get_it.dart';
import '../services/database_service.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerSingleton<DatabaseService>(FirestoreService());

  getIt.registerSingleton<ProductRepoImp>(
    ProductRepoImp(
      ProductRemoteDataSourceImp(
        ProductSupabase(),
        ProductFirebase(getIt.get<DatabaseService>()),
      ),
    ),
  );

  getIt.registerSingleton<AddProductUseCase>(
    AddProductUseCase(getIt.get<ProductRepoImp>()),
  );
}
