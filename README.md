Processing_rhythmGame
=====================

Arduinoからの信号を受け取ってあそぶ音ゲー。Processing単体でも動きます。
![001](/screenshots/001.png)
![002](/screenshots/002.png)

##曲の追加・削除
`/score/score_list.csv`を編集します。コロン区切り。

以下の例のような順序でcsvを書きます。

Song Title | Author | File Path | Score Path | BPM | Offet Sec.
:------------: | :-------------: | :------------: | :------------: | :------------: | :------------:
We found Love | feat. De Lancaster  | We found Love.mp3 | 002.csv | 128 | 30

実際のテキストは以下のようになります。

`We found Love,feat. De Lancaster,We found Love.mp3,002.csv,128,30`

行を削除すれば曲一覧から消えます。
コロンの前後にはスペースを開けてはいけません。ここらへんは不自由な作りになっています。

##譜面（スコア）の作成
###譜面への書き込み
曲を追加しても譜面ファイルがないので、ゲームとしては成り立ちません。

プレイ中に曲に合わせて`a, s, d, f`をタイプすることで、譜面データを記録。4軸が左か順番にそれぞれ`a, s, d, f`と対応しています。

最後に`w`を入力することで、ファイルに書き込みます。
書き込まれた譜面ファイルは`/input/***.csv`の名前で保存されています。

###譜面ファイルの移動・適応
`/input`にある譜面ファイルを`/score`へコピーします。
その後、`/score/score_list.csv`のFilePathに合致するようファイル名を整形することで、曲と譜面が対応します。
