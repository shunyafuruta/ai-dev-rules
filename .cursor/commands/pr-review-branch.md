---
name: PRレビューを依頼（ブランチ指定）
description: 指定したベースブランチとの差分でPRレビューを依頼
---

# PRレビューを依頼（ブランチ指定）

このコマンドは、現在のブランチと指定したベースブランチの差分を取得し、Claudeに自動的にPRレビューを依頼します。

## 使い方

```bash
/pr-review-branch <base-branch>
```

例:
```bash
/pr-review-branch main
/pr-review-branch develop
/pr-review-branch feature/base-feature
```

## 動作概要

1. **引数の検証**: ベースブランチ名が指定されているか確認
2. **差分の取得**: `git diff <base-branch>...HEAD` で変更内容を取得
3. **プロンプトの読み込み**: `.github/prompts/pr-review.md` を読み込み
4. **PR情報の整形**: ブランチ名、変更ファイル、diffを整形
5. **PR作成**: PRが存在しない場合は自動作成
6. **Claudeレビュー依頼**: PRに `@claude レビューして` コメントを追加
7. **レビュー依頼**: 整形した情報をClaudeに渡してレビューを実施
8. **結果の表示**: JSON形式のレビュー結果を表示

## 実行内容

### 1. 引数の検証

```typescript
if (!baseBranch) {
  throw new Error('ベースブランチ名を指定してください。使い方: /pr-review-branch <branch>');
}
```

### 2. ブランチの存在確認

```bash
git rev-parse --verify <base-branch>
```

### 3. 現在のブランチ情報を取得

```bash
git rev-parse --abbrev-ref HEAD
```

### 4. 変更ファイル一覧を取得

```bash
git diff --name-status <base-branch>...HEAD
```

### 5. 完全なdiffを取得

```bash
git diff <base-branch>...HEAD
```

### 6. PRレビュープロンプトを読み込み

```bash
cat .github/prompts/pr-review.md
```

### 7. PRの存在確認と作成

```bash
# PRが既に存在するかチェック
gh pr view --json number 2>/dev/null || gh pr create --base <base-branch> --fill
```

PRが存在しない場合は、指定されたベースブランチに対してPRを自動作成します。

### 8. Claudeレビュー依頼コメントを追加

```bash
gh pr comment <pr-number> --body "@claude レビューして"
```

PRに自動的にClaudeへのレビュー依頼コメントを追加します。

### 9. 情報を整形してレビュー依頼

取得した情報を以下の形式で整形：

```markdown
[PRレビュープロンプトの内容]

---

## PRの情報

**ブランチ**: [現在のブランチ名]
**ベースブランチ**: [指定されたブランチ名]
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

- **引数なし**: 「エラー: ベースブランチ名を指定してください」
- **ブランチが存在しない**: 「エラー: ブランチ '<branch>' が見つかりません」
- **現在のブランチと同じ**: 「エラー: 現在のブランチと同じブランチは指定できません」
- **差分なし**: 「エラー: ベースブランチとの差分がありません」
- **プロンプトファイルなし**: 「エラー: .github/prompts/pr-review.md が見つかりません」
- **git エラー**: 「エラー: gitコマンドの実行に失敗しました」
- **gh CLI未インストール**: 「エラー: GitHub CLI (gh) がインストールされていません」
- **gh 認証エラー**: 「エラー: GitHub CLIの認証が必要です (gh auth login)」
- **PR作成失敗**: 「エラー: PRの作成に失敗しました」

## 注意事項

- このコマンドは**PRを自動作成**します（PRが存在しない場合）
- PRに自動的に`@claude レビューして`コメントが追加されます
- GitHub CLI (`gh`) がインストールされ、認証済みである必要があります
- 指定したベースブランチに対してPRが作成されます
- 大量の変更がある場合、Claudeのトークン制限に注意してください
- 機密情報（`.env`ファイルなど）が差分に含まれていないか確認してください

## 関連コマンド

- `/pr-review`: developブランチとの差分をレビュー（デフォルト）

---

## 実装指示（Claude向け）

このコマンドが実行されたときの動作：

### ステップ1: 引数の取得と検証

```typescript
// コマンドライン引数からベースブランチ名を取得
// Cursorのコマンドシステムから引数を受け取る想定
const args = process.argv.slice(2); // または Cursor の引数取得方法
const baseBranch = args[0]?.trim();

if (!baseBranch) {
  throw new Error('❌ エラー: ベースブランチ名を指定してください\n使い方: /pr-review-branch <branch>');
}

console.log(`📊 ベースブランチ: ${baseBranch}`);
```

### ステップ2: ベースブランチの存在確認

```bash
git rev-parse --verify <base-branch>
```

```typescript
try {
  execSync(`git rev-parse --verify ${baseBranch}`, { stdio: 'ignore' });
  console.log('✅ ベースブランチを確認しました');
} catch (error) {
  throw new Error(`❌ エラー: ブランチ '${baseBranch}' が見つかりません\n💡 ヒント: ブランチ名を確認してください`);
}
```

### ステップ3: 現在のブランチを確認

```bash
git rev-parse --abbrev-ref HEAD
```

```typescript
const currentBranch = execSync('git rev-parse --abbrev-ref HEAD')
  .toString()
  .trim();

