# AI開発支援ルール集

AIを活用した効率的な開発を実現するためのコーディング規約・コマンド・ワークフロー集です。

**Cursor** および **Claude Code** と連携して、コードレビュー、Issue管理、PR作成などを自動化・効率化します。

---

## 📋 特徴

### 🏥🏦🏛️ エンタープライズグレード対応

**病院・銀行・官公庁レベルのセキュリティ基準に対応**

- **セキュリティ**: OWASP Top 10対策、MFA、監査ログ、暗号化
- **コンプライアンス**: 個人情報保護法、医療法、PCI DSS、金融商品取引法、NISC対応
- **IPA・総務省ガイドライン**: 「安全なウェブサイトの作り方」、地方公共団体向けセキュリティポリシー
- **インシデント対応**: セキュリティインシデント・障害対応計画

### ✅ 包括的なコーディング規約
- **TypeScript**: 変数宣言、型定義、JSDocなど
- **React 19.2**: React Compiler対応、最新のベストプラクティス
- **バックエンドAPI**: Zod検証、Prisma、エラーハンドリング
- **データベース**: スキーマ設計、N+1問題対策、トランザクション管理
- **Git運用**: ブランチ戦略、worktree、force-push禁止

### 🧪 品質保証
- **テスト戦略**: ユニット・統合・E2Eテスト、カバレッジ90%以上
- **パフォーマンス**: Core Web Vitals、バンドルサイズ最適化、キャッシュ戦略
- **モニタリング**: ログ管理、APM、エラー追跡（Sentry）、アラート設定

### 🚀 デプロイメント・運用
- **CI/CD**: GitHub Actions、ゼロダウンタイムデプロイ、ロールバック
- **依存関係管理**: 脆弱性スキャン、自動更新、ライセンス管理
- **インシデント対応**: P1〜P4レベル別対応、エスカレーションフロー

### ⚡ 効率化コマンド
- **ワンコマンドセットアップ**: `./setup.sh` でAI開発環境を自動構築
- **PRレビュー自動化**: `/pr-review` でClaudeが自動レビュー
- **Issue自動生成**: `/create-issue` でザックリした説明から詳細Issueを生成
- **Issue実装フロー**: `/issue 123` でIssueの実装からPR作成まで自動化

### 🤖 AI連携
- **Cursor Rules**: プロジェクト固有のルールをCursorに読み込ませる
- **Claude Code Skills**: カスタムスキルでワークフローを自動化
- **レビュー自動化**: PRに `@claude レビューして` でコードレビュー
- **階層型AI開発チーム**: PM・Coder・Reviewerの3つのエージェントで開発を自動化

### 🎯 並列開発システム（新機能）

**設計書を読んで自動的にIssueを立て、複数のCoderが並列実装する完全自動化システム**

```
設計書（reference/）
    ↓
PM（AI）: 設計書を読んでIssueを作成
    ↓
state/backlog.md に Issue番号リスト
    ↓
Coder1  Coder2  Coder3  ← 並列実装（tmuxセッション）
 #123    #124    #125
    ↓      ↓      ↓
   PR     PR     PR
```

#### ワンコマンド起動

```bash
cd .ai-dev-rules
./auto-dev.sh
```

これだけで、以下がすべて自動実行されます:
1. ✅ PMが設計書（`reference/`）を読む
2. ✅ PMがタスク分解してIssueを作成
3. ✅ 並列実装可能なIssueを検出
4. ✅ 複数のCoderが並列でIssueを実装
5. ✅ PRを自動作成

#### 特徴

- 🚀 **完全自動**: `./auto-dev.sh` 一発で設計書→Issue→実装まで自動化
- ⚡ **並列実装**: 最大3〜10個のIssueを同時に並列実装（設定可能）
- 🎯 **tmux + send-keys**: Zennの記事と同じアプローチで複数エージェントを制御
- 📊 **状態管理**: `state/backlog.md` でIssueを一元管理

詳細は [PARALLEL_DEVELOPMENT.md](./PARALLEL_DEVELOPMENT.md) を参照

---

## 🚀 クイックスタート

### 🎯 最速セットアップ（推奨）

**コマンド1つで AI 開発環境を構築！**

