# Carrega funções da DLL user32.dll via P/Invoke
Add-Type @"
  using System;
  using System.Runtime.InteropServices;
  public class WinUtils {
    [DllImport("user32.dll", SetLastError=true)]
    public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);
    [DllImport("user32.dll", SetLastError=true)]
    public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);
  }
"@

# Nome exato do AVD que você usa
$avdName = "Pixel_9_Pro"

# Caminho do executável do emulador (ajuste se necessário)
$emulatorExe = Join-Path -Path $env:USERPROFILE -ChildPath "AppData\Local\Android\sdk\emulator\emulator.exe"

# Inicia o emulador
Start-Process -FilePath $emulatorExe -ArgumentList "-avd $avdName"

# Espera 5 segundos para a janela carregar (ajuste se necessário)
Start-Sleep -Seconds 5

# Busca a janela do emulador — o título geralmente contém o nome do dispositivo
$hWnd = [WinUtils]::FindWindow($null, $avdName)

if ($hWnd -ne [IntPtr]::Zero) {
    # Move e redimensiona a janela (x, y, largura, altura)
    [WinUtils]::MoveWindow($hWnd, 0, 0, 1080, 1920, $true) | Out-Null
    Write-Host "Emulador reposicionado com sucesso!"
} else {
    Write-Warning "Janela do emulador não encontrada."
}
