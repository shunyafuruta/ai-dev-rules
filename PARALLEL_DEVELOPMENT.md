# 並列開発システム - 使い方ガイド

**設計書をPMが読んで必要なIssueを立て、Coderが並列実装する自動化システム**

---

## 🎯 システム構成

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

---

## ⚡ クイックスタート

### 方法1: 完全自動（推奨）

**ワンコマンドですべて自動実行:**

```bash
cd .ai-dev-rules
./auto-dev.sh
```

これで以下が自動的に実行されます:
1. PMエージェントが起動して設計書を読む
2. PMがIssueを作成して `state/backlog.md` に記録
3. 並列実装可能なIssueを検出
4. 複数のCoderが並列でIssueを実装

---

### 方法2: 手動ステップ（細かく制御したい場合）

#### Step 1: PMを起動してIssueを作成

```bash
cd .ai-dev-rules
./start-pm.sh
```

PMの作業を確認:

```bash
tmux attach -t ai-dev-pm
```

PMが `state/backlog.md` を更新するまで待つ。

#### Step 2: 並列Coderを起動

```bash
./run-parallel-coders.sh
```

各Coderの作業を確認:

```bash
# Coderのtmuxセッション一覧を表示
tmux ls | grep coder-issue

# 特定のCoderにアタッチ（例: Issue #123を実装中のCoder）
tmux attach -t coder-issue-123
```

---

## 📁 前提条件

### 1. 設計書を配置

`reference/` ディレクトリに設計書を配置してください:

```
reference/
├── requirements/
│   ├── spec.md          # 要件定義書
│   └── user-story.md    # ユーザーストーリー
├── design/
│   ├── architecture.md  # アーキテクチャ設計
│   └── database.md      # データベース設計
└── api/
    └── api-spec.md      # API仕様書
```

### 2. 必要なツールのインストール

```bash
# tmux
brew install tmux

# GitHub CLI
brew install gh

# Claude Code
# https://code.claude.com/ からインストール
```

---

## ⚙️ 設定

### 並列Coder数の変更

`run-parallel-coders.sh` の `MAX_PARALLEL_CODERS` を編集:

```bash
MAX_PARALLEL_CODERS=3  # デフォルト: 3
```

推奨値:
- **3〜5**: 通常のプロジェクト
- **8〜10**: 大規模プロジェクト（Zennの記事と同じ）

---

## 📊 進捗確認

### Issue一覧

```bash
gh issue list --label ready,in-progress
```

### PR一覧

```bash
gh pr list
```

### backlog.md を確認

```bash
cat state/backlog.md
```

### tmuxセッション一覧

```bash
tmux ls
```

---

## 🛑 停止方法

### 特定のCoderを停止

```bash
tmux kill-session -t coder-issue-123
```

### PMを停止

```bash
tmux kill-session -t ai-dev-pm
```

### 全エージェントを停止

```bash
tmux kill-server
```

---

## 🔧 トラブルシューティング

### PMがIssueを作成しない

**原因:** 設計書が見つからない、または内容が不明確

**対処法:**
1. `reference/` ディレクトリに設計書があるか確認
2. PMのtmuxセッションにアタッチして手動で指示:
   ```bash
   tmux attach -t ai-dev-pm
   ```
3. PMに直接指示を送る:
   ```
   reference/requirements/spec.md を読んで、Issueを作成してください
   ```

---

### Coderが起動しない

**原因:** `state/backlog.md` に並列実装可能なIssueがない

**対処法:**
1. `state/backlog.md` を確認:
   ```bash
   cat state/backlog.md
   ```
2. 「## 並列実装可能（Ready）」セクションにIssueがあるか確認
3. なければPMにIssueを作成してもらう

---

### tmuxセッションが見つからない

**原因:** tmuxが起動していない、またはセッション名が間違っている

**対処法:**
```bash
# セッション一覧を表示
tmux ls

# セッション名を確認してアタッチ
tmux attach -t <セッション名>
```

---

### CoderがIssueを実装できない

**原因:** Issueの内容が不明確、または依存関係が解決していない

**対処法:**
1. Coderのtmuxセッションにアタッチ:
   ```bash
   tmux attach -t coder-issue-123
   ```
2. エラーメッセージを確認
3. Issueの内容を修正:
   ```bash
   gh issue edit 123
   ```

---

## 📖 仕組みの詳細

### Zennの記事との対応

| Zennの記事 | このシステム |
|-----------|------------|
| 将軍（メインエージェント） | PM（設計書読み→Issue作成） |
| 家老（サブマネージャー） | （不要） |
| 足軽8名（ワーカー） | Coder × N（並列実装） |
| YAMLファイルベース通信 | state/backlog.md（Markdown） |
| tmux send-keys | tmux send-keys で `/issue <番号>` |
| イベント駆動 | auto-dev.sh でファイル監視 |

### send-keys の2回分割ルール

Zennの記事で重要なポイント:

> tmuxへのコマンド送信時、メッセージとEnterキーを分割して実行しないと機能しません

このシステムでも同様に実装:

```bash
tmux send-keys -t "$session_name" "/issue $issue_num"  # コマンドを送信
sleep 0.5                                                # 少し待機
tmux send-keys -t "$session_name" C-m                   # Enterキーを送信
```

---

## 🚀 今後の拡張

### Reviewerの自動化

現在はCoderのみ並列実装していますが、Reviewerも自動化可能:

1. PRが作成されたらGitHub Actions/webhookでReviewerを起動
2. Reviewerが自動レビュー
3. 承認 or 差し戻し

### ダッシュボード

進捗をリアルタイム表示:

```bash
watch -n 5 'gh issue list --label in-progress && gh pr list'
```

---

## 💡 Tips

### Issue作成のコツ

PMに明確な指示を出す:

```
reference/requirements/spec.md を読んで、以下の方針でIssueを作成してください:
- 1 Issue = 1〜2時間で完了できる粒度
- フロントエンド/バックエンドは別Issue
- 依存関係を明記
```

### 並列実装の効率化

- **独立したタスクを優先**: 依存関係がないタスクから実装
- **層ごとに分離**: API → UI の順で実装すると効率的
- **小さく作る**: 1 Issueを小さくして並列度を上げる

---

**Happy Parallel Development! 🚀**