if (currentBranch === baseBranch) {
  throw new Error(`❌ エラー: 現在のブランチ '${currentBranch}' と同じブランチは指定できません`);
}

console.log(`🔍 ブランチ: ${currentBranch}`);
```

### ステップ4: 差分の存在確認

```bash
git diff --quiet <base-branch>...HEAD
```

```typescript
try {
  execSync(`git diff --quiet ${baseBranch}...HEAD`, { stdio: 'ignore' });
  // 差分なし（正常終了）
  throw new Error(`❌ エラー: ブランチ '${baseBranch}' との差分がありません`);
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

### ステップ5: 変更ファイル一覧を取得

```bash
git diff --name-status <base-branch>...HEAD
```

```typescript
const changedFiles = execSync(`git diff --name-status ${baseBranch}...HEAD`)
  .toString()
  .trim();

console.log(`📝 変更ファイル数: ${changedFiles.split('\n').length}件`);
```

### ステップ6: 完全なdiffを取得

```bash
git diff <base-branch>...HEAD
```

```typescript
const diffContent = execSync(`git diff ${baseBranch}...HEAD`).toString();

console.log(`📦 差分サイズ: ${(diffContent.length / 1024).toFixed(2)} KB`);

// トークン制限の警告（目安: 100KB以上）
if (diffContent.length > 100000) {
  console.warn('⚠️  警告: 差分が大きいため、レビューに時間がかかる可能性があります');
}
```

### ステップ7: PRレビュープロンプトを読み込み

```typescript
const fs = require('fs');
const promptPath = '.github/prompts/pr-review.md';

if (!fs.existsSync(promptPath)) {
  throw new Error(`❌ エラー: ${promptPath} が見つかりません`);
}

const reviewPrompt = fs.readFileSync(promptPath, 'utf-8');
console.log('✅ レビュープロンプトを読み込みました');
```

### ステップ8: PR情報を整形

```typescript
const prInfo = `
---

## PRの情報

**ブランチ**: \`${currentBranch}\`
**ベースブランチ**: \`${baseBranch}\`

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
console.log(fullPrompt);
```

### 完全な実装例

```typescript
/**
 * PRレビューコマンド（ブランチ指定版）の実装
 */
async function executePRReviewBranch(baseBranch: string): Promise<void> {
  try {
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    console.log('🚀 PRレビューコマンドを実行します');
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
    
    // 1. 引数検証
    if (!baseBranch) {
      throw new Error('ベースブランチ名を指定してください\n使い方: /pr-review-branch <branch>');
    }
    
    console.log(`📊 ベースブランチ: ${baseBranch}`);
    
    // 2. ベースブランチの存在確認
    try {
      execSync(`git rev-parse --verify ${baseBranch}`, { stdio: 'ignore' });
      console.log('✅ ベースブランチを確認しました');
    } catch (error) {
      throw new Error(`ブランチ '${baseBranch}' が見つかりません`);
    }
    
    // 3. 現在のブランチ確認
    const currentBranch = execSync('git rev-parse --abbrev-ref HEAD')
      .toString()
      .trim();
    
    if (currentBranch === baseBranch) {
      throw new Error(`現在のブランチ '${currentBranch}' と同じブランチは指定できません`);
    }
    
    console.log(`🔍 ブランチ: ${currentBranch}\n`);
    
    // 4. 差分確認
    try {
      execSync(`git diff --quiet ${baseBranch}...HEAD`, { stdio: 'ignore' });
      throw new Error(`ブランチ '${baseBranch}' との差分がありません`);
    } catch (error) {
      if (error.status !== 1) {
        throw error;
      }
      // 差分あり（期待される動作）
    }
    
    // 5. 変更ファイル取得
    const changedFiles = execSync(`git diff --name-status ${baseBranch}...HEAD`)
      .toString()
      .trim();
    
    const fileCount = changedFiles.split('\n').length;
    console.log(`📝 変更ファイル数: ${fileCount}件`);
    
    // 6. diff取得
    const diffContent = execSync(`git diff ${baseBranch}...HEAD`).toString();
    const diffSizeKB = (diffContent.length / 1024).toFixed(2);
    console.log(`📦 差分サイズ: ${diffSizeKB} KB`);
    
    if (diffContent.length > 100000) {
      console.warn('⚠️  警告: 差分が大きいため、レビューに時間がかかる可能性があります\n');
    }
    
    // 7. プロンプト読み込み
    const promptPath = '.github/prompts/pr-review.md';
    if (!require('fs').existsSync(promptPath)) {
      throw new Error(`${promptPath} が見つかりません`);
    }
    
    const reviewPrompt = require('fs').readFileSync(promptPath, 'utf-8');
    console.log('✅ レビュープロンプトを読み込みました\n');
    
    // 8. PRの存在確認と作成
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
      const createResult = execSync(`gh pr create --base ${baseBranch} --fill`, { encoding: 'utf-8' });
      prUrl = createResult.trim();
      const prMatch = prUrl.match(/\/pull\/(\d+)/);
      if (prMatch) {
        prNumber = parseInt(prMatch[1], 10);
      }
      console.log(`✅ PR #${prNumber} を作成しました`);
    }
    
    console.log(`📎 ${prUrl}\n`);
    
    // 9. Claudeレビュー依頼コメントを追加
    if (prNumber > 0) {
      console.log('💬 Claudeにレビューを依頼中...');
      try {
        execSync(`gh pr comment ${prNumber} --body "@claude レビューして"`, { stdio: 'ignore' });
        console.log('✅ Claudeへのレビュー依頼コメントを追加しました\n');
      } catch (commentError) {
        console.warn('⚠️  警告: レビュー依頼コメントの追加に失敗しました\n');
      }
    }
    
    // 10. PR情報整形
    const prInfo = `
---

## PRの情報

**ブランチ**: \`${currentBranch}\`
**ベースブランチ**: \`${baseBranch}\`
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
    
    // 11. レビュー開始
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    console.log('🤖 PRレビューを開始します');
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
    
    // プロンプト全体を出力（Claudeに送信）
    console.log(fullPrompt);
    
  } catch (error) {
    console.error(`\n❌ エラー: ${error.message}\n`);
    
    if (error.message.includes('指定してください')) {
      console.log('💡 ヒント: ベースブランチ名を指定してください');
      console.log('   例: /pr-review-branch main');
    } else if (error.message.includes('見つかりません')) {
      console.log('💡 ヒント: ブランチ名を確認してください');
      console.log('   使用可能なブランチ: git branch -a');
    } else if (error.message.includes('差分がありません')) {
      console.log('💡 ヒント: コミットを作成してから再度実行してください');
    } else if (error.message.includes('同じブランチ')) {
      console.log('💡 ヒント: 別のブランチを指定してください');
    }
    
    throw error;
  }
}

// コマンド実行
// Cursorから引数を受け取る（実装方法はCursorのAPIに依存）
const baseBranch = process.argv[2]; // または Cursor の引数取得方法
executePRReviewBranch(baseBranch);
```