```bash
# 1. このリポジトリをクローン
git clone https://github.com/your-username/ai-dev-rules.git
cd ai-dev-rules

# 2. プロジェクトディレクトリにセットアップ
./setup.sh /path/to/your-project

# または Makefile を使用
make setup PROJECT=/path/to/your-project

# カレントディレクトリにセットアップする場合
./setup.sh
```

**セットアップスクリプトが自動的に以下を実行:**
- ✅ `.cursor/` ディレクトリをコピー
- ✅ `.claude/` ディレクトリをコピー
- ✅ `CLAUDE.md` をコピー
- ✅ `agents/` ディレクトリを作成（PM/Coder/Reviewer）
- ✅ `state/` ディレクトリを作成（タスク管理）
- ✅ `reference/` ディレクトリを作成（参照資料用）
- ✅ `.gitignore` に設定を追加

---

### 手動セットアップ（上級者向け）

<details>
<summary>クリックして展開</summary>

#### オプション A: 直接コピー

```bash
# .cursor/ ディレクトリをコピー
cp -r ai-dev-rules/.cursor /path/to/your-project/

# .claude/ ディレクトリをコピー
cp -r ai-dev-rules/.claude /path/to/your-project/

# CLAUDE.md をコピー
cp ai-dev-rules/CLAUDE.md /path/to/your-project/

# agents/ と state/ をコピー
cp -r ai-dev-rules/agents /path/to/your-project/
cp -r ai-dev-rules/state /path/to/your-project/

# reference/ を作成
mkdir -p /path/to/your-project/reference
cp ai-dev-rules/reference/README.md /path/to/your-project/reference/
```

#### オプション B: Git Submodule として追加

```bash
cd /path/to/your-project
git submodule add https://github.com/your-username/ai-dev-rules .ai-dev-rules

# シンボリックリンクを作成
ln -s .ai-dev-rules/.cursor .cursor
ln -s .ai-dev-rules/.claude .claude
ln -s .ai-dev-rules/CLAUDE.md CLAUDE.md
ln -s .ai-dev-rules/agents agents
ln -s .ai-dev-rules/state state

# reference/ は個別に作成（ローカルのみ）
mkdir -p reference
cp .ai-dev-rules/reference/README.md reference/
```

</details>

---

### カスタマイズ

#### 1. プロジェクト固有の設定

- `CLAUDE.md` の「プロジェクト概要」セクションを編集
- `.cursor/rules/general.mdc` の技術スタックを編集
- 不要なルールファイルを削除

#### 2. GitHubリポジトリ名を設定

`.cursor/commands/` 内のコマンドファイルで、リポジトリ名を置換：

```bash
find .cursor/commands -type f -name "*.md" -exec sed -i '' 's/kizuki-dsd\/manabi/your-org\/your-repo/g' {} +
```

---

### GitHub Actionsのセットアップ（オプション）

#### 前提条件
- GitHub Actionsが有効になっていること
- Claude Code OAuthトークンまたはAnthropic API Keyを取得済み

#### セットアップ手順

```bash
# .github/ ディレクトリをコピー
cp -r ai-dev-rules/.github /path/to/your-project/
```

#### シークレットの設定

GitHubリポジトリの Settings > Secrets and variables > Actions で以下を設定：

1. **`CLAUDE_CODE_OAUTH_TOKEN`** (推奨)
   - Claude Code OAuthトークンを設定
   - 取得方法: https://code.claude.com/settings/tokens

2. **`ANTHROPIC_API_KEY`** (代替)
   - Anthropic API Keyを設定
   - 取得方法: https://console.anthropic.com/

#### ワークフローの説明

- **`claude-code.yml`**: PR/Issueに `@claude` とメンションすると自動実行
- **`claude-code-review.yml`**: PR作成時に自動レビュー（オプション）
- **`claude.yml`**: レガシー設定（必要に応じて削除可能）

#### PRテンプレートとIssueガイドライン

- **`PULL_REQUEST_TEMPLATE.md`**: PR作成時の自動テンプレート
- **`ISSUE_GUIDELINES.md`**: Issue作成時のガイドライン

---

## 📁 構成

