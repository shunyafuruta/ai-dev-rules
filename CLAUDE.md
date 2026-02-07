# AI開発支援ルール集

このドキュメントは、AIを活用した開発プロジェクトのコーディング規約とワークフローを定義します。

---

## プロジェクト概要

**このセクションはプロジェクトに応じてカスタマイズしてください。**

例: Webアプリケーション、APIサービス、モバイルアプリなど

### 技術スタック

詳細は `.cursor/rules/general.mdc` を参照してください。

**推奨技術スタック（2026年2月時点 - 安定性重視）:**

#### 実行環境
- **Node.js**: 22.x LTS（推奨）
  - Node.js 20.xは2026年4月でEOL
  - Node.js 22.xは2027年4月までサポート

#### フロントエンド
- **React**: 19.2.4以上（セキュリティパッチ適用版）
- **TypeScript**: 5.8以上
- **ビルドツール**: Vite 6.x（Vite 7は様子見推奨）
- **スタイリング**: Tailwind CSS
- **状態管理**: TanStack Query v4/v5, Context API

#### バックエンド
- **フレームワーク**: Express + TypeScript または Next.js API Routes
- **ORM**: Prisma 5.x（Prisma 6は様子見推奨）
- **データベース**: MySQL 8.0 / PostgreSQL 14+
- **認証**: JWT + bcrypt または Firebase Auth

#### テスト
- **ユニット・統合**: Vitest
- **APIテスト**: Supertest
- **E2Eテスト**: Playwright

#### インフラ
- **クラウド**: Google Cloud / AWS / Azure
- **CI/CD**: GitHub Actions

### ディレクトリ構成

プロジェクトに応じて調整してください。

```
apps/
├── api/          # バックエンドAPI (Express)
└── web/          # フロントエンド (React + Vite)

packages/
└── shared/       # 共有コード（型定義、スキーマ）

specification/
├── api/          # API仕様書
├── database/     # データベース設計書
└── ui/           # UI画面仕様書

reference/        # 📚 参照資料（ローカルのみ、GitHub除外）
├── requirements/ # 要件定義書
├── design/       # デザイン資料
├── api/          # API仕様書
└── meeting-notes/ # 議事録
```

**`reference/` ディレクトリについて:**
- AIに読み込ませたい資料を保存する専用ディレクトリ
- `.gitignore` で除外されており、GitHubにはアップロードされません
- 機密情報（顧客要件定義書、社内仕様書など）を安全に保存できます
- 使い方: `reference/requirements/spec.md を参照して実装して` のように指示

---

## コーディング規約

詳細なコーディング規約は、以下の `.cursor/rules/` ディレクトリのルールファイルを参照してください。

### プロジェクト全般

📄 [**general.mdc**](./.cursor/rules/general.mdc)

- プロジェクト基本設定
- 技術スタック
- ディレクトリ構成
- 言語設定
- **Import / Export 規約**（パスエイリアス、Named Export）

### TypeScript規約

📄 [**typescript.mdc**](./.cursor/rules/typescript.mdc)

- 変数宣言ルール（`const`のみ使用）
- 早期リターンパターン
- JSDocとコメント（日本語で記述）
- マジックナンバー禁止
- 型安全性
- **型定義のベストプラクティス**
  - Interface vs Type Alias
  - Readonly修飾子
  - ジェネリクス
  - ユーティリティ型
  - 型ガード
  - 非同期処理
  - Discriminated Union

### React規約

📄 [**react.mdc**](./.cursor/rules/react.mdc)

- React 19.2.4とReact Compilerについて
- メモ化のルール（React Compilerが自動最適化）
- コンポーネント構成
- TanStack Query の使用
- Vite環境変数
- セキュリティ
- **コンポーネント設計パターン**
  - Presentation / Container パターン
  - カスタムフック
  - Context API
- **フォームハンドリング**（React Hook Form + Zod）
- **TanStack Query ガイド**
  - クエリキーの命名規則
  - オプティミスティック更新
  - エラーハンドリング
- **パフォーマンス最適化**
  - コード分割
  - 仮想スクロール
- **アクセシビリティ**
  - ARIA属性
  - キーボードナビゲーション
- **Tailwind CSS ガイド**
  - クラス名の命名規則
  - レスポンシブデザイン

### バックエンドAPI規約

📄 [**api.mdc**](./.cursor/rules/api.mdc)

- 入力検証（Zodバリデーション必須）
- 機密情報の保護
- エラーハンドリング
- Prismaクエリ
- ページネーション

### Prismaマイグレーション規約

