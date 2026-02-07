---
name: Issue を作成
description: ザックリとした内容から詳細なGitHub Issueを自動生成して作成する
---

# GitHub Issue を自動生成・作成

このコマンドは、**ザックリとした説明を元に、詳細な内容を自動生成してGitHub issueを作成**します。

## 使い方

```bash
/create-issue <ザックリとした説明>
```

例:
```bash
/create-issue ログイン機能を追加したい

/create-issue エラーハンドリングを改善する

/create-issue Redisのセッション管理を実装
```

## 動作概要

1. **入力内容の分析**: ユーザーから受け取ったザックリとした説明を分析
2. **詳細化**: 内容を詳細化して以下を生成
   - 適切なタイトル
   - 概要セクション
   - 背景・課題セクション
   - 求める機能・仕様
   - 技術的な実装案（該当する場合）
   - 受入基準
3. **issue作成**: `gh issue create` でissueを作成
4. **結果報告**: 作成されたissue番号とURLを表示

## 実行内容

### 1. 入力内容の受け取り

ユーザーから簡単な説明を受け取ります：

```bash
/create-issue <説明>
```

複数行の説明にも対応：
```bash
/create-issue ユーザー認証機能を追加したい。
Firebase Authenticationを使って、
Google、メール/パスワードでのログインに対応する。
```

### 2. 内容の詳細化

受け取った説明を分析して、以下のような詳細なissue本文を自動生成：

```markdown
## 概要

[ユーザーの説明を元に、機能や改善内容を明確に記述]

## 背景・課題

[なぜこの機能が必要か、現状の課題は何かを推測して記述]

## 求める機能・仕様

- [機能要件1]
- [機能要件2]
- [機能要件3]

## 技術的な実装案

[該当する場合のみ]
- 使用する技術・ライブラリ
- アーキテクチャ上の考慮事項
- 実装の流れ

## 受入基準

- [ ] [受入基準1]
- [ ] [受入基準2]
- [ ] [受入基準3]
```

### 3. タイトルの自動生成

内容に基づいて適切なタイトルを生成：

- **機能追加**: `[機能名]を実装`
- **改善**: `[対象]を改善`
- **バグ修正**: `[問題]を修正`
- **リファクタリング**: `[対象]をリファクタリング`

### 4. issue作成

生成した内容でissueを作成：

```bash
gh issue create \
  --title "生成されたタイトル" \
  --body "生成された本文" \
  --assignee @me
```

### 5. 結果の報告

```
✅ Issue を作成しました！

📋 Issue #<番号>: <タイトル>
🔗 https://github.com/kizuki-dsd/manbi-poc/issues/<番号>

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
生成された内容:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[生成されたissue本文]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💡 内容を修正したい場合は、以下のコマンドで編集できます:
   gh issue edit <番号> --body "新しい本文"
```

## エラーハンドリング

- **引数なし**: 「エラー: 説明を指定してください。使い方: /create-issue <説明>」
- **gh CLIエラー**: 「エラー: GitHub CLIの実行に失敗しました」
- **権限エラー**: 「エラー: issueを作成する権限がありません」

## 注意事項

- 説明は**簡潔でOK**（詳細は自動生成されます）
- 生成された内容は**あくまで提案**です（後で編集可能）
- issueは**自動的に自分にアサイン**されます
- ラベルは自動付与されません（必要に応じて手動で追加）

## オプション機能（将来的に実装予定）

### ラベルの自動付与

```bash
/create-issue --label enhancement ログイン機能を追加
/create-issue --label bug エラー処理が不完全
```

### テンプレートの指定

```bash
/create-issue --template feature <説明>
/create-issue --template bug <説明>
```

### インタラクティブモード

```bash
/create-issue --interactive

# 対話形式で入力を促す
# - タイトル
# - 概要
# - 優先度
# - ラベル
```

### プレビューモード

```bash
/create-issue --preview ログイン機能を追加

# issue作成前に生成内容を表示
# ユーザーが内容を確認後、実際に作成するか選択
```

---

## 実装指示（Claude向け）

このコマンドが実行されたときの動作：

### ステップ1: 引数チェック

```typescript
// 説明の検証
if (!description || description.trim().length === 0) {
  throw new Error('説明を指定してください。使い方: /create-issue <説明>');
}

if (description.trim().length < 3) {
  throw new Error('説明が短すぎます。もう少し詳しく説明してください。');
}
```

