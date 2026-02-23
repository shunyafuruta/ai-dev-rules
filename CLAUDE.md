# AI開発支援ルール集

## プロジェクト概要

- **フロントエンド**: React 19.2, TypeScript, Vite, Tailwind CSS
- **バックエンド**: Express + TypeScript
- **データベース**: Prisma + MySQL
- **テスト**: Vitest, Supertest

```
apps/
├── api/          # バックエンドAPI (Express)
└── web/          # フロントエンド (React + Vite)
packages/
└── shared/       # 共有コード（型定義、スキーマ）
specification/    # 仕様書
reference/        # 参照資料（.gitignore対象）
```

---

## コーディング規約（必須）

- `const` のみ使用（`let` 禁止）
- Named Export のみ（Default Export 禁止）
- JSDoc・コメントは日本語
- 早期リターンパターン
- マジックナンバー禁止

詳細は `.cursor/rules/` の各ファイルを参照：
- `general.mdc` - プロジェクト設定、Import/Export規約
- `typescript.mdc` - TypeScript規約、型定義
- `react.mdc` - Reactコンポーネント規約
- `api.mdc` - バックエンドAPI規約（Zodバリデーション必須）
- `git.mdc` - Git運用（force-push禁止）
- `testing.mdc` - テスト戦略（カバレッジ90%目標）
- `database.mdc` - DB設計（N+1対策）
- `prisma-migration.mdc` - マイグレーション（`npm run prisma:migrate -- --name xxx`）
- `security.mdc` - OWASP Top 10対策
- `review.mdc` - コードレビュー基準

---

## 開発フロー

```bash
# Issue確認 → ブランチ作成 → 実装 → PR作成
gh issue view <番号>
git checkout develop && git pull origin develop
git checkout -b issue-<番号>-<機能名>
# 実装...
git push -u origin issue-<番号>-<機能名>
gh pr create --base develop --title "タイトル" --body "Closes #<番号>"
```

---

## Claude Code スキル

- `/issue <番号>` - Issueを実装してPR作成
- `/pm` - PMとしてIssue作成→Coder並列起動
- `/test` - テストコマンド

## Cursor Commands

- `/pr-review` - PRレビュー依頼
- `/create-issue` - Issue自動生成
- `/get-issue <番号>` - Issue情報取得
- `/resolve-conflicts` - コンフリクト解決
