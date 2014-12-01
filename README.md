Processing_rhythmGame
=====================

Arduinoからの信号を受け取ってあそぶ音ゲー。Processing単体でも動きます。

###曲の追加・削除
=====================
/score/score_list.csvを編集します。コロン区切り。

以下の例のような順序でcsvを書きます。

Song Title | Author | File Path | Score Path | BPM | Offet Sec.
:------------: | :-------------: | :------------: | :------------: | :------------: | :------------:
We found Love | feat. De Lancaster  | We found Love.mp3 | 002.csv | 128 | 30

実際のテキストは以下のようになります。

`We found Love,feat. De Lancaster,We found Love.mp3,002.csv,128,30`

コロンの前後にはスペースを開けてはいけません。ここらへんは不自由な作りになっています。

