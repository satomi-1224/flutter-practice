# プロジェクト作成・設定コマンド

このドキュメントには、`docs/library.md` および `docs/architecture.md` の設計に基づいたFlutterプロジェクトのセットアップコマンドを記載しています。

## 1. Flutterプロジェクトの初期化

プロジェクトのルートディレクトリ（現在のディレクトリ）で以下のコマンドを実行します。

```bash
flutter create --org com.example --platforms android,ios .
```
*(注: `com.example` は実際の組織ドメインに変更してください)*

## 2. ライブラリのインストール

`docs/library.md` で定義されたライブラリをインストールします。

### メイン依存関係 (Dependencies)
```bash
flutter pub add flutter_riverpod hooks_riverpod flutter_hooks riverpod_annotation \
  dio retrofit \
  json_annotation freezed_annotation \
  flutter_secure_storage cached_network_image shared_preferences \
  go_router go_router_builder \
  gap flutter_dotenv intl
```

### 開発用依存関係 (Dev Dependencies)
```bash
flutter pub add --dev build_runner \
  riverpod_generator \
  retrofit_generator \
  json_serializable \
  freezed \
  custom_lint riverpod_lint \
  flutter_launcher_icons \
  http_mock_adapter
```

## 3. ディレクトリ構成の作成

`docs/architecture.md` で定義されたフォルダ構成を作成します。

### PowerShell (Windows)
```powershell
New-Item -ItemType Directory -Force -Path lib/config
New-Item -ItemType Directory -Force -Path lib/pages/home
New-Item -ItemType Directory -Force -Path lib/pages/auth
New-Item -ItemType Directory -Force -Path lib/pages/products
New-Item -ItemType Directory -Force -Path lib/features/auth
New-Item -ItemType Directory -Force -Path lib/features/product/infra
New-Item -ItemType Directory -Force -Path lib/features/product/models
New-Item -ItemType Directory -Force -Path lib/features/product/controllers
New-Item -ItemType Directory -Force -Path lib/features/product/containers
New-Item -ItemType Directory -Force -Path lib/features/product/widgets
New-Item -ItemType Directory -Force -Path lib/widgets/atoms
New-Item -ItemType Directory -Force -Path lib/widgets/molecules
New-Item -ItemType Directory -Force -Path lib/widgets/layouts
New-Item -ItemType Directory -Force -Path lib/infra/api
New-Item -ItemType Directory -Force -Path lib/infra/generated
New-Item -ItemType Directory -Force -Path lib/infra/exceptions
New-Item -ItemType Directory -Force -Path lib/routes
New-Item -ItemType Directory -Force -Path lib/theme
New-Item -ItemType Directory -Force -Path lib/utils
```

### Bash / ターミナル (Mac/Linux)
```bash
mkdir -p lib/config
mkdir -p lib/pages/home lib/pages/auth lib/pages/products
mkdir -p lib/features/auth
mkdir -p lib/features/product/{infra,models,controllers,containers,widgets}
mkdir -p lib/widgets/{atoms,molecules,layouts}
mkdir -p lib/infra/{api,generated,exceptions}
mkdir -p lib/routes
mkdir -p lib/theme
mkdir -p lib/utils
```

## 4. 設定ファイルの更新

### analysis_options.yaml
`docs/architecture.md` の指定通り、自動生成ファイルを静的解析の対象外に設定します。

```yaml
analyzer:
  exclude:
    - "lib/infra/generated/**"
    - "**/*.g.dart"
    - "**/*.freezed.dart"
```