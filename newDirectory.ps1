#newDirectory -argduscript "c:\myDirectory"

Param(
[string]$argduscript
)

New-Item -Path $argduscript -ItemType directory -Force