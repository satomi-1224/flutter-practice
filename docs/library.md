# Project Libraries & Packages

本プロジェクトで採用するFlutterパッケージの選定一覧と、その採用理由です。
**「BFF連携」「自動生成による型安全」「キャッシュ・セキュリティ」** を重視した構成になっています。

## 1. ライブラリ一覧 (Dependencies)

アプリの動作に必要なメインライブラリです。

### 🧠 状態管理 & ロジック (State Management)

* **`flutter_riverpod`**
* アプリ全体のDI（依存注入）と状態管理を行う基盤。


* **`riverpod_annotation`**
* Riverpod Generator (`@riverpod`) を使用するために必須。ボイラープレートを削減する。


* **`hooks_riverpod`**
* RiverpodとFlutter Hooksを共存させるためのパッケージ。


* **`flutter_hooks`**
* `TextEditingController` やアニメーションなどの破棄処理(`dispose`)を自動化し、UIロジックを簡潔にする。



### 📡 通信 & データ (Network & Data)

* **`dio`**
* 高機能HTTPクライアント。Interceptorによるトークン付与やログ出力に使用。


* **`retrofit`**
* APIインターフェース定義から通信コードを自動生成する。LaravelのAPI仕様に合わせて手動定義を行う。


* **`json_annotation`**
* JSONレスポンスとDartクラスの相互変換(`fromJson`/`toJson`)用アノテーション。


* **`freezed_annotation`**
* イミュータブル（不変）なデータモデルを定義するためのアノテーション。



### 💾 ストレージ & キャッシュ (Storage & Cache)

* **`flutter_secure_storage`**
* **【重要】** 認証トークン(JWT)などの機密情報を暗号化して保存する。iOS Keychain / Android Keystoreを使用。


* **`cached_network_image`**
* Web上の画像を端末ストレージにキャッシュする。通信量削減と表示速度向上のため必須。


* **`shared_preferences`**
* 初回起動フラグやテーマ設定など、機密性のない簡易的な設定値の保存に使用。



### 🛣️ ルーティング (Routing)

* **`go_router`**
* URLベースの画面遷移、ディープリンク、リダイレクト処理（ログイン判定）を管理。


* **`go_router_builder`**
* URLを文字列ではなく、型安全なクラス（Typed Routes）として扱うための定義用。



### 🛠️ ユーティリティ (Utilities)

* **`gap`**
* `SizedBox` の代わりに使用。余白を直感的に記述する。


* **`flutter_dotenv`**
* `.env` ファイルからAPIのエンドポイントや環境変数を読み込む。


* **`intl`**
* 日付フォーマット(`DateFormat`)や多言語対応のための標準ライブラリ。



---

## 2. 開発・生成ツール (Dev Dependencies)

ビルド時や開発中にのみ使用するツール群です。アプリ本体には含まれません。

### ⚙️ コード生成 (Generators)

* **`build_runner`**
* 以下のGenerator系パッケージを一括実行するためのコマンドランナー。


* **`riverpod_generator`**
* `@riverpod` アノテーションからProvider定義を自動生成。


* **`retrofit_generator`**
* RetrofitインターフェースからDioの実装コードを自動生成。


* **`json_serializable`**
* JSONシリアライズロジックを自動生成。


* **`freezed`**
* `copyWith`, `toString`, `==` などのデータクラス用メソッドを自動生成。



### 🛡️ 品質管理・テスト (Quality & Testing)

* **`custom_lint` / `riverpod_lint**`
* Riverpodの推奨実装パターンを強制し、バグの温床となる書き方を警告する静的解析ツール。


* **`http_mock_adapter`**
* Dioの通信をインターセプトし、ローカルで定義したMockデータを返却する。バックエンド未完成時の開発に使用。


* **`flutter_launcher_icons`**
* アプリアイコン画像(iOS/Android)を一括生成するツール。



---

## 3. インストールコマンド (Installation)

以下のコマンドを実行することで、上記すべてのライブラリを一括導入できます。

### ① Dependencies (アプリ本体)

```bash
flutter pub add flutter_riverpod hooks_riverpod flutter_hooks riverpod_annotation \
  dio retrofit \
  json_annotation freezed_annotation \
  flutter_secure_storage cached_network_image shared_preferences \
  go_router go_router_builder \
  gap flutter_dotenv intl

```

### ② Dev Dependencies (開発ツール)

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

### ③ コード生成の監視コマンド

開発中は常に以下のコマンドを裏で実行しておきます。

```bash
dart run build_runner watch -d

```