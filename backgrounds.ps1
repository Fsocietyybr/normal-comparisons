$folder = "C:\Users\Samsung\Desktop\backgrounds" # Utilizar caminho das imagens

if (!(Test-Path $folder)) {
    Write-Output "[ERRO] Pasta nao encontrada: '$folder'."
} else {
$images = Get-ChildItem -Path $folder -Include *.jpg,*.png,*.bmp,*.jpeg -File -Recurse
$imagesCount = $images.Count

if ($imagesCount -gt 0 ) {
    $image = Get-Random -InputObject $images
    Write-Output "Trocando para: $($image.FullName)"

    Add-Type -TypeDefinition @"
    using System.Runtime.InteropServices;
    public class Wallpaper {
        [DllImport("user32.dll", SetLastError = true)]
        public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
    }
"@
    [Wallpaper]::SystemParametersInfo(20, 0, $image.FullName, 3)
} else {
    Write-Output "[ERRO] ($imagesCount) Imagens encontradas em: '$folder'. Verifique o caminho e formatos aceitos das imagens: *.jpg,*.png,*.bmp,*.jpeg."
}
}