```
ai-dev-rules/
├── .cursor/
│   ├── rules/              # コーディング規約
│   │   ├── general.mdc     # プロジェクト基本設定
│   │   ├── typescript.mdc  # TypeScript規約
│   │   ├── react.mdc       # React規約
│   │   ├── api.mdc         # バックエンドAPI規約
│   │   ├── git.mdc         # Git運用ルール
│   │   ├── prisma-migration.mdc  # Prismaマイグレーション
│   │   ├── documentation.mdc     # ドキュメント管理
│   │   ├── review.mdc      # コードレビュー基準
│   │   ├── security.mdc    # セキュリティガイドライン（病院・銀行・官公庁対応）
│   │   ├── compliance.mdc  # コンプライアンス規約（医療・金融・行政）
│   │   ├── testing.mdc     # テスト戦略（ユニット・統合・E2E）
│   │   ├── database.mdc    # データベース設計規約
│   │   ├── monitoring.mdc  # モニタリング・ログ戦略
│   │   ├── deployment.mdc  # デプロイメント戦略
│   │   ├── performance.mdc # パフォーマンス最適化基準
│   │   ├── dependencies.mdc # 依存関係管理
│   │   ├── incident-response.mdc # インシデント対応計画
│   │   └── ipa-soumu-compliance.mdc # IPA・総務省ガイドライン対応
│   └── commands/           # Cursorカスタムコマンド
│       ├── pr-review.md    # PRレビュー依頼
│       ├── pr-review-branch.md  # PRレビュー（ブランチ指定）
│       ├── get-issue.md    # Issue情報取得
│       ├── create-issue.md # Issue自動生成
│       ├── update-issue.md # Issue更新
│       └── resolve-conflicts.md  # コンフリクト解決
├── .claude/
│   ├── commands/           # Claude Codeスキル
│   │   ├── issue.md        # Issue実装フロー
│   │   └── test.md         # テストコマンド
│   └── settings.json       # Claude Code設定（サンプル）
├── .github/
│   ├── prompts/            # AIプロンプト
│   │   └── pr-review.md    # PRレビュー用プロンプト
│   ├── workflows/          # GitHub Actions
│   │   ├── claude-code.yml           # Claude Code連携（@claudeメンション）
│   │   ├── claude-code-review.yml    # 自動レビュー（PR作成時）
│   │   └── claude.yml                # Claude GitHub Actions
│   ├── PULL_REQUEST_TEMPLATE.md      # PRテンプレート
│   └── ISSUE_GUIDELINES.md           # Issueガイドライン
├── agents/                 # 階層型AI開発チーム
│   ├── pm/CLAUDE.md        # PM専用指示書
│   ├── coder/CLAUDE.md     # Coder専用指示書
│   └── reviewer/CLAUDE.md  # Reviewer専用指示書
├── state/                  # 状態管理ファイル
│   ├── current-task.md     # 現在進行中のタスク
│   ├── backlog.md          # 未着手タスク一覧
│   ├── review-queue.md     # レビュー待ちキュー
│   └── decisions.md        # 部長の決裁履歴
├── reference/              # 📚 参照資料（ローカルのみ、GitHubにはアップロードしない）
│   └── README.md           # 資料ディレクトリの使い方
├── setup.sh                # ⚡ セットアップスクリプト（コマンド1つで環境構築）
├── Makefile                # ⚡ セットアップ用 Makefile
├── CLAUDE.md               # プロジェクト指示書（メイン）
├── CONTRIBUTING.md         # 共通リポジトリ運用ガイド
├── README.md               # このファイル
└── .gitignore
```

---

## 📚 参照資料ディレクトリ（reference/）

**AIに読み込ませたい資料を保存するための専用ディレクトリです。**

### 特徴

✅ **ローカルのみで管理** - `.gitignore` で除外されており、GitHubにはアップロードされません
✅ **機密情報も安全** - 顧客要件定義書、社内仕様書、デザイン資料などを安心して保存できます
✅ **AIが自動参照** - Claude Code / Cursor が自動的にファイルを読み込めます

### 使い方

#### 1. 資料を配置

```bash
reference/
├── requirements/      # 要件定義書
│   ├── spec.md
│   └── user-story.pdf
├── design/           # デザイン資料
│   ├── wireframe.png
│   └── ui-spec.pdf
├── api/              # API仕様書
│   └── swagger.yaml
└── meeting-notes/    # 議事録
    └── 2024-01-15.md
```

#### 2. AIに参照させる

開発中に以下のように指示：

