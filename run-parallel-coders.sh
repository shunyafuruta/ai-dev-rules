#!/bin/bash
# 並列Coder実行スクリプト
# state/backlog.md から並列実装可能なIssueを取得し、複数のCoderを起動して並列実装

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"
BACKLOG_FILE="$PROJECT_ROOT/state/backlog.md"
MAX_PARALLEL_CODERS=3  # 同時実行するCoderの数（調整可能）

echo "🤖 並列Coder実行システムを起動します..."

# backlog.md が存在するか確認
if [ ! -f "$BACKLOG_FILE" ]; then
    echo "❌ エラー: $BACKLOG_FILE が見つかりません"
    exit 1
fi

# backlog.md から並列実装可能なIssue番号を抽出
# "## 並列実装可能（Ready）" セクションから Issue番号を取得
extract_ready_issues() {
    awk '
        /^## 並列実装可能/ { in_ready=1; next }
        /^## / { in_ready=0 }
        in_ready && /^\| #[0-9]+/ {
            match($0, /#([0-9]+)/, arr)
            print arr[1]
        }
    ' "$BACKLOG_FILE"
}

READY_ISSUES=($(extract_ready_issues))

if [ ${#READY_ISSUES[@]} -eq 0 ]; then
    echo "ℹ️  並列実装可能なIssueがありません"
    echo "💡 PMにIssueを作成してもらってください"
    exit 0
fi

echo "📋 並列実装可能なIssue: ${READY_ISSUES[*]}"
echo "🔧 最大並列数: $MAX_PARALLEL_CODERS"

# 並列実行するIssueを決定
ISSUES_TO_RUN=("${READY_ISSUES[@]:0:$MAX_PARALLEL_CODERS}")
echo "🚀 実行するIssue: ${ISSUES_TO_RUN[*]}"

# 各IssueごとにCoder tmuxセッションを起動
for issue_num in "${ISSUES_TO_RUN[@]}"; do
    session_name="coder-issue-$issue_num"

    echo "🔨 起動中: Coder for Issue #$issue_num (tmux: $session_name)"

    # 既存セッションがあれば削除
    tmux kill-session -t "$session_name" 2>/dev/null || true

    # 新しいセッションを作成
    tmux new-session -d -s "$session_name" -c "$PROJECT_ROOT/agents/coder"

    # Claude Codeを起動
    tmux send-keys -t "$session_name" "claude" C-m

    # Claude Codeの起動を待つ
    sleep 3

    # /issue コマンドを実行（2回に分けて送信: Zennの記事の重要ポイント）
    tmux send-keys -t "$session_name" "/issue $issue_num"
    sleep 0.5
    tmux send-keys -t "$session_name" C-m

    echo "✅ 起動完了: Coder for Issue #$issue_num"
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ ${#ISSUES_TO_RUN[@]} 個のCoderを並列起動しました！"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📺 各Coderの作業を見るには:"
for issue_num in "${ISSUES_TO_RUN[@]}"; do
    echo "  tmux attach -t coder-issue-$issue_num"
done
echo ""
echo "🛑 全Coderを停止するには:"
for issue_num in "${ISSUES_TO_RUN[@]}"; do
    echo "  tmux kill-session -t coder-issue-$issue_num"
done
echo ""
echo "📊 進捗確認:"
echo "  gh pr list"
echo ""
