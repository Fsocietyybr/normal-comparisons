# CONFIG
$folder = "C:\Users\Samsung\Desktop\backgrounds"
$shuffleFile = "$folder\shuffle.txt"
$indexFile = "$folder\index.txt"

# 1. CARREGAR IMAGENS DISPONÍVEIS
$images = Get-ChildItem -Path $folder -Include *.jpg,*.jpeg,*.png,*.bmp -File -Recurse
if ($images.Count -eq 0) {
    Write-Output "Nenhuma imagem encontrada em $folder"
    exit
}

# 2. CARREGAR OU CRIAR SHUFFLE
if (-Not (Test-Path $shuffleFile)) {
    $shuffled = $images | Get-Random -Count $images.Count
    $shuffledPaths = $shuffled.FullName
    $shuffledPaths | Set-Content $shuffleFile -Encoding UTF8
} else {
    $shuffledPaths = Get-Content $shuffleFile
}

# 3. CARREGAR OU INICIAR ÍNDICE
if (Test-Path $indexFile) {
    $index = [int](Get-Content $indexFile)
} else {
    $index = 0
}

# 4. NORMALIZAR ÍNDICE
if ($index -ge $shuffledPaths.Count) {
    $index = 0
}

# 5. OBTER IMAGEM ATUAL
$imagePath = $shuffledPaths[$index]
Write-Output "Imagem atual: $imagePath"

# 6. DEFINIR COMO WALLPAPER
Add-Type -TypeDefinition @"
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@
[Wallpaper]::SystemParametersInfo(20, 0, $imagePath, 3)

# 7. SALVAR PRÓXIMO ÍNDICE
$nextIndex = ($index + 1) % $shuffledPaths.Count
$nextIndex | Set-Content $indexFile
