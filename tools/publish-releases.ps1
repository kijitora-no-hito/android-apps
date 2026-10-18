<#
.SYNOPSIS
  releases.json の各エントリを GitHub Releases に作る（既にあるタグはスキップ）。

.DESCRIPTION
  前提: GitHub CLI（gh）がインストール済みで `gh auth login` 済みであること。
  APK は git に入れず、Release のアセットとして添付する。
  アップロード前に APK の SHA-256 を releases.json の値と照合し、違えば中止する。

.EXAMPLE
  cd d:\work\android\android-apps
  .\tools\publish-releases.ps1            # 全件（既存タグはスキップ）
  .\tools\publish-releases.ps1 -DryRun    # 何をするかだけ表示
  .\tools\publish-releases.ps1 -Only tripplanner-v1.6
#>
param(
    [switch]$DryRun,
    [string]$Only
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$config = Get-Content (Join-Path $root 'releases.json') -Raw -Encoding UTF8 | ConvertFrom-Json
$repo = $config.repo
# APK は releases.json にはファイル名だけを書き、手元の <ワークスペース>\<folder>\dist\ から探す（公開物に PC のパスを載せない）
$workspace = Split-Path -Parent $root
# タグは README だけの空のコミット（release-tags ブランチ）に付ける。Release の「Source code」の zip にリポジトリの中身が入らないように
$tagTarget = 'release-tags'
function Resolve-Apk($folder, $apk) { Join-Path (Join-Path (Join-Path $workspace $folder) 'dist') $apk }

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    throw 'gh（GitHub CLI）が見つかりません。https://cli.github.com/ から入れて gh auth login してください。'
}

# 既存のタグ一覧
$existing = @(gh release list --repo $repo --limit 200 --json tagName --jq '.[].tagName')

foreach ($r in $config.releases) {
    if ($Only -and $r.tag -ne $Only) { continue }

    if ($existing -contains $r.tag) {
        Write-Host "skip   $($r.tag)（既にあります）"
        continue
    }
    # distFolder があればそのフォルダの dist から探す（例: Windows 版は folder=phonetic_hound_pc / distFolder=phonetic_hound）
    $srcFolder = if ($r.distFolder) { $r.distFolder } else { $r.folder }
    $apkPath = Resolve-Apk $srcFolder $r.apk
    if (-not (Test-Path $apkPath)) {
        throw "APK が見つかりません: $apkPath"
    }
    $hash = (Get-FileHash $apkPath -Algorithm SHA256).Hash
    if ($hash -ne $r.sha256) {
        throw "SHA-256 が releases.json と一致しません: $($r.tag)`n  実際: $hash`n  記載: $($r.sha256)"
    }

    # 追加の APK（例: 軽量版。"extraApks": [{"apk": "<ファイル名>", "sha256": "..."}]）も同じく照合して添付する
    $assets = @($apkPath)
    foreach ($x in @($r.extraApks)) {
        if (-not $x) { continue }
        $xPath = Resolve-Apk $srcFolder $x.apk
        if (-not (Test-Path $xPath)) { throw "APK が見つかりません: $xPath" }
        $xh = (Get-FileHash $xPath -Algorithm SHA256).Hash
        if ($xh -ne $x.sha256) {
            throw "SHA-256 が releases.json と一致しません: $($x.apk)`n  実際: $xh`n  記載: $($x.sha256)"
        }
        $assets += $xPath
    }

    if ($DryRun) {
        Write-Host "create $($r.tag)  $($r.title)  <= $($assets -join ', ')"
        continue
    }

    # 改行を含むノートは一時ファイル経由で渡す（UTF-8 BOM なし）
    $notesFile = [System.IO.Path]::GetTempFileName()
    try {
        [System.IO.File]::WriteAllText($notesFile, $r.notes, (New-Object System.Text.UTF8Encoding($false)))
        # 開発中の版（"prerelease": true）はプレリリースとして作る
        $extra = @()
        if ($r.prerelease) { $extra += '--prerelease' }
        gh release create $r.tag @assets --repo $repo --target $tagTarget --title $r.title --notes-file $notesFile @extra
        if ($LASTEXITCODE -ne 0) { throw "gh release create に失敗しました: $($r.tag)" }
        Write-Host "done   $($r.tag)"
    }
    finally {
        Remove-Item $notesFile -ErrorAction SilentlyContinue
    }
}
