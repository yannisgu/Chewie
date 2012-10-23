﻿
function Get-MaxCompatibleVersion {
  [CmdletBinding()]
  param(
    [Parameter(Position=0,Mandatory=$true)][string]$packageName,
    [Parameter(Position=1,Mandatory=$true)][AllowEmptyString()][string]$versionSpec
  )
  [xml]$targets = Get-PackageList $packageName
  Assert ($targets.feed.entry -ne $null) ($messages.error_package_not_found -f $packageName)
  $versions = $targets.feed.entry | %{ (Get-VersionFromString $_.properties.version) }
  $matchingVersions = $versions | ? { Test-VersionCompatibility $versionSpec $_.Version.ToString() }
  $maxCompatibleVersion = Find-MaxVersion $matchingVersions
  return $maxCompatibleVersion
}