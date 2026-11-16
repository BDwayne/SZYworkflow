# SZY workflow - scaffold or update a small two-role workflow in a project.
# ASCII-only on purpose for Windows PowerShell 5.1.
[CmdletBinding()]
param(
    [string]$Path = ".",
    # Kept for command compatibility with v1. They are no longer used.
    [string]$Lines = "",
    [string]$AddLine = "",
    [switch]$Update
)
$ErrorActionPreference = "Stop"

$KitRoot = Split-Path -Parent $PSScriptRoot
$Utf8 = New-Object System.Text.UTF8Encoding($false)
function ReadText([string]$p) { return [System.IO.File]::ReadAllText($p, $Utf8) }
function WriteText([string]$p, [string]$t) { [System.IO.File]::WriteAllText($p, $t, $Utf8) }
$Report = New-Object System.Collections.Generic.List[string]
function Note([string]$kind, [string]$what) { $Report.Add(("{0,-8} {1}" -f $kind, $what)) }

if (-not (Test-Path $Path)) { throw "Project path not found: $Path" }
$Root = (Resolve-Path $Path).Path
if (Test-Path (Join-Path $Root "kit\scripts\init.ps1")) {
    throw "This looks like the SZYworkflow kit repo itself. Run init inside a project folder instead."
}
$Wf  = Join-Path $Root "workflow"
$Szy = Join-Path $Wf ".szy"
$Tpl = Join-Path $KitRoot "templates"
$Today = Get-Date -Format "yyyy-MM-dd"

function FromTemplate([string]$name, [string]$dest) {
    if (Test-Path $dest) { Note "skip" ($dest.Substring($Root.Length + 1)); return }
    $parent = Split-Path -Parent $dest
    New-Item -ItemType Directory -Path $parent -Force | Out-Null
    $t = ReadText (Join-Path $Tpl $name)
    $t = $t.Replace("{{DATE}}", $Today)
    WriteText $dest $t
    Note "create" ($dest.Substring($Root.Length + 1))
}
function EnsureDir([string]$d, [switch]$Keep) {
    if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
    if ($Keep) {
        $k = Join-Path $d ".gitkeep"
        if (-not (Test-Path $k)) { WriteText $k "" }
    }
}

# 1. Workflow-owned files are refreshed on every run. Project state files are
# created only when missing, so -Update never overwrites user progress.
EnsureDir $Szy
foreach ($sub in @("procedures", "templates")) {
    $dst = Join-Path $Szy $sub
    if (Test-Path $dst) { Remove-Item $dst -Recurse -Force }
    Copy-Item (Join-Path $KitRoot $sub) $dst -Recurse
    Note "update" ("workflow\.szy\" + $sub)
}
$ver = "unknown"
if (Test-Path (Join-Path $KitRoot "VERSION")) { $ver = (ReadText (Join-Path $KitRoot "VERSION")).Trim() }
WriteText (Join-Path $Szy "VERSION") ($ver + [Environment]::NewLine)
Copy-Item (Join-Path $Tpl "workflow-README.md") (Join-Path $Wf "README.md") -Force
Note "update" "workflow\README.md"

# 2. Keep the short workflow block in AGENTS.md in sync.
$block = (ReadText (Join-Path $Tpl "AGENTS-block.md")).Trim()
$agents = Join-Path $Root "AGENTS.md"
if (Test-Path $agents) {
    $a = ReadText $agents
    $pattern = '(?s)<!-- SZY-WORKFLOW:BEGIN -->.*?<!-- SZY-WORKFLOW:END -->'
    if ($a -match $pattern) {
        $a = [regex]::Replace($a, $pattern, { param($m) $block })
        Note "update" "AGENTS.md (workflow block)"
    } else {
        $a = $a.TrimEnd() + [Environment]::NewLine + [Environment]::NewLine + $block + [Environment]::NewLine
        Note "append" "AGENTS.md (workflow block)"
    }
    WriteText $agents $a
} else {
    WriteText $agents ((ReadText (Join-Path $Tpl "AGENTS-header.md")) + $block + [Environment]::NewLine)
    Note "create" "AGENTS.md"
}
$claude = Join-Path $Root "CLAUDE.md"
if (-not (Test-Path $claude)) { WriteText $claude ("@AGENTS.md" + [Environment]::NewLine); Note "create" "CLAUDE.md" }
elseif ((ReadText $claude) -notmatch '@AGENTS\.md') {
    WriteText $claude ((ReadText $claude).TrimEnd() + [Environment]::NewLine + [Environment]::NewLine + "@AGENTS.md" + [Environment]::NewLine); Note "append" "CLAUDE.md (@AGENTS.md)"
}

# 3. Compact project state. Existing MAP/line files are left untouched so an
# update is reversible; the new workflow simply ignores them.
EnsureDir (Join-Path $Wf "tasks\active") -Keep
EnsureDir (Join-Path $Wf "tasks\done") -Keep
FromTemplate "PLAN.md" (Join-Path $Wf "PLAN.md")
FromTemplate "PROGRESS.md" (Join-Path $Wf "PROGRESS.md")

if ($Lines -ne "" -or $AddLine -ne "") {
    Note "ignore" "-Lines/-AddLine are retained for compatibility; this workflow has one plan"
}
Write-Output "SZY workflow $ver -> $Root"
$Report | ForEach-Object { Write-Output "  $_" }
if (-not (Test-Path (Join-Path $Root ".git"))) { Write-Output "  note     not a git repository yet (git init recommended)" }
