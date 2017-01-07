# tpNpcChat
すぐに消えてしまうテキストをログに残すアドオンです。  
主に「NPCの台詞」がチャットにログとして残るようになります。  

クエストなどでNPCの話がログに残らないのが気になったので作成しました。  
後から読み返すことが可能になります。  

1.1.0より、システムからの通知(NOTICE)の一部が表示されるようになっています。

| アイコン | 利用ケース | ToS内部の名前 | 設定の名前 |
| ---- | ---- | ---- | ---- |
| △に！ | クエストやダンジョンのメッセージ<br>115IDや240IDの開通がログに残ります | NOTICE_Dm_! | isShowExc |
| 巻物 | 防衛戦のメッセージなど<br>防衛戦で取得アイテムがログに残ります | NOTICE_Dm_scroll | isShowScr |
| 旗 | IDでボスの出現など | NOTICE_Dm_Clear | isShowClr |
| 宝石 | 特定アイテムの入手 | NOTICE_Dm_GetItem | isShowGet |
| 頭部 | キャラレベルアップ | NOTICE_Dm_levelup_base | isShowLvl |
| 交差剣 | クラスレベルアップ | NOTICE_Dm_levelup_skill | isShowLvl |


設定が増えてログが多くなっているため、ON/OFFが可能になっています。
「/addons/tpnpcchat/settings.json」をテキストで編集して、上記表の「設定の名前」項目をfalseにすると表示されなくなります。



