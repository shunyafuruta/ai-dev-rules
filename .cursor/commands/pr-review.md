---
name: PRレビューを依頼
description: 現在のブランチのPRレビューを依頼（developとの差分）
---

# PRレビューを依頼

このコマンドは、現在のブランチとdevelopブランチの差分を取得し、Claudeに自動的にPRレビューを依頼します。

## 使い方

```bash
/pr-review
```

## 動作概要

1. **差分の取得**: `git diff develop...HEAD` で変更内容を取得
2. **プロンプトの読み込み**: `.github/prompts/pr-review.md` を読み込み
3. **PR情報の整形**: ブランチ名、変更ファイル、diffを整形
4. **PR作成**: PRが存在しない場合は自動作成
5. **Claudeレビュー依頼**: PRに `@claude レビューして` コメントを追加
6. **レビュー依頼**: 整形した情報をClaudeに渡してレビューを実施
7. **結果の表示**: JSON形式のレビュー結果を表示

## 実行内容

### 1. 現在のブランチ情報を取得

```bash
git rev-parse --abbrev-ref HEAD
```

### 2. 変更ファイル一覧を取得

```bash
git diff --name-status develop...HEAD
```

### 3. 完全なdiffを取得

```bash
git diff develop...HEAD
```

### 4. PRレビュープロンプトを読み込み

```bash
cat .github/prompts/pr-review.md
```

### 5. PRの存在確認と作成

```bash
# PRが既に存在するかチェック
gh pr view --json number 2>/dev/null || gh pr create --base develop --fill
```

PRが存在しない場合は、以下の情報で自動作成：
- タイトル: ブランチ名またはコミットメッセージから生成
- 本文: コミットメッセージとdiff情報
- ベースブランチ: develop

### 6. Claudeレビュー依頼コメントを追加

```bash
gh pr comment <pr-number> --body "@claude レビューして"
```

PRに自動的にClaudeへのレビュー依頼コメントを追加します。

### 7. 情報を整形してレビュー依頼

取得した情報を以下の形式で整形：

```markdown
[PRレビュープロンプトの内容]

---

## PRの情報

**ブランチ**: [現在のブランチ名]
**ベースブランチ**: develop
**PR**: [PR URL]

### 変更ファイル一覧

```
[git diff --name-status の出力]
```

### 変更内容（diff）

```diff
[git diff の完全な出力]
```

---

上記のPull Requestを、プロジェクトのコーディング規約に基づいてレビューしてください。
```

## エラーハンドリング

- **ブランチがdevelop**: 「エラー: developブランチではPRレビューできません」
- **差分なし**: 「エラー: developブランチとの差分がありません」
- **プロンプトファイルなし**: 「エラー: .github/prompts/pr-review.md が見つかりません」
- **git エラー**: 「エラー: gitコマンドの実行に失敗しました」
- **gh CLI未インストール**: 「エラー: GitHub CLI (gh) がインストールされていません」
- **gh 認証エラー**: 「エラー: GitHub CLIの認証が必要です (gh auth login)」
- **PR作成失敗**: 「エラー: PRの作成に失敗しました」

## 注意事項

- このコマンドは**PRを自動作成**します（PRが存在しない場合）
- PRに自動的に`@claude レビューして`コメントが追加されます
- GitHub CLI (`gh`) がインストールされ、認証済みである必要があります
- 大量の変更がある場合、Claudeのトークン制限に注意してください
- 機密情報（`.env`ファイルなど）が差分に含まれていないか確認してください

## 関連コマンド

- `/pr-review-branch <branch>`: 指定したブランチとの差分をレビュー

---

## 実装指示（Claude向け）

このコマンドが実行されたときの動作：

### ステップ1: 現在のブランチを確認

```bash
git rev-parse --abbrev-ref HEAD
```

現在のブランチ名を取得し、`develop`ブランチではないことを確認：

```typescript
const currentBranch = execSync('git rev-parse --abbrev-ref HEAD').toString().trim();

if (currentBranch === 'develop') {
  throw new Error('❌ エラー: developブランチではPRレビューできません');
}

console.log(`🔍 ブランチ: ${currentBranch}`);
console.log(`📊 ベースブランチ: develop`);
```