### 実行例

```
ユーザー: /pr-review-branch main

Claude:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PRレビューコマンドを実行します
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 ベースブランチ: main
✅ ベースブランチを確認しました
🔍 ブランチ: feature/contract-search

📝 変更ファイル数: 12件
📦 差分サイズ: 23.45 KB
✅ レビュープロンプトを読み込みました

🔍 PRの確認中...
📝 PRを作成中...
✅ PR #124 を作成しました
📎 https://github.com/kizuki-dsd/manabi/pull/124

💬 Claudeにレビューを依頼中...
✅ Claudeへのレビュー依頼コメントを追加しました

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🤖 PRレビューを開始します
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[レビュープロンプトとPR情報が表示される]
[ClaudeがJSON形式のレビュー結果を返す]

{"summary":"## 📋 概要\n\nmainブランチとの差分をレビューしました...","event":"APPROVE","comments":[...]}
```

### エラーケースの例

```
# 引数なし
ユーザー: /pr-review-branch
→ ❌ エラー: ベースブランチ名を指定してください
   使い方: /pr-review-branch <branch>

# 存在しないブランチ
ユーザー: /pr-review-branch nonexistent-branch
→ ❌ エラー: ブランチ 'nonexistent-branch' が見つかりません
   💡 ヒント: ブランチ名を確認してください

# 現在のブランチと同じ
ユーザー: feature/test ブランチで /pr-review-branch feature/test
→ ❌ エラー: 現在のブランチ 'feature/test' と同じブランチは指定できません
   💡 ヒント: 別のブランチを指定してください

# 差分なし
ユーザー: /pr-review-branch main （差分がない状態で）
→ ❌ エラー: ブランチ 'main' との差分がありません
   💡 ヒント: コミットを作成してから再度実行してください
```

### セキュリティ考慮事項

機密情報が含まれていないかチェック（オプション機能）：

```typescript
// .env ファイルなど機密情報を含むファイルが変更されている場合は警告
const sensitiveFiles = ['.env', '.env.local', 'terraform.tfvars'];
const changedFileNames = changedFiles.split('\n').map(line => line.split('\t')[1]);

const hasSensitiveFiles = changedFileNames.some(file => 
  sensitiveFiles.some(sensitive => file && file.includes(sensitive))
);

if (hasSensitiveFiles) {
  console.warn('⚠️  警告: 機密情報を含む可能性のあるファイルが変更されています');
  console.warn('    レビュー前に内容を確認してください\n');
}
```

