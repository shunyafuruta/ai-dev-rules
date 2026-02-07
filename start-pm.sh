#!/bin/bash
# PM起動スクリプト
# PMエージェントを起動して、設計書を読んでIssueを作成させる

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"
PM_DIR="$PROJECT_ROOT/agents/pm"
PM_SESSION="ai-dev-pm"

echo "🧑‍💼 PMエージェントを起動します..."

# 既存セッションがあれば削除
tmux kill-session -t "$PM_SESSION" 2>/dev/null || true

# 新しいセッションを作成
tmux new-session -d -s "$PM_SESSION" -c "$PM_DIR"

# Claude Codeを起動
tmux send-keys -t "$PM_SESSION" "claude" C-m

# Claude Codeの起動を待つ
sleep 3

# PMに指示を送る
INSTRUCTION="reference/ ディレクトリの設計書をすべて読んで、並列実装可能なIssueに分解してください。Issue作成後、state/backlog.md を更新してください。"

tmux send-keys -t "$PM_SESSION" "$INSTRUCTION"
sleep 0.5
tmux send-keys -t "$PM_SESSION" C-m

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ PMエージェントが起動しました！"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📺 PMの作業を見るには:"
echo "  tmux attach -t $PM_SESSION"
echo ""
echo "🛑 PMを停止するには:"
echo "  tmux kill-session -t $PM_SESSION"
echo ""
echo "⏭️  次のステップ:"
echo "  1. PMがIssueを作成するまで待つ（tmux attach で確認）"
echo "  2. ./run-parallel-coders.sh で並列実装を開始"
echo ""