### ステップ2: 差分の存在確認

```bash
git diff --quiet develop...HEAD
```

差分がない場合はエラー：

```typescript
try {
  execSync('git diff --quiet develop...HEAD');
  // 差分なし（正常終了）
  throw new Error('❌ エラー: developブランチとの差分がありません');
} catch (error) {
  if (error.status === 1) {
    // 差分あり（期待される動作）
    console.log('✅ 差分を検出しました');
  } else {
    // その他のエラー
    throw error;
  }
}
```

### ステップ3: 変更ファイル一覧を取得

```bash
git diff --name-status develop...HEAD
```

```typescript
const changedFiles = execSync('git diff --name-status develop...HEAD')
  .toString()
  .trim();

console.log(`📝 変更ファイル数: ${changedFiles.split('\n').length}件`);
```

### ステップ4: 完全なdiffを取得

```bash
git diff develop...HEAD
```

```typescript
const diffContent = execSync('git diff develop...HEAD').toString();

console.log(`📦 差分サイズ: ${(diffContent.length / 1024).toFixed(2)} KB`);

// トークン制限の警告（目安: 100KB以上）
if (diffContent.length > 100000) {
  console.warn('⚠️  警告: 差分が大きいため、レビューに時間がかかる可能性があります');
}
```

### ステップ5: PRレビュープロンプトを読み込み

```typescript
const fs = require('fs');
const path = require('path');

const promptPath = '.github/prompts/pr-review.md';

if (!fs.existsSync(promptPath)) {
  throw new Error(`❌ エラー: ${promptPath} が見つかりません`);
}

const reviewPrompt = fs.readFileSync(promptPath, 'utf-8');
console.log('✅ レビュープロンプトを読み込みました');
```

### ステップ6: PRの存在確認と作成

```typescript
console.log('\n🔍 PRの確認中...');

// PRが既に存在するかチェック
let prUrl = '';
let prNumber = 0;

try {
  const prInfoResult = execSync('gh pr view --json number,url', { encoding: 'utf-8' });
  const prData = JSON.parse(prInfoResult);
  prNumber = prData.number;
  prUrl = prData.url;
  console.log(`✅ PR #${prNumber} が既に存在します`);
  console.log(`📎 ${prUrl}`);
} catch (error) {
  // PRが存在しない場合は作成
  console.log('📝 PRを作成中...');
  
  try {
    // PRを作成（--fillでコミットメッセージからタイトルと本文を自動生成）
    const createResult = execSync('gh pr create --base develop --fill', { encoding: 'utf-8' });
    prUrl = createResult.trim();
    
    // PRのURLから番号を抽出
    const prMatch = prUrl.match(/\/pull\/(\d+)/);
    if (prMatch) {
      prNumber = parseInt(prMatch[1], 10);
    }
    
    console.log(`✅ PR #${prNumber} を作成しました`);
    console.log(`📎 ${prUrl}`);
  } catch (createError) {
    console.error('❌ エラー: PRの作成に失敗しました');
    console.error('💡 ヒント: コミットメッセージが適切か確認してください');
    throw createError;
  }
}
```

### ステップ7: Claudeレビュー依頼コメントを追加

```typescript
if (prNumber > 0) {
  console.log('\n💬 Claudeにレビューを依頼中...');
  
  try {
    execSync(`gh pr comment ${prNumber} --body "@claude レビューして"`, { stdio: 'ignore' });
    console.log('✅ Claudeへのレビュー依頼コメントを追加しました');
  } catch (commentError) {
    console.warn('⚠️  警告: レビュー依頼コメントの追加に失敗しました');
    // エラーでも処理は続行
  }
}
```

### ステップ8: PR情報を整形

```typescript
const prInfo = `
---

## PRの情報

**ブランチ**: \`${currentBranch}\`
**ベースブランチ**: \`develop\`
**PR**: ${prUrl}

### 変更ファイル一覧

\`\`\`
${changedFiles}
\`\`\`

### 変更内容（diff）

\`\`\`diff
${diffContent}
\`\`\`

---

上記のPull Requestを、プロジェクトのコーディング規約に基づいてレビューしてください。

**重要**: 出力は必ずJSON形式で提供してください。マークダウンコードブロック（\`\`\`json）は使用せず、純粋なJSONのみを出力してください。
`;

