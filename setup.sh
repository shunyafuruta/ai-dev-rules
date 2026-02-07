#!/bin/bash

set -e

# AI開発環境セットアップスクリプト
# 使い方: ./setup.sh [プロジェクトディレクトリ]

# 色の定義
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# このスクリプトがあるディレクトリ（ai-dev-rules/）
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# プロジェクトディレクトリ（引数で指定、デフォルトはカレントディレクトリ）
PROJECT_DIR="${1:-.}"
PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"

echo -e "${BLUE}=====================================${NC}"
echo -e "${BLUE}AI開発環境セットアップ${NC}"
echo -e "${BLUE}=====================================${NC}"
echo ""
echo -e "${GREEN}セットアップ先:${NC} $PROJECT_DIR"
echo ""

# 確認
read -p "この場所にAI開発環境をセットアップしますか？ (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}キャンセルしました。${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}[1/8] .cursor/ ディレクトリをコピー中...${NC}"
if [ -d "$PROJECT_DIR/.cursor" ]; then
    echo -e "${YELLOW}  既存の .cursor/ が存在します。スキップします。${NC}"
else
    cp -r "$SCRIPT_DIR/.cursor" "$PROJECT_DIR/.cursor"
    echo -e "${GREEN}  ✓ .cursor/ をコピーしました${NC}"
fi

echo ""
echo -e "${BLUE}[2/8] .claude/ ディレクトリをコピー中...${NC}"
if [ -d "$PROJECT_DIR/.claude" ]; then
    echo -e "${YELLOW}  既存の .claude/ が存在します。スキップします。${NC}"
else
    cp -r "$SCRIPT_DIR/.claude" "$PROJECT_DIR/.claude"
    echo -e "${GREEN}  ✓ .claude/ をコピーしました${NC}"
fi

echo ""
echo -e "${BLUE}[3/8] CLAUDE.md をコピー中...${NC}"
if [ -f "$PROJECT_DIR/CLAUDE.md" ]; then
    echo -e "${YELLOW}  既存の CLAUDE.md が存在します。スキップします。${NC}"
else
    cp "$SCRIPT_DIR/CLAUDE.md" "$PROJECT_DIR/CLAUDE.md"
    echo -e "${GREEN}  ✓ CLAUDE.md をコピーしました${NC}"
fi

echo ""
echo -e "${BLUE}[4/8] agents/ ディレクトリを作成中...${NC}"
if [ -d "$PROJECT_DIR/agents" ]; then
    echo -e "${YELLOW}  既存の agents/ が存在します。スキップします。${NC}"
else
    cp -r "$SCRIPT_DIR/agents" "$PROJECT_DIR/agents"
    echo -e "${GREEN}  ✓ agents/ を作成しました${NC}"
fi

echo ""
echo -e "${BLUE}[5/8] state/ ディレクトリを作成中...${NC}"
if [ -d "$PROJECT_DIR/state" ]; then
    echo -e "${YELLOW}  既存の state/ が存在します。スキップします。${NC}"
else
    cp -r "$SCRIPT_DIR/state" "$PROJECT_DIR/state"
    echo -e "${GREEN}  ✓ state/ を作成しました${NC}"
fi

echo ""
echo -e "${BLUE}[6/8] reference/ ディレクトリを作成中...${NC}"
if [ -d "$PROJECT_DIR/reference" ]; then
    echo -e "${YELLOW}  既存の reference/ が存在します。スキップします。${NC}"
else
    mkdir -p "$PROJECT_DIR/reference"
    cp "$SCRIPT_DIR/reference/README.md" "$PROJECT_DIR/reference/README.md"
    cp "$SCRIPT_DIR/reference/.gitkeep" "$PROJECT_DIR/reference/.gitkeep"
    echo -e "${GREEN}  ✓ reference/ を作成しました${NC}"
fi

echo ""
echo -e "${BLUE}[7/8] .gitignore に reference/ を追加中...${NC}"
if [ -f "$PROJECT_DIR/.gitignore" ]; then
    if grep -q "reference/\*" "$PROJECT_DIR/.gitignore"; then
        echo -e "${YELLOW}  既に .gitignore に reference/ が追加されています。スキップします。${NC}"
    else
        cat >> "$PROJECT_DIR/.gitignore" << 'EOF'

# Reference directory (local resources only)
# 参照資料ディレクトリ（ローカルのみ、GitHubにはアップロードしない）
reference/*
!reference/.gitkeep
!reference/README.md
EOF
        echo -e "${GREEN}  ✓ .gitignore に追加しました${NC}"
    fi
else
    cat > "$PROJECT_DIR/.gitignore" << 'EOF'
# Reference directory (local resources only)
# 参照資料ディレクトリ（ローカルのみ、GitHubにはアップロードしない）
reference/*
!reference/.gitkeep
!reference/README.md
EOF
    echo -e "${GREEN}  ✓ .gitignore を作成しました${NC}"
fi

echo ""
echo -e "${BLUE}[8/8] GitHubリポジトリ名の設定...${NC}"
echo -e "${YELLOW}  .cursor/commands/ 内のリポジトリ名を更新してください。${NC}"
echo -e "${YELLOW}  例: find .cursor/commands -type f -name '*.md' -exec sed -i '' 's/kizuki-dsd\/manabi/your-org\/your-repo/g' {} +${NC}"

echo ""
echo -e "${GREEN}=====================================${NC}"
echo -e "${GREEN}✓ セットアップが完了しました！${NC}"
echo -e "${GREEN}=====================================${NC}"
echo ""
echo -e "${BLUE}次のステップ:${NC}"
echo ""
echo "1. プロジェクト固有の設定をカスタマイズ:"
echo "   - CLAUDE.md の「プロジェクト概要」セクションを編集"
echo "   - .cursor/rules/general.mdc の技術スタックを編集"
echo ""
echo "2. GitHubリポジトリ名を更新:"
echo "   cd $PROJECT_DIR"
echo "   find .cursor/commands -type f -name '*.md' -exec sed -i '' 's/kizuki-dsd\/manabi/your-org\/your-repo/g' {} +"
echo ""
echo "3. 階層型AI開発チームを使用する場合:"
echo "   cd agents/pm && claude     # PMとして起動"
echo "   cd agents/coder && claude  # Coderとして起動"
echo "   cd agents/reviewer && claude  # Reviewerとして起動"
echo ""
echo "4. 参照資料を配置:"
echo "   cp ~/Documents/要件定義.pdf $PROJECT_DIR/reference/requirements/"
echo ""
echo -e "${GREEN}Happy coding with AI! 🚀${NC}"