```
reference/requirements/spec.md を参照して、ログイン機能を実装して
```

```
reference/design/wireframe.png を見て、画面レイアウトを作成して
```

### 対応ファイル形式

- **テキスト**: `.md`, `.txt`, `.json`, `.yaml`
- **画像**: `.png`, `.jpg`, `.svg`, `.webp`
- **PDF**: `.pdf`（Claude が内容を読み取れます）
- **コード**: `.ts`, `.js`, `.py` など

### 注意事項

⚠️ **本番環境の認証情報や秘密鍵は保存しないでください**

詳細は [`reference/README.md`](./reference/README.md) を参照してください。

---

## 🛠️ 使い方

### Cursorコマンド

#### `/pr-review` - PRレビュー依頼

現在のブランチとdevelopブランチの差分を自動的に取得し、Claudeにコードレビューを依頼します。

```bash
/pr-review
```

**動作:**
1. 差分を取得（`git diff develop...HEAD`）
2. PRが存在しない場合は自動作成
3. PRに `@claude レビューして` コメントを追加
4. レビュー結果を表示

#### `/get-issue <issue番号>` - Issue情報取得

指定したGitHub issueの詳細情報を取得して表示します。

```bash
/get-issue 137
```

**オプション:**
- `--comments`: コメント一覧を表示
- `--deps`: 依存関係を表示
- `--web`: ブラウザで開く
- `--json`: JSON形式で出力

#### `/create-issue <説明>` - Issue自動生成

ザックリとした説明から詳細なGitHub Issueを自動生成して作成します。

```bash
/create-issue ログイン機能を追加したい
```

**生成される内容:**
- 適切なタイトル
- 概要セクション
- 背景・課題
- 求める機能・仕様
- 技術的な実装案
- 受入基準

### Claude Codeスキル

#### `/issue <issue番号>` - Issue実装フロー

指定したIssueを読み解いて実装し、PRを作成してレビューリクエストを送ります。

```bash
/issue 123
```

**自動実行内容:**
1. Issueを取得・理解
2. ブランチを作成
3. 実装を実施
4. コミット・プッシュ
5. PRを作成
6. レビュー依頼を送信

---

## 📖 コーディング規約

詳細は [`CLAUDE.md`](./CLAUDE.md) を参照してください。

### 主要なルール

#### TypeScript
- `const` のみ使用（`let` は禁止）
- 早期リターンパターン
- JSDoc必須（日本語）
- マジックナンバー禁止
- Named Export推奨（Default Export禁止）

#### React
- React 19.2とReact Compiler対応
- メモ化は不要（React Compilerが自動最適化）
- `forwardRef` 不要（ref as prop）
- Context APIの簡素化

#### Git
- ブランチ: `main` ← `develop` ← `feature/*`
- force-push禁止（main/master/developへは絶対禁止）
- コミットメッセージ: `<type>: <subject>` 形式
- Git worktree運用

---

## 🔧 カスタマイズ

### プロジェクトに応じた調整

1. **技術スタックの変更**
   - `.cursor/rules/general.mdc` を編集

2. **不要なルールの削除**
   - 例: Prismaを使わない場合は `prisma-migration.mdc` を削除

3. **リポジトリ名の置換**
   ```bash
   find .cursor/commands -type f -name "*.md" -exec sed -i '' 's/kizuki-dsd\/manabi/your-org\/your-repo/g' {} +
   ```

4. **プロジェクト概要の編集**
   - `CLAUDE.md` の「プロジェクト概要」セクションを編集

---

## 🎯 階層型AI開発チーム

### 概要

複数のAIエージェント（PM・Coder・Reviewer）が協調して開発を進める仕組みです。

### チーム構成

```
部長（人間） - 要件定義・最終決裁
    ↓
PM（AI） - 設計・タスク分解・進捗管理
    ↓
Coder（AI） ←→ Reviewer（AI）
  実装         コードレビュー
```

### 各ロールの責務

#### 部長（人間）
- 作りたいものの要件を出す
- 重要な判断の決裁
- 最終的なGO/NO-GO判断

#### PM（AI）
- 部長の要件をタスクに分解
- Coder・Reviewerへの指示出し
- 進捗管理と状態ファイルの更新
- 軽微な判断は自己決裁、重要事項は部長にエスカレーション

