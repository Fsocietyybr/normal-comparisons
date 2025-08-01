# normal-comparisons

## Projeto pra fazer um carrossel de plano de fundo (wallpaper) no Windows, alternando automaticamente entre imagens de uma pasta.

### Para a troca via script e não via menus tradicionais, dá pra usar PowerShell, Python, Visual Basic, etc...

---

    O Exemplo abaixo troca o wallpaper para uma imagem aleatória da pasta:

```powershell
$folder = "C:\Users\Teste\Desktop\backgrounds"
$images = Get-ChildItem -Path $folder -Include *.jpg,*.png,*.bmp,*.jpeg -File -Recurse
$imagesCount = $images.Count

if ($imagesCount -gt 0) {
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
}

```

Bem simples, não?



# Descrição
Atributos e distribuições randômicas podem causar efeitos que podem ser chamados de caóticos...

O que acontece na prática aqui é que quando você usa Get-Random (ou qualquer randomização ingênua tipo rand()), especialmente com poucos itens, o comportamento fica estranho para algumas coisas por três motivos:

| Comportamento                             | Problema                       |
| ----------------------------------------- | ------------------------------ |
| Pode repetir imagem várias vezes seguidas | Sensação de bug ou travamento  |
| Pode pular imagens por muito tempo        | Dá impressão de desorganização |
| Transições abruptas                       | Falta de "ritmo visual"        |

## 🧠 Solução de aplicação de noise fns, ou, funções de ruído+normalização.

Por que usar Perlin noise ou funções tipo Simplex?

Porque ao invés de um "pulo aleatório", você tem uma flutuação contínua, suave. Podemos explorar isso em: https://thebookofshaders.com/11

## Como Usar

    Obs.: Lembre-se de executar utilizando os parâmetros que desativam as restrições.

- ✅ Para executar em powershell a versão randômica simples, sem ajustes:


```shell
powershell -ExecutionPolicy Bypass -File .\backgrounds.ps1
```
- ✅ Versão com ruído e normalizada:

```shell
powershell -ExecutionPolicy Bypass -File .\backgrounds-normalized.ps1
```

## How it Works

- i dont know?

to be continued..