📄 [**prisma-migration.mdc**](./.cursor/rules/prisma-migration.mdc)

- **正しいコマンド実行方法**（`npm run prisma:migrate -- --name xxx`）
- マイグレーション命名規則（英語、snake_case、動詞で始める）
- 作成前チェックリスト
- 作成後チェックリスト
- レビュー観点
- よくあるエラーと対処法

### Git運用ルール

📄 [**git.mdc**](./.cursor/rules/git.mdc)

- ブランチ構成（`main` / `develop` / `feature/*`）
- ブランチ命名規則
- Git worktree運用規約
- **force-push の禁止**（main/master/developへは絶対禁止）
- Issue管理ルール
- GitHub CLI の使用
- コミットメッセージ規約

### ドキュメント管理

📄 [**documentation.mdc**](./.cursor/rules/documentation.mdc)

- 仕様書作成・更新の基本方針
- 仕様書作成タイミング
- 仕様書の品質基準

### コードレビュー基準

📄 [**review.mdc**](./.cursor/rules/review.mdc)

- レビューステータスの判断基準
- 必須チェック項目
- レビュー方針

---

## エンタープライズグレード規約

**病院・銀行・官公庁レベルのセキュリティ・コンプライアンス対応**

### セキュリティガイドライン

📄 [**security.mdc**](./.cursor/rules/security.mdc)

- **OWASP Top 10対策**
  - 認証の破れ（MFA、パスワードポリシー、セッション管理）
  - SQLインジェクション対策
  - XSS対策（CSP設定）
  - CSRF対策
  - 機密情報の露出対策
  - アクセス制御（RBAC）
  - ログと監視（監査ログ）
  - レート制限（DoS/DDoS対策）
  - 入力検証とサニタイゼーション
  - 安全でない逆シリアル化対策
- **データ保護**
  - 個人情報の仮名化
  - データ保持・削除ポリシー
- **通信セキュリティ**（HTTPS必須、CORS設定）
- セキュリティテスト（脆弱性診断、ペネトレーションテスト）

### コンプライアンス規約

📄 [**compliance.mdc**](./.cursor/rules/compliance.mdc)

- **個人情報保護法対応**
  - 個人情報の取得・同意記録
  - 第三者提供記録
  - 開示請求対応
  - 削除請求（忘れられる権利）
- **医療業界**
  - 医療情報の暗号化
  - 医療従事者のアクセス制限
  - 閲覧履歴記録
- **金融業界**
  - PCI DSS対応（カード情報非保持）
  - 取引履歴保存（7年間）
  - マネーロンダリング対策
- **行政システム**
  - NISC ガイドライン対応
  - 電子署名法対応

### テスト戦略

📄 [**testing.mdc**](./.cursor/rules/testing.mdc)

- **テストピラミッド**（ユニット70% / 統合20% / E2E10%）
- **ユニットテスト**
  - Vitest、React Testing Library
  - AAA パターン
  - モック/スタブ
- **統合テスト**（Supertest）
- **E2Eテスト**（Playwright）
- **テストカバレッジ目標**: 90%以上

### データベース設計規約

📄 [**database.mdc**](./.cursor/rules/database.mdc)

- スキーマ設計原則（命名規則、プライマリキー、外部キー）
- インデックス戦略
- N+1問題対策
- トランザクション管理
- 楽観的ロック
- パフォーマンス最適化（ページネーション、集計クエリ）

### モニタリング・ログ戦略

📄 [**monitoring.mdc**](./.cursor/rules/monitoring.mdc)

- **ログレベル**（DEBUG / INFO / WARN / ERROR / FATAL）
- 構造化ログ（JSON形式）
- APM（レスポンスタイム計測、データベースクエリ監視）
- エラー追跡（Sentry連携）
- ヘルスチェック
- メトリクス収集（Prometheus）
- アラート設定
- ログ保持ポリシー（90日〜7年）

### デプロイメント戦略

📄 [**deployment.mdc**](./.cursor/rules/deployment.mdc)

- 環境構成（Development / Staging / Production）
- CI/CDパイプライン（GitHub Actions）
- デプロイ前チェックリスト
- ゼロダウンタイムデプロイ（ブルーグリーン、ローリング）
- データベースマイグレーション
- ロールバック手順
- デプロイメント通知（Slack）

### パフォーマンス最適化基準

📄 [**performance.mdc**](./.cursor/rules/performance.mdc)

- **Core Web Vitals目標**
  - LCP < 2.5秒
  - FID < 100ms
  - CLS < 0.1
