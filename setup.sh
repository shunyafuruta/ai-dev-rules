#!/bin/bash

set -e

# AI開発環境セットアップスクリプト
# 使い方: ./setup.sh [プロジェクトディレクトリ]

# 色の定義
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# このスクリプトがあるディレクトリ（ai-dev-rules/）
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# プロジェクトディレクトリ（引数で指定、デフォルトはカレントディレクトリ）
PROJECT_DIR="${1:-.}"
PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"

echo -e "${BLUE}=====================================${NC}"
echo -e "${BLUE}   AI開発環境セットアップ${NC}"
echo -e "${BLUE}=====================================${NC}"
echo ""
echo -e "${GREEN}セットアップ先:${NC} $PROJECT_DIR"
echo ""

# プロジェクトタイプを選択
echo -e "${CYAN}プロジェクトタイプを選択してください:${NC}"
echo ""
echo -e "  ${CYAN}1.${NC} モノリポ（Turborepo）"
echo -e "     ${YELLOW}→${NC} Web + API + 共有パッケージ"
echo -e "     ${YELLOW}→${NC} 推奨: フルスタックアプリ、マイクロサービス"
echo ""
echo -e "  ${CYAN}2.${NC} Web アプリのみ"
echo -e "     ${YELLOW}→${NC} React + TypeScript + Vite"
echo -e "     ${YELLOW}→${NC} 推奨: フロントエンドのみ、SPA"
echo ""
echo -e "  ${CYAN}3.${NC} API サーバーのみ"
echo -e "     ${YELLOW}→${NC} Express + TypeScript + Prisma"
echo -e "     ${YELLOW}→${NC} 推奨: バックエンドのみ、REST API"
echo ""
echo -e "  ${CYAN}4.${NC} 基本セットアップのみ"
echo -e "     ${YELLOW}→${NC} AI開発環境のみ（プロジェクト構造なし）"
echo -e "     ${YELLOW}→${NC} 推奨: 既存プロジェクトへの導入"
echo ""
read -p "選択 [1-4]: " -n 1 -r PROJECT_TYPE
echo ""
echo ""

# プロジェクトタイプの検証
if [[ ! $PROJECT_TYPE =~ ^[1-4]$ ]]; then
    echo -e "${RED}無効な選択です。${NC}"
    exit 1
fi

# 確認
echo -e "${YELLOW}このセットアップを開始しますか？ (y/N):${NC} "
read -p "" -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}キャンセルしました。${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}=====================================${NC}"
echo -e "${BLUE}   セットアップ開始${NC}"
echo -e "${BLUE}=====================================${NC}"
echo ""

# 基本セットアップ（全プロジェクトタイプ共通）
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

# プロジェクト構造のセットアップ
echo ""
echo -e "${BLUE}[8/8] プロジェクト構造を作成中...${NC}"

case $PROJECT_TYPE in
    1)
        # モノリポ（Turborepo）
        echo -e "${CYAN}  モノリポ構成を作成します...${NC}"
        mkdir -p "$PROJECT_DIR/apps/web" "$PROJECT_DIR/apps/api" "$PROJECT_DIR/packages/shared"
        mkdir -p "$PROJECT_DIR/specification/api" "$PROJECT_DIR/specification/database" "$PROJECT_DIR/specification/ui"
        echo -e "${GREEN}  ✓ モノリポ構造を作成しました${NC}"
        echo -e "${YELLOW}  → apps/web/    (React + Vite)${NC}"
        echo -e "${YELLOW}  → apps/api/    (Express + Prisma)${NC}"
        echo -e "${YELLOW}  → packages/shared/ (共有コード)${NC}"
        ;;
    2)
        # Web アプリのみ
        echo -e "${CYAN}  Web アプリ構成を作成します...${NC}"
        mkdir -p "$PROJECT_DIR/src"
        mkdir -p "$PROJECT_DIR/specification/ui"
        echo -e "${GREEN}  ✓ Web アプリ構造を作成しました${NC}"
        echo -e "${YELLOW}  → src/ (React + Vite)${NC}"
        ;;
    3)
        # API サーバーのみ
        echo -e "${CYAN}  API サーバー構成を作成します...${NC}"
        mkdir -p "$PROJECT_DIR/src"
        mkdir -p "$PROJECT_DIR/prisma"
        mkdir -p "$PROJECT_DIR/specification/api" "$PROJECT_DIR/specification/database"
        echo -e "${GREEN}  ✓ API サーバー構造を作成しました${NC}"
        echo -e "${YELLOW}  → src/ (Express + TypeScript)${NC}"
        echo -e "${YELLOW}  → prisma/ (Prisma スキーマ)${NC}"
        ;;
    4)
        # 基本セットアップのみ
        echo -e "${CYAN}  基本セットアップのみ（プロジェクト構造なし）${NC}"
        echo -e "${GREEN}  ✓ 基本セットアップ完了${NC}"
        ;;
