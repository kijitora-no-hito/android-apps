# TPS Camera マルチプレイ用サーバの立て方

TPS Camera のマルチプレイは、**自分で用意した中継サーバ**に、同じ「部屋コード」を入れた人どうしが集まって、
お互いの位置・向き・ピン・ひとことメッセージを共有する仕組みです。アプリにサーバは付属していないので、
仲間内の誰か 1 人がこのページの手順でサーバを立ててください。

[← TPS Camera のページに戻る](./)

## 最初に知っておいてほしいこと

- **サーバを立てた人（管理者）は、接続中の人の位置情報を見られる立場になります。** 信頼できる仲間どうしで使ってください。
- **合言葉（`AUTH_TOKEN`）は必ず設定してください。** 設定しないと、サーバのアドレスと部屋コードを知っている人は誰でも入れます。
- サーバは位置・ピン・メッセージを**メモリ上で中継するだけ**で、ファイルやデータベースには保存しません。全員が抜けた部屋は消え、サーバを止めればすべて消えます。
- アプリには**通報・ブロックの機能がありません**。知らない人と同じ部屋に入る使い方は想定していません。
- アプリは**暗号化された接続（`wss://`）にしかつなげません**。そのため、下のどちらかの方法で HTTPS の入口を用意します。

| | A. 自宅の PC ＋ Cloudflare Tunnel | B. VPS ＋ 自分のドメイン |
|---|---|---|
| 向いている人 | とりあえず試したい / 集まるときだけ使う | 常時動かしておきたい |
| 必要なもの | Windows / Mac / Linux の PC 1 台 | VPS（Linux）とドメイン |
| 費用 | 無料 | VPS とドメインの料金 |
| アドレス | 起動するたびに変わる（`https://〜.trycloudflare.com`） | 固定（`wss://tps.example.com/ws`） |
| PC の電源 | 使う間はつけっぱなし | 不要 |

## サーバのダウンロード

