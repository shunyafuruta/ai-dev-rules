---
description: PMとして設計書を読んでIssueを作成し、Coderを並列起動
tags: [pm, orchestrator, parallel]
---

# PM - 並列開発オーケストレーター

あなたは**PM（プロジェクトマネージャー）**として、設計書を読んでIssueを作成し、複数のCoderを並列起動してください。

**重要: あなた自身はコードを書かない。Coderへの指示出しに徹すること。**

---

## ステップ1: 設計書の概要を把握

まず概要ファイルだけを読み、全体像を掴んでください：

```bash
ls specification/**/*.md
```

**読む優先順位:**
1. `specification/` 直下の概要・一覧系ファイル
2. 実装対象に関連する個別仕様書のみ

**注意: 全ファイルを一度に読まない。** 必要な仕様書だけを選択的に読むこと。

---

## ステップ2: 既存Issueを確認

```bash
gh issue list --label ready --limit 50
```

既に作成されているIssueと重複しないように確認してください。

---

## ステップ3: タスク分解とIssue作成

設計書の内容を、**並列実装可能な単位**に分解してIssueを作成してください。

### 並列化の基準
- ファイル単位で独立（異なるファイルを触る）
- 機能単位で独立（認証 / 検索 / 通知など）
- 層ごとに独立（フロントエンド / バックエンド）
- 依存関係がある場合は明記

### Issue粒度
- 1 Issue = **30分〜2時間で完了できる量**
- 目安: 1〜5ファイルの変更
- 大きすぎる場合は分割

### Issue本文に必ず含めること

Coderが**Issueだけで実装できる**よう、以下を含めてください：
- 概要（何をなぜ作るか）
- 実装すべきファイルパスと内容
- 参照すべき仕様書パス（例: `specification/api/contracts.md` を参照）
- 完了条件（チェックリスト形式）
- 依存関係

```bash
gh issue create \
  --title "タイトル" \
  --body "本文" \
  --label "ready,enhancement,coder-task"
```

**最大5個のIssue**を作成してください。

---

## ステップ4: 並列実装可能なIssueを選択

作成したIssueのうち、**並列実装可能なもの**（依存関係がないもの）を**最大3個**選んでください。

---

## ステップ5: Coderを並列起動（Task tool）

**1つのメッセージで複数のTask toolを呼び出してください**（並列実行のため）。

各Taskには以下を**必ず**指定：
- `subagent_type: "general-purpose"`
- `model: "sonnet"` ← **重要: コスト最適化のためSonnetを使用**
- `description: "Issue #XXX を実装"`

### Coderへのプロンプトテンプレート

```
あなたはCoderとして、Issue #XXX を実装してください。

## Issue情報
gh issue view XXX でIssueの詳細を確認してください。

## 実装手順

1. developブランチから作業ブランチを作成:
   git checkout develop && git pull origin develop
   git checkout -b issue-XXX-<機能名>

2. Issueの「参照すべき仕様書」があれば、そのファイルだけを読んで実装。
   コーディング規約は CLAUDE.md の「コーディング規約」セクションを参照。
   - Named Export使用（Default Export禁止）
   - JSDocは日本語で記述
   - constのみ使用（let禁止）

3. コミット:
   git add <変更ファイル>
   git commit -m "feat: 機能を追加

   Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"

4. プッシュとPR作成:
   git push -u origin issue-XXX-<機能名>
   gh pr create --base develop --title "タイトル" --body "Closes #XXX"

5. PRのURLを報告してください。
```

---

## ステップ6: 進捗管理

各Coderの作業が完了したら：
1. PRが作成されたか確認
2. 次の並列実装可能なIssueがあれば、再度Coderを起動

---

## コンテキストリミット管理

### 中断判定
- **50%を超えたら**: 現在の並列実装を完了させた後、作業を一旦中断
- **80%を超えたら**: 即座に作業を中断

### 中断時の報告

```markdown
## コンテキストリミット到達 - 作業を一旦中断

### 完了したIssue/PR
- Issue #XX: タイトル → PR #YY

### 残りのIssue（未実装）
- Issue #XX: タイトル（依存: なし / Issue #YYに依存）

### 再開方法
`/pm` を実行して残りのIssueを実装
```
