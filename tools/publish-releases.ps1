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
    if (-not (Test-Path $r.apk)) {
        throw "APK が見つかりません: $($r.apk)"
    }
    $hash = (Get-FileHash $r.apk -Algorithm SHA256).Hash
    if ($hash -ne $r.sha256) {
        throw "SHA-256 が releases.json と一致しません: $($r.tag)`n  実際: $hash`n  記載: $($r.sha256)"
    }

    if ($DryRun) {
        Write-Host "create $($r.tag)  $($r.title)  <= $($r.apk)"
        continue
    }

    # 改行を含むノートは一時ファイル経由で渡す（UTF-8 BOM なし）
    $notesFile = [System.IO.Path]::GetTempFileName()
    try {
        [System.IO.File]::WriteAllText($notesFile, $r.notes, (New-Object System.Text.UTF8Encoding($false)))
        gh release create $r.tag $r.apk --repo $repo --title $r.title --notes-file $notesFile
        if ($LASTEXITCODE -ne 0) { throw "gh release create に失敗しました: $($r.tag)" }
        Write-Host "done   $($r.tag)"
    }
    finally {
        Remove-Item $notesFile -ErrorAction SilentlyContinue
    }
}
