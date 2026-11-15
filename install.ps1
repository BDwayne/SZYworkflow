# SZY workflow installer (run once per machine, and again after `git pull`).
#   powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1
#   options: -DsSkillDir <dir>   also install the DeepSeek entry skill into that skills folder
#            -NoClaude / -NoCodex  skip a client
#            -HomeDir <dir>      install somewhere else (testing)
# ASCII-only on purpose (Windows PowerShell 5.1).
[CmdletBinding()]
param(
    [string]$HomeDir = $env:USERPROFILE,
    [string]$DsSkillDir = "",
    [switch]$NoClaude,
    [switch]$NoCodex
)
$ErrorActionPreference = "Stop"
$Repo = $PSScriptRoot
$KitHome = Join-Path $HomeDir ".szy-workflow"

function CopyDir([string]$src, [string]$dst) {
    if (Test-Path $dst) { Remove-Item $dst -Recurse -Force }
    New-Item -ItemType Directory -Path (Split-Path -Parent $dst) -Force | Out-Null
    Copy-Item $src $dst -Recurse
}
function InstallSkills([string]$group, [string]$target) {
    New-Item -ItemType Directory -Path $target -Force | Out-Null
    Get-ChildItem (Join-Path $Repo "skills\$group") -Directory | ForEach-Object {
        CopyDir $_.FullName (Join-Path $target $_.Name)
        Write-Output ("  {0,-8} {1}" -f $group, (Join-Path $target $_.Name))
    }
}

# 1. kit home: procedures, templates, scripts (projects copy procedures/templates from here)
New-Item -ItemType Directory -Path $KitHome -Force | Out-Null
foreach ($sub in @("procedures", "templates", "scripts")) { CopyDir (Join-Path $Repo "kit\$sub") (Join-Path $KitHome $sub) }
Copy-Item (Join-Path $Repo "kit\VERSION") (Join-Path $KitHome "VERSION") -Force
CopyDir (Join-Path $Repo "skills") (Join-Path $KitHome "skills")   # source copy, e.g. for the DeepSeek client
$ver = (Get-Content (Join-Path $Repo "kit\VERSION") -Raw).Trim()
Write-Output "SZY workflow $ver"
Write-Output "  kit      $KitHome"

# 2. skills
if (-not $NoClaude) { InstallSkills "claude" (Join-Path $HomeDir ".claude\skills") }
if (-not $NoCodex)  { InstallSkills "codex"  (Join-Path $HomeDir ".codex\skills") }
if ($DsSkillDir -ne "") { InstallSkills "deepseek" $DsSkillDir }
else { Write-Output "  deepseek (skipped: the DeepSeek client can use the trigger phrase listed in the project AGENTS.md, or rerun with -DsSkillDir)" }

Write-Output ""
Write-Output "Next: open a project folder and run szy-init (Claude: /szy-init, Codex: `$szy-init)."
Write-Output "Restart Claude Code / Codex if the new skills do not show up."
