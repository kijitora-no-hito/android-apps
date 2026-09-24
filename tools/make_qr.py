"""各アプリページ（GitHub Pages）の QR コードを作る。

QR は APK の直リンクではなくアプリページを指すので、版を上げても作り直す必要はない。
アプリを追加したときだけ PAGES に 1 行足して実行する。

    pip install "qrcode[pil]"
    python tools/make_qr.py

出力: <folder>/images/qr.png（アプリページ）と images/qr-top.png（トップページ）
"""
from pathlib import Path

import qrcode
from qrcode.constants import ERROR_CORRECT_M

BASE_URL = "https://kijitora-no-hito.github.io/android-apps/"

# フォルダ名 → URL はここ 1 か所で定義する（None はトップページ）
PAGES = [
    None,
    "trip_planner",
    "career_log",
    "whistle_trainer",
    "link_conne2",
    "mask_camera",
    "TPS_CAMERA",
]

ROOT = Path(__file__).resolve().parent.parent
TARGET_PX = 400


def make(url: str, out: Path) -> None:
    qr = qrcode.QRCode(error_correction=ERROR_CORRECT_M, box_size=10, border=4)
    qr.add_data(url)
    qr.make(fit=True)
    img = qr.make_image(fill_color="black", back_color="white").get_image()
    # モジュール数に合わせて 400px 前後の整数倍に収める（ぼやけないよう NEAREST）
    modules = qr.modules_count + qr.border * 2
    box = max(1, TARGET_PX // modules)
    img = img.resize((modules * box, modules * box), resample=0)
    out.parent.mkdir(parents=True, exist_ok=True)
    img.save(out)
    print(f"{out.relative_to(ROOT)}  {img.size[0]}px  {url}")


def main() -> None:
    for folder in PAGES:
        if folder is None:
            make(BASE_URL, ROOT / "images" / "qr-top.png")
        else:
            make(f"{BASE_URL}{folder}/", ROOT / folder / "images" / "qr.png")


if __name__ == "__main__":
    main()