esac

echo ""
echo -e "${GREEN}=====================================${NC}"
echo -e "${GREEN}   ✓ セットアップが完了しました！${NC}"
echo -e "${GREEN}=====================================${NC}"
echo ""
echo -e "${BLUE}次のステップ:${NC}"
echo ""

# プロジェクトタイプ別の次のステップ
case $PROJECT_TYPE in
    1)
        echo -e "${CYAN}1. プロジェクト固有の設定をカスタマイズ:${NC}"
        echo "   - CLAUDE.md の「プロジェクト概要」セクションを編集"
        echo "   - .cursor/rules/general.mdc の技術スタックを編集"
        echo ""
        echo -e "${CYAN}2. 初期ファイルを作成:${NC}"
        echo "   - apps/web/package.json, apps/web/vite.config.ts"
        echo "   - apps/api/package.json, apps/api/src/index.ts"
        echo "   - packages/shared/package.json"
        echo "   - package.json (ルート)"
        echo "   - turbo.json"
        echo ""
        echo -e "${CYAN}3. 依存関係をインストール:${NC}"
        echo "   npm install"
        ;;
    2)
        echo -e "${CYAN}1. プロジェクト固有の設定をカスタマイズ:${NC}"
        echo "   - CLAUDE.md の「プロジェクト概要」セクションを編集"
        echo ""
        echo -e "${CYAN}2. Vite プロジェクトを初期化:${NC}"
        echo "   npm create vite@latest . -- --template react-ts"
        ;;
    3)
        echo -e "${CYAN}1. プロジェクト固有の設定をカスタマイズ:${NC}"
        echo "   - CLAUDE.md の「プロジェクト概要」セクションを編集"
        echo ""
        echo -e "${CYAN}2. package.json と Prisma スキーマを作成:${NC}"
        echo "   npm init -y"
        echo "   npx prisma init"
        ;;
    4)
        echo -e "${CYAN}1. プロジェクト固有の設定をカスタマイズ:${NC}"
        echo "   - CLAUDE.md の「プロジェクト概要」セクションを編集"
        echo "   - .cursor/rules/general.mdc の技術スタックを編集"
        ;;
esac

echo ""
echo -e "${CYAN}4. GitHubリポジトリ名を更新（必要に応じて）:${NC}"
echo "   find .cursor/commands -type f -name '*.md' -exec sed -i '' 's/kizuki-dsd\/manabi/your-org\/your-repo/g' {} +"
echo ""
echo -e "${CYAN}5. 階層型AI開発チームを使用:${NC}"
echo "   cd agents/pm && claude     # PMとして起動"
echo "   cd agents/coder && claude  # Coderとして起動"
echo "   cd agents/reviewer && claude  # Reviewerとして起動"
echo ""
echo -e "${CYAN}6. 1on1 & PDCA サイクルを開始:${NC}"
echo "   /daily-standup      # 日次スタンドアップ"
echo "   /retrospective      # 週次振り返り"
echo "   /team-metrics       # メトリクス更新"
echo ""
echo -e "${GREEN}Happy coding with AI! 🚀${NC}"
