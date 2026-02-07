#!/bin/bash
# 完全自動開発スクリプト
# PM起動 → Issue作成 → 並列Coder起動をワンコマンドで実行

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"
BACKLOG_FILE="$PROJECT_ROOT/state/backlog.md"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🚀 自動開発システムを起動します"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Step 1: PMを起動
echo "📍 Step 1/3: PMエージェントを起動中..."
"$PROJECT_ROOT/start-pm.sh"

# Step 2: PMがIssueを作成するまで待機
echo ""
echo "📍 Step 2/3: PMがIssueを作成するまで待機中..."
echo "   （backlog.md が更新されるまで監視します）"
echo ""

# backlog.md の初期タイムスタンプを記録
if [ -f "$BACKLOG_FILE" ]; then
    INITIAL_TIMESTAMP=$(stat -f "%m" "$BACKLOG_FILE" 2>/dev/null || stat -c "%Y" "$BACKLOG_FILE" 2>/dev/null)
else
    INITIAL_TIMESTAMP=0
fi

TIMEOUT=300  # 5分でタイムアウト
ELAPSED=0
WAIT_INTERVAL=5

while [ $ELAPSED -lt $TIMEOUT ]; do
    if [ -f "$BACKLOG_FILE" ]; then
        CURRENT_TIMESTAMP=$(stat -f "%m" "$BACKLOG_FILE" 2>/dev/null || stat -c "%Y" "$BACKLOG_FILE" 2>/dev/null)

        if [ "$CURRENT_TIMESTAMP" != "$INITIAL_TIMESTAMP" ]; then
            echo "✅ backlog.md が更新されました！"
            sleep 5  # 書き込み完了を待つ
            break
        fi
    fi

    echo "⏳ 待機中... ($ELAPSED 秒経過)"
    sleep $WAIT_INTERVAL
    ELAPSED=$((ELAPSED + WAIT_INTERVAL))
done

if [ $ELAPSED -ge $TIMEOUT ]; then
    echo "⚠️  タイムアウト: PMがIssueを作成しませんでした"
    echo "💡 手動でPMを確認してください: tmux attach -t ai-dev-pm"
    exit 1
fi

# Step 3: 並列Coderを起動
echo ""
echo "📍 Step 3/3: 並列Coderを起動中..."
"$PROJECT_ROOT/run-parallel-coders.sh"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ 自動開発システムが稼働しています！"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📺 各エージェントの作業を見るには:"
echo "  PM:      tmux attach -t ai-dev-pm"
echo "  Coder:   tmux ls | grep coder-issue"
echo ""
echo "📊 進捗確認:"
echo "  gh pr list"
echo "  gh issue list --label in-progress"
echo ""
echo "🛑 全エージェントを停止するには:"
echo "  tmux kill-server"
echo ""
