# Phonetic Hound 楽曲データ / Phonetic Hound tune data (ODbL)

このフォルダは、アプリに同梱している BGM の譜面データ（派生データベース）を
ODbL の Share-Alike 条項に従って公開するための原本一式です。

This folder holds the tune transcription data bundled with the app as background
music (a Derivative Database), to be published as required by the ODbL share-alike terms.

## 中身 / Contents

| ファイル | 内容 |
| --- | --- |
| `*.abc` | 譜面データ 26 曲（ABC 記譜） |
| `credits.json` | 曲ごとの場面（role・stage・scene）・出典・採譜者・元 URL・加えた変更 |
| `LICENSE.txt` | ライセンス表記・著作権表示・加えた変更 |

`android/assets/music/` と同じ内容です。`tools/music/fetch_tunes.py` が両方を書き出します。

## 曲一覧 / Tunes

| 場面 / Scene | 曲 / Tune | 種類・調 / Type, key | 採譜 / Transcribed by | 出典 / Source |
| --- | --- | --- | --- | --- |
| TITLE | Carolan's Farewell To Music | reel, A dorian | glauber | <https://thesession.org/tunes/244#setting244> |
| EXPLORE (TOKYO AREA I) | Morrison's | jig, E dorian | Jeremy | <https://thesession.org/tunes/71#setting71> |
| EXPLORE (TOKYO AREA I) | The Cliffs Of Moher | jig, A dorian | Jeremy | <https://thesession.org/tunes/12#setting12> |
| EXPLORE (TOKYO AREA II) | The Rights Of Man | hornpipe, E minor | Jeremy | <https://thesession.org/tunes/83#setting83> |
| EXPLORE (TOKYO AREA II) | The Mist Covered Mountain | jig, A dorian | glauber | <https://thesession.org/tunes/256#setting256> |
| EXPLORE (KYUSHU) | The Ballydesmond | polka, A dorian | Jeremy | <https://thesession.org/tunes/238#setting238> |
| EXPLORE (KYUSHU) | The Sligo Maid | reel, A dorian | Josh Kane | <https://thesession.org/tunes/399#setting399> |
| EXPLORE (TOKYO AREA III) | Julia Delaney's | reel, D dorian | b.maloney | <https://thesession.org/tunes/589#setting589> |
| EXPLORE (TOKYO AREA III) | Jenny's Chickens | reel, B minor | b.maloney | <https://thesession.org/tunes/756#setting756> |
| EXPLORE (NAGANO) | The Kid On The Mountain | slip jig, E minor | Jeremy | <https://thesession.org/tunes/52#setting52> |
| EXPLORE (NAGANO) | Scatter The Mud | jig, A dorian | seara | <https://thesession.org/tunes/728#setting728> |
| EXPLORE (TOKYO AREA IV) | The Gravel Walks | reel, A dorian | Jeremy | <https://thesession.org/tunes/42#setting42> |
| EXPLORE (TOKYO AREA IV) | Brian Boru's March | jig, A minor | JeffK627 | <https://thesession.org/tunes/271#setting271> |
| COMBAT (TOKYO AREA I) | The Musical Priest | reel, B minor | Jeremy | <https://thesession.org/tunes/73#setting73> |
| COMBAT (TOKYO AREA II) | The Tarbolton | reel, E dorian | b.maloney | <https://thesession.org/tunes/560#setting560> |
| COMBAT (KYUSHU) | The Rakes Of Kildare | jig, A dorian | Jeremy | <https://thesession.org/tunes/84#setting84> |
| COMBAT (TOKYO AREA III) | The Glass Of Beer | reel, B minor | Will Harmon | <https://thesession.org/tunes/188#setting188> |
| COMBAT (NAGANO) | The Lilting Banshee | jig, A dorian | Jeremy | <https://thesession.org/tunes/60#setting60> |
| COMBAT (TOKYO AREA IV) | The Maids Of Mount Kisco | reel, A dorian | b.maloney | <https://thesession.org/tunes/432#setting432> |
| COMBAT (SWARM) | The Star Of Munster | reel, A dorian | Jeremy | <https://thesession.org/tunes/197#setting197> |
| COMBAT (FINAL) | Toss The Feathers | reel, E dorian | Jeremy | <https://thesession.org/tunes/113#setting113> |
| COMBAT (BOSS) | The Butterfly | slip jig, E minor | Jeremy | <https://thesession.org/tunes/10#setting10> |
| COMBAT (BOSS) | The Rocky Road To Dublin | slip jig, A dorian | bsykes62 | <https://thesession.org/tunes/593#setting593> |
| REST | Port Na bPúcaí | waltz, D major | Daithi_C | <https://thesession.org/tunes/1811#setting1811> |
| CLEAR | Haste To The Wedding | jig, D major | Jeremy | <https://thesession.org/tunes/582#setting582> |
| DOWN | Chumha Eoghain Rua Ui Neill | reel, G minor | Respect | <https://thesession.org/tunes/907#setting7199> |

COMBAT (FINAL) は最終ステージ（TOKYO AREA IV）で巨大局のシールドが消えた後の戦闘曲です（`credits.json` の `scene: "FINAL"`）。
COMBAT (FINAL) is the battle tune for the final stage (TOKYO AREA IV) after the macro station's shield is down.

COMBAT (SWARM) は敵の群れが集まってきたとき（自分を狙う敵が 40m 以内に 6 体以上）の戦闘曲です（`credits.json` の `scene: "SWARM"`）。
COMBAT (SWARM) is the battle tune played when a swarm of enemies closes in (6 or more hostiles targeting you within 40 m).

COMBAT（ステージ id 付き）はそのステージの通常の戦闘曲です（v0.19.0-dev からステージごと。`credits.json` の `stage`）。
COMBAT (BOSS) はボスと戦っている間の曲で、旋律を 1 オクターブ下げて遅く重く演奏します（`credits.json` の `scene: "BOSS"`）。
COMBAT entries with a stage id are that stage's regular battle tune (per stage since v0.19.0-dev, `stage` in `credits.json`).
COMBAT (BOSS) plays while fighting a boss, performed an octave lower, slower and heavier (`scene: "BOSS"` in `credits.json`).

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
