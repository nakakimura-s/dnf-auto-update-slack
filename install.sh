#!/bin/bash

# dnf-auto-update-slack 自動インストールスクリプト
# Usage: curl -sSL https://raw.githubusercontent.com/YOUR_USERNAME/dnf-auto-update-slack/main/install.sh | sudo bash

set -e

echo "==== dnf-auto-update-slack インストール開始 ===="

# 変数定義
SCRIPT_NAME="dnf-auto-update-slack.sh"
SCRIPT_PATH="/usr/local/bin/$SCRIPT_NAME"
LOGFILE="/var/log/dnf-auto-update-slack.log"
LOGROTATE_CONFIG="/etc/logrotate.d/dnf-auto-update-slack"
REPO_URL="https://raw.githubusercontent.com/nakakimura-s/dnf-auto-update-slack/main"

# root権限チェック
if [[ $EUID -ne 0 ]]; then
   echo "このスクリプトはroot権限で実行してください。"
   echo "Usage: sudo $0"
   exit 1
fi

# 必要なコマンドの存在チェック
for cmd in curl dnf crontab; do
    if ! command -v $cmd &> /dev/null; then
        echo "エラー: $cmd が見つかりません。"
        exit 1
    fi
done

echo "1. メインスクリプトをダウンロード中..."
curl -sSL "$REPO_URL/$SCRIPT_NAME" -o "$SCRIPT_PATH"
chmod +x "$SCRIPT_PATH"
echo "   ✓ $SCRIPT_PATH に配置完了"

echo "2. ログファイルを作成中..."
touch "$LOGFILE"
chmod 644 "$LOGFILE"
echo "   ✓ $LOGFILE を作成完了"

echo "3. logrotate設定をダウンロード中..."
curl -sSL "$REPO_URL/logrotate-config" -o "$LOGROTATE_CONFIG"
chmod 644 "$LOGROTATE_CONFIG"
echo "   ✓ $LOGROTATE_CONFIG に配置完了"

echo "4. logrotate設定を確認中..."
if logrotate -d "$LOGROTATE_CONFIG" &>/dev/null; then
    echo "   ✓ logrotate設定は正常です"
else
    echo "   ⚠ logrotate設定に問題がある可能性があります"
fi

echo ""
echo "==== インストール完了 ===="
echo ""
echo "次の手順を実行してください："
echo ""
echo "1. Slack Webhook URLを設定:"
echo "   sudo nano $SCRIPT_PATH"
echo "   # SLACK_WEBHOOK_URL を実際のURLに変更してください"
echo ""
echo "2. cron設定（推奨頻度を選択してください）:"
echo "   sudo crontab -e"
echo "   # 以下の行を追加:"
echo "   # 毎日AM2時"
echo "   0 2 * * * $SCRIPT_PATH"
echo "   # 週1回（日曜日AM2時）"
echo "   0 2 * * 0 $SCRIPT_PATH"
echo ""
echo "3. 動作テスト:"
echo "   sudo $SCRIPT_PATH"
echo "   sudo tail -f $LOGFILE"
echo ""
echo "ファイル構成:"
echo "   スクリプト: $SCRIPT_PATH"
echo "   ログファイル: $LOGFILE"
echo "   logrotate設定: $LOGROTATE_CONFIG"
echo ""
echo "アンインストール:"
echo "   curl -sSL https://raw.githubusercontent.com/nakakimura-s/dnf-auto-update-slack/main/uninstall.sh | sudo bash"
