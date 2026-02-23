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

2. **ブランチを作成**: developブランチから作業ブランチを作成
   - ブランチ命名: `issue-<番号>-<機能名>`（英語ケバブケース）

3. **必要な仕様書だけ読む**: Issueに記載された参照仕様書のみ読み込む
   - 全仕様書を読まない。Issue内の「参照すべき仕様書」パスだけを読むこと
   - コーディング規約は CLAUDE.md の「コーディング規約」セクションを参照

4. **実装**: Issueの要件を満たすコードを実装
   - Named Export使用（Default Export禁止）
   - JSDocは日本語で記述
   - constのみ使用（let禁止）

5. **コミット**: git add & commit
   ```
   [タイトル]

   Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
   ```

6. **PRを作成**: developブランチへのPRを作成
   - タイトル: Issue内容を反映
   - 本文: Summary（箇条書き）、`Closes #$ARGUMENTS`、Test plan

7. **レビューリクエスト**: PRコメントに `@claude レビューして` を追加

実装を開始してください。
