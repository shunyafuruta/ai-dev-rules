# AI開発支援ルール集

AIを活用した効率的な開発を実現するためのコーディング規約・コマンド・ワークフロー集です。

**Cursor** および **Claude Code** と連携して、コードレビュー、Issue管理、PR作成などを自動化・効率化します。

---

## 📋 特徴

### ✅ 包括的なコーディング規約
- **TypeScript**: 変数宣言、型定義、JSDocなど
- **React 19.2**: React Compiler対応、最新のベストプラクティス
- **バックエンドAPI**: Zod検証、Prisma、エラーハンドリング
- **Git運用**: ブランチ戦略、worktree、force-push禁止

### ⚡ 効率化コマンド
- **PRレビュー自動化**: `/pr-review` でClaudeが自動レビュー
- **Issue自動生成**: `/create-issue` でザックリした説明から詳細Issueを生成
- **Issue実装フロー**: `/issue 123` でIssueの実装からPR作成まで自動化

### 🤖 AI連携
- **Cursor Rules**: プロジェクト固有のルールをCursorに読み込ませる
- **Claude Code Skills**: カスタムスキルでワークフローを自動化
- **レビュー自動化**: PRに `@claude レビューして` でコードレビュー

---

## 🚀 クイックスタート

### 1. リポジトリをクローン

```bash
git clone https://github.com/your-username/ai-dev-rules.git
```

### 2. 既存プロジェクトに統合

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

### 3. プロジェクト固有の設定をカスタマイズ

- `CLAUDE.md` の「プロジェクト概要」セクションを編集
- `.cursor/rules/general.mdc` の技術スタックを編集
- 不要なルールファイルを削除

### 4. GitHubリポジトリ名を設定

`.cursor/commands/` 内のコマンドファイルで、リポジトリ名を置換：

```bash
# "kizuki-dsd/manabi" を自分のリポジトリ名に置換
find .cursor/commands -type f -name "*.md" -exec sed -i '' 's/kizuki-dsd\/manabi/your-org\/your-repo/g' {} +
```

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
│   │   └── review.mdc      # コードレビュー基準
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
├── CLAUDE.md               # プロジェクト指示書（メイン）
├── README.md               # このファイル
└── .gitignore
```

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

## 🤝 貢献

このリポジトリへの貢献を歓迎します！

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'feat: Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

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
