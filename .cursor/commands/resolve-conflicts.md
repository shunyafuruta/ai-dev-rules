---
name: コンフリクト解消
description: developブランチへのマージ時のコンフリクトを段階的に解消する
---

# Git コンフリクト解消支援

developブランチへのマージ時に発生したコンフリクトを安全に解消します。

## 使い方

```bash
/resolve-conflicts
```

## 動作概要

1. **現在の状況確認**: ブランチ、未コミット変更の確認
2. **developの最新取得**: `git fetch origin develop`
3. **マージ実行**: `git merge origin/develop`
4. **コンフリクト検出**: コンフリクトファイルの一覧表示
5. **解消支援**: 各ファイルのコンフリクト内容を分析して解消方法を提案
6. **解消後の確認**: テスト実行とコミット

## 前提条件

- 現在featureブランチにいること
- 作業内容がコミット済みであること
- 未コミットの変更がないこと

## 実行内容

### 1. 現在の状況確認

```bash
# 現在のブランチ確認
git branch --show-current

# 変更状況確認
git status

# コミット済みか確認
git diff --name-only
```

### 2. developの最新取得

```bash
git fetch origin develop
```

### 3. developをマージ

```bash
git merge origin/develop
```

### 4. コンフリクト検出

```bash
# コンフリクトファイル一覧
git diff --name-only --diff-filter=U

# 各ファイルの詳細表示
git diff [ファイル名]
```

### 5. 解消支援

各コンフリクトファイルについて：
- コンフリクトマーカー (`<<<<<<<`, `=======`, `>>>>>>>`) の説明
- 各箇所の変更内容の説明
- どちらを選ぶべきかの提案（可能な範囲で）
- エディタで開いて解消する手順

### 6. 解消後の確認

```bash
# ビルド・テスト実行
npm run typecheck
npm run lint
npm run build

# コンフリクト解消をコミット
git add .
git commit -m "chore: resolve merge conflicts with develop"
```

## コンフリクトマーカーの読み方

```
<<<<<<< HEAD
あなたの変更（現在のブランチの内容）
=======
developの変更（マージしようとしているブランチの内容）
>>>>>>> origin/develop
```

## よくあるコンフリクトパターンと解消方法

### パターン1: 同じファイルの同じ行を編集

**状況**: 両方のブランチで同じ行を異なる内容に変更

**解消方法**:
1. 両方の変更内容を確認
2. どちらが正しいか、または両方を統合すべきかを判断
3. 適切な内容にマージしてマーカーを削除

**例**:
```typescript
<<<<<<< HEAD
const API_ENDPOINT = 'https://api-dev.example.com';
=======
const API_ENDPOINT = 'https://api.example.com';
>>>>>>> origin/develop

// 解消後:
const API_ENDPOINT = 'https://api.example.com';  // developの変更を採用
```

### パターン2: package.jsonの依存関係

**状況**: 両方のブランチで異なるパッケージを追加

**解消方法**:
1. 両方のパッケージを確認
2. バージョンの競合がないか確認
3. 両方のパッケージを残す（両方必要な場合）
4. `npm install` を再実行

**例**:
```json
<<<<<<< HEAD
  "dependencies": {
    "react": "^19.0.0",
    "package-a": "^1.0.0"
  }
=======
  "dependencies": {
    "react": "^19.0.0",
    "package-b": "^2.0.0"
  }
>>>>>>> origin/develop

// 解消後:
  "dependencies": {
    "react": "^19.0.0",
    "package-a": "^1.0.0",
    "package-b": "^2.0.0"
  }
```

### パターン3: import文の順序

**状況**: import文の順序が異なる

**解消方法**:
1. 両方のimportを確認
2. アルファベット順に整理
3. 重複を削除

**例**:
```typescript
<<<<<<< HEAD
import { ComponentA } from '@/components/ComponentA';
import { ComponentC } from '@/components/ComponentC';
=======
import { ComponentB } from '@/components/ComponentB';
import { ComponentC } from '@/components/ComponentC';
>>>>>>> origin/develop

// 解消後:
import { ComponentA } from '@/components/ComponentA';
import { ComponentB } from '@/components/ComponentB';
import { ComponentC } from '@/components/ComponentC';
```

### パターン4: 削除と変更の競合

**状況**: 片方で削除、もう片方で変更

