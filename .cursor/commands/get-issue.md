---
name: Issue を取得
description: GitHub Issue の詳細情報を取得して表示する
---

# GitHub Issue 情報を取得

このコマンドは、指定されたGitHub issueの詳細情報を取得して、見やすく表示します。

## 使い方

```bash
/get-issue <issue番号> [オプション]
```

### 基本的な使用例

```bash
# 基本的な情報表示
/get-issue 43

# コメント付きで表示
/get-issue 43 --comments

# ブラウザで開く
/get-issue 43 --web

# JSON形式で出力
/get-issue 43 --json

# 依存関係を表示
/get-issue 43 --deps

# 複数オプションの組み合わせ
/get-issue 43 --comments --deps
```

## オプション

### `--comments`

issueのコメント一覧を表示します。

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💬 コメント (3件)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] @user1 (2025-12-20 10:30)
────────────────────────────────────
この実装方針に賛成です。ただし、パフォーマンスへの影響を考慮すべきです。

[2] @user2 (2025-12-20 11:45)
────────────────────────────────────
パフォーマンステストの結果を追加しました。問題なさそうです。
```

### `--web`

ブラウザでissueを開きます（`gh issue view <番号> --web` を実行）。

### `--json`

JSON形式で完全な情報を出力します（スクリプト連携用）。

### `--deps`

issue本文から依存関係を抽出して表示します。

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔗 依存関係
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📥 前提条件（このissueを開始する前に完了が必要）
  #43 [Infrastructure] update-issueコマンド改善 [✅ Closed]
  #52 [Backend] API基盤実装 [🟢 Open]

📤 ブロックするissue（このissueが完了しないと開始できない）
  #120 [Frontend] PR画面UI実装 [⏸️ Blocked]
  #121 [Backend] PRレビューAPI実装 [⏸️ Blocked]
```

## 動作概要

1. **issue情報の取得**: `gh issue view` でissue情報を取得
2. **整形して表示**: タイトル、ステータス、本文などを見やすく表示
3. **オプション機能**: コメント表示、依存関係表示などのオプション

## 実行内容

### 1. issue情報の取得

```bash
gh issue view <issue番号> --json title,body,state,number,author,createdAt,labels,assignees,comments
```

### 2. 情報の表示

取得した情報を以下の形式で表示：

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 Issue #<番号>: <タイトル>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

状態: <OPEN/CLOSED>
作成者: @<username>
作成日: <YYYY-MM-DD>
ラベル: [label1, label2, ...]
アサイン: @<assignee1>, @<assignee2>
コメント: <件数>件

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📝 本文
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[本文の内容]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔗 https://github.com/kizuki-dsd/manabi/issues/<番号>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## エラーハンドリング

- **引数なし**: 「エラー: issue番号を指定してください。使い方: /get-issue <番号>」
- **無効なissue**: 「エラー: issue #<番号> が見つかりません」
- **gh CLIエラー**: 「エラー: GitHub CLIの実行に失敗しました」
- **ネットワークエラー**: 「エラー: ネットワークに接続できません」
- **認証エラー**: 「エラー: GitHub認証が必要です」（ヒント: `gh auth login` を実行）
- **レート制限**: 「エラー: APIレート制限に達しました」

## 注意事項

- このコマンドは**読み取り専用**です（issueを変更しません）
- プライベートリポジトリのissueも取得できます（gh認証済みの場合）
- issue番号は必須です
- 複数のオプションを同時に指定できます（`--json` を除く）

## 関連コマンド

- `/update-issue <番号>`: issueの本文を更新
- `gh issue list`: issue一覧を表示

---

## 実装指示（Claude向け）

このコマンドが実行されたときの動作：

### ステップ1: 引数チェックとオプション解析

```typescript
/**
 * 解析されたコマンドライン引数
 */
interface ParsedArgs {
  /** issue番号（未指定の場合はnull） */
  issueNumber: string | null;
  /** コメント一覧を表示するかどうか */
  showComments: boolean;
  /** ブラウザで開くかどうか */
  openWeb: boolean;
  /** JSON形式で出力するかどうか */
  outputJson: boolean;
  /** 依存関係を表示するかどうか */
  showDeps: boolean;
}

/**
 * コマンドライン引数を解析してオプションを抽出する
 *
 * @param args - コマンドライン引数の配列
 * @returns 解析されたオプションとissue番号
 */
function parseArgs(args: string[]): ParsedArgs {
  const issueNumber = args.find((arg) => /^\d+$/.test(arg)) || null;

  return {
    issueNumber,
    showComments: args.includes('--comments'),
    openWeb: args.includes('--web'),
    outputJson: args.includes('--json'),
    showDeps: args.includes('--deps'),
  };
}

// issue番号の検証
if (!issueNumber) {
  throw new Error(
    'issue番号を指定してください。使い方: /get-issue <番号> [オプション]',
  );
}
if (!/^\d+$/.test(issueNumber)) {
  throw new Error('無効なissue番号です。数字を指定してください。');
}
```

