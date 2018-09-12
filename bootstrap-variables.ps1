param (
  [Parameter(Mandatory=$true)]$hcl,
  [Parameter(Mandatory=$true)]$workspace
)

function getVariableValue($variables, $variable_name){
  $default = $variables.$variable_name.default
  if (!$default){
    return "null"
  }
  return $default
}
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Write-Output "Downloading json2hcl"
New-Item -ItemType Directory "bin" -Force | Out-Null
$url = "http://github.com/kvz/json2hcl/releases/download/v0.0.6/json2hcl_v0.0.6_windows_386.exe"
Invoke-WebRequest -Uri $url -OutFile "bin/json2hcl.exe"

$variables = (Get-Content $hcl | bin/json2hcl.exe -reverse | ConvertFrom-Json).variable

foreach ($variable in $variables) {
  $variable_name = ($variable[0] | Get-Member -MemberType NoteProperty).Name
  $variable_value = getVariableValue $variables $variable_name
  "tfe pushvars -name $workspace -var '${variable_name}:${variable_value}'"
}

