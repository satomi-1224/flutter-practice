# 03. Setup & Dependencies

本ドキュメントでは、プロジェクトに必要なライブラリの解説と、初期セットアップ手順について説明します。

## 1. 使用ライブラリ (Dependencies)

### 🧠 State Management & Logic
*   **`flutter_riverpod`**: アプリ全体のDI（依存注入）と状態管理。
*   **`riverpod_annotation`**: Generator (`@riverpod`) を使用するためのアノテーション。
*   **`hooks_riverpod`**: RiverpodとFlutter Hooksの共存。
*   **`flutter_hooks`**: `TextEditingController` 等のUIロジック簡略化。

### 📡 Network & Data
*   **`dio`**: 高機能HTTPクライアント。
*   **`retrofit`**: APIインターフェースから通信コードを自動生成。
*   **`freezed_annotation`**: イミュータブルなデータモデル定義。
*   **`json_annotation`**: JSONシリアライズ定義。

### 💾 Storage & Utility
*   **`flutter_secure_storage`**: 機密情報（トークン等）の保存。
*   **`shared_preferences`**: 簡易設定の保存。
*   **`go_router`**: URLベースのルーティング。
*   **`flutter_dotenv`**: 環境変数管理 (`.env`)。
*   **`gap`**: 余白 (`SizedBox` の代用)。

### 🛠 Dev Tools (Dev Dependencies)
*   **`build_runner`**: コード生成ランナー。
*   **`riverpod_generator`**: Riverpod Provider生成。
*   **`retrofit_generator`**: APIクライアント生成。
*   **`freezed`**: データクラス生成。
*   **`custom_lint`, `riverpod_lint`**: 静的解析ルール。

---

## 2. セットアップ手順 (Setup Steps)

### Step 1. プロジェクト初期化
```bash
flutter create --org com.example --platforms android,ios .
```

### Step 2. ライブラリインストール
以下のコマンドで必要なパッケージを一括インストールします。

**Dependencies (アプリ本体)**
```bash
flutter pub add flutter_riverpod hooks_riverpod flutter_hooks riverpod_annotation \
  dio retrofit \
  json_annotation freezed_annotation \
  flutter_secure_storage cached_network_image shared_preferences \
  go_router go_router_builder \
  gap flutter_dotenv intl
```

**Dev Dependencies (開発ツール)**
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

### Step 3. ディレクトリ作成
推奨されるディレクトリ構成を作成します。

**Mac / Linux**
```bash
mkdir -p lib/config
mkdir -p lib/pages/home lib/pages/auth
mkdir -p lib/features/auth/{infra,models,controllers,widgets}
mkdir -p lib/widgets/{atoms,molecules,layouts}
mkdir -p lib/infra/{api,exceptions}
mkdir -p lib/routes lib/theme lib/utils
```

**Windows (PowerShell)**
```powershell
New-Item -ItemType Directory -Force -Path lib/config, lib/pages/home, lib/pages/auth
New-Item -ItemType Directory -Force -Path lib/features/auth/infra, lib/features/auth/models, lib/features/auth/controllers, lib/features/auth/widgets
New-Item -ItemType Directory -Force -Path lib/widgets/atoms, lib/widgets/molecules, lib/widgets/layouts
New-Item -ItemType Directory -Force -Path lib/infra/api, lib/infra/exceptions
New-Item -ItemType Directory -Force -Path lib/routes, lib/theme, lib/utils
```

### Step 4. 設定ファイル (analysis_options.yaml)
自動生成されたファイルを静的解析（Lint）の対象外に設定します。

```yaml
analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
  plugins:
    - custom_lint
```

---

## 3. 開発中のコマンド

コード生成（build_runner）を常時実行しておくことで、変更をリアルタイムに反映させます。

```bash
dart run build_runner watch -d
```

