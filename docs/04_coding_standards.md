# 04. Coding Standards

本プロジェクトにおけるコーディング規約です。
「なぜそう書くのか」を重視し、可読性と保守性の高いコードを目指します。

## 1. 命名規則 (Naming Conventions)

Dart/Flutterの標準規約準拠に加え、以下のルールを適用します。

### ファイル名
*   **Snake Case**: `product_detail_page.dart`, `auth_controller.dart`
*   **Suffix**: 役割を明確にするため、ファイル名の末尾に役割を付けます。
    *   Page: `_page.dart` (例: `login_page.dart`)
    *   Controller: `_controller.dart` (例: `user_controller.dart`)
    *   Repository: `_repository.dart` (例: `auth_repository.dart`)
    *   Widget: 役割に応じた名前 (例: `primary_button.dart`)

### クラス名
*   **Pascal Case**: `ProductDetailPage`, `AuthController`
*   **Suffix**: ファイル名と一致させます。

### 変数・メソッド
*   **Camel Case**: `fetchUserData()`, `isLoading`
*   **Boolean**: `is`, `has`, `can`, `should` で始める。
    *   ✅ `isVisible`
    *   ❌ `visible` (形容詞のみは避ける)

---

## 2. コメント規約 (Comments)

**「What（何をしているか）」よりも「Why（なぜそうしているか）」** を記述してください。
コードを見ればわかることはコメント不要です。

### 必須コメント
1.  **複雑なロジック**: 一見して意図が掴みにくい計算や条件分岐。
2.  **回避策 (Workaround)**: バグ回避やライブラリの制約による特殊な実装。
3.  **ドメイン知識**: 業務特有のルール。

### 良いコメントの例

```dart
// ❌ Bad: コードを見ればわかる
// ユーザーIDがnullでなければ詳細画面へ遷移
if (userId != null) {
  context.push('/detail/$userId');
}

// ✅ Good: なぜその判定が必要なのか、業務ルールを記述
// 未会員(Guest)の場合はIDが存在しないため、詳細画面ではなく登録画面へ誘導する
if (userId != null) {
  context.push('/detail/$userId');
} else {
  context.push('/register');
}
```

---

## 3. Widget実装ルール

### 3.1. HookConsumerWidget の使用
StatefulWidgetの代わりに、原則として `HookConsumerWidget` (hooks_riverpod) を使用します。
これにより、`useEffect` や `useTextEditingController` などのHooksと、`ref.watch` を1つのWidget内で共存させます。

### 3.2. buildメソッドの肥大化防止
`build` メソッドが長くなりすぎないよう、適切な単位でWidgetを分割してください。
メソッド抽出 (`_buildHeader()` など) ではなく、**別クラスのWidgetとして切り出す**ことを推奨します（パフォーマンス最適化のため）。

```dart
// ❌ Bad: メソッドで分割 (リビルド範囲が最適化されない)
Widget build(BuildContext context, WidgetRef ref) {
  return Column(
    children: [
      _buildHeader(),
      _buildBody(),
    ],
  );
}

// ✅ Good: クラスで分割 (const化可能でリビルドを抑制)
Widget build(BuildContext context, WidgetRef ref) {
  return const Column(
    children: [
      HeaderWidget(),
      BodyWidget(),
    ],
  );
}
```

---

## 4. Import整理

絶対パス (`package:project_name/...`) と相対パスの混在を避け、**相対パス** を推奨します（同一Feature内の場合）。
ただし、別Featureや共通層 (`lib/widgets`, `lib/utils`) を参照する場合は絶対パスでも構いませんが、プロジェクト内で統一感を意識してください。
Importの並び順は `dart fix` コマンドで自動整列させます。

```dart
// Dart Imports
import 'dart:async';

// Package Imports
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project Imports (Relative)
import '../models/user.dart';
import 'user_state.dart';
```

---

## 5. 環境変数 (Environment Variables)

`.env` ファイルへのアクセスは、必ず **`lib/config/env.dart`** (Envクラス) を経由してください。
コード内で直接 `dotenv.env['KEY']` を参照することは禁止します。これにより、キー名のタイプミスを防ぎ、型安全性やデフォルト値の管理を一元化します。

```dart
// ❌ Bad: 直接参照
final apiKey = dotenv.env['API_KEY'];

// ✅ Good: Envクラス経由
final apiKey = Env.apiKey;
```