**解消方法**:
1. 削除した理由を確認
2. 変更した理由を確認
3. どちらが正しいか判断
4. 通常は変更を採用（削除が意図的な場合は削除）

## トラブルシューティング

### マージを中断したい場合

```bash
git merge --abort
```

マージをやり直したい場合に使用します。現在の状態をマージ前に戻します。

### 間違えて解消してしまった場合

```bash
# 最後のコミット前の状態に戻る
git reset --hard HEAD

# 再度マージ
git fetch origin develop
git merge origin/develop
```

### 特定のファイルを一括で解消したい場合

**自分の変更を優先**:
```bash
git checkout --ours [ファイル名]
git add [ファイル名]
```

**developの変更を優先**:
```bash
git checkout --theirs [ファイル名]
git add [ファイル名]
```

### コンフリクトマーカーの検索

```bash
# コンフリクトマーカーが残っていないか確認
grep -r "<<<<<<< HEAD" .
grep -r "=======" .
grep -r ">>>>>>>" .
```

## エラーハンドリング

- **未コミットの変更がある**: 「エラー: 未コミットの変更があります。先にコミットしてください」
- **featureブランチにいない**: 「警告: featureブランチにいません。このブランチでマージを続けますか？」
- **コンフリクトなし**: 「✅ コンフリクトはありません。マージは正常に完了しました」
- **マージ済み**: 「✅ developの変更はすでにマージ済みです」

## 注意事項

- コンフリクト解消前に必ず変更内容をコミットしてください
- 解消後は必ずビルド・テストを実行してください
- 不明な場合はチームメンバーに相談してください
- 重要な変更の場合はレビューを依頼してください

---

## 実装指示（Claude向け）

このコマンドが実行されたときの動作：

### ステップ1: 前提条件の確認

```bash
# 現在のブランチ確認
CURRENT_BRANCH=$(git branch --show-current)

# featureブランチかチェック
if [[ ! $CURRENT_BRANCH =~ ^feature/ ]]; then
  echo "⚠️ 警告: featureブランチにいません (現在: $CURRENT_BRANCH)"
  echo "このブランチでマージを続けますか？ (y/n)"
  # ユーザー入力待ち
fi

# 未コミットの変更確認
if [ -n "$(git status --porcelain)" ]; then
  echo "❌ エラー: 未コミットの変更があります"
  echo "先に変更をコミットしてください："
  git status
  exit 1
fi
```

### ステップ2: developの最新取得

```bash
echo "📡 developの最新を取得しています..."
git fetch origin develop

if [ $? -ne 0 ]; then
  echo "❌ エラー: developの取得に失敗しました"
  exit 1
fi

echo "✅ developの最新を取得しました"
```

### ステップ3: マージ実行

```bash
echo "🔀 origin/develop をマージしています..."
git merge origin/develop

MERGE_STATUS=$?
```

### ステップ4: マージ結果の判定

```typescript
if (mergeStatus === 0) {
  console.log('✅ マージが正常に完了しました（コンフリクトなし）');
  console.log('🎉 developの変更が正常にマージされました');
  return;
}

// コンフリクトが発生した場合
console.log('⚠️ コンフリクトが発生しました');
console.log('');
```

### ステップ5: コンフリクトファイルの検出と表示

```bash
# コンフリクトファイル一覧
CONFLICT_FILES=$(git diff --name-only --diff-filter=U)

if [ -z "$CONFLICT_FILES" ]; then
  echo "✅ コンフリクトはありません"
  exit 0
fi

echo "📋 コンフリクトが発生したファイル:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "$CONFLICT_FILES" | nl
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

FILE_COUNT=$(echo "$CONFLICT_FILES" | wc -l | tr -d ' ')
echo "合計: ${FILE_COUNT}件のファイルでコンフリクトが発生しています"
echo ""
```

### ステップ6: 各ファイルのコンフリクト分析

