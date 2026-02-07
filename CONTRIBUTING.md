# 共通リポジトリ運用ガイド

このリポジトリは、複数のプロジェクトで共有する**AI開発支援ルール集**の共通リポジトリです。

---

## 📖 概要

このリポジトリは、以下を提供します：

- **コーディング規約**（TypeScript、React、API、データベースなど）
- **セキュリティガイドライン**（病院・銀行・官公庁レベル対応）
- **コンプライアンス規約**（医療・金融・行政対応）
- **テスト戦略**
- **デプロイメント戦略**
- **パフォーマンス最適化基準**
- **モニタリング・ログ戦略**
- **インシデント対応計画**
- **Cursorコマンド**
- **Claude Codeスキル**
- **GitHub Actions**

---

## 🎯 使用方法

### 既存プロジェクトへの統合

#### オプション A: Git Submodule（推奨）

```bash
# プロジェクトルートで実行
cd /path/to/your-project

# Submoduleとして追加
git submodule add https://github.com/YOUR_USERNAME/ai-dev-rules .ai-dev-rules

# シンボリックリンクを作成
ln -s .ai-dev-rules/.cursor .cursor
ln -s .ai-dev-rules/.claude .claude
ln -s .ai-dev-rules/CLAUDE.md CLAUDE.md

# .gitignoreに追加（プロジェクト固有の設定は除外）
echo ".claude/settings.local.json" >> .gitignore
```

**Submodule更新方法**:

```bash
# 最新版を取得
git submodule update --remote .ai-dev-rules

# コミット
git add .ai-dev-rules
git commit -m "chore: update ai-dev-rules to latest version"
```

#### オプション B: 直接コピー

```bash
# ファイルをコピー
cp -r ai-dev-rules/.cursor /path/to/your-project/
cp -r ai-dev-rules/.claude /path/to/your-project/
cp ai-dev-rules/CLAUDE.md /path/to/your-project/
```

### プロジェクト固有のカスタマイズ

#### 1. CLAUDE.md のカスタマイズ

[CLAUDE.md](./CLAUDE.md)の「プロジェクト概要」セクションを編集：

```markdown
## プロジェクト概要

**プロジェクト名**: あなたのプロジェクト名
**説明**: プロジェクトの説明

### 技術スタック

- フロントエンド: React 19.2, TypeScript, Vite
- バックエンド: Express + TypeScript
- データベース: Prisma + PostgreSQL
- 認証: JWT + bcrypt
```

#### 2. GitHubリポジトリ名の置換

```bash
# .cursor/commands/ 内のリポジトリ名を置換
find .cursor/commands -type f -name "*.md" -exec sed -i '' 's/kizuki-dsd\/manabi/YOUR_ORG\/YOUR_REPO/g' {} +
```

#### 3. プロジェクト固有の設定ファイル

`.claude/settings.local.json` を作成（gitignoreに追加済み）：

```json
{
  "permissions": {
    "autoApprove": ["read", "glob", "grep"]
  }
}
```

---

## 🔄 共通リポジトリの更新フロー

### 共通ルールを更新したい場合

1. **このリポジトリをフォーク**

```bash
git clone https://github.com/YOUR_USERNAME/ai-dev-rules.git
cd ai-dev-rules
```

2. **ブランチを作成**

```bash
git checkout -b feature/update-security-rules
```

3. **ルールを更新**

```bash
# 例: セキュリティガイドラインを更新
vim .cursor/rules/security.mdc
```

4. **コミット & プッシュ**

```bash
git add .cursor/rules/security.mdc
git commit -m "feat: add MFA implementation guide to security rules"
git push origin feature/update-security-rules
```

5. **プルリクエストを作成**

GitHub上でプルリクエストを作成し、レビューを依頼

6. **マージ後、全プロジェクトに反映**

```bash
# 各プロジェクトで実行
cd /path/to/project-a
git submodule update --remote .ai-dev-rules
git commit -m "chore: update ai-dev-rules"

cd /path/to/project-b
git submodule update --remote .ai-dev-rules
git commit -m "chore: update ai-dev-rules"
```