### ステップ2: 入力内容の分析

受け取った説明から以下を判断：

1. **種類の判定**
   - 機能追加（「追加」「実装」「作成」などのキーワード）
   - 改善（「改善」「最適化」「強化」などのキーワード）
   - バグ修正（「修正」「バグ」「エラー」などのキーワード）
   - リファクタリング（「リファクタリング」「整理」などのキーワード）

2. **技術要素の抽出**
   - 特定の技術名（Firebase、Redis、Prismaなど）
   - コンポーネント名
   - 機能領域

3. **スコープの把握**
   - フロントエンド/バックエンド
   - 影響範囲
   - 複雑度

### ステップ3: タイトルの生成

判定した種類に基づいてタイトルを生成：

```typescript
function generateTitle(description: string, type: IssueType): string {
  // 主要なキーワードを抽出
  const keywords = extractKeywords(description);
  
  switch (type) {
    case 'feature':
      return `${keywords.main}を実装`;
    case 'improvement':
      return `${keywords.main}を改善`;
    case 'bug':
      return `${keywords.main}を修正`;
    case 'refactor':
      return `${keywords.main}をリファクタリング`;
    default:
      return keywords.main;
  }
}
```

### ステップ4: 本文の詳細化

プロジェクトのコンテキストを考慮して、詳細な本文を生成：

```typescript
function generateBody(description: string, type: IssueType): string {
  // このプロジェクトの情報を参照
  // - 使用技術スタック（Next.js、Prisma、Firebase、GCP）
  // - 既存の機能
  // - コーディング規約
  
  const body = `
## 概要

${generateOverview(description, type)}

## 背景・課題

${generateBackground(description, type)}

## 求める機能・仕様

${generateSpecifications(description, type)}

${shouldIncludeTechnicalSection(description) ? `
## 技術的な実装案

${generateTechnicalProposal(description)}
` : ''}

## 受入基準

${generateAcceptanceCriteria(description, type)}
`;

  return body.trim();
}
```

**詳細化のポイント**:

1. **概要セクション**
   - ユーザーの説明を整理して明確に記述
   - 何を実現するかを端的に表現

2. **背景・課題セクション**
   - なぜこの機能が必要かを推測
   - 現状の問題点や改善点
   - ユーザー/ビジネス価値

3. **求める機能・仕様**
   - 具体的な機能要件をリスト化
   - ユーザーストーリー形式で記述
   - エッジケースも考慮

4. **技術的な実装案**（該当する場合）
   - 使用する技術・ライブラリ
   - アーキテクチャ上の考慮事項
   - 実装の流れやステップ

5. **受入基準**
   - チェックボックス形式で記述
   - テスト可能な具体的な基準
   - 最低3-5項目

### ステップ5: プロジェクトコンテキストの活用

このプロジェクトの情報を参照して、より具体的な提案を生成：

```typescript
const projectContext = {
  techStack: [
    'Next.js 15 (App Router)',
    'React 19',
    'Prisma (PostgreSQL)',
    'Firebase (Authentication, Firestore)',
    'GCP (Cloud SQL, Cloud Functions, Memorystore Redis)',
    'TypeScript',
    'Tailwind CSS',
  ],
  features: [
    'ブース予約システム',
    'リアルタイム状況表示',
    'Comiru連携',
    '教室・ブース管理',
  ],
  structure: {
    monorepo: 'Turborepo',
    packages: ['database', 'shared-types', 'comiru-client'],
    apps: ['web', 'api', 'websocket'],
  },
};

// このコンテキストを使って、より具体的な実装提案を生成
function generateTechnicalProposal(description: string): string {
  // 説明に含まれる技術要素と、プロジェクトの技術スタックをマッチング
  // 適切なパッケージ、ディレクトリ、実装方針を提案
}
```

### ステップ6: issue作成の実行

**セキュリティ対策**: コマンドインジェクション対策として、`--body-file` オプションを使用します。

```bash
# 一時ファイルに本文を書き込み（特殊文字のエスケープ不要）
TEMP_FILE=$(mktemp /tmp/issue_body.XXXXXX)
echo "${GENERATED_BODY}" > "${TEMP_FILE}"

# --body-file を使ってissueを作成
gh issue create \
  --title "${GENERATED_TITLE}" \
  --body-file "${TEMP_FILE}" \
  --assignee @me

# 一時ファイルを削除
rm "${TEMP_FILE}"
```

