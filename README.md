Make sure your env OPENAI_API_KEY available. 
You can also editing .env, put OPENAI_API_KEY inside. eg.
```
echo "OPENAI_API_KEY=sk-proj-tLl...PcA" > .env
```

## Generate Embedding

Fetch 165 cases using 165cases.sh
This command fetch 3 pages(order by create date ASC)
```
./165cases.sh 3
```

Get embeddings from OpenAI
Exists file will be skipped. Delete file to re-fetch the embedding
```
./165embedding.sh cases/p001.json
```

## Run similarity service
```
Usage of ./165simserv:
  -embedding-dir string
        [Required] Path to the OpenAI embedding dir
  -result-number int
        [Optional] Result number of similarity (default 5)
```

```
./165simserv -embedding-dir embedding -result-number 10
```
This will show prompt below to make sure your understand the charge will happen on each request.
Currently we use text-embedding-3-large, check [OpenAI Pricing](https://openai.com/api/pricing/#:~:text=Embedding%20models) for details.

```
2025/01/11 18:19:54 OpenAI API Key: sk-proj-tL ... done

IMPORTANT NOTICE:
This service will use OpenAI API with your provided API key.
Each request will incur charges to your OpenAI account.
Do you want to continue? (y/n):
```

After you pressing `y`, the service will load all embeddings into memory, then show the service running:
```
2025/01/11 18:26:28 Starting server on :9989
```

## Query Similarity

curl 'http://localhost:9989/?q={Query Text}'

```
curl 'http://localhost:9989/?q=那天晚上，我正準備收工回家，手機突然跳出一則簡訊，自稱是台灣大哥 大，說我還有將近兩萬點積分即將過期，可以兌換獎品！身為一個在台北努力工作的商店店員，平時省吃儉用， 突然聽到有這麼多積分，心裡頭可樂壞了！鬼迷心竅的，我毫不猶豫地點擊了簡訊裡的連結。網站設計得有模有 樣，簡直跟台灣大哥大的官網一模一樣！它要求我輸入信用卡卡號和安全碼，還需要輸入手機收到的認證碼。我 毫不遲疑地照做了，心想反正只是兌換積分，應該沒什麼問題。直到隔天早上，我收到銀行簡訊，顯示我的信用 卡被盜刷了四萬元！四萬元！那是我省吃儉用好幾個月的薪水啊！我整個人都傻掉了，手腳冰冷，腦袋一片空白 。我趕緊打電話給台北富邦銀行客服，他們表示會協助處理。然而，這噩夢還沒結束。幾個月後，我又接到一個 電話，自稱是富邦信用卡客服，說之前那筆被盜刷的四萬元，銀行追不回來，現在要我付錢！我氣得渾身發抖， 簡直不敢相信！這分明是二次詐騙！我立刻撥打了165反詐騙專線報案。四萬塊錢，對我來說是一筆巨款，現在卻因為一時的貪小便宜，全打了水漂。更可惡的是，這群詐騙集團竟然還敢再次出手！這段經歷讓我心痛不已，也 讓我深深體會到，網路詐騙的可怕，以及自己輕信他人付出的慘痛代價。現在只要一看到任何來路不明的簡訊或 連結，我都會格外謹慎，再也不敢輕易相信任何天上掉下來的「好康」了。' | jq
```

Example Response:
```
{
  "similarity": [
    {
      "Similarity": 0.9080605,
      "Index": "135920408959389696"
    },
    {
      "Similarity": 0.82657945,
      "Index": "130867847642484749"
    },
    {
      "Similarity": 0.81674975,
      "Index": "126877770805415936"
    }
  ],
  "documents": {
    "126877770805415936": {
      "Id": "126877770805415936",
      "CaseDate": "2024-12-14T16:00:00Z",
      "CityName": "臺北市",
      "CityId": 1,
      "Summary": "那晚，我正加班到深夜，疲憊地滑著手機。突然，手機跳出一則簡訊，顯示我的信用卡消費 異常。我，一個38歲的男性，從事個人服務業，平常工作忙碌，對這類訊息向來不太留意，但我隱約覺得不太對 勁。簡訊裡提示我點擊連結查詢詳情。\n\n鬼迷心竅，我點開了連結。一個仿冒得極為逼真的銀行網頁跳了出來 ，上面顯示著我的卡號後四碼，以及一筆巨額消費，我的心瞬間涼了半截。網頁要求我輸入卡號、有效日期及背 面安全碼以「取消」這筆交易。當時的我，腦中一片混亂，只想着趕快阻止這筆錢被盜刷，根本沒察覺到任何異 狀。\n\n我慌慌張張地輸入了所有資訊。幾秒鐘後，網頁跳出「處理成功」的訊息，我鬆了口氣。直到隔天早上 ，銀行的電話才打來，告知我信用卡被盜刷了五萬元！五萬！我辛辛苦苦幾個月才能賺到的錢，就這麼憑空消失 了！\n\n我報了警，但警察說這種網路詐騙手法層出不窮，追回的可能性微乎其微。五萬塊，對我來說是一筆巨 款，想到這筆錢可能就這麼不見了，我恨不得狠狠抽自己幾個耳光！悔恨和憤怒交織在一起，讓我徹夜難眠。這 件事成了我人生中一個巨大的污點，也讓我更加明白，網路詐騙的可怕，以及自己輕信他人、缺乏警惕的後果有 多麼悲慘。\n",
      "CaseTitle": "信用卡遭盜刷詐騙",
      "embedding": null
    },
    "130867847642484749": {
      "Id": "130867847642484749",
      "CaseDate": "2024-12-09T16:00:00Z",
      "CityName": "臺北市",
      "CityId": 1,
      "Summary": "那天，手機螢幕閃爍著中國信託的簡訊，我，一個44歲的證券金融從業人員，從來沒有想過 ，自己會淪為詐騙集團的獵物。簡訊內容顯示我的信用卡有異常消費，並附上一個看起來很官方的網址。鬼迷心 竅，我竟然點進去了。\n\n那是一個偽造得幾乎以假亂真的網站，要求我輸入信用卡資訊以確認身份。我當時真 是愚不可及，竟然完全沒有察覺到網址上的細微差別！輸入完畢後，我還收到一封「確認完成」的電郵，簡直像 是被編織好的陷阱，一步一步把我推進深淵。\n\n接下來幾天，我根本沒注意到帳戶有任何異常，直到我收到銀 行的消費明細，才發現噩夢降臨。我的信用卡竟然被盜刷了151922元！這筆錢，夠我買一台好車，夠我一家三口 度假一年，卻就這樣憑空消失了！\n\n我報警後，警察耐心地聽我敘述案情，語氣中卻帶著無奈，這種案件他們 見多了。那一刻，我感到無比的沮喪和悔恨。我的專業知識，我的理財能力，在這個精心設計的詐騙面前，竟然 不堪一擊。我恨那些躲在螢幕後面，操縱著鍵盤，榨取他人血汗錢的惡棍！我更恨自己的輕率和疏忽，讓他們有 機可乘。\n\n現在，除了報案，我所能做的，只有更加小心謹慎，提醒身邊的人注意網路詐騙，不要再讓更多人 和我一樣，成為他們斂財的工具，嚐到這令人心碎的苦果。\n",
      "CaseTitle": "信用卡遭盜刷詐騙",
      "embedding": null
    },
    "135920408959389696": {
      "Id": "135920408959389696",
      "CaseDate": "2025-01-08T16:00:00Z",
      "CityName": "臺北市",
      "CityId": 1,
      "Summary": "那天晚上，我正準備收工回家，手機突然跳出一則簡訊，自稱是台灣大哥大，說我還有將近 兩萬點積分即將過期，可以兌換獎品！身為一個在台北努力工作的商店店員，平時省吃儉用，突然聽到有這麼多 積分，心裡頭可樂壞了！鬼迷心竅的，我毫不猶豫地點擊了簡訊裡的連結。\n\n網站設計得有模有樣，簡直跟台 灣大哥大的官網一模一樣！它要求我輸入信用卡卡號和安全碼，還需要輸入手機收到的認證碼。我毫不遲疑地照 做了，心想反正只是兌換積分，應該沒什麼問題。\n\n直到隔天早上，我收到銀行簡訊，顯示我的信用卡被盜刷 了四萬元！四萬元！那是我省吃儉用好幾個月的薪水啊！我整個人都傻掉了，手腳冰冷，腦袋一片空白。我趕緊 打電話給台北富邦銀行客服，他們表示會協助處理。\n\n然而，這噩夢還沒結束。幾個月後，我又接到一個電話 ，自稱是富邦信用卡客服，說之前那筆被盜刷的四萬元，銀行追不回來，現在要我付錢！我氣得渾身發抖，簡直 不敢相信！這分明是二次詐騙！\n\n我立刻撥打了165反詐騙專線報案。四 萬塊錢，對我來說是一筆巨款，現在卻因為一時的貪小便宜，全打了水漂。更可惡的是，這群詐騙集團竟然還敢再次出手！這段經歷讓我心痛不已，也 讓我深深體會到，網路詐騙的可怕，以及自己輕信他人付出的慘痛代價。現在只要一看到任何來路不明的簡訊或 連結，我都會格外謹慎，再也不敢輕易相信任何天上掉下來的「好康」了。\n",
      "CaseTitle": "釣魚簡訊(惡意連結)詐騙",
      "embedding": null
    }
  }
}
```
