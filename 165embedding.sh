#!/bin/bash
if [ -f .env ]; then
    while IFS='=' read -r key value; do
        # 跳過空行和註釋行
        if [ -z "$key" ] || [[ $key == \#* ]]; then
            continue
        fi
        eval "$key=$value"
    done < .env
fi

# 檢查是否提供輸入檔案參數
if [ -z "$1" ]; then
    echo "Error: Input file is required"
    echo "Usage: $0 <input-json-file>"
    echo "Example: $0 input.json"
    exit 1
fi

# 檢查檔案是否存在
if [ ! -f "$1" ]; then
    echo "Error: File '$1' does not exist"
    exit 1
fi

# 檢查檔案是否可讀
if [ ! -r "$1" ]; then
    echo "Error: File '$1' is not readable"
    exit 1
fi

# 檢查檔案是否為 JSON 格式
if ! jq empty "$1" 2>/dev/null; then
    echo "Error: File '$1' is not a valid JSON file"
    exit 1
fi

# 檢查 OPENAI_API_KEY 環境變數
if [ -z "$OPENAI_API_KEY" ]; then
    echo "Error: OPENAI_API_KEY environment variable is not set"
    echo "Please set it using: export OPENAI_API_KEY='your-api-key-here'"
    exit 1
fi

INPUT_FILE="$1"
DELAY=0.333  # 每次 API 呼叫之間的延遲（秒）

# 建立 embedding 目錄
mkdir -p embedding

process_item() {
    local item="$1"
    local id=$(echo $item | jq -r '.Id')
    
    # 檢查檔案是否已存在
    if [ -f "embedding/${id}.json" ]; then
        echo "File embedding/${id}.json already exists, skipping..."
        return 0
    fi
    
    echo "Processing ID: $id"
    
    # 只有當檔案不存在時才執行以下處理
    local ReqText=$(echo $item | \
        jq -r '[.CityName, .CaseTitle, .Summary] | join(" | ")' | \
        # 移除換行符號並轉換成空格
        tr '\n' ' ' | \
        # 移除多餘空格
        tr -s ' ' | \
        # 移除結尾空白
        sed 's/[[:space:]]*$//' | \
        # 處理雙引號
        sed 's/"/\\"/g' | \
        # 處理 Windows 風格的換行符號
        sed 's/\r//g' | \
        # 額外處理可能造成 JSON 解析錯誤的特殊字元
        sed 's/\\/\\\\/g' | \
        # 處理反斜線之後再處理雙引號，確保正確跳脫
        sed 's/"/\\"/g')

    # 呼叫 API 並檢查回應
    response=$(curl -s https://api.openai.com/v1/embeddings \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $OPENAI_API_KEY" \
      -d "{
        \"input\": \"$ReqText\",
        \"model\": \"text-embedding-3-large\"
      }")
    
    # 檢查是否有錯誤
    if echo "$response" | jq -e '.error' >/dev/null; then
        echo "Error processing ID ${id}: $(echo $response | jq -r '.error.message')"
        return 1
    fi
    
    # 取得 embedding 並儲存
    embedding=$(echo $response | jq '.data[0].embedding')
    if [ "$embedding" = "null" ]; then
        echo "Error: No embedding found for ID ${id}"
        return 1
    fi
    
    # 儲存結果
    echo $item | jq --argjson emb "$embedding" '. + {embedding: $emb}' > "embedding/${id}.json"
    echo "Successfully processed and saved embedding/${id}.json"
    
    sleep $DELAY
}

# 主處理流程
echo "Starting processing file: $INPUT_FILE"
jq -c '.body.Detail[]' "$INPUT_FILE" | while read -r item; do
    process_item "$item"
done
echo "Processing completed!"
