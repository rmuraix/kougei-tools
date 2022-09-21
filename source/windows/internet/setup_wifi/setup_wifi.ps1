Write-Host "プロキシ自動設定スクリプトを設定" -ForegroundColor "DarkCyan"

$RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
$RegKey = "AutoConfigURL"
$RegKeyType = "String"
$RegKeyValue = "http://wpad.t-kougei.ac.jp/wpad.dat"

$KeyStr = (Get-ItemProperty -Path $RegPath).$RegKey

if([string]::IsNullOrEmpty($KeyStr)){
    New-ItemProperty -Path $RegPath -Name $RegKey -PropertyType $RegKeyType -Value $RegKeyValue
}
elseif ($KeyStr -eq $RegKeyValue) {
    Write-Host "すでに $KeyStr が設定されています。更新の必要はありません。"
}
else {
    $title = "更新が必要です"
    $message = "すでにプロキシ自動設定スクリプトは $KeyStr が設定がされていますが、必要なものとは異なります。更新しますか？"

    $tChoiceDescription = "System.Management.Automation.Host.ChoiceDescription"
    $options = @(
        New-Object $tChoiceDescription ("はい(&Y)", "操作を続行します。")
        New-Object $tChoiceDescription ("いいえ(&N)", "操作を終了します。")
    )

    $result = $host.ui.PromptForChoice($title, $message, $options, 0)
    switch ($result){
        0 {
            Write-Host "プロキシ自動設定スクリプトを更新します。"
            Set-ItemProperty -Path $RegPath -Name $RegKey -Value $RegKeyValue
            Write-Host "更新完了"
            break
        }
        1 {
            Write-Host "プロキシ自動設定スクリプトの更新は行いません。"
            break
        }
    }
}
Write-Host "kougei-WiFi.1xSTを既知のネットワークに追加" -ForegroundColor "DarkCyan"
netsh wlan add profile filename="./kougei-WiFi.1xST.xml" #netshは廃止予定の機能

Write-Host "処理終了" -ForegroundColor "DarkCyan"