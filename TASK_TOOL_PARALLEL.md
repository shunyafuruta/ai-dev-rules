# Task Tool ベース並列開発システム

**Claude CodeのTask toolを使った、安全でシンプルな並列開発システム**

---

## ✨ 特徴

- ✅ **信頼確認は1回だけ**: メインのClaude Codeセッションのみ
- ✅ **自動並列実行**: Task toolが複数のCoderを自動起動
- ✅ **tmux不要**: 複雑なセッション管理が不要
- ✅ **セキュリティ**: 信頼設定を自動化しない

---

## 🚀 使い方

### ステップ1: Claude Codeを起動

```bash
cd /Users/shunyafuruta/Desktop/civic-business-system
claude
```

### ステップ2: PMオーケストレーターを実行

Claude Codeのプロンプトで：

```
/pm-orchestrator
```

これで以下が自動実行されます：
1. ✅ PMが `specification/` の設計書を読む
2. ✅ 並列実装可能なIssueを作成（最大5個）
3. ✅ Task toolで複数のCoderを並列起動（最大3個）
4. ✅ 各CoderがIssueを実装してPRを作成

---

## 📊 実行フロー

```
あなた: /pm-orchestrator
    ↓
PM: specification/ の設計書を読む
    ↓
PM: Issue #101, #102, #103 を作成
    ↓
PM: Task tool で 3つのCoder を並列起動
    ↓
Coder1 (Task 1): Issue #101 を実装 → PR作成
Coder2 (Task 2): Issue #102 を実装 → PR作成
Coder3 (Task 3): Issue #103 を実装 → PR作成
    ↓
あなた: PRをレビュー・マージ
```

---

## 🔍 進捗確認

### Issue一覧

```bash
gh issue list --label ready,in-progress
```

### PR一覧

```bash
gh pr list
```

### 実行中のタスク

Claude Codeの画面で、Task toolの進捗が表示されます。

---

## ⚙️ 設定

### 並列Coder数の変更

`.claude/commands/pm-orchestrator.md` の以下の部分を編集：

```markdown
**最大5個のIssue**を作成してください（並列実行のため）。
```

↓

```markdown
**最大10個のIssue**を作成してください（並列実行のため）。
```

---

## 🆚 tmuxベースとの比較

| 項目 | Task tool ベース | tmux ベース |
|------|-----------------|-------------|
| 信頼確認 | 1回のみ | 各セッションごと |
| セキュリティ | ✅ 安全 | ⚠️ 自動化必要 |
| 管理の複雑さ | ✅ シンプル | ❌ 複雑 |
| 並列実行 | ✅ 自動 | ⚠️ 手動起動 |
| 独立性 | △ 親子関係 | ✅ 完全独立 |
| リソース | ✅ 軽量 | ❌ 重い |

---

## 🧪 テスト方法

### 小規模テスト（推奨）

まず1つのIssueで試す：

```
specification/ui/screen-list.md を読んで、1つのIssueを作成し、Coderに実装させてください。
```

### 本番実行

```
/pm-orchestrator
```

---

## 📝 ログ確認

Claude Codeの画面で、各Taskの実行ログが表示されます。

---

## 🛑 停止方法

実行中のTaskを停止する場合：
- Claude Codeで `Ctrl+C` を押す
- または、新しいメッセージで「停止してください」と指示

---

## 💡 Tips

### Issue作成のコツ

PMに明確な指示を出す：

```
specification/ を読んで、以下の方針でIssueを作成してください:
- 1 Issue = 1〜2時間で完了できる粒度
- フロントエンド/バックエンドは別Issue
- 依存関係を明記
- 並列実装可能なものから優先
```

### 並列実行の効率化

- **独立したタスクを優先**: 依存関係がないタスクから実装
- **小さく作る**: 1 Issueを小さくして並列度を上げる
- **段階的に実行**: Phase 1（API）→ Phase 2（UI）のように分ける

---

**Happy Task Tool Development! 🚀**