const fullPrompt = reviewPrompt + prInfo;
```

### ステップ9: レビュー依頼を表示

```typescript
console.log('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
console.log('🤖 PRレビューを開始します');
console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

// プロンプト全体をClaudeに渡す
// Cursorが自動的にClaudeに送信
console.log(fullPrompt);
```

### ステップ10: エラーハンドリング

```typescript
try {
  // 各ステップを実行
  const currentBranch = getCurrentBranch();
  checkNotOnDevelopBranch(currentBranch);
  checkDiffExists();
  
  const changedFiles = getChangedFiles();
  const diffContent = getDiffContent();
  const reviewPrompt = loadReviewPrompt();
  
  const fullPrompt = formatPRReview({
    currentBranch,
    baseBranch: 'develop',
    changedFiles,
    diffContent,
    reviewPrompt,
  });
  
  console.log(fullPrompt);
  
} catch (error) {
  console.error(`\n❌ エラーが発生しました: ${error.message}\n`);
  
  if (error.message.includes('develop')) {
    console.log('💡 ヒント: developブランチ以外で実行してください');
  } else if (error.message.includes('差分がありません')) {
    console.log('💡 ヒント: コミットを作成してから再度実行してください');
  } else if (error.message.includes('見つかりません')) {
    console.log('💡 ヒント: プロジェクトルートで実行してください');
  }
  
  throw error;
}
```

### 完全な実装例

```typescript
/**
 * PRレビューコマンドの実装
 */
async function executePRReview(): Promise<void> {
  try {
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    console.log('🚀 PRレビューコマンドを実行します');
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
    
    // 1. ブランチ確認
    const currentBranch = execSync('git rev-parse --abbrev-ref HEAD')
      .toString()
      .trim();
    
    if (currentBranch === 'develop') {
      throw new Error('developブランチではPRレビューできません');
    }
    
    console.log(`🔍 ブランチ: ${currentBranch}`);
    console.log(`📊 ベースブランチ: develop\n`);
    
    // 2. 差分確認
    try {
      execSync('git diff --quiet develop...HEAD', { stdio: 'ignore' });
      throw new Error('developブランチとの差分がありません');
    } catch (error) {
      if (error.status !== 1) {
        throw error;
      }
      // 差分あり（期待される動作）
    }
    
    // 3. 変更ファイル取得
    const changedFiles = execSync('git diff --name-status develop...HEAD')
      .toString()
      .trim();
    
    const fileCount = changedFiles.split('\n').length;
    console.log(`📝 変更ファイル数: ${fileCount}件`);
    
    // 4. diff取得
    const diffContent = execSync('git diff develop...HEAD').toString();
    const diffSizeKB = (diffContent.length / 1024).toFixed(2);
    console.log(`📦 差分サイズ: ${diffSizeKB} KB`);
    
    if (diffContent.length > 100000) {
      console.warn('⚠️  警告: 差分が大きいため、レビューに時間がかかる可能性があります\n');
    }
    
    // 5. プロンプト読み込み
    const promptPath = '.github/prompts/pr-review.md';
    if (!require('fs').existsSync(promptPath)) {
      throw new Error(`${promptPath} が見つかりません`);
    }
    
    const reviewPrompt = require('fs').readFileSync(promptPath, 'utf-8');
    console.log('✅ レビュープロンプトを読み込みました\n');
    
    // 6. PRの存在確認と作成
    console.log('\n🔍 PRの確認中...');
    
    let prUrl = '';
    let prNumber = 0;
    
    try {
      const prInfoResult = execSync('gh pr view --json number,url', { encoding: 'utf-8' });
      const prData = JSON.parse(prInfoResult);
      prNumber = prData.number;
      prUrl = prData.url;
      console.log(`✅ PR #${prNumber} が既に存在します`);
    } catch (error) {
      // PRが存在しない場合は作成
      console.log('📝 PRを作成中...');
      const createResult = execSync('gh pr create --base develop --fill', { encoding: 'utf-8' });
      prUrl = createResult.trim();
      const prMatch = prUrl.match(/\/pull\/(\d+)/);
      if (prMatch) {
        prNumber = parseInt(prMatch[1], 10);
      }
      console.log(`✅ PR #${prNumber} を作成しました`);
    }
    
    console.log(`📎 ${prUrl}\n`);
    
    // 7. Claudeレビュー依頼コメントを追加
    if (prNumber > 0) {
      console.log('💬 Claudeにレビューを依頼中...');
      try {
        execSync(`gh pr comment ${prNumber} --body "@claude レビューして"`, { stdio: 'ignore' });
        console.log('✅ Claudeへのレビュー依頼コメントを追加しました\n');
      } catch (commentError) {
        console.warn('⚠️  警告: レビュー依頼コメントの追加に失敗しました\n');
      }
    }
    
    // 8. PR情報整形
    const prInfo = `
---

## PRの情報

**ブランチ**: \`${currentBranch}\`
**ベースブランチ**: \`develop\`
**PR**: ${prUrl}

### 変更ファイル一覧

\`\`\`
${changedFiles}
\`\`\`

### 変更内容（diff）

\`\`\`diff
${diffContent}
\`\`\`

---

上記のPull Requestを、プロジェクトのコーディング規約に基づいてレビューしてください。

**重要**: 出力は必ずJSON形式で提供してください。マークダウンコードブロック（\`\`\`json）は使用せず、純粋なJSONのみを出力してください。
`;
    
    const fullPrompt = reviewPrompt + prInfo;
    
    // 9. レビュー開始
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    console.log('🤖 PRレビューを開始します');
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
    
    // プロンプト全体を出力（Claudeに送信）
    console.log(fullPrompt);
    
  } catch (error) {
    console.error(`\n❌ エラー: ${error.message}\n`);
    
    if (error.message.includes('develop')) {
      console.log('💡 ヒント: developブランチ以外で実行してください');
    } else if (error.message.includes('差分がありません')) {
      console.log('💡 ヒント: コミットを作成してから再度実行してください');
    } else if (error.message.includes('見つかりません')) {
      console.log('💡 ヒント: プロジェクトルートで実行してください');
    }
    
    throw error;
  }
}

// コマンド実行
executePRReview();
```

### 実行例

```
ユーザー: /pr-review

Claude:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PRレビューコマンドを実行します
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔍 ブランチ: feature/contract-search
📊 ベースブランチ: develop

📝 変更ファイル数: 8件
📦 差分サイズ: 15.32 KB
✅ レビュープロンプトを読み込みました

🔍 PRの確認中...
📝 PRを作成中...
✅ PR #123 を作成しました
📎 https://github.com/kizuki-dsd/manabi/pull/123

💬 Claudeにレビューを依頼中...
✅ Claudeへのレビュー依頼コメントを追加しました

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🤖 PRレビューを開始します
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[レビュープロンプトとPR情報が表示される]
[ClaudeがJSON形式のレビュー結果を返す]

{"summary":"## 📋 概要\n\n契約検索機能の実装です...","event":"APPROVE","comments":[...]}
```

### セキュリティ考慮事項

機密情報が含まれていないかチェック（オプション機能）：

```typescript
// .env ファイルなど機密情報を含むファイルが変更されている場合は警告
const sensitiveFiles = ['.env', '.env.local', 'terraform.tfvars'];
const changedFileNames = changedFiles.split('\n').map(line => line.split('\t')[1]);

const hasSensitiveFiles = changedFileNames.some(file => 
  sensitiveFiles.some(sensitive => file.includes(sensitive))
);

if (hasSensitiveFiles) {
  console.warn('⚠️  警告: 機密情報を含む可能性のあるファイルが変更されています');
  console.warn('    レビュー前に内容を確認してください\n');
}
```

