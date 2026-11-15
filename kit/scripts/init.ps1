# SZY workflow - scaffold or update the workflow inside a project folder.
# ASCII-only on purpose (Windows PowerShell 5.1 reads BOM-less scripts as ANSI).
[CmdletBinding()]
param(
    [string]$Path = ".",
    [string]$Lines = "dev,test",
    [string]$AddLine = "",
    [switch]$Update
)
$ErrorActionPreference = "Stop"

$KitRoot = Split-Path -Parent $PSScriptRoot          # ...\.szy-workflow  (or repo\kit)
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

function FromTemplate([string]$name, [string]$dest, [string]$line = "") {
    if (Test-Path $dest) { Note "skip" ($dest.Substring($Root.Length + 1)); return }
    $t = ReadText (Join-Path $Tpl $name)
    $t = $t.Replace("{{LINE}}", $line).Replace("{{DATE}}", $Today)
    WriteText $dest $t
    Note "create" ($dest.Substring($Root.Length + 1))
}
function EnsureDir([string]$d, [switch]$Keep) {
    if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
    if ($Keep) { $k = Join-Path $d ".gitkeep"; if (-not (Test-Path $k)) { WriteText $k "" } }
}
function EnsureLine([string]$l) {
    $l = $l.Trim()
    if ($l -eq "") { return }
    if ($l -notmatch '^[a-z0-9][a-z0-9_-]*$') { throw "Line name must be lowercase letters/digits/-/_ : '$l'" }
    $d = Join-Path $Wf "lines\$l"
    EnsureDir $d
    $statusTpl = "line-STATUS.md"
    if ($l -eq "test") { $statusTpl = "test-STATUS.md" }
    FromTemplate $statusTpl (Join-Path $d "STATUS.md") $l
    FromTemplate "INBOX.md" (Join-Path $d "INBOX.md") $l
    if ($l -eq "test") { FromTemplate "BUGS.md" (Join-Path $d "BUGS.md") $l }
}

# 1. kit-owned files: always refreshed
EnsureDir $Szy
foreach ($sub in @("procedures", "templates")) {
    $dst = Join-Path $Szy $sub
    if (Test-Path $dst) { Remove-Item $dst -Recurse -Force }
    Copy-Item (Join-Path $KitRoot $sub) $dst -Recurse
    Note "update" "workflow\.szy\$sub"
}
$ver = "unknown"
if (Test-Path (Join-Path $KitRoot "VERSION")) { $ver = (ReadText (Join-Path $KitRoot "VERSION")).Trim() }
WriteText (Join-Path $Szy "VERSION") "$ver`n"
Copy-Item (Join-Path $Tpl "workflow-README.md") (Join-Path $Wf "README.md") -Force
Note "update" "workflow\README.md"

# 2. AGENTS.md workflow block (replace between markers, or append)
$block = (ReadText (Join-Path $Tpl "AGENTS-block.md")).Trim()
$agents = Join-Path $Root "AGENTS.md"
if (Test-Path $agents) {
    $a = ReadText $agents
    $pattern = '(?s)<!-- SZY-WORKFLOW:BEGIN -->.*?<!-- SZY-WORKFLOW:END -->'
    if ($a -match $pattern) {
        $a = [regex]::Replace($a, $pattern, { param($m) $block })
        Note "update" "AGENTS.md (workflow block)"
    } else {
        $a = $a.TrimEnd() + "`n`n" + $block + "`n"
        Note "append" "AGENTS.md (workflow block)"
    }
    WriteText $agents $a
} else {
    WriteText $agents ((ReadText (Join-Path $Tpl "AGENTS-header.md")) + $block + "`n")
    Note "create" "AGENTS.md"
}
$claude = Join-Path $Root "CLAUDE.md"
if (-not (Test-Path $claude)) { WriteText $claude "@AGENTS.md`n"; Note "create" "CLAUDE.md" }
elseif ((ReadText $claude) -notmatch '@AGENTS\.md') {
    WriteText $claude ((ReadText $claude).TrimEnd() + "`n`n@AGENTS.md`n"); Note "append" "CLAUDE.md (@AGENTS.md)"
}

# 3. project-owned files: created once, never overwritten
if (-not $Update) {
    EnsureDir (Join-Path $Wf "tasks\active") -Keep
    EnsureDir (Join-Path $Wf "tasks\done") -Keep
    EnsureDir (Join-Path $Wf "runbooks") -Keep
    FromTemplate "MAP.md" (Join-Path $Wf "MAP.md")
    FromTemplate "ESCALATE.md" (Join-Path $Wf "ESCALATE.md")
    if ($AddLine -ne "") { EnsureLine $AddLine }
    else { foreach ($l in ($Lines -split ",")) { EnsureLine $l } }
}

Write-Output "SZY workflow $ver -> $Root"
$Report | ForEach-Object { Write-Output "  $_" }
if (-not (Test-Path (Join-Path $Root ".git"))) { Write-Output "  note     not a git repository yet (git init recommended)" }
