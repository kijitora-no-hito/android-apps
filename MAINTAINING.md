# 運用メモ（配布リポジトリの更新手順）

このリポジトリ（`kijitora-no-hito/android-apps`）は **ソースコードを入れない** 配布専用リポジトリ。
入れるのは説明ページ・画像・プライバシーポリシー・楽曲データなどの公開物だけ。
**APK / AAB は git に入れず GitHub Releases に添付する**（`.gitignore` で除外済み）。

各アプリの正本は `d:\work\android\<app>\store\`（掲載文・ポリシー・画像）と `dist\`（APK）。ここはその写し。

## 構成

```
android-apps/
├── README.md              トップ（アプリ一覧・共通のインストール方法・利用条件）
├── LICENSE                利用条件（All rights reserved・再配布禁止）
├── _config.yml            GitHub Pages（Jekyll / jekyll-theme-primer）
├── releases.json          Release の tag / title / APK / SHA-256 / ノート
├── images/qr-top.png      トップページの QR
├── tools/make_qr.py       QR の生成（URL 一覧はこのファイルの PAGES）
├── tools/publish-releases.ps1  releases.json → gh release create
└── <folder>/
    ├── README.md          アプリページ（Pages では index.html になる）
    ├── privacy-policy.html
    └── images/            icon.png / feature.png / qr.png / スクリーンショット（JPEG 540px）
```

- URL: トップ `https://kijitora-no-hito.github.io/android-apps/`、アプリ `…/android-apps/<folder>/`（大文字小文字を区別する。`TPS_CAMERA/`）。
- タグ: `<slug>-v<version>`（`tripplanner-v1.5` など。slug は APK ファイル名の先頭と同じ）。
- APK の直リンク: `https://github.com/kijitora-no-hito/android-apps/releases/download/<tag>/<apk ファイル名>`
- **QR はアプリページを指している**ので、版を上げても作り直さない。

## 初回の公開

1. GitHub に公開リポジトリ `android-apps` を作り、このフォルダを push する（main ブランチ）。
   `gh release create` はタグをデフォルトブランチの先頭に打つので、**Release より先に 1 回 push しておく**。
2. Settings → Pages → Source: 「Deploy from a branch」、Branch: `main` / `/ (root)`。
3. `gh auth login` 済みの状態で `.\tools\publish-releases.ps1 -DryRun` → 問題なければ `.\tools\publish-releases.ps1`。
4. Pages とリポジトリ画面の両方で、各アプリページのダウンロードリンクが 404 にならないか確かめる。

## 新しい版を出すとき

例: 旅行プランナーを 1.6 にする。

1. アプリ側で `versionCode` +1・`versionName` を上げてビルドし、`<app>\dist\` に APK を置く
   （tsukutta 版・Play 版と**同じ APK / 同じ versionCode**。手順は各アプリの `store/README.md`）。
2. SHA-256 とサイズを取る:
   ```powershell
   $f = Get-Item d:\work\android\trip_planner\dist\tripplanner-1.6-release.apk
   (Get-FileHash $f.FullName -Algorithm SHA256).Hash; $f.Length
   ```
3. `releases.json` の該当エントリを書き換える（`tag` / `title` / `apk` / `sha256` / `notes`）。
   古いエントリは消してよい（既存タグはどのみちスキップされる）。
4. `.\tools\publish-releases.ps1 -Only tripplanner-v1.6` で Release を作って APK を添付する。
5. アプリページ `<folder>/README.md` を直す:
   - ダウンロードの見出し（版・MB）とリンク先（タグとファイル名）
   - 表のバージョン・日付・ファイル名・バイト数・SHA-256・対応 Android（minSdk を変えたとき）・権限（増減したとき）
   - 機能説明・スクリーンショット・注意書き（変わったとき）
6. トップ `README.md` のアプリ一覧の版表記を直す。
7. 掲載文やプライバシーポリシーを変えた版なら、`store/` から `privacy-policy.html` と画像をコピーし直す。
8. commit → push。Pages は数分で反映される。

**QR は作り直さない。** 作り直すのはアプリを追加したとき（`tools/make_qr.py` の `PAGES` に 1 行足して実行）だけ。

## アプリを追加するとき

1. `<folder>/` を作り、`images/icon.png`（`store/play-icon-512.png`）・`images/feature.png`・
   スクリーンショット（Pillow で幅 540px の JPEG・品質 85 に縮小）・`privacy-policy.html` を置く。
2. 既存のアプリページを雛形に `<folder>/README.md` を書く（tsukutta 固有の文言は外す）。
3. `tools/make_qr.py` の `PAGES` に追加して実行（`pip install "qrcode[pil]"`）。
4. トップ `README.md` の表に 1 行足す。`releases.json` にエントリを足して Release を作る。

## 注意

- **ソースコード・署名鍵・keystore.properties・local.properties は絶対に入れない。**
- 載せていないアプリ: target_camera（同梱モデルのライセンスが未決）、radio_survey（Maps API キーの扱いで保留）、radioprop（配布しない）。
- link_conne2 の APK（direct flavor）は、アプリ内のアップデート確認が **tsukutta.app の配布ページ**を読み、
  APK の SHA-256 で版を判定する。GitHub にも **tsukutta に上げたのと同じ APK** を置くこと（作り直すと「履歴に無い」扱いになる）。
- link_conne2 の譜面データ（`link_conne2/music-data/`）は ODbL の Share-Alike のための公開物。譜面を変えたら `store/music-data/` からコピーし直す。
- Jekyll は `.md` を Liquid で処理するので、ページに `{{` や `{%` を書かない。
