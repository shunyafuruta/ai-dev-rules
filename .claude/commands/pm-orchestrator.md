---
description: PMとして設計書を読んでIssueを作成し、Coderを並列起動
tags: [pm, orchestrator, parallel]
---

# PM Orchestrator - 並列開発オーケストレーター

あなたは**PM（プロジェクトマネージャー）**として、以下のステップを実行してください。

## ステップ1: 設計書を読む

`specification/` ディレクトリ内のすべての設計書を読み込んで理解してください：

```bash
ls specification/**/*.md
```

特に以下を優先的に読んでください：
- `specification/requirements/system-overview.md`
- `specification/ui/screen-list.md`
- その他すべての `.md` ファイル

## ステップ2: タスク分解とIssue作成

設計書の内容を、**並列実装可能な単位**に分解してIssueを作成してください。

### 並列化の基準
- ✅ **ファイル単位で独立**: 異なるファイルを触るタスクは並列化可能
- ✅ **機能単位で独立**: 認証機能 / 検索機能 / 通知機能など
- ✅ **層ごとに独立**: フロントエンド / バックエンド / データベース
- ❌ **依存関係あり**: 「Aが完了しないとBができない」場合は順次実行

### Issue粒度
- 1 Issue = 30分〜2時間で完了できる量
- 目安: 1〜5ファイルの変更
- 大きすぎる場合は分割

### Issue作成

```bash
gh issue create \
  --title "タイトル" \
  --body "本文（概要・実装内容・完了条件・依存関係を含む）" \
  --label "ready,feature"
```

**最大5個のIssue**を作成してください（並列実行のため）。

## ステップ3: 並列実装可能なIssueをリストアップ

作成したIssueのうち、**並列実装可能なもの**（依存関係がないもの）を最大3個選んでください。

Issue番号をメモ：
- Issue #XXX
- Issue #YYY
- Issue #ZZZ

## ステップ4: Coderを並列起動（Task toolを使用）

**重要**: ここからTask toolを使って、複数のCoderエージェントを**並列**で起動します。

**1つのメッセージで複数のTask toolを呼び出してください**（並列実行のため）。

各Taskには以下を指定：
- `subagent_type: "general-purpose"`
- `description: "Issue #XXX を実装"`
- `prompt`: 以下のテンプレートを使用

### Coderへの指示（promptテンプレート）

```
あなたはCoderとして、Issue #XXX を実装してください。

1. Issueを確認:
   gh issue view XXX

2. featureブランチを作成:
   git checkout -b issue-XXX-<機能名>

3. 実装を開始:
   - Issueの完了条件をすべて満たす
   - コーディング規約に従う（CLAUDE.mdを参照）
   - 小さく作って動作確認を繰り返す

4. コミット:
   git add .
   git commit -m "feat: 機能を追加

   - 詳細1
   - 詳細2

   Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"

5. プッシュとPR作成:
   git push -u origin issue-XXX-<機能名>
   gh pr create --base develop --title "タイトル" --body "Closes #XXX"

6. 完了報告:
   実装が完了したら、PRのURLを報告してください。
```

### 並列実行の例

**3つのCoderを同時に起動する場合は、以下のように1つのメッセージで3つのTask toolを呼び出してください：**

```
<Task tool 1: Issue #123を実装>
<Task tool 2: Issue #124を実装>
<Task tool 3: Issue #125を実装>
```

## ステップ5: 進捗管理

各Coderの作業が完了したら：
1. PRがマージされたか確認
2. 次の並列実装可能なIssueがあれば、再度Coderを起動

## 注意事項

- **コードは書かない**（それはCoderの仕事）
- **並列化を意識**（依存関係を明確に）
- **Issueは具体的に**（Coderが迷わないように）
- **Task toolは並列実行**（1つのメッセージで複数呼び出し）

---

## 実行例

1. 設計書を読む
2. Issue #101, #102, #103を作成（すべて並列実装可能）
3. Task toolで3つのCoderを並列起動
4. 各Coderが実装してPRを作成
5. レビュー・マージ
