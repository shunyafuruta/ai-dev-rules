# Reference（参照資料）ディレクトリ

このディレクトリは、AI開発時に参照する資料を保存するための場所です。

## 使い方

### 資料の配置

任意の形式の資料をこのディレクトリに配置してください：

```
reference/
├── README.md           # このファイル
├── design/            # デザイン資料
│   ├── ui-spec.pdf
│   └── wireframe.png
├── requirements/      # 要件定義書
│   └── spec.md
├── api/              # API仕様書
│   └── swagger.yaml
└── meeting-notes/    # 議事録
    └── 2024-01-15.md
```

### AI による参照方法

Claude Code (Cursor / Claude CLI) は、このディレクトリ内のファイルを自動的に読み込めます。

開発中に以下のように指示してください：

```
reference/requirements/spec.md を参照して、ログイン機能を実装して
```

```
reference/design/ui-spec.pdf を見て、画面レイアウトを作成して
```

### 対応ファイル形式

- **テキストファイル**: `.md`, `.txt`, `.json`, `.yaml`, `.yml`
- **画像ファイル**: `.png`, `.jpg`, `.jpeg`, `.gif`, `.svg`, `.webp`
- **PDFファイル**: `.pdf`（Claude は PDF の内容を読み取れます）
- **コードファイル**: `.ts`, `.tsx`, `.js`, `.jsx`, `.py`, など

## 注意事項

⚠️ **このディレクトリの内容は Git で管理されません**

- `.gitignore` により、`reference/` ディレクトリの内容は GitHub にアップロードされません
- 機密情報や社内資料を安全に保存できます
- チームメンバーと共有する場合は、別の方法（Google Drive, Dropbox など）で共有してください

## セキュリティ

このディレクトリには以下のような機密情報を安全に保存できます：

- 顧客要件定義書
- 社内仕様書
- デザインモックアップ
- API認証情報（開発環境用）
- 議事録・打ち合わせメモ

ただし、**本番環境の認証情報や秘密鍵は保存しないでください**。
