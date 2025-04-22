# gcloud-env

プロジェクトディレクトリごとに複数のGoogle Cloud SDK設定を管理するツールです。asdfがランタイムバージョンを管理するのと同様の方法で動作します。

## 問題点

複数のGoogle Cloudプロジェクトを扱う場合、異なるgcloud設定を切り替えるのは面倒な作業になります。`gcloud config configurations`コマンドは役立ちますが、グローバルであり、特定のプロジェクトディレクトリに紐付けられていません。

## 解決策

`gcloud-env`を使用すると、以下のことが可能になります：

1. プロジェクトごとに個別のgcloud設定を作成・管理する
2. ディレクトリを変更すると自動的に設定を切り替える
3. プロジェクト間でGoogle Cloudの認証情報と設定を分離して保持する

## インストール方法

1. このリポジトリをクローンします：
   ```bash
   git clone https://github.com/yourusername/gcloud-env.git
   ```

2. binディレクトリをPATHに追加します：
   ```bash
   echo 'export PATH="$PATH:/path/to/gcloud-env/bin"' >> ~/.bashrc
   # または zsh の場合
   echo 'export PATH="$PATH:/path/to/gcloud-env/bin"' >> ~/.zshrc
   ```

3. シェル設定に自動切り替え機能を追加します：
   ```bash
   # gcloud-env setup
   gcloud-env
   ```

4. シェル設定をリロードします：
   ```bash
   source ~/.bashrc
   # または zsh の場合
   source ~/.zshrc
   ```

## 使用方法

### プロジェクト用の新しい設定を初期化する

プロジェクトディレクトリに移動し、新しい設定を初期化します：

```bash
cd /path/to/your/project
gcloud-env init my-project-config
```

これにより：
- `my-project-config`という名前の新しい設定が作成されます
- 現在のgcloud設定がこの設定にコピーされます（存在する場合）
- プロジェクトディレクトリに`.gcloud-env`ファイルが作成されます

### 設定を切り替える

特定の設定に手動で切り替えるには：

```bash
gcloud-env use my-project-config
```

自動切り替え機能が有効になっている場合、`.gcloud-env`ファイルがあるディレクトリに移動するだけで、指定された設定に自動的に切り替わります。

### 利用可能な設定を一覧表示する

```bash
gcloud-env list
```

### 現在の設定を表示する

```bash
gcloud-env current
```

### 設定を削除する

```bash
gcloud-env delete my-project-config
```

これにより、指定した設定が削除されます。現在アクティブな設定は削除できないことに注意してください。

### ヘルプを表示する

```bash
gcloud-env help
```

## 動作の仕組み

`gcloud-env`は以下の方法で動作します：

1. 異なるgcloud設定を`~/.gcloud-env/`に保存する
2. `~/.config/gcloud`からアクティブな設定へのシンボリックリンクを作成する
3. 各プロジェクトディレクトリに`.gcloud-env`ファイルを使用して、どの設定を使用するかを指定する
4. ディレクトリを変更すると自動的に設定を切り替えるシェルフックを提供する

## ライセンス

このプロジェクトはBSD 3-Clauseライセンスの下で提供されています - 詳細は[LICENSE.md](../LICENSE.md)ファイルをご覧ください。
