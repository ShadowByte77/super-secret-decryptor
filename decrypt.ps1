$ErrorActionPreference = "SilentlyContinue"
$filename = read-host -Prompt "Filename to decode" 
if(!(test-path $filename)) 
	{Write-host "`nERROR: Please verify the filename is correct and you are in the right directory!"}
$EncryptionKey = [System.Convert]::FromBase64String("OoJsAweF73ofAWoLDA0OQe==")
$AESProvider = New-Object 'System.Security.Cryptography.AesManaged'
$AESProvider.key = $EncryptionKey
[Byte[]]$IV = ( 0, 1, 4, 3, 5, 1, 0, 1, 3, 0, 2, 1, 6, 9, 2, 0 )
$AESProvider.IV = $IV
$ciphertext = Get-content $filename -Encoding Byte
$decryptor = $AESProvider.CreateDecryptor()
$plaintxt = $decryptor.TransformFinalBlock($ciphertext, 16, $ciphertext.Length - 16);

[System.Text.Encoding]::ASCII.GetString($plaintxt[16..($plaintxt.count-1)]) | Out-file ([io.fileinfo]$filename).basename
