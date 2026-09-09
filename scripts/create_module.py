#!/usr/bin/env python3
import sys
import os
import re

def to_pascal_case(snake_str: str) -> str:
    return "".join(word.capitalize() for word in snake_str.split("_"))

def to_camel_case(snake_str: str) -> str:
    parts = snake_str.split("_")
    return parts[0] + "".join(word.capitalize() for word in parts[1:])

def main():
    if len(sys.argv) < 2:
        print("Foydalanish: ./scripts/create_module.sh <module_name>")
        print("Misol: ./scripts/create_module.sh catalog")
        sys.exit(1)

    raw_name = sys.argv[1].strip().lower()
    snake_name = re.sub(r"[^a-z0-9_]", "_", raw_name)
    pascal_name = to_pascal_case(snake_name)
    camel_name = to_camel_case(snake_name)

    repo_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
    module_dir = os.path.join(repo_dir, "modules", snake_name)

    if os.path.exists(module_dir):
        print(f"❌ Xatolik: modules/{snake_name} allaqachon mavjud!")
        sys.exit(1)

    print(f"🚀 Yangi modul yaratilmoqda: modules/{snake_name} ({pascal_name})...")

    files = {}

    # 1. pubspec.yaml
    files[f"modules/{snake_name}/pubspec.yaml"] = f"""name: {snake_name}
version: 0.0.1
homepage: "none"
publish_to: "none"
description: "{pascal_name} module."

environment:
  sdk: ">=3.13.0 <4.0.0"
  flutter: ">=3.47.0"

dependencies:
  flutter:
    sdk: flutter
  material_ui: ^1.2.0
  core:
    path: ../../packages/core
  components:
    path: ../../packages/components
  navigation:
    path: ../../packages/navigation

dev_dependencies:
  flutter_test:
    sdk: flutter
  mocktail: ^1.0.5
  bloc_test: ^10.0.0
  analysis_lints: ^1.1.0

flutter:
  uses-material-design: true
"""

    # 2. lib/<module>.dart
    files[f"modules/{snake_name}/lib/{snake_name}.dart"] = f"""export 'src/{snake_name}_container.dart';
"""

    # 3. lib/src/<module>_container.dart
    files[f"modules/{snake_name}/lib/src/{snake_name}_container.dart"] = f"""import 'package:core/core.dart';
import 'package:navigation/navigation.dart';
import 'package:{snake_name}/src/di/{snake_name}_injection.dart';
import 'package:{snake_name}/src/router/{snake_name}_router.dart';

final class {pascal_name}Container implements ModuleContainer {{
  const new();

  @override
  AppRouter<RouteBase> get router => const {pascal_name}Router();

  @override
  Injection get injection => const {pascal_name}Injection();
}}
"""

    # 4. lib/src/di/<module>_injection.dart
    files[f"modules/{snake_name}/lib/src/di/{snake_name}_injection.dart"] = f"""import 'dart:async' show FutureOr;

import 'package:core/core.dart';
import 'package:{snake_name}/src/data/datasource/{snake_name}_remote_data_source.dart';
import 'package:{snake_name}/src/data/repository/{snake_name}_repository_impl.dart';
import 'package:{snake_name}/src/domain/repository/{snake_name}_repository.dart';
import 'package:{snake_name}/src/domain/usecases/get_{snake_name}.dart';
import 'package:{snake_name}/src/presentation/{snake_name}/bloc/{snake_name}_bloc.dart';

final class {pascal_name}Injection implements Injection {{
  const new();

  @override
  FutureOr<void> registerDependencies({{required Injector di}}) {{
    di
      ..registerLazySingleton<{pascal_name}RemoteDataSource>(() => {pascal_name}RemoteDataSourceImpl(di.get()))
      ..registerLazySingleton<{pascal_name}Repository>(() => {pascal_name}RepositoryImpl(di.get()))
      ..registerLazySingleton(() => Get{pascal_name}(di.get()))
      ..registerFactory(() => {pascal_name}Bloc(di.get()));
  }}
}}
"""

    # 5. lib/src/router/<module>_router.dart
    files[f"modules/{snake_name}/lib/src/router/{snake_name}_router.dart"] = f"""import 'package:core/core.dart';
import 'package:navigation/navigation.dart';
import 'package:{snake_name}/src/presentation/{snake_name}/bloc/{snake_name}_bloc.dart';
import 'package:{snake_name}/src/presentation/{snake_name}/{snake_name}_page.dart';

final class {pascal_name}Router implements AppRouter<RouteBase> {{
  const new();

  @override
  List<RouteBase> getRouters(Injector di) => [
    CupertinoRoute(
      path: '/{snake_name}',
      name: '{snake_name}',
      builder: (_, _) => BlocProvider<{pascal_name}Bloc>(
        create: (_) => di.get<{pascal_name}Bloc>(),
        child: const {pascal_name}Page(),
      ),
    ),
  ];
}}
"""

    # 6. lib/src/domain/entities/<module>_entity.dart
    files[f"modules/{snake_name}/lib/src/domain/entities/{snake_name}_entity.dart"] = f"""import 'package:core/core.dart' show Equatable;

class {pascal_name}Entity extends Equatable {{
  const new({{
    required this.id,
    required this.title,
  }});

  final String id;
  final String title;

  @override
  List<Object?> get props => [id, title];
}}
"""

    # 7. lib/src/domain/repository/<module>_repository.dart
    files[f"modules/{snake_name}/lib/src/domain/repository/{snake_name}_repository.dart"] = f"""import 'package:core/core.dart';
import 'package:{snake_name}/src/domain/entities/{snake_name}_entity.dart';

abstract interface class {pascal_name}Repository {{
  ResultFuture<List<{pascal_name}Entity>> getItems();
}}
"""

    # 8. lib/src/domain/usecases/get_<module>.dart
    files[f"modules/{snake_name}/lib/src/domain/usecases/get_{snake_name}.dart"] = f"""import 'package:core/core.dart';
import 'package:{snake_name}/src/domain/entities/{snake_name}_entity.dart';
import 'package:{snake_name}/src/domain/repository/{snake_name}_repository.dart';

class Get{pascal_name} extends UsecaseWithoutParams<List<{pascal_name}Entity>> {{
  const new(this._repo);

  final {pascal_name}Repository _repo;

  @override
  ResultFuture<List<{pascal_name}Entity>> call() => _repo.getItems();
}}
"""

    # 9. lib/src/data/datasource/<module>_remote_data_source.dart
    files[f"modules/{snake_name}/lib/src/data/datasource/{snake_name}_remote_data_source.dart"] = f"""import 'package:core/core.dart';
import 'package:{snake_name}/src/data/models/{snake_name}_model.dart';

part '{snake_name}_remote_data_source_impl.dart';

abstract interface class {pascal_name}RemoteDataSource {{
  Future<List<{pascal_name}Model>> getItems();
}}
"""

    # 10. lib/src/data/datasource/<module>_remote_data_source_impl.dart
    files[f"modules/{snake_name}/lib/src/data/datasource/{snake_name}_remote_data_source_impl.dart"] = f"""part of '{snake_name}_remote_data_source.dart';

final class {pascal_name}RemoteDataSourceImpl implements {pascal_name}RemoteDataSource {{
  const new(this._networkProvider);

  final NetworkProvider _networkProvider;

  @override
  Future<List<{pascal_name}Model>> getItems() async {{
    try {{
      final result = await _networkProvider.fetchMethod<List<dynamic>>(
        '/api/v1/{snake_name}',
        methodType: RMethodTypes.get,
      );
      return (result.data ?? [])
          .whereType<Map<String, dynamic>>()
          .map({pascal_name}Model.fromMap)
          .toList();
    }} on FormatException {{
      throw ServerException.formatException(locale: _networkProvider.locale);
    }} on ServerException {{
      rethrow;
    }} on Exception {{
      rethrow;
    }} on Error catch (error, stackTrace) {{
      logMessage('ERROR getItems: ', error: error, stackTrace: stackTrace);
      if (error is TypeError) {{
        throw ServerException.typeError(locale: _networkProvider.locale);
      }}
      throw ServerException.unknownError(locale: _networkProvider.locale);
    }}
  }}
}}
"""

    # 11. lib/src/data/models/<module>_model.dart
    files[f"modules/{snake_name}/lib/src/data/models/{snake_name}_model.dart"] = f"""import 'package:{snake_name}/src/domain/entities/{snake_name}_entity.dart';

class {pascal_name}Model extends {pascal_name}Entity {{
  const new({{
    required super.id,
    required super.title,
  }});

  factory fromMap(Map<String, dynamic> map) => {pascal_name}Model(
    id: '${{map['id'] ?? ''}}',
    title: map['title'] as String? ?? '',
  );

  Map<String, dynamic> toMap() => {{
    'id': id,
    'title': title,
  }};
}}
"""

    # 12. lib/src/data/repository/<module>_repository_impl.dart
    files[f"modules/{snake_name}/lib/src/data/repository/{snake_name}_repository_impl.dart"] = f"""import 'package:core/core.dart';
import 'package:{snake_name}/src/data/datasource/{snake_name}_remote_data_source.dart';
import 'package:{snake_name}/src/domain/entities/{snake_name}_entity.dart';
import 'package:{snake_name}/src/domain/repository/{snake_name}_repository.dart';

final class {pascal_name}RepositoryImpl implements {pascal_name}Repository {{
  const new(this._remoteDataSource);

  final {pascal_name}RemoteDataSource _remoteDataSource;

  @override
  ResultFuture<List<{pascal_name}Entity>> getItems() async {{
    try {{
      final result = await _remoteDataSource.getItems();
      return Right(result);
    }} on ServerException catch (error) {{
      return Left(error.failure);
    }} on Exception catch (error) {{
      return Left(ServerFailure(message: error.toString()));
    }}
  }}
}}
"""

    # 13. lib/src/presentation/<module>/bloc/<module>_bloc.dart
    files[f"modules/{snake_name}/lib/src/presentation/{snake_name}/bloc/{snake_name}_bloc.dart"] = f"""import 'package:core/core.dart';
import 'package:{snake_name}/src/domain/entities/{snake_name}_entity.dart';
import 'package:{snake_name}/src/domain/usecases/get_{snake_name}.dart';

part '{snake_name}_event.dart';
part '{snake_name}_state.dart';

final class {pascal_name}Bloc extends Bloc<{pascal_name}Event, {pascal_name}State> {{
  new(this._get{pascal_name}) : super(const {pascal_name}InitialState()) {{
    on<Get{pascal_name}Event>(_get{pascal_name}Handler, transformer: droppable());
  }}

  final Get{pascal_name} _get{pascal_name};

  Future<void> _get{pascal_name}Handler(Get{pascal_name}Event event, Emitter<{pascal_name}State> emit) async {{
    if (state is {pascal_name}LoadingState) {{
      return;
    }}
    emit(const {pascal_name}LoadingState());

    final result = await _get{pascal_name}();
    result.fold(
      (failure) => emit({pascal_name}FailureState(message: failure.message)),
      (items) => emit({pascal_name}LoadedState(items: items)),
    );
  }}
}}
"""

    # 14. lib/src/presentation/<module>/bloc/<module>_event.dart
    files[f"modules/{snake_name}/lib/src/presentation/{snake_name}/bloc/{snake_name}_event.dart"] = f"""part of '{snake_name}_bloc.dart';

sealed class {pascal_name}Event extends Equatable {{
  const new();
}}

final class Get{pascal_name}Event extends {pascal_name}Event {{
  const new();

  @override
  List<Object?> get props => [];
}}
"""

    # 15. lib/src/presentation/<module>/bloc/<module>_state.dart
    files[f"modules/{snake_name}/lib/src/presentation/{snake_name}/bloc/{snake_name}_state.dart"] = f"""part of '{snake_name}_bloc.dart';

sealed class {pascal_name}State extends Equatable {{
  const new();
}}

final class {pascal_name}InitialState extends {pascal_name}State {{
  const new();

  @override
  List<Object?> get props => [];
}}

/// Ro'yxatni yuklash oilasi — `BlocBuilder.buildWhen` shu subfamily'ni nomlaydi.
sealed class {pascal_name}ListState extends {pascal_name}State {{
  const new();
}}

final class {pascal_name}LoadingState extends {pascal_name}ListState {{
  const new();

  @override
  List<Object?> get props => [];
}}

final class {pascal_name}LoadedState extends {pascal_name}ListState {{
  const new({{required this.items}});

  final List<{pascal_name}Entity> items;

  @override
  List<Object?> get props => [items];
}}

final class {pascal_name}FailureState extends {pascal_name}ListState {{
  const new({{required this.message}});

  final String message;

  @override
  List<Object?> get props => [message];
}}
"""

    # 16. lib/src/presentation/<module>/mixin/<module>_mixin.dart
    files[f"modules/{snake_name}/lib/src/presentation/{snake_name}/mixin/{snake_name}_mixin.dart"] = f"""part of '../{snake_name}_page.dart';

mixin {pascal_name}Mixin on State<{pascal_name}Page> {{
  // Mixin — yagona ma'lumot egasi. Ro'yxat, paginatsiya va controllerlar shu yerda yashaydi.
  List<{pascal_name}Entity> _items = [];

  {pascal_name}Bloc get bloc => context.read<{pascal_name}Bloc>();

  bool get _hasItems => _items.isNotEmpty;

  void _handleStates(BuildContext context, {pascal_name}State state) {{
    if (state is {pascal_name}LoadedState) {{
      _items = state.items;
    }} else if (state is {pascal_name}FailureState) {{
      showErrorMessage(context, message: state.message);
    }}
  }}

  Future<void> _refresh() async => bloc.add(const Get{pascal_name}Event());
}}
"""

    # 17. lib/src/presentation/<module>/<module>_page.dart
    files[f"modules/{snake_name}/lib/src/presentation/{snake_name}/{snake_name}_page.dart"] = f"""import 'package:components/components.dart';
import 'package:core/core.dart';
import 'package:material_ui/material_ui.dart';
import 'package:{snake_name}/src/domain/entities/{snake_name}_entity.dart';
import 'package:{snake_name}/src/presentation/{snake_name}/bloc/{snake_name}_bloc.dart';

part 'mixin/{snake_name}_mixin.dart';

class {pascal_name}Page extends StatefulWidget {{
  const new({{super.key}});

  @override
  State<{pascal_name}Page> createState() => _{pascal_name}PageState();
}}

class _{pascal_name}PageState extends State<{pascal_name}Page> with {pascal_name}Mixin {{
  @override
  void initState() {{
    super.initState();
    // Boshlang'ich so'rov doim page'ning initState() ida yuboriladi (docs/rules/page-mixin.md §3.2).
    bloc.add(const Get{pascal_name}Event());
  }}

  @override
  Widget build(BuildContext context) => BlocListener<{pascal_name}Bloc, {pascal_name}State>(
    listener: _handleStates,
    child: Scaffold(
      // TODO({snake_name}): o'zingning l10n kalitingni qo'sh — packages/core/lib/src/l10n/app_{{en,uz,ru}}.arb
      appBar: AppBar(title: Text(context.l10n.appName)),
      body: SafeAreaWithMinimum(
        minimum: Dimensions.kPaddingAll16,
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: BlocBuilder<{pascal_name}Bloc, {pascal_name}State>(
            buildWhen: (_, current) => current is {pascal_name}ListState,
            builder: (context, state) {{
              if (state is {pascal_name}LoadingState && !_hasItems) {{
                return const Center(child: CustomCircularProgressIndicator());
              }}
              if (!_hasItems) {{
                return Center(child: Text(context.l10n.noItems));
              }}

              return ListView.separated(
                itemCount: _items.length,
                separatorBuilder: (_, _) => Dimensions.kGap8,
                itemBuilder: (context, index) => ListTile(title: Text(_items[index].title)),
              );
            }},
          ),
        ),
      ),
    ),
  );
}}
"""

    # 18. test/<module>_test.dart
    files[f"modules/{snake_name}/test/{snake_name}_test.dart"] = f"""import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:{snake_name}/src/di/{snake_name}_injection.dart';
import 'package:{snake_name}/src/domain/usecases/get_{snake_name}.dart';
import 'package:{snake_name}/src/presentation/{snake_name}/bloc/{snake_name}_bloc.dart';
import 'package:{snake_name}/src/router/{snake_name}_router.dart';
import 'package:{snake_name}/{snake_name}.dart';

class _MockGet{pascal_name} extends Mock implements Get{pascal_name};

void main() {{
  group('{pascal_name} Module Tests', () {{
    test('{pascal_name}Container exposes router and injection', () {{
      const container = {pascal_name}Container();
      expect(container.router, isA<{pascal_name}Router>());
      expect(container.injection, isA<{pascal_name}Injection>());
    }});

    test('{pascal_name}Bloc initial state and handler', () async {{
      final mockUseCase = _MockGet{pascal_name}();
      final bloc = {pascal_name}Bloc(mockUseCase);

      expect(bloc.state, const {pascal_name}InitialState());
      await bloc.close();
    }});
  }});
}}
"""

    for rel_path, content in files.items():
        abs_path = os.path.join(repo_dir, rel_path)
        os.makedirs(os.path.dirname(abs_path), exist_ok=True)
        with open(abs_path, "w", encoding="utf-8") as f:
            f.write(content)

    print(f"✅ {len(files)} ta fayl muvaffaqiyatli yaratildi!")
    print(f"📦 Modul: modules/{snake_name}")
    print("👉 Keyingi qadam:")
    print(f"   1. Orkestratsiyaga ulash: packages/merge_dependencies/lib/merge_dependencies.dart ga {pascal_name}Container() ni qo'shing.")
    print(f"   2. Tekshirish: ./scripts/test_module.sh {snake_name}")

if __name__ == "__main__":
    main()