### ステップ2: issue情報の取得

```bash
gh issue view <issue番号> --json title,body,state,number,author,createdAt,labels,assignees,comments
```

JSON形式でデータを取得して、以下の情報を抽出：

- `number`: issue番号
- `title`: タイトル
- `state`: ステータス（OPEN/CLOSED）
- `body`: 本文
- `author.login`: 作成者のユーザー名
- `createdAt`: 作成日時
- `labels`: ラベルの配列
- `assignees`: アサインされたユーザーの配列
- `comments.totalCount`: コメント数

### ステップ3: オプション処理

#### --web オプション

```bash
gh issue view <issue番号> --web
```

ブラウザでissueを開いて、処理を終了します。

#### --json オプション

```typescript
// JSON形式でそのまま出力
console.log(JSON.stringify(issueData, null, 2));
```

他のオプションは無視して、JSON出力のみ行います。

#### --comments オプション

```bash
# コメントを取得
gh api repos/kizuki-dsd/manabi/issues/<issue番号>/comments
```

コメント情報を取得して表示：

```typescript
/**
 * コメント一覧を整形して表示する
 *
 * @param comments - コメントの配列
 */
function displayComments(comments: Comment[]): void {
  // 早期リターン: コメントが存在しない
  if (comments.length === 0) {
    console.log('\n💬 コメントはありません\n');
    return;
  }

  console.log('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  console.log(`💬 コメント (${comments.length}件)`);
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

  // メモ化: コメント一覧の整形（commentsが変更された時のみ再計算）
  const formattedComments = comments.map((comment, index) => {
    const createdAt = formatDateTime(comment.created_at);
    return [
      `[${index + 1}] @${comment.user.login} (${createdAt})`,
      '────────────────────────────────────',
      comment.body,
      '',
    ].join('\n');
  });

  formattedComments.forEach((formatted) => console.log(formatted));
}
```

#### --deps オプション

issue本文から依存関係を抽出：

```typescript
// 依存関係抽出用の定数
const PREREQ_SECTION_PATTERN = /### 前提条件[\s\S]*?(?=###|$)/;
const BLOCKS_SECTION_PATTERN = /### ブロックするissue[\s\S]*?(?=###|$)/;
const ISSUE_REF_PATTERN = /#(\d+)/g;
const DECIMAL_BASE = 10;

/**
 * 依存関係情報
 */
interface Dependencies {
  /** 前提条件となるissue番号の配列 */
  prerequisites: number[];
  /** このissueが完了しないと開始できないissue番号の配列 */
  blocks: number[];
}

/**
 * セクションからissue番号を抽出する
 *
 * @param sectionMatch - セクションのマッチ結果
 * @returns 抽出されたissue番号の配列
 */
function extractIssueNumbers(sectionMatch: RegExpMatchArray | null): number[] {
  // 早期リターン: セクションが存在しない
  if (!sectionMatch) {
    return [];
  }

  const sectionText = sectionMatch[0];
  const issueRefs = Array.from(sectionText.matchAll(ISSUE_REF_PATTERN));

  return issueRefs.map((match) => parseInt(match[1], DECIMAL_BASE));
}

/**
 * issue本文から依存関係を抽出する
 *
 * @param body - issue本文
 * @returns 抽出された依存関係
 */
function extractDependencies(body: string): Dependencies {
  // 前提条件セクションからissue番号を抽出
  const prereqMatch = body.match(PREREQ_SECTION_PATTERN);
  const prerequisites = extractIssueNumbers(prereqMatch);

  // ブロックするissueセクションからissue番号を抽出
  const blocksMatch = body.match(BLOCKS_SECTION_PATTERN);
  const blocks = extractIssueNumbers(blocksMatch);

  return { prerequisites, blocks };
}

/**
 * 依存関係を表示する
 *
 * @param dependencies - 依存関係
 * @param issueNumber - 現在のissue番号
 */
async function displayDependencies(
  dependencies: Dependencies,
  issueNumber: string,
): Promise<void> {
  if (
    dependencies.prerequisites.length === 0 &&
    dependencies.blocks.length === 0
  ) {
    console.log('\n🔗 依存関係: なし\n');
    return;
  }

  console.log('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  console.log('🔗 依存関係');
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

  // 前提条件
  if (dependencies.prerequisites.length > 0) {
    console.log('📥 前提条件（このissueを開始する前に完了が必要）');
    for (const issueNum of dependencies.prerequisites) {
      const info = await getIssueBasicInfo(issueNum);
      console.log(
        `  #${issueNum} ${info.title} [${info.stateEmoji} ${info.state}]`,
      );
    }
    console.log('');
  }

  // ブロックするissue
  if (dependencies.blocks.length > 0) {
    console.log('📤 ブロックするissue（このissueが完了しないと開始できない）');
    for (const issueNum of dependencies.blocks) {
      const info = await getIssueBasicInfo(issueNum);
      console.log(
        `  #${issueNum} ${info.title} [${info.stateEmoji} ${info.state}]`,
      );
    }
    console.log('');
  }
}

