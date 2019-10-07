$ErrorActionPreference = "Stop"
$versao = $args[0]
$url = $args[1]
$nomesvc = $args[2]
function instalar {
 write-output $args[0] > "c:\puppet\arquivos\EVServiceVersion"
 write-host "Baixando Serviço"
 $fullpath = "c:\puppet\arquivos\evupsvc$versao.msi"
 $start_time = Get-Date
 write-output $start_time
 $time = (Get-Date).ToString("ddMMyyyyHHmm")
 Invoke-WebRequest -Uri $url -OutFile $fullpath
 write-host "Parando serviço"
 $result = net stop $nomesvc
 write-host $result
 write-host "Deletando serviço"
 $result = sc delete $nomesvc
 write-host $result
 write-host "Rodando MSIZAP"
 $msizap = cmd /c "c:\puppet\arquivos\MsiZap.Exe TW! {85BEAE77-93F3-4155-BFAF-17915E071027}"
 $msizap[0..5]
 write-host "Criando Backup da pasta instalada"
 Rename-Item "C:\Program Files (x86)\EVUP\EVUP.ServicoLocal" "EVUPV$time"
 write-host "Instalando serviço"
 (Start-Process -FilePath "msiexec.exe" -ArgumentList "/qn /package $fullpath" -Wait -Passthru).ExitCode
 Write-host "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"
}
instalar
