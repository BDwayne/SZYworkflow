# SZY workflow installer (run once per machine, and again after `git pull`).
#   powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1
#   options: -DsSkillDir <dir>   compatibility alias: install generic skills there
#            -NoClaude / -NoCodex  skip a client
#            -HomeDir <dir>      install somewhere else (testing)
# ASCII-only on purpose (Windows PowerShell 5.1).
[CmdletBinding()]
param(
    [string]$HomeDir = $env:USERPROFILE,
    # Kept as a compatibility alias. The same generic skills are installed there.
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
function InstallSkills([string]$target) {
    New-Item -ItemType Directory -Path $target -Force | Out-Null
    # Remove only skills owned by SZYworkflow v1. The generic v2 entries below
    # are then installed in their place; unrelated user skills stay untouched.
    @("szy-blueprint", "szy-replan", "szy-handoff", "szy-runbook", "szy-ds-run") |
        ForEach-Object {
            $old = Join-Path $target $_
            if (Test-Path $old) { Remove-Item $old -Recurse -Force }
        }
    Get-ChildItem (Join-Path $Repo "skills\common") -Directory | ForEach-Object {
        CopyDir $_.FullName (Join-Path $target $_.Name)
        Write-Output ("  common   {0}" -f (Join-Path $target $_.Name))
    }
}

# 1. kit home: procedures, templates, scripts (projects copy procedures/templates from here)
New-Item -ItemType Directory -Path $KitHome -Force | Out-Null
foreach ($sub in @("procedures", "templates", "scripts")) { CopyDir (Join-Path $Repo "kit\$sub") (Join-Path $KitHome $sub) }
Copy-Item (Join-Path $Repo "kit\VERSION") (Join-Path $KitHome "VERSION") -Force
$KitSkills = Join-Path $KitHome "skills"
if (Test-Path $KitSkills) { Remove-Item $KitSkills -Recurse -Force }
CopyDir (Join-Path $Repo "skills\common") (Join-Path $KitSkills "common")
$ver = (Get-Content (Join-Path $Repo "kit\VERSION") -Raw).Trim()
Write-Output "SZY workflow $ver"
Write-Output "  kit      $KitHome"

# 2. skills
if (-not $NoClaude) { InstallSkills (Join-Path $HomeDir ".claude\skills") }
if (-not $NoCodex)  { InstallSkills (Join-Path $HomeDir ".codex\skills") }
if ($DsSkillDir -ne "") {
    InstallSkills $DsSkillDir
    Write-Output "  note     -DsSkillDir is kept as a compatibility alias for generic skills"
}

Write-Output ""
Write-Output "Next: open a project folder and run szy-init."
Write-Output "Restart your client if the new skills do not show up."