[Releases の「TPS Camera サーバ」](https://github.com/kijitora-no-hito/android-apps/releases/tag/tpscamera-server-v1.0) から、使う環境に合ったファイルを 1 つダウンロードします。

| ファイル | 環境 |
|---|---|
| `tpscamera-server-windows-amd64.exe` | Windows（64 ビット） |
| `tpscamera-server-linux-amd64` | Linux（一般的な VPS・PC。`uname -m` が `x86_64`） |
| `tpscamera-server-linux-arm64` | Linux（ARM。Raspberry Pi 4/5 の 64 ビット OS、ARM の VPS など。`uname -m` が `aarch64`） |
| `tpscamera-server-darwin-arm64` | Mac（Apple シリコン） |

1 ファイルだけで動きます（インストールや追加のソフトは不要）。SHA-256 は Releases のページに載せています。

サーバの設定は環境変数で渡します。

| 環境変数 | 意味 |
|---|---|
| `AUTH_TOKEN` | 合言葉。アプリの「合言葉」欄にこれと同じ文字列を入れた人だけが入れる。**必ず設定する** |
| `PORT` | 方法 A で使う待ち受けポート（既定 8080） |
| `DOMAIN` | 方法 B で使う自分のドメイン。設定すると 443 番で `wss://` を提供し、証明書（Let's Encrypt）を自動で取得・更新する |
| `CERT_DIR` | 方法 B の証明書の保存先（既定 `./certs`） |

---

## 方法 A: 自宅の PC ＋ Cloudflare Tunnel（無料・ドメイン不要）

PC で動かしたサーバに、Cloudflare の無料の仕組み（Quick Tunnel）で `https://` の入口を付けます。
アカウント登録は要りません。ここでは Windows の例を書きます（Mac / Linux もコマンドはほぼ同じです）。

### 1. サーバを起動する

ダウンロードした `tpscamera-server-windows-amd64.exe` を置いたフォルダで PowerShell を開き、次を実行します
（`好きな合言葉` は自分で決めた文字列に置き換えてください）。

```powershell
$env:AUTH_TOKEN = "好きな合言葉"
.\tpscamera-server-windows-amd64.exe
```

`TPS Camera relay listening on :8080 (plain, auth=true)` と出れば起動しています。この窓は閉じずにおきます。
Windows のファイアウォールの確認が出た場合は、許可しなくても方法 A は動きます。

### 2. cloudflared を入れて、トンネルを開く

別の PowerShell を開いて、次を実行します。

```powershell
winget install --id Cloudflare.cloudflared
cloudflared tunnel --url http://localhost:8080
```

（`winget` のあとはターミナルを開き直さないと `cloudflared` が見つからないことがあります。）
しばらくすると、次のようなアドレスが表示されます。

```
Your quick Tunnel has been created! Visit it at (it may take some time to be reachable):
https://example-words-here.trycloudflare.com
```

### 3. 動作確認

スマホのブラウザで `https://example-words-here.trycloudflare.com/healthz` を開き、`ok` と出れば準備完了です。

### 4. アプリに入れるアドレス

表示されたアドレスの `https://` を `wss://` に変え、最後に `/ws` を付けます。

```
wss://example-words-here.trycloudflare.com/ws
```

### 方法 A の注意

- **アドレスは cloudflared を起動するたびに変わります。** 起動し直したら、新しいアドレスを仲間に伝えてください。
- 使う間は PC をつけたまま、スリープしないようにしておきます。終わったら 2 つの窓で Ctrl+C を押して止めます。
- Quick Tunnel は Cloudflare が試用向けに提供している仕組みで、稼働の保証はありません。

---

## 方法 B: VPS ＋ 自分のドメイン（常時稼働）

サーバ自身が Let's Encrypt の証明書を取得・更新するので、nginx や certbot は要りません。
ここでは systemd のある Linux（Ubuntu / Debian / AlmaLinux など）の例を書きます。

### 1. 準備

- ドメイン（サブドメインでよい。例 `tps.example.com`）の **A レコードを VPS のグローバル IP に向けます**。
- VPS のファイアウォール（と、事業者のコントロールパネルのパケットフィルタ）で **TCP 80 と 443 を開けます**。
  80 番は証明書の取得に使います。
- 同じ VPS で、すでに 80 / 443 番を使っている Web サーバがあると起動できません。

### 2. サーバを置く

```bash
sudo mkdir -p /opt/tpscamera
cd /opt/tpscamera
sudo curl -L -o tpscamera-server https://github.com/kijitora-no-hito/android-apps/releases/download/tpscamera-server-v1.0/tpscamera-server-linux-amd64
sudo chmod +x tpscamera-server
```

ARM の VPS なら、URL の最後を `tpscamera-server-linux-arm64` にします。

### 3. 常駐させる（systemd）

`/etc/systemd/system/tpscamera.service` を次の内容で作ります（`DOMAIN` と `AUTH_TOKEN` は自分の値に）。

```ini
[Unit]
Description=TPS Camera relay
After=network-online.target
Wants=network-online.target

[Service]
Environment=DOMAIN=tps.example.com
Environment=AUTH_TOKEN=好きな合言葉
Environment=CERT_DIR=/var/lib/tpscamera/certs
ExecStart=/opt/tpscamera/tpscamera-server
DynamicUser=yes
StateDirectory=tpscamera
AmbientCapabilities=CAP_NET_BIND_SERVICE
Restart=always

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now tpscamera
sudo systemctl status tpscamera
journalctl -u tpscamera -f      # ログを見る（Ctrl+C で抜ける）
```

最初の接続のときに証明書を取得します。

### 4. 動作確認とアプリに入れるアドレス

```bash
curl https://tps.example.com/healthz     # → ok
```

アプリに入れるアドレスは `wss://tps.example.com/ws` です。

合言葉を変えたいときは、service ファイルの `AUTH_TOKEN` を書き換えて `sudo systemctl restart tpscamera` します。

---

## アプリ側の設定

1. カメラ画面の右側にある**人のアイコン（マルチプレイ）**を押します。
2. 次の 4 つを入れて「接続する」を押します。

| 欄 | 入れるもの |
|---|---|
| サーバURL | 上で作ったアドレス（`wss://〜/ws`） |
| 部屋コード | 仲間どうしで決めた同じ文字列。同じサーバでも、部屋コードが違えば別の部屋になる |
| 表示名 | ほかの人に見える自分の名前 |
| 合言葉 | サーバの `AUTH_TOKEN` と同じ文字列 |

3. 状態が「接続済み」になれば成功です。参加者の一覧に仲間が並び、地図とカメラ（AR）に相手の位置が出ます。
   地図で立てたピンとひとことメッセージも、同じ部屋の全員に共有されます。
4. 位置は**カメラ画面を開いている間**、2 秒ごとに送られます。終わったら「切断する」を押してください。

## うまくつながらないとき

| 症状 | 確かめること |
|---|---|
| 「エラー」になる / 「接続済み」にならない | アドレスが `wss://` で始まり `/ws` で終わっているか。ブラウザで `https://〜/healthz` が `ok` になるか。アプリの合言葉とサーバの `AUTH_TOKEN` が一字一句同じか（前後の空白にも注意。違うとサーバに切断される） |
| 一覧に仲間はいるが、地図や AR に出ない | 相手がカメラ画面を開いているか、位置情報を許可しているか（位置が届くまで地図・AR には出ない） |
| 仲間が一覧にも出ない | 部屋コードが全員同じか。全員が同じサーバのアドレスに接続しているか |
| 方法 A で急につながらなくなった | cloudflared を起動し直していないか（アドレスが変わる）。PC がスリープしていないか |
| 方法 B で証明書が取れない | ドメインが VPS の IP を向いているか、80 と 443 が外から開いているか、ほかのソフトが 80/443 を使っていないか |

## 送られるデータ

接続中、アプリはサーバに次のものを送ります。サーバは同じ部屋のほかの人に中継するだけで、保存しません。

- 表示名・部屋コード・合言葉（接続時）
- 現在地（緯度・経度）・向き・速さ（カメラ画面を開いている間、2 秒ごと）
- 地図で立てたピン（位置と名前）とひとことメッセージ

詳しくは [プライバシーポリシー](https://kijitora-no-hito.github.io/android-apps/TPS_CAMERA/privacy-policy.html) を参照してください。
