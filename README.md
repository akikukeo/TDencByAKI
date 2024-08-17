<!--タイトル-->
# TDenc｜byAKI v0.1.2 README-使用方法


「つんでれんこ」は、動画のエンコーダーです。元々の「つんでれんこ」を改造し、YouTubeにアップロードする動画を入力すると、自動的にエンコードを行う機能を追加しました。プリセットによって、本来の「つんでれんこ」で行われる質問をスキップし、スムーズにエンコードを実行します。

> ### 追記 <br>
> コードのダウンロードを行う際はZIP形式ではなくCloneでダウンロードしたほうがいいですよ！<br>
> なんかZIPだとBatが実行出来ない？



## 特徴

- **自動エンコード**: 動画ファイルを指定するだけで、自動的にエンコードを開始します。
- **プリセット対応**: エンコード設定はプリセットで管理され、質問をスキップしてスムーズに処理します。
    プリセットはご自分で変更も可能です。
- **簡単な操作**: 動画ファイルを「【ここに動画をD&D】.bat」にドラッグ＆ドロップし、媒体を指定するとエンコードが開始されます。

- **ブラウザで確認**:「ここにD&Dして動画をチェック」にエンコード済みの動画ファイルを投げることでブラウザから確認することができます。



## インストール

インストール手順は現在検討中です。必要なソフトウェアは自動的にインストールされます。詳細が決まり次第、こちらに記載いたします。



## 使用方法

1. **「動画をドロップ.bat」に動画ファイルを投げます。**

2. 自動的にコマンドプロンプトが立ち上がり、媒体の指定の質問が行われます。現在はYoutubeのみの対応です。<br>
    **YouTube以外を選択すると通常のつんでれんこと同様の手順となります。**

3. 確認が行われます。答えてください。終了するとエンコードが開始されます。

4. 完了するとブラウザにプレビューが表示されます。




### 応用的な使い方 | 本家つんでれんこ公式サイトの一部コピペ
1. 動画の音声差し替え<br>
動画ファイルと音声ファイル（wavのみ対応）を**一緒**にドラッグ＆ドロップすると、動画の音声を音声ファイルの音声と差し替えます。

2. 連番動画を連結してエンコード<br>
連番AVI（＆音声ファイル）をフォルダに入れ、フォルダごとドラッグ＆ドロップすると連番ファイルを連結して（＆音声をつけて）エンコード。

3. 複数の動画を連続エンコード<br>
複数の映像ファイルをドラッグ＆ドロップすると、動画をどんどん連続でエンコードしていきます。

4. ファイルサイズ、解像度、FPSなどの指定<br>
設定ファイル（user_setting.bat）で以下の設定を弄ることがができます。
    - 総ビットレート上限<br>
    - MP4の容量<br>
    - 自動リサイズの解像度<br>
    - FPS変換<br>
    - AACエンコーダ選択<br>
    - AACエンコードプロファイル選択<br>
    - デコーダ選択<br>
    - フルレンジ<br>
    - 自動バージョンチェック<br>
    - パス数設定<br>
    - MP4出力先<br>
    - 自動シャットダウン<br>





## ライセンス

TDencY_byAKI\Licenses\つんでれんこのライセンス.txtをご覧ください。<br>
元のつんでれんこのライセンスを継承します。
改良とか改造とかはどんどんしてくださいね！




## 作者
本家つんでれんこ作者｜窓屋
- [公式サイト](https://tdenc.com/)  <br>

改造版作者｜akikukeo
- [GitHub](https://github.com/akikukeo) <br>
- Discord|@akikukeo