---

## 📝 ルール追加ガイド

### 新しいルールファイルを追加する

1. **ルールファイルを作成**

```bash
# .cursor/rules/ に新しいルールを作成
vim .cursor/rules/new-rule.mdc
```

2. **ルールファイルのテンプレート**

```markdown
---
description: 新しいルールの説明
globs:
  - "**/*.ts"
alwaysApply: true
---

# 新しいルール

## 概要

このルールは...

## ベストプラクティス

### 1. ルール1

\```typescript
// ✅ 良い例
const example = "good";

// ❌ 悪い例
const example = "bad";
\```

## チェックリスト

- [ ] 項目1
- [ ] 項目2

## 参考資料

- [リンク](https://example.com)
```

3. **CLAUDE.md に追記**

```markdown
## 新しいルール

📄 [**new-rule.mdc**](./.cursor/rules/new-rule.mdc)

- ルールの説明
```

---

## 🤝 貢献ガイドライン

### コントリビューションの種類

- **バグ修正**: 規約の誤り、リンク切れなど
- **新規ルール追加**: 新しいコーディング規約や戦略
- **改善提案**: 既存ルールの改善
- **ドキュメント改善**: 説明の明確化、サンプルコード追加

### プルリクエストの作成

1. **Issue を作成**（大きな変更の場合）
2. **ブランチ命名規則**
   - `feature/add-xxx`
   - `fix/correct-xxx`
   - `docs/update-xxx`
3. **コミットメッセージ規約**
   - `feat: 新機能追加`
   - `fix: バグ修正`
   - `docs: ドキュメント更新`
   - `chore: その他`

### レビュープロセス

1. PRを作成
2. 自動チェック（Lint、フォーマット）
3. メンテナーによるレビュー
4. 承認後にマージ

---

## 🛠️ メンテナンス

### 定期メンテナンスタスク

| タスク | 頻度 | 担当 |
|--------|------|------|
| 依存関係の更新 | 月1回 | メンテナー |
| リンクチェック | 月1回 | メンテナー |
| 新規ツール/フレームワークの調査 | 四半期ごと | チーム |
| ルールの見直し | 半年ごと | チーム |

### バージョニング

このリポジトリは[Semantic Versioning](https://semver.org/)を採用：

- **MAJOR**: 破壊的変更（既存プロジェクトに影響）
- **MINOR**: 新機能追加（後方互換性あり）
- **PATCH**: バグ修正、ドキュメント改善

```bash
# 新しいバージョンをリリース
git tag v2.0.0
git push origin v2.0.0
```

---

## 📞 サポート

### 質問・相談

- **GitHub Issues**: バグ報告、機能要望
- **GitHub Discussions**: 質問、ディスカッション
- **Slack**: リアルタイムサポート（社内の場合）

### FAQ

#### Q1: Submoduleとコピーのどちらを使うべき？

**A**: 共通ルールを常に最新に保ちたい場合は**Submodule**を推奨。プロジェクト固有にカスタマイズしたい場合は**コピー**を使用してください。

#### Q2: プロジェクト固有のルールを追加したい

**A**: `.cursor/rules/` に新しいファイルを追加し、`alwaysApply: true` を設定してください。Submodule使用時は、プロジェクトのルートに追加してください。

#### Q3: 共通ルールを一部だけ使いたい

**A**: 不要なルールファイルを削除するか、`alwaysApply: false` に変更してください。

---

## 📄 ライセンス

MIT License

このルール集は自由にカスタマイズして使用できます。

---

## 🙏 謝辞

このルール集の作成にあたり、以下のプロジェクト・コミュニティから着想を得ています：

- [Anthropic Claude](https://claude.ai/)
- [Cursor](https://cursor.sh/)
- [React](https://react.dev/)
- [Prisma](https://www.prisma.io/)
- [OWASP](https://owasp.org/)
- [NIST](https://www.nist.gov/)

---

**Happy Coding with AI! 🚀**