- **フロントエンド最適化**
  - バンドルサイズ < 200KB
  - コード分割
  - 画像最適化（WebP/AVIF）
  - キャッシュ戦略
  - 仮想スクロール
- **バックエンド最適化**
  - データベースクエリ最適化
  - Redisキャッシュ
  - レート制限
  - 非同期処理（ジョブキュー）

### 依存関係管理

📄 [**dependencies.mdc**](./.cursor/rules/dependencies.mdc)

- ライブラリ選定基準（メンテナンス状況、セキュリティ、ライセンス）
- バージョン管理（`package.json`、lockファイル）
- 脆弱性管理（npm audit、Snyk、Dependabot）
- アップデート戦略（セキュリティパッチ、メジャー/マイナー/パッチ）
- ライセンス管理

### インシデント対応計画

📄 [**incident-response.mdc**](./.cursor/rules/incident-response.mdc)

- **インシデントレベル**（P1〜P4）
- インシデント対応フロー（検知 → トリアージ → 対応 → 復旧 → 事後対応）
- **セキュリティインシデント**
  - データ漏洩時の対応
  - 法令対応（個人情報保護委員会への報告）
  - ユーザーへの通知
- 連絡体制（エスカレーションフロー）
- インシデント報告書

### IPA・総務省ガイドライン対応

📄 [**ipa-soumu-compliance.mdc**](./.cursor/rules/ipa-soumu-compliance.mdc)

- **IPA「安全なウェブサイトの作り方」対応**
  - SQLインジェクション対策（プレースホルダ）
  - XSS対策（HTMLエスケープ、サニタイズ）
  - CSRF対策（トークン検証）
  - ディレクトリトラバーサル対策
  - HTTPヘッダーインジェクション対策
  - セッション管理（セキュアなセッションID）
  - 認可制御（RBAC）
- **総務省ガイドライン対応**
  - 地方公共団体向けセキュリティポリシー
  - アクセスログの記録（監査証跡）
  - パスワードポリシー（12文字以上、履歴チェック）
  - 多要素認証（MFA）
  - データ暗号化（保存時・通信時）
  - バックアップとリカバリ

---

## 開発フロー

### 1. 新機能開発の流れ

```bash
# 1. Issue内容を確認
gh issue view <issue番号>

# 2. developから作業ブランチを作成（worktreeを使用）
cd /path/to/project
git checkout develop
git pull origin develop
git worktree add -b issue-<番号>-<機能名> ../project-issue-<番号> develop

# 3. 作業ディレクトリに移動
cd ../project-issue-<番号>

# 4. 実装を進める
# - 仕様書を作成/更新（specification/ ディレクトリ）
# - コードを実装
# - テストを作成

# 5. コミット
git add .
git commit -m "feat: 機能を追加"

# 6. プッシュ
git push -u origin issue-<番号>-<機能名>

# 7. PRを作成
gh pr create --base develop --title "タイトル" --body "Closes #<issue番号>"

# 8. レビュー依頼（Cursorコマンド）
/pr-review

# 9. PRマージ後、worktreeを削除
cd ../project
git worktree remove ../project-issue-<番号>
git branch -d issue-<番号>-<機能名>
```

### 2. コードレビュー

Cursor上で `/pr-review` コマンドを使用すると、自動的にレビュープロセスが実行されます：

1. ✅ 差分の取得と検証
2. ✅ PRを自動作成（存在しない場合）
3. ✅ PRに `@claude レビューして` コメントを追加
4. ✅ レビュー結果を返却（JSON形式）

---

## Cursor Commands（開発効率化コマンド）

Cursor上で使用できるカスタムコマンドを提供しています。

### `/pr-review` - PRレビュー依頼

現在のブランチとdevelopブランチの差分を自動的に取得し、Claudeにコードレビューを依頼します。

```
/pr-review
```

### `/pr-review-branch <base-branch>` - PRレビュー依頼（ブランチ指定）

指定したベースブランチとの差分でPRレビューを依頼します。

```
/pr-review-branch main
```

### `/get-issue <issue番号>` - GitHub Issue情報取得

指定したGitHub issueの詳細情報を取得して表示します。

```
/get-issue 137
```

### `/create-issue` - GitHub Issue作成

ザックリとした説明から詳細なGitHub Issueを自動生成して作成します。

```
/create-issue ログイン機能を追加したい
```

### `/update-issue <issue番号>` - GitHub Issue更新

issueの本文を更新します。

```
/update-issue 137
```

### `/resolve-conflicts` - マージコンフリクト解決

gitマージコンフリクトの解決を支援します。

