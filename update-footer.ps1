# Automatically updates "Last updated: <Month Year>" in all HTML files in this directory
$currentDate = Get-Date -Format "MMMM yyyy"
Write-Host "Updating all HTML footers to: Last updated: $currentDate" -ForegroundColor Cyan

$files = Get-ChildItem -Path "$PSScriptRoot\*.html"
$updatedCount = 0

foreach ($f in $files) {
    $content = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
    if ($content -match 'Last updated:\s*[A-Za-z]+\s*\d{4}') {
        $updated = [regex]::Replace($content, 'Last updated:\s*[A-Za-z]+\s*\d{4}', "Last updated: $currentDate")
        if ($updated -ne $content) {
            [System.IO.File]::WriteAllText($f.FullName, $updated, [System.Text.Encoding]::UTF8)
            Write-Host "  Updated: $($f.Name)" -ForegroundColor Green
            $updatedCount++
        } else {
            Write-Host "  Already up to date: $($f.Name)" -ForegroundColor DarkGray
        }
    } else {
        Write-Host "  Pattern not found: $($f.Name)" -ForegroundColor Yellow
    }
}

Write-Host "`nCompleted! $updatedCount file(s) updated." -ForegroundColor Cyan
