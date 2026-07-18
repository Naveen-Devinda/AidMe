$dirs = @('lib\pages', 'lib\widgets')
$files = foreach ($d in $dirs) { Get-ChildItem -Path $d -Filter '*.dart' -Recurse }
foreach ($f in $files) {
    $c = [System.IO.File]::ReadAllText($f.FullName)
    $n = [regex]::Replace($c, '\.withOpacity\(([^)]+)\)', '.withValues(alpha: $1)')
    if ($c -ne $n) {
        [System.IO.File]::WriteAllText($f.FullName, $n)
        Write-Host "Fixed: $($f.Name)"
    }
}
Write-Host "Done."
