# AI開発環境セットアップ用 Makefile

.PHONY: help setup install clean

# デフォルトターゲット
help:
	@echo "AI開発環境セットアップ"
	@echo ""
	@echo "使い方:"
	@echo "  make setup [PROJECT=/path/to/project]  - AI開発環境をセットアップ"
	@echo "  make install [PROJECT=/path/to/project] - setup のエイリアス"
	@echo "  make clean [PROJECT=/path/to/project]   - セットアップしたファイルを削除"
	@echo ""
	@echo "例:"
	@echo "  make setup PROJECT=~/my-project"
	@echo "  make setup  # カレントディレクトリにセットアップ"

# プロジェクトディレクトリ（デフォルトはカレントディレクトリ）
PROJECT ?= .

# セットアップ
setup:
	@./setup.sh $(PROJECT)

# install は setup のエイリアス
install: setup

# クリーンアップ（慎重に使用）
clean:
	@echo "⚠️  以下のファイル・ディレクトリを削除します:"
	@echo "  - $(PROJECT)/.cursor"
	@echo "  - $(PROJECT)/.claude"
	@echo "  - $(PROJECT)/CLAUDE.md"
	@echo "  - $(PROJECT)/agents"
	@echo "  - $(PROJECT)/state"
	@echo "  - $(PROJECT)/reference"
	@read -p "本当に削除しますか？ (y/N): " confirm && [ "$$confirm" = "y" ] || exit 1
	@rm -rf $(PROJECT)/.cursor
	@rm -rf $(PROJECT)/.claude
	@rm -f $(PROJECT)/CLAUDE.md
	@rm -rf $(PROJECT)/agents
	@rm -rf $(PROJECT)/state
	@rm -rf $(PROJECT)/reference
	@echo "✓ クリーンアップが完了しました"