```typescript
for (const file of conflictFiles) {
  console.log(`\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`);
  console.log(`📄 ${file}`);
  console.log(`━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n`);

  // ファイル内容を読み取り
  const content = readFile(file);

  // コンフリクトマーカーを検出
  const conflicts = parseConflicts(content);

  console.log(`コンフリクト箇所: ${conflicts.length}箇所\n`);

  // 各コンフリクトを分析
  conflicts.forEach((conflict, index) => {
    console.log(`\n【コンフリクト ${index + 1}】`);
    console.log(`行番号: ${conflict.startLine}-${conflict.endLine}\n`);

    console.log('あなたの変更 (HEAD):');
    console.log('```');
    console.log(conflict.ours);
    console.log('```\n');

    console.log('developの変更:');
    console.log('```');
    console.log(conflict.theirs);
    console.log('```\n');

    // 解消方法の提案
    const suggestion = analyzeSuggestion(conflict, file);
    if (suggestion) {
      console.log('💡 解消方法の提案:');
      console.log(suggestion);
    }
  });

  console.log(`\n🔧 解消手順:`);
  console.log(`1. エディタでファイルを開く: ${file}`);
  console.log(`2. コンフリクトマーカー (<<<<<<<, =======, >>>>>>>) を確認`);
  console.log(`3. 適切な内容にマージ`);
  console.log(`4. マーカーを削除`);
}
```

### ステップ7: 解消方法の提案ロジック

```typescript
function analyzeSuggestion(conflict, filePath) {
  // package.jsonの場合
  if (filePath.endsWith('package.json')) {
    return '両方のパッケージを残すことを推奨します。依存関係を統合してください。';
  }

  // import文の場合
  if (conflict.ours.includes('import') && conflict.theirs.includes('import')) {
    return '両方のimportを残し、アルファベット順に整理してください。';
  }

  // 設定ファイルの場合
  if (filePath.includes('config') || filePath.includes('.env')) {
    return 'developの設定を優先することを推奨します。';
  }

  // デフォルト
  return '両方の変更内容を確認し、適切にマージしてください。';
}
```

### ステップ8: 解消後のガイダンス

```bash
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📝 次のステップ"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "1. 上記のファイルでコンフリクトを解消してください"
echo "2. 解消後、以下のコマンドを実行:"
echo ""
echo "   # コンフリクトが解消されたか確認"
echo "   git diff --name-only --diff-filter=U"
echo ""
echo "   # ビルド・テスト実行"
echo "   npm run typecheck"
echo "   npm run lint"
echo "   npm run build"
echo ""
echo "   # コミット"
echo "   git add ."
echo "   git commit -m \"chore: resolve merge conflicts with develop\""
echo ""
echo "💡 ヒント:"
echo "- マージを中断する場合: git merge --abort"
echo "- 自分の変更を優先: git checkout --ours [ファイル]"
echo "- developの変更を優先: git checkout --theirs [ファイル]"
echo ""
```

### 実行例

```
ユーザー: /resolve-conflicts

Claude:
📋 現在の状況を確認しています...
- ブランチ: feature/update-issue-command
- 未コミットの変更: なし
✅ 前提条件を満たしています

📡 developの最新を取得しています...
✅ developの最新を取得しました

🔀 origin/develop をマージしています...
⚠️ コンフリクトが発生しました

📋 コンフリクトが発生したファイル:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1. .cursor/commands/update-issue.md
2. package.json
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

合計: 2件のファイルでコンフリクトが発生しています

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📄 .cursor/commands/update-issue.md
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

コンフリクト箇所: 1箇所

【コンフリクト 1】
行番号: 10-25

あなたの変更 (HEAD):
```
## 動作概要

1. **会話履歴の参照**: コマンド実行前の直近の会話内容を参照
2. **内容の抽出・要約**: 議論された内容、決定事項、追加情報などを抽出
```

developの変更:
```
## 動作概要

質問や情報を GitHub Issue に追加・更新する際に使用します。
```

💡 解消方法の提案:
あなたの変更（新しい機能）を採用することを推奨します。

🔧 解消手順:
1. エディタでファイルを開く: .cursor/commands/update-issue.md
2. コンフリクトマーカー (<<<<<<<, =======, >>>>>>>) を確認
3. 適切な内容にマージ
4. マーカーを削除

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📝 次のステップ
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. 上記のファイルでコンフリクトを解消してください
2. 解消後、以下のコマンドを実行:

   npm run typecheck
   npm run lint
   npm run build

   git add .
   git commit -m "chore: resolve merge conflicts with develop"

💡 ヒント:
- マージを中断する場合: git merge --abort
- 自分の変更を優先: git checkout --ours [ファイル]
- developの変更を優先: git checkout --theirs [ファイル]
```
