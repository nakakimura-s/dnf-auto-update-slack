#!/bin/bash

# dnf-auto-update-slack アンインストールスクリプト
# Usage: curl -sSL https://raw.githubusercontent.com/nakakimura-s/dnf-auto-update-slack/main/uninstall.sh | sudo bash

set -e

echo "==== dnf-auto-update-slack アンインストール開始 ===="

# 変数定義
SCRIPT_PATH="/usr/local/bin/dnf-auto-update-slack.sh"
LOGFILE="/var/log/dnf-auto-update-slack.log"
LOGROTATE_CONFIG="/etc/logrotate.d/dnf-auto-update-slack"

# root権限チェック
if [[ $EUID -ne 0 ]]; then
   echo "このスクリプトはroot権限で実行してください。"
   echo "Usage: sudo $0"
   exit 1
fi

echo "1. メインスクリプトを削除中..."
if [[ -f "$SCRIPT_PATH" ]]; then
    rm -f "$SCRIPT_PATH"
    echo "   ✓ $SCRIPT_PATH を削除しました"
else
    echo "   - $SCRIPT_PATH は存在しません"
fi

echo "2. logrotate設定を削除中..."
if [[ -f "$LOGROTATE_CONFIG" ]]; then
    rm -f "$LOGROTATE_CONFIG"
    echo "   ✓ $LOGROTATE_CONFIG を削除しました"
else
    echo "   - $LOGROTATE_CONFIG は存在しません"
fi

echo "3. ログファイルについて..."
if [[ -f "$LOGFILE" ]]; then
    echo "   ⚠ ログファイル $LOGFILE が存在します"
    read -p "   削除しますか？ (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -f "$LOGFILE"*
        echo "   ✓ ログファイルを削除しました"
    else
        echo "   - ログファイルを保持します"
    fi
else
    echo "   - ログファイルは存在しません"
fi

echo ""
echo "==== アンインストール完了 ===="
echo ""
echo "cron設定の削除が必要な場合："
echo "   sudo crontab -e"
echo "   # 以下の行を削除してください:"
echo "   0 2 * * * $SCRIPT_PATH"
