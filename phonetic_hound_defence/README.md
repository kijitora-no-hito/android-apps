<p><img src="images/icon.png" width="96" alt="Phonetic Hound Defence のアイコン"></p>

# Phonetic Hound Defence（開発中）

> **⚠ 開発中の版です。** 遊べるのはステージ 1 だけで、内容・バランス・画面は今後大きく変わります。
> セーブデータは今後の版で引き継げなくなることがあります。

[Phonetic Hound](https://kijitora-no-hito.github.io/android-apps/phonetic_hound/) の街とキャラクターで遊ぶ、横画面のタワーディフェンスです。

## どんなゲーム？

電波で操られたゾンビの街から、人類はついに基地局を取り戻した。
けれど街に残ったゾンビの群れは、基地局を奪い返そうと押し寄せてくる——。

- 街の外れから道路に沿って攻めてくる **wave** を、防衛装置と**勇者**で食い止め、基地局を守り抜く
- 防衛装置はアンテナを砲台にしたもの。資金の範囲で置き、強化・売却しながら守りを組み立てる
- 勇者は Phonetic Hound の主人公。自動で戦い、地図をタップした所へ駆けつけ、必殺技の衝撃波で群れを吹き飛ばす
- 次の wave の**進路を先に地図で確かめて**から配置できる（その先の wave も薄く表示）
- 装置を置けるのは基地局の**電波が届く範囲**だけ。局ごとに**周波数帯**を選ぶと、届く範囲と置ける台数が変わる（高い帯ほど狭いが、たくさん置ける）。**中継器**で範囲を広げられる
- 街並みは Phonetic Hound と同じく、実在の地形と建物のデータから作り、電波は建物での回折まで計算

<table>
<tr>
<td align="center"><img src="top/routes.jpg" width="420" alt="進路の予告"><br>次の wave の進路を確かめてから守りを組む</td>
<td align="center"><img src="top/battle.jpg" width="420" alt="防衛"><br>道路を進む群れを砲台で迎え撃つ</td>
</tr>
<tr>
<td align="center"><img src="top/boss_wave.jpg" width="420" alt="最後の wave"><br>最後の wave。勇者が巨大局の前で踏みとどまる</td>
<td></td>
</tr>
</table>

## ダウンロード

### [APK をダウンロード（v0.3.0-dev・開発中・6.4 MB）](https://github.com/kijitora-no-hito/android-apps/releases/download/phonetichounddefence-v0.3.0-dev/phonetichounddefence-0.3.0-dev-release.apk)

<p><img src="images/qr.png" width="140" alt="このページの QR コード"><br>PC で見ている方へ: スマホでこの QR を読み取ると、このページが開きます。</p>

## インストール方法

1. このページをスマホのブラウザで開き、上の「APK をダウンロード」を押します。
2. ダウンロードした APK を開きます。初回は「提供元不明のアプリ」のインストールを許可するよう求められるので、使っているブラウザ（またはファイルアプリ）に許可してください。
3. Google Play プロテクトが警告を出すことがあります。ストアを通さない APK では一般的に出る表示です。心配なときは下の SHA-256 と一致するか確かめてください。

- 自動更新はありません。新しい版は、このページから同じ手順で入れ直してください（上書きインストールになります）。
- Phonetic Hound とは別のアプリです。両方入れても、互いのセーブには影響しません。
- このアプリは GitHub でのみ配布しています。

## この版でできること（0.3.0-dev）

- ステージ 1（TOKYO AREA I）: 10 wave、最後に大型の敵。局を守り切った残りの耐久で ★1〜3。
- 防衛装置 6 種類（3 段階の強化・売却）、勇者 1 人（タップで移動・必殺技）、中継器。
- 進路の予告（次の wave ははっきり、その先は薄く）と、これからの wave の一覧。
- 周波数帯（900MHz / 2.4GHz / 6GHz / 14GHz / 28GHz）を局ごとに選ぶと、置ける範囲と台数が変わる。
- 設定: 音・中継器の置き方（自由に置く／決まった地点から選ぶ。端末の速さで初期値が決まる）。

これから: ステージ 2・3、バランスの調整。

## 注意

- 開発中の版です。不具合があれば [Issues](https://github.com/kijitora-no-hito/android-apps/issues) へお知らせください。
- 登場する携帯基地局・事業者は架空のもので、実在の事業者・基地局とは関係ありません。
- ゾンビとの戦闘の表現があります（流血の表現はありません）。

## 出典

- 建物・道路などの地図データ: © [OpenStreetMap](https://www.openstreetmap.org/copyright) contributors（ODbL）
- 地形: [国土地理院（標高タイル）](https://maps.gsi.go.jp/development/ichiran.html)
- 電波の計算: ITU-R P.526（回折）・3GPP TR 36.814（アンテナのパターン）をもとに自作
- BGM の譜面: [The Session](https://thesession.org/)（ODbL 1.0）。Phonetic Hound と同じ譜面データを使っています
  （[music-data](https://github.com/kijitora-no-hito/android-apps/tree/main/phonetic_hound/music-data)）。
- フォント: Noto Sans JP（SIL Open Font License 1.1）
- ゲームエンジン: libGDX（Apache License 2.0）

## プライバシーポリシー

[Phonetic Hound Defence プライバシーポリシー](https://kijitora-no-hito.github.io/android-apps/phonetic_hound_defence/privacy-policy.html)

## 更新履歴

<details open markdown="1">
<summary><b>0.3.0-dev</b>（2026-10-05）</summary>

- 最初の公開（開発中）。ステージ 1、防衛装置・勇者・中継器、進路の予告、周波数帯とカバレッジ、設定。

</details>

---

| 項目 | 内容 |
| --- | --- |
| バージョン | 0.3.0-dev（2026-10-05・開発中） |
| ファイル | `phonetichounddefence-0.3.0-dev-release.apk`（6,688,493 バイト） |
| SHA-256 | `F7330FD4BC971D47F17E65C687B8B8A43851D98C11926BA8D336AED4C9D06CB4` |
| 対応 Android | 7.0 以上（横画面） |
| 価格 | 無料・広告なし・アプリ内課金なし・アカウント登録なし |

使う権限はありません（インターネットにも接続しません）。
