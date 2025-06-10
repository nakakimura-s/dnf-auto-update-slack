#!/bin/bash

# 設定
SLACK_WEBHOOK_URL="https://hooks.slack.com/services/YOUR/WEBHOOK/URL"
HOSTNAME=$(hostname)
LOGFILE="/var/log/dnf-auto-update-slack.log"

# ログ関数
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOGFILE"
}

# Slack通知関数
send_slack_notification() {
    local message="$1"
    local color="$2"
    
    curl -X POST -H 'Content-type: application/json' \
        --data "{
            \"attachments\": [
                {
                    \"color\": \"$color\",
                    \"title\": \"DNF Update Report - $HOSTNAME\",
                    \"text\": \"$message\",
                    \"ts\": $(date +%s)
                }
            ]
        }" \
        "$SLACK_WEBHOOK_URL"
}

# メイン処理開始
log "DNF自動更新スクリプト開始"

# 更新可能なパッケージをチェック
UPDATES_AVAILABLE=$(dnf check-update --quiet 2>/dev/null | wc -l)

if [ "$UPDATES_AVAILABLE" -gt 0 ]; then
    log "更新対象パッケージ数: $UPDATES_AVAILABLE"
    
    # 更新対象パッケージ一覧を取得
    UPDATE_LIST=$(dnf check-update --quiet 2>/dev/null)
    
    # 更新実行
    log "DNF更新を実行中..."
    UPDATE_RESULT=$(dnf update -y 2>&1)
    UPDATE_EXIT_CODE=$?
    
    if [ $UPDATE_EXIT_CODE -eq 0 ]; then
        log "更新が正常に完了しました"
        
        # 成功通知をSlackに送信
        MESSAGE="✅ パッケージ更新が正常に完了しました\n\n"
        MESSAGE+="*更新されたパッケージ:*\n\`\`\`\n$UPDATE_LIST\n\`\`\`\n"
        MESSAGE+="*実行時刻:* $(date '+%Y-%m-%d %H:%M:%S')"
        
        send_slack_notification "$MESSAGE" "good"
        
    else
        log "更新中にエラーが発生しました (終了コード: $UPDATE_EXIT_CODE)"
        
        # エラー通知をSlackに送信
        MESSAGE="❌ パッケージ更新中にエラーが発生しました\n\n"
        MESSAGE+="*エラー詳細:*\n\`\`\`\n$UPDATE_RESULT\n\`\`\`\n"
        MESSAGE+="*実行時刻:* $(date '+%Y-%m-%d %H:%M:%S')"
        
        send_slack_notification "$MESSAGE" "danger"
    fi
    
else
    log "更新対象のパッケージはありません"
    
    # 更新なし通知をSlackに送信（オプション）
    MESSAGE="ℹ️ 更新対象のパッケージはありませんでした\n\n"
    MESSAGE+="*実行時刻:* $(date '+%Y-%m-%d %H:%M:%S')"
    
    send_slack_notification "$MESSAGE" "warning"
fi

log "DNF自動更新スクリプト終了"
