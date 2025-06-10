# dnf-auto-update-slack

DNFの自動更新とSlack通知を行うシステム

## 機能

- DNFパッケージの自動更新
- 更新結果のSlack通知
- ログローテーション機能
- エラーハンドリング

## クイックインストール

```bash
curl -sSL https://raw.githubusercontent.com/nakakimura-s/dnf-auto-update-slack/main/install.sh | sudo bash
```

## 手動インストール

### 1. リポジトリをクローン

```bash
git clone https://github.com/nakakimura-s/dnf-auto-update-slack.git
cd dnf-auto-update-slack
```

### 2. インストールスクリプトを実行

```bash
sudo ./install.sh
```

## 設定

### 1. Slack Webhook URLの設定

```bash
sudo nano /usr/local/bin/dnf-auto-update-slack.sh
```

`SLACK_WEBHOOK_URL` を実際のSlack Webhook URLに変更してください。

### 2. cron設定

```bash
sudo crontab -e
```

以下の行を追加（毎日午前2時に実行）：

```
0 2 * * * /usr/local/bin/dnf-auto-update-slack.sh
```

## 使用方法

### 手動実行

```bash
sudo /usr/local/bin/dnf-auto-update-slack.sh
```

### ログ確認

```bash
sudo tail -f /var/log/dnf-auto-update-slack.log
```

## ファイル構成

```
/usr/local/bin/dnf-auto-update-slack.sh  # メインスクリプト
/var/log/dnf-auto-update-slack.log       # ログファイル
/etc/logrotate.d/dnf-auto-update-slack   # ログローテーション設定
```

## Slack通知内容

- ✅ 更新成功時：更新されたパッケージ一覧
- ❌ 更新失敗時：エラー詳細
- ℹ️ 更新なし時：実行確認通知

## アンインストール

```bash
curl -sSL https://raw.githubusercontent.com/nakakimura-s/dnf-auto-update-slack/main/uninstall.sh | sudo bash
```

## 要件

- RHEL/CentOS/Fedora系Linux
- DNFパッケージマネージャー
- curl
- root権限

## ライセンス

MIT License

## 作者

Your Name
