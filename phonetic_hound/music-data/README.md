# Phonetic Hound 楽曲データ / Phonetic Hound tune data (ODbL)

このフォルダは、アプリに同梱している BGM の譜面データ（派生データベース）を
ODbL の Share-Alike 条項に従って公開するための原本一式です。

This folder holds the tune transcription data bundled with the app as background
music (a Derivative Database), to be published as required by the ODbL share-alike terms.

## 中身 / Contents

| ファイル | 内容 |
| --- | --- |
| `*.abc` | 譜面データ 10 曲（ABC 記譜） |
| `credits.json` | 曲ごとの場面（role）・出典・採譜者・元 URL・加えた変更 |
| `LICENSE.txt` | ライセンス表記・著作権表示・加えた変更 |

`android/assets/music/` と同じ内容です。`tools/music/fetch_tunes.py` が両方を書き出します。

## ライセンス / License

ODC Open Database License (ODbL) v1.0
<https://opendatacommons.org/licenses/odbl/1-0/>

Contains information from The Session (<https://thesession.org>), which is
made available under the ODC Open Database License (ODbL).

詳細と採譜者一覧、加えた変更の内容は `LICENSE.txt` を参照してください。
See `LICENSE.txt` for the full attribution list and the changes made.

## 公開先 / Published at

<https://github.com/kijitora-no-hito/android-apps/tree/main/phonetic_hound/music-data>
（android-apps リポジトリ。`credits.json` の `dataUrl`・`LICENSE.txt` の 5 節と同じ）。
アプリ内の「クレジット → 楽曲データを書き出す」でもこの一式を zip で取り出せる。

## 譜面を追加・変更したら

`tools/music/fetch_tunes.py` の `TUNES` を直して再実行し、このフォルダを公開先にも上げ直すこと。
ODbL の Share-Alike は、派生データベースを更新した場合にも適用されます。