/**
 * issue基本情報を取得する（タイトルとステータスのみ）
 *
 * @param issueNumber - issue番号
 * @returns issue基本情報
 */
async function getIssueBasicInfo(issueNumber: number): Promise<{
  title: string;
  state: string;
  stateEmoji: string;
}> {
  try {
    const result = await execCommand(
      `gh issue view ${issueNumber} --json title,state`,
    );
    const data = JSON.parse(result.stdout);

    const stateEmoji =
      data.state === 'OPEN' ? '🟢' : data.state === 'CLOSED' ? '✅' : '⏸️';

    return {
      title: data.title,
      state: data.state,
      stateEmoji,
    };
  } catch (error) {
    return {
      title: '(取得失敗)',
      state: 'Unknown',
      stateEmoji: '❓',
    };
  }
}
```

### ステップ4: 情報の整形と表示

取得したデータを見やすく整形して表示：

```typescript
/**
 * issue情報を整形して表示する
 *
 * @param issueData - issue情報
 */
function displayIssue(issueData: IssueData): void {
  // ヘッダー
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  console.log(`📋 Issue #${issueData.number}: ${issueData.title}`);
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

  // メタ情報
  console.log(`状態: ${issueData.state === 'OPEN' ? '🟢 Open' : '🔴 Closed'}`);
  console.log(`作成者: @${issueData.author.login}`);
  console.log(`作成日: ${formatDate(issueData.createdAt)}`);

  // ラベル
  if (issueData.labels && issueData.labels.length > 0) {
    const labelNames = issueData.labels.map((l) => l.name).join(', ');
    console.log(`ラベル: ${labelNames}`);
  }

  // アサイン
  if (issueData.assignees && issueData.assignees.length > 0) {
    const assigneeNames = issueData.assignees
      .map((a) => '@' + a.login)
      .join(', ');
    console.log(`アサイン: ${assigneeNames}`);
  }

  // コメント数
  if (issueData.comments && issueData.comments.totalCount > 0) {
    console.log(`コメント: ${issueData.comments.totalCount}件`);
  }

  // 本文
  console.log('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  console.log('📝 本文');
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
  console.log(issueData.body || '(本文なし)');

  // フッター
  console.log('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  console.log(
    `🔗 https://github.com/kizuki-dsd/manabi/issues/${issueData.number}`,
  );
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
}
```

### ステップ5: エラーハンドリング

```typescript
// エラーメッセージ定数
const ERROR_MESSAGES = {
  NOT_FOUND: {
    message: (issueNumber: string) => `issue #${issueNumber} が見つかりません`,
    hint: 'issue番号を確認してください',
  },
  CLI_NOT_FOUND: {
    message: 'gh コマンドが見つかりません',
    hint: 'GitHub CLI (gh) をインストールしてください\n   https://cli.github.com/',
  },
  NETWORK: {
    message: 'ネットワークに接続できません',
    hint: 'インターネット接続を確認してください',
  },
  AUTH: {
    message: 'GitHub認証が必要です',
    hint: '`gh auth login` を実行してください',
  },
  RATE_LIMIT: {
    message: 'APIレート制限に達しました',
    hint: 'しばらく待ってから再試行してください',
  },
} as const;

/**
 * エラーの種類を判定する
 *
 * @param error - エラーオブジェクト
 * @returns エラーの種類
 */
function getErrorType(error: any): string {
  const stderr = error.stderr || '';
  const code = error.code;

  if (stderr.includes('Could not resolve')) return 'NOT_FOUND';
  if (stderr.includes('not found')) return 'CLI_NOT_FOUND';
  if (code === 'ENOTFOUND' || stderr.includes('network')) return 'NETWORK';
  if (stderr.includes('authentication')) return 'AUTH';
  if (stderr.includes('rate limit')) return 'RATE_LIMIT';

  return 'UNKNOWN';
}

/**
 * エラー種類に応じたメッセージを表示する
 *
 * @param errorType - エラーの種類
 * @param issueNumber - issue番号
 * @param error - エラーオブジェクト
 */
function displayErrorMessage(
  errorType: string,
  issueNumber: string | null,
  error: any,
): void {
  const errorInfo = ERROR_MESSAGES[errorType as keyof typeof ERROR_MESSAGES];

  if (errorInfo) {
    const message =
      typeof errorInfo.message === 'function'
        ? errorInfo.message(issueNumber || '')
        : errorInfo.message;
    console.error(`❌ エラー: ${message}`);
    console.log(`💡 ヒント: ${errorInfo.hint}`);
    return;
  }

  // UNKNOWN
  console.error(`❌ エラー: ${error.message}`);
  if (error.stderr) {
    console.error(`詳細: ${error.stderr}`);
  }
}

try {
  // オプション解析
  const options = parseArgs(args);

  // --web オプション: ブラウザで開く
  if (options.openWeb) {
    await execCommand(`gh issue view ${options.issueNumber} --web`);
    console.log(`✅ ブラウザでissue #${options.issueNumber} を開きました`);
    return;
  }

  // issue情報取得
  const result = await execCommand(
    `gh issue view ${options.issueNumber} --json title,body,state,number,author,createdAt,labels,assignees,comments`,
  );
  const issueData = JSON.parse(result.stdout);

  // --json オプション: JSON形式で出力
  if (options.outputJson) {
    console.log(JSON.stringify(issueData, null, 2));
    return;
  }

  // 通常表示
  displayIssue(issueData);

  // --deps オプション: 依存関係を表示
  if (options.showDeps) {
    const dependencies = extractDependencies(issueData.body);
    await displayDependencies(dependencies, options.issueNumber);
  }

  // --comments オプション: コメントを表示
  if (options.showComments) {
    const commentsResult = await execCommand(
      `gh api repos/kizuki-dsd/manabi/issues/${options.issueNumber}/comments`,
    );
    const comments = JSON.parse(commentsResult.stdout);
    displayComments(comments);
  }
} catch (error) {
  const errorType = getErrorType(error);
  displayErrorMessage(errorType, options.issueNumber, error);
}
```

### 日付フォーマット関数

```typescript
/**
 * ISO形式の日付文字列をYYYY-MM-DD形式にフォーマットする
 *
 * @param isoDateString - ISO形式の日付文字列
 * @returns YYYY-MM-DD形式の日付文字列
 */
function formatDate(isoDateString: string): string {
  const date = new Date(isoDateString);
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  return `${year}-${month}-${day}`;
}

/**
 * ISO形式の日付文字列をYYYY-MM-DD HH:MM形式にフォーマットする
 *
 * @param isoDateString - ISO形式の日付文字列
 * @returns YYYY-MM-DD HH:MM形式の日付時刻文字列
 */
function formatDateTime(isoDateString: string): string {
  const date = new Date(isoDateString);
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  const hours = String(date.getHours()).padStart(2, '0');
  const minutes = String(date.getMinutes()).padStart(2, '0');
  return `${year}-${month}-${day} ${hours}:${minutes}`;
}
```

### 実行例

#### 基本的な使用例

```
ユーザー: /get-issue 43

Claude:
issue #43 の情報を取得しています...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 Issue #43: Cursorコマンド改善: update-issue コマンドでissue本文を直接更新できるようにする
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

状態: 🟢 Open
作成者: @tomiyoshi-keisuke-kizuki
作成日: 2025-10-27
コメント: 0件

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📝 本文
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 概要

現在の `.cursor/commands/update-issue.md` コマンドは...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔗 https://github.com/kizuki-dsd/manabi/issues/43
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

#### --comments オプション

```
ユーザー: /get-issue 116 --comments

Claude:
issue #116 の情報を取得しています...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 Issue #116: PRレビュー依頼のCursor commands実装
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

(メタ情報...)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💬 コメント (3件)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] @user1 (2025-12-20 10:30)
────────────────────────────────────
この実装方針に賛成です。

[2] @user2 (2025-12-20 11:45)
────────────────────────────────────
パフォーマンステストの結果を追加しました。
```

#### --deps オプション

```
ユーザー: /get-issue 117 --deps

Claude:
issue #117 の情報を取得しています...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 Issue #117: get-issueコマンドの機能拡張
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

(メタ情報...)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔗 依存関係
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📤 ブロックするissue（このissueが完了しないと開始できない）
  #116 PRレビュー依頼のCursor commands実装 [🟢 Open]
```

### エラーケースのテスト

```bash
# 存在しないissue
/get-issue 99999
# → ❌ エラー: issue #99999 が見つかりません
#    💡 ヒント: issue番号を確認してください

# 引数なし
/get-issue
# → ❌ エラー: issue番号を指定してください。使い方: /get-issue <番号> [オプション]

# 無効な引数
/get-issue abc
# → ❌ エラー: 無効なissue番号です。数字を指定してください。
```