```
/resolve-conflicts
```

---

## Claude Code スキル

Claude Code上で使用できるスキルコマンドです。

### `issue` - Issue実装フロー

指定したIssueを読み解いて実装し、PRを作成してレビューリクエストを送ります。

```
/issue 123
```

### `test` - テストコマンド

現在のブランチを表示するテストコマンドです。

```
/test
```

---

## クイックリファレンス

### よく使うパターン

#### Reactコンポーネントの基本構成

```typescript
import type { ReactNode } from 'react';

interface ComponentProps {
  propName: string;
  children?: ReactNode;
}

/**
 * コンポーネントの説明
 *
 * @param props - コンポーネントのProps
 * @param props.propName - プロパティの説明
 * @returns コンポーネント
 */
function Component({ propName, children }: ComponentProps) {
  // 早期リターン: 条件チェック
  if (!propName) {
    return null;
  }

  // メインの描画
  return (
    <div>
      {propName}
      {children}
    </div>
  );
}

export { Component };
```

#### カスタムフックの基本構成

```typescript
/**
 * フックの説明
 *
 * @param param - パラメータの説明
 * @returns フックの戻り値
 */
function useCustomHook(param: string) {
  const [state, setState] = useState<string>(param);

  // React Compilerが自動最適化するため、useCallbackは不要
  const handleUpdate = (newValue: string) => {
    setState(newValue);
  };

  return { state, handleUpdate };
}

export { useCustomHook };
```

#### API関数の基本構成

```typescript
/**
 * API関数の説明
 *
 * @param param - パラメータの説明
 * @returns APIレスポンス
 * @throws {ApiError} API呼び出しが失敗した場合
 */
async function fetchData(param: string): Promise<DataType> {
  const response = await fetch(`/api/data/${param}`);

  if (!response.ok) {
    throw new ApiError(`Failed to fetch data: ${response.statusText}`);
  }

  return await response.json();
}

export { fetchData };
```

---

## セットアップ方法

### 1. このリポジトリをプロジェクトに統合

#### オプション A: 直接コピー

```bash
# .cursor/ ディレクトリをコピー
cp -r ai-dev-rules/.cursor /path/to/your-project/

# .claude/ ディレクトリをコピー
cp -r ai-dev-rules/.claude /path/to/your-project/

# CLAUDE.md をコピー（必要に応じてカスタマイズ）
cp ai-dev-rules/CLAUDE.md /path/to/your-project/
```

#### オプション B: Git Submodule として追加

```bash
cd /path/to/your-project
git submodule add https://github.com/your-username/ai-dev-rules .ai-dev-rules

# シンボリックリンクを作成
ln -s .ai-dev-rules/.cursor .cursor
ln -s .ai-dev-rules/.claude .claude
ln -s .ai-dev-rules/CLAUDE.md CLAUDE.md
```

### 2. プロジェクト固有の設定をカスタマイズ

- `CLAUDE.md` の「プロジェクト概要」セクションを編集
- `.cursor/rules/general.mdc` の技術スタックを編集
- 不要なルールファイルを削除（例: Prismaを使わない場合は `prisma-migration.mdc` を削除）

### 3. GitHubリポジトリ名を設定

`.cursor/commands/` 内のコマンドファイルで、リポジトリ名を置換：

```bash
# "kizuki-dsd/manabi" を自分のリポジトリ名に置換
find .cursor/commands -type f -name "*.md" -exec sed -i '' 's/kizuki-dsd\/manabi/your-org\/your-repo/g' {} +
```

### 4. Claude Code設定（オプション）

`.claude/settings.local.json` を作成して、プロジェクト固有の権限を設定してください。

---

## 更新履歴

- 2026-02-07: 技術スタックを2026年最新版に更新（安定性重視）
  - React 19.2.4（セキュリティパッチ適用）
  - TypeScript 5.8
  - Node.js 22.x LTS（Node.js 20.xは2026年4月EOL）
  - Vite 6.x推奨（Vite 7は様子見）
  - Prisma 5.x推奨（Prisma 6は様子見）
  - OWASP Top 10:2025対応
    - A03: Software Supply Chain Failures（新規）
    - A10: Mishandling of Exceptional Conditions（新規）
    - A02: Security Misconfiguration（ランクアップ）

- 2026-02-07: AI開発支援ルール集として汎用化テンプレートを作成
  - manabiプロジェクトから規約・コマンドを抽出
  - プロジェクト固有の情報を汎用化
  - セットアップガイドを追加

---

## ライセンス

MIT License

このルール集は自由にカスタマイズして使用できます。
