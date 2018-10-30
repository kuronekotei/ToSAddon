# tpFarmed
手に入れた物に関するログが出ます。  
v1.0.0でダメージ集計に対応しました。


- マップ切り替え時に前マップの取得経験とシルバー表示(無い物は出ません)
- アイテム取得時に個数と総個数を表示  
  重ならないものは個数が出ません
- アイテム取得時に冒険日誌の進捗表示  
  カウントは疑似カウントです、本来カウントされない取得方法でも加算表示されます
- ダメージ集計は対応するログの設定がONでないと集計されません  
  ログの設定はキャラ毎なので注意


設定あります。  
「/addons/tpfarmed/stg_tpfarmed.json」をテキストで編集してください。

| 名称 | 効果 |
| ---- | ---- |
| isShowCube	 | true/false　falseだとキューブ開封時の専用ログが出なくなります。	 |
| isShowSilver	 | true/false　falseだとシルバー取得時のログが出なくなります。	 |
| isShowJournal	 | true/false　falseだと冒険日誌用のカウントが出なくなります。	 |
| isShowGiveDmg	 | true/false　falseだと与ダメージ集計が出なくなります。	 |
| isShowTakeDmg	 | true/false　falseだと受ダメージ集計が出なくなります。	 |
| ManyMoney		 | true/false　この価格を超えると、上記がfalseでも表示されます。	 |



