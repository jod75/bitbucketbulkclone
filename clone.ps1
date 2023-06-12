[CmdletBinding()]
Param(
  [Parameter(Mandatory=$true, Position=0, HelpMessage="Enter your Bitbucket Server URL.")]
  [string]$url
)

$cred = Get-Credential -Message "Credentail are required to access $url"

$uri = $url + "/rest/api/latest/repos?limit=500&start=1"
$username = ($cred.GetNetworkCredential()).username
$password = ($cred.GetNetworkCredential()).password
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $username,$password)))
$env:GIT_REDIRECT_STDERR = '2>&1'

$data = Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -Uri $uri

$data.values | % {&"git" clone -v $_.links.clone.href}