---
description: Issueを読み解いて実装し、PRを作成してレビューリクエストを送る
argument-hint: [issue-number]
allowed-tools: Bash(gh issue view:*), Bash(gh pr view:*), Bash(gh pr create:*), Bash(gh pr comment:*), Bash(git checkout:*), Bash(git add:*), Bash(git commit:*), Bash(git push:*)
---

Issue #$ARGUMENTS を実装してください。

## Issue情報

!`gh issue view $ARGUMENTS`

## 実装手順

1. **Issueを理解する**: 上記のIssue内容を分析し、要件を明確にする

2. **ブランチを作成**: developブランチから適切な名前の新ブランチを作成
   - ブランチ命名: `feature/[機能名]`, `bugfix/[バグ名]`, `hotfix/[修正名]`
   - 英語ケバブケース（例: `feature/contract-search`）

3. **実装**: Issueの要件を満たすコードを実装
   - `specification/` に仕様書を作成・更新
   - CLAUDE.mdのコーディング規約を遵守
   - TodoWriteで進捗管理（複雑な場合）

4. **コミット**: git add & commit（以下の形式で）
   ```
   [タイトル]

   🤖 Generated with [Claude Code](https://claude.com/claude-code)

   Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
   ```

5. **PRを作成**: developブランチへのPRを作成
   - タイトル: Issue内容を反映
   - 本文: Summary（箇条書き）、`Closes #$ARGUMENTS`、Test plan
   - フッター: `🤖 Generated with [Claude Code](https://claude.com/claude-code)`

6. **レビューリクエスト**: PRコメントに `@claude レビューして` を追加

実装を開始してください。