#### Coder（AI）
- PMからの指示に基づき実装
- 作業前後に状態ファイルを更新
- 不明点はPMに確認

#### Reviewer（AI）
- Coderの成果物をレビュー
- コード品質・設計の妥当性をチェック
- 問題があればCoderに差し戻し
- 重大な問題はPMにエスカレーション

### 状態管理

各エージェントは以下のファイルで状態を共有：

| ファイル | 用途 |
|---------|------|
| `state/current-task.md` | 現在進行中のタスク |
| `state/decisions.md` | 部長の決裁履歴 |
| `state/backlog.md` | 未着手タスク一覧 |
| `state/review-queue.md` | レビュー待ちの項目 |

### ワークフロー

#### 1. タスク開始
1. 部長が要件を伝える
2. PMがタスク分解して `state/backlog.md` に追記
3. PMがCoderにタスクをアサイン
4. `state/current-task.md` を更新

#### 2. 実装
1. Coderが実装
2. 完了したら `state/current-task.md` のステータスを「レビュー待ち」に
3. `state/review-queue.md` に追加

#### 3. レビュー
1. ReviewerがコードチェックLeviewer
2. OKなら「完了」、NGなら「差し戻し」+ 理由を記載
3. 差し戻しの場合、Coderが修正して再レビュー

#### 4. 完了
1. レビュー通過でタスク完了
2. PMが `state/backlog.md` を更新
3. 次のタスクへ

### 起動方法

各エージェントは専用ディレクトリで起動：

```bash
# PMとして起動
cd agents/pm && claude

# Coderとして起動
cd agents/coder && claude

# Reviewerとして起動
cd agents/reviewer && claude
```

### ディレクトリ構成

```
project-root/
├── CLAUDE.md              # メイン指示書
├── agents/
│   ├── pm/
│   │   └── CLAUDE.md      # PM専用指示
│   ├── coder/
│   │   └── CLAUDE.md      # Coder専用指示
│   └── reviewer/
│       └── CLAUDE.md      # Reviewer専用指示
├── state/
│   ├── current-task.md
│   ├── decisions.md
│   ├── backlog.md
│   └── review-queue.md
├── reference/             # 📚 参照資料（要件定義書、デザイン、議事録など）
│   └── README.md          # 使い方ガイド
└── src/
    └── [実装コード]
```

### エスカレーション基準

#### PMが部長に確認すべき事項
- 要件の解釈に迷うとき
- 当初の想定から大きく工数が変わるとき
- 技術選定で複数の選択肢があるとき
- スコープの変更が必要なとき

#### Reviewerが PMに報告すべき事項
- 設計レベルの問題発見
- セキュリティ上の懸念
- 3回以上の差し戻し

---

## 🤝 貢献

このリポジトリへの貢献を歓迎します！

詳細は [**CONTRIBUTING.md**](./CONTRIBUTING.md) を参照してください。

### クイックガイド

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'feat: Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### 共通リポジトリとして使用する

このリポジトリを複数のプロジェクトで共有する場合は、Git Submoduleを使用してください：

```bash
cd /path/to/your-project
git submodule add https://github.com/YOUR_USERNAME/ai-dev-rules .ai-dev-rules
ln -s .ai-dev-rules/.cursor .cursor
ln -s .ai-dev-rules/.claude .claude
```

詳細は [CONTRIBUTING.md](./CONTRIBUTING.md) の「共通リポジトリ運用ガイド」を参照してください。

---

## 📝 ライセンス

MIT License

このルール集は自由にカスタマイズして使用できます。

---

## 🙏 謝辞

このルール集は以下のプロジェクトから着想を得ています：

- [Anthropic Claude](https://claude.ai/)
- [Cursor](https://cursor.sh/)
- [React](https://react.dev/)
- [Prisma](https://www.prisma.io/)

---

## 📚 関連リンク

- [CLAUDE.md](./CLAUDE.md) - 詳細なプロジェクト指示書
- [Cursor Documentation](https://cursor.sh/docs)
- [Claude Code Documentation](https://docs.anthropic.com/claude-code)
- [React 19 Documentation](https://react.dev/blog/2024/12/05/react-19)
- [Prisma Documentation](https://www.prisma.io/docs)

---

**Happy Coding with AI! 🚀**
