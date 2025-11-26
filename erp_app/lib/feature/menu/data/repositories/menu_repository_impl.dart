

import '../../domain/entities/menu_entity.dart';
import '../../domain/repositories/menu_repository.dart';
import '../datasource/menu_remote_datasource.dart';

class MenuRepositoryImpl implements MenuRepository {
  final MenuRemoteDataSource remoteDataSource;

  MenuRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<MenuEntity>> getMenu() async {

    print("🟡 Repository: getMenu CALLED");
    final models = await remoteDataSource.getMenu();
    print("🟡 Repository: result LENGTH = ");
    return models.map((e) => e.toEntity()).toList();
  }
}
