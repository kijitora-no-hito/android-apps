# 神社めぐり 同梱の神社データ（ODbL 1.0）

`shrine_master.tsv.gz` は、アプリ「神社めぐり」に入れている全国の神社の一覧です（アプリの中の `assets/shrine_master.dat` と同じ中身）。

- 元データ: **© OpenStreetMap contributors**（<https://www.openstreetmap.org/copyright>）
- ライセンス: **Open Database License（ODbL）1.0**（<https://opendatacommons.org/licenses/odbl/1-0/>）。
  この一覧は OpenStreetMap から作った派生データベースなので、同じ ODbL で提供します。
- 市区町村コード・名前: 「国土数値情報（行政区域データ）」（国土交通省）を加工して作成（CC BY 4.0、2026-01-01 時点）
- 版: 2026-11-05 作成（OpenStreetMap は Geofabrik `japan-latest.osm.pbf` の 2026-11-03T21:24:23Z 時点）
- 件数: 40,410 社（名前あり 30,066・名称不明 10,344・wikidata/wikipedia タグあり 5,059・境内の形あり 3,386）

## 作り方

1. Geofabrik の `japan-latest.osm.pbf` から、`amenity=place_of_worship` かつ `religion=shinto` の node / way / relation を抜き出す。
2. 境内の形: 神社が面ならその形（建物・1,500 m² 未満は「境内が分からない」）。点や建物だけの神社は、その点を含む
   `landuse=religious`・`amenity=place_of_worship`（面）・`historic=*` の面（1,500 m²〜0.5 km²、ほかの神社・寺の面を除く）を境内とみなす。
   形は 2.5 m で単純化。
3. 同じ名前の神社の面の中にある点は重複として除く。ほかの神社の境内にある「本殿」「神楽殿」などの建物・名前のない点は除く。
4. 中心の点を国土数値情報（行政区域）に重ねて市区町村コードを付ける（政令指定都市は区ではなく市でまとめる）。

作成ツール: アプリのソースの `tools/shrine_dataset/build.py`。

## 形式（UTF-8 の TSV を gzip）

```
#format	1
#version	20261105
#count	40410
#osm	2026-11-03T21:24:23Z
…
M	13113	東京都	渋谷区                ← 市区町村コード・都道府県名・市区町村名
w469908925	明治神宮	3	356757974	1396996534	13113	2422,-4640,-309,118,…
```

神社の行: OSM の id（`n`=node・`w`=way・`r`=relation + 番号）・名前（無ければ空）・フラグ（1 = wikidata/wikipedia タグあり、
2 = 自分の面を境内に、4 = 周りの面を境内に）・中心の緯度 ×1e7・経度 ×1e7・市区町村コード・境内の形。

境内の形: 多角形は `|`、輪は `;`（先頭が外周、続きが穴）で区切る。点は「緯度,経度」の整数（1e-6 度）で、
先頭の点は中心（1e-7 度の整数を 10 で割って切り捨てたもの）からの差、以降は前の点からの差。