JSONで結果を受け取る場合：
```bash
# GitHub CLI はデフォルトでURLを返すため、追加の処理は不要
# 必要に応じて issue番号を抽出
ISSUE_URL=$(gh issue create \
  --title "${GENERATED_TITLE}" \
  --body-file "${TEMP_FILE}" \
  --assignee @me)

ISSUE_NUMBER=$(echo "${ISSUE_URL}" | grep -oE '[0-9]+$')
```

### ステップ7: 結果の報告

```typescript
const result = JSON.parse(ghOutput);

console.log('✅ Issue を作成しました！\n');
console.log(`📋 Issue #${result.number}: ${result.title}`);
console.log(`🔗 ${result.url}\n`);
console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
console.log('生成された内容:');
console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
console.log(generatedBody);
console.log('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
console.log('💡 内容を修正したい場合は、以下のコマンドで編集できます:');
console.log(`   gh issue edit ${result.number} --body "新しい本文"`);
```

### エラーハンドリング

```typescript
try {
  // 入力検証
  validateInput(description);
  
  // 内容の生成
  const title = generateTitle(description, type);
  const body = generateBody(description, type);
  
  // issue作成
  const result = await createIssue(title, body);
  
  // 結果報告
  displayResult(result, body);
  
} catch (error) {
  if (error.stderr?.includes('permission denied') || error.stderr?.includes('forbidden')) {
    console.error('❌ エラー: issueを作成する権限がありません');
    console.log('💡 ヒント: リポジトリへの書き込み権限を確認してください');
    console.log('   確認方法: gh repo view --json viewerPermission');
  } else if (error.message.includes('not found') || error.code === 127) {
    console.error('❌ エラー: gh コマンドが見つかりません');
    console.log('💡 ヒント: GitHub CLI (gh) をインストールしてください');
    console.log('   インストール方法: https://cli.github.com/');
  } else if (error.stderr?.includes('authentication') || error.stderr?.includes('not authenticated')) {
    console.error('❌ エラー: GitHub認証が必要です');
    console.log('💡 ヒント: gh auth login を実行してください');
  } else if (error.stderr?.includes('rate limit')) {
    console.error('❌ エラー: GitHub API のレート制限に達しました');
    console.log('💡 ヒント: しばらく待ってから再試行してください');
  } else {
    console.error(`❌ エラー: ${error.message}`);
    if (error.stderr) {
      console.error(`詳細: ${error.stderr}`);
    }
  }
}
```

### 実行例

#### 例1: シンプルな機能追加

```
ユーザー: /create-issue ログイン機能を追加

Claude:
入力内容を分析しています...
- 種類: 機能追加
- 技術要素: 認証、ログイン
- スコープ: フロントエンド + バックエンド

詳細なissue内容を生成しています...

Issue を作成しています...

✅ Issue を作成しました！

📋 Issue #45: ログイン機能を実装
🔗 https://github.com/kizuki-dsd/manbi-poc/issues/45

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
生成された内容:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 概要

ユーザーがシステムにログインできる機能を実装します。

## 背景・課題

現在、システムには認証機能がなく、全ての機能が誰でもアクセス可能な状態です。
ブース予約システムとして、教師や管理者を識別し、適切な権限管理を行う必要があります。

## 求める機能・仕様

- ユーザーは認証情報（メールアドレス・パスワード）を使ってログインできる
- Firebase Authenticationを使用して認証を実装する
- ログイン状態をセッションで管理する
- ログアウト機能も提供する
- ログインページとログアウトボタンのUIを実装する
- 未認証ユーザーは保護されたページにアクセスできないようにする

## 技術的な実装案

### 認証プロバイダー
- Firebase Authentication を使用
- メールアドレス/パスワード認証を実装

### フロントエンド
- Next.js App Router の middleware で認証状態をチェック
- ログインページ: `/login`
- 認証コンテキストを作成してアプリ全体で状態を共有

### バックエンド
- Firebase Admin SDK でトークンを検証
- API エンドポイントで認証ミドルウェアを適用

### セッション管理
- Redis (Memorystore) でセッション情報を管理
- セッションの有効期限を設定

## 受入基準

- [ ] ログインページが実装されている
- [ ] メールアドレス・パスワードでログインできる
- [ ] ログイン状態がセッションで維持される
- [ ] ログアウト機能が動作する
- [ ] 未認証ユーザーは保護されたページにアクセスできない
- [ ] 認証エラーが適切に表示される

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💡 内容を修正したい場合は、以下のコマンドで編集できます:
   gh issue edit 45 --body "新しい本文"
```

#### 例2: 技術的な改善

```
ユーザー: /create-issue Redisのセッション管理を実装する。現状はメモリに保存されてるので、スケールしない。

Claude:
入力内容を分析しています...
- 種類: 改善
- 技術要素: Redis、セッション管理
- スコープ: バックエンド、インフラ

詳細なissue内容を生成しています...

Issue を作成しています...

✅ Issue を作成しました！

📋 Issue #46: Redisを使ったセッション管理を実装
🔗 https://github.com/kizuki-dsd/manbi-poc/issues/46

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
生成された内容:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 概要

現在メモリで管理しているセッション情報をRedis（Memorystore）に移行し、スケーラブルなセッション管理を実現します。

## 背景・課題

現状、セッション情報はアプリケーションのメモリに保存されているため、以下の問題があります：

- アプリケーションを再起動するとセッションが失われる
- 複数インスタンスでのセッション共有ができない（水平スケールできない）
- メモリ使用量が増加する

本プロジェクトではすでにCloud Memorystore（Redis）が構築されているため、これを活用してセッション管理を改善します。

## 求める機能・仕様

- セッション情報をRedisに保存する
- セッションの有効期限を設定する（例: 24時間）
- セッションIDの生成とCookieへの設定
- 既存の認証フローはそのまま維持する
- 環境変数でRedis接続情報を管理する

## 技術的な実装案

### 使用ライブラリ
- `connect-redis`: Express/Next.jsのセッションストア
- `ioredis`: Redisクライアント

### 実装内容

1. **Redis接続の設定**
   ```typescript
   // packages/database or apps/api/src/lib/redis.ts
   import Redis from 'ioredis';
   
   export const redisClient = new Redis({
     host: process.env.REDIS_HOST,
     port: parseInt(process.env.REDIS_PORT || '6379'),
   });
   ```

2. **セッションストアの設定**
   ```typescript
   import RedisStore from 'connect-redis';
   import session from 'express-session';
   
   app.use(session({
     store: new RedisStore({ client: redisClient }),
     secret: process.env.SESSION_SECRET,
     resave: false,
     saveUninitialized: false,
     cookie: {
       secure: process.env.NODE_ENV === 'production',
       maxAge: 1000 * 60 * 60 * 24, // 24時間
     },
   }));
   ```

3. **環境変数の追加**
   - `REDIS_HOST`: Memorystore RedisのIPアドレス
   - `REDIS_PORT`: Redisのポート（デフォルト: 6379）
   - `SESSION_SECRET`: セッションシークレット（Secret Managerから取得）

### 移行戦略
- 既存のセッション管理コードを特定
- Redisストアに段階的に移行
- ローカル開発環境ではローカルRedis、または互換性のあるメモリストアを使用

## 受入基準

- [ ] Redisクライアントが正しく接続できる
- [ ] セッション情報がRedisに保存される
- [ ] セッションの有効期限が設定されている
- [ ] アプリケーション再起動後もセッションが維持される
- [ ] 複数インスタンスでセッションが共有される
- [ ] 環境変数で接続情報が管理されている
- [ ] ローカル開発環境でも動作する

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💡 内容を修正したい場合は、以下のコマンドで編集できます:
   gh issue edit 46 --body "新しい本文"
```

### 注意事項

1. **プロジェクトコンテキストの参照**
   - `.cursor/` ディレクトリの情報
   - `package.json` の依存関係
   - 既存のコード構造
   - ドキュメント

2. **適切な詳細度**
   - 過度に詳細すぎず、適度に具体的
   - 実装者が理解しやすいレベル
   - 必要に応じて技術提案を含める

3. **柔軟な生成**
   - ユーザーの説明が詳しい場合は、その情報を優先
   - 曖昧な部分は推測して補完
   - プロジェクトの文脈に合わせる

4. **編集可能性の強調**
   - 生成された内容は提案であることを明示
   - 後から編集可能であることを案内
   - 編集方法を具体的に提示

5. **セキュリティ考慮事項**
   - `--body-file` を使用してコマンドインジェクションを防止
   - ユーザー入力に含まれる特殊文字を適切に処理
   - 一時ファイルは処理後に必ず削除

