[CmdletBinding()]
param()

# Define the JRE/JDK key names.
$jre6KeyName = "Software\JavaSoft\Java Runtime Environment\1.6"
$jre7KeyName = "Software\JavaSoft\Java Runtime Environment\1.7"
$jre8KeyName = "Software\JavaSoft\Java Runtime Environment\1.8"
$jdk6KeyName = "Software\JavaSoft\Java Development Kit\1.6"
$jdk7KeyName = "Software\JavaSoft\Java Development Kit\1.7"
$jdk8KeyName = "Software\JavaSoft\Java Development Kit\1.8"

# JRE/JDK keys for major version >= 9
$jdk9AndGreaterNameOracle = "Software\JavaSoft\JDK"
$jre9AndGreaterNameOracle = "Software\JavaSoft\JRE"
$jre9AndGreaterName = "Software\JavaSoft\Java Runtime Environment"
$jdk9AndGreaterName = "Software\JavaSoft\Java Development Kit"
$minimumMajorVersion9 = 9

# JRE/JDK keys for AdoptOpenJDK
$jdk9AndGreaterNameAdoptOpenJDK = "Software\AdoptOpenJDK\JDK"
$jdk9AndGreaterNameAdoptOpenJRE = "Software\AdoptOpenJDK\JRE"

# These keys required for several previous versions of AdoptOpenJDK that were published under the name Eclipse Foundation
$jdk9AndGreaterNameAdoptOpenJDKEclipseFoundation = "Software\Eclipse Foundation\JDK"
$jdk9AndGreaterNameAdoptOpenJREEclipseFoundation = "Software\Eclipse Foundation\JRE"

# These keys required for latest versions of AdoptOpenJDK since they started to publish under Eclipse Adoptium name from 22th October 2021 https://blog.adoptopenjdk.net/2021/03/transition-to-eclipse-an-update/ 
$jdk9AndGreaterNameAdoptOpenJDKEclipseAdoptium = "Software\Eclipse Adoptium\JDK"
$jdk9AndGreaterNameAdoptOpenJREEclipseAdoptium = "Software\Eclipse Adoptium\JRE"

# JRE/JDK keys for AdoptOpenJDK with openj9 runtime
$jdk9AndGreaterNameAdoptOpenJDKSemeru = "Software\Semeru\JDK"
$jdk9AndGreaterNameAdoptOpenJRESemeru = "Software\Semeru\JRE"

# JVM subdirectories for AdoptOpenJDK, since it could be ditributed with two different JVM versions, which are located in different subdirectories inside version directory
$jvmHotSpot = "hotspot\MSI"
$jvmOpenj9 = "openj9\MSI"

# Check for JRE.
$latestJre = $null
$null = Add-CapabilityFromRegistry -Name 'java_6' -Hive 'LocalMachine' -View 'Registry32' -KeyName $jre6KeyName -ValueName 'JavaHome' -Value ([ref]$latestJre)
$null = Add-CapabilityFromRegistry -Name 'java_7' -Hive 'LocalMachine' -View 'Registry32' -KeyName $jre7KeyName -ValueName 'JavaHome' -Value ([ref]$latestJre)
$null = Add-CapabilityFromRegistry -Name 'java_8' -Hive 'LocalMachine' -View 'Registry32' -KeyName $jre8KeyName -ValueName 'JavaHome' -Value ([ref]$latestJre)
$null = Add-CapabilityFromRegistry -Name 'java_6_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jre6KeyName -ValueName 'JavaHome' -Value ([ref]$latestJre)
$null = Add-CapabilityFromRegistry -Name 'java_7_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jre7KeyName -ValueName 'JavaHome' -Value ([ref]$latestJre)
$null = Add-CapabilityFromRegistry -Name 'java_8_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jre8KeyName -ValueName 'JavaHome' -Value ([ref]$latestJre)

if  (-not (Test-Path env:DISABLE_JAVA_CAPABILITY_HIGHER_THAN_9)) {
    try {
        $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'java_' -Hive 'LocalMachine' -View 'Registry32' -KeyName $jre9AndGreaterName -ValueName 'JavaHome' -Value ([ref]$latestJre) -MinimumMajorVersion $minimumMajorVersion9
        $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'java_' -Hive 'LocalMachine' -View 'Registry32' -KeyName $jre9AndGreaterNameOracle -ValueName 'JavaHome' -Value ([ref]$latestJre) -MinimumMajorVersion $minimumMajorVersion9
        $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'java_' -PostfixName '_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jre9AndGreaterName -ValueName 'JavaHome' -Value ([ref]$latestJre) -MinimumMajorVersion $minimumMajorVersion9
        $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'java_' -PostfixName '_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jre9AndGreaterNameOracle -ValueName 'JavaHome' -Value ([ref]$latestJre) -MinimumMajorVersion $minimumMajorVersion9
    } catch {
        Write-Host "An error occured while trying to check if there are JRE >= 9"
        Write-Host $_
    }
}

# Check default reg keys for AdoptOpenJDK in case we didn't find JRE in JavaSoft
if (-not $latestJre) {
    # AdoptOpenJDK section
    $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'java_' -PostfixName '_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jdk9AndGreaterNameAdoptOpenJRE -ValueName 'Path' -Value ([ref]$latestJre) -VersionSubdirectory $jvmHotSpot -MinimumMajorVersion $minimumMajorVersion9
    $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'java_' -PostfixName '_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jdk9AndGreaterNameAdoptOpenJRE -ValueName 'Path' -Value ([ref]$latestJre) -VersionSubdirectory $jvmOpenj9 -MinimumMajorVersion $minimumMajorVersion9
    $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'java_' -PostfixName '_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jdk9AndGreaterNameAdoptOpenJREEclipseAdoptium -ValueName 'Path' -Value ([ref]$latestJre) -VersionSubdirectory $jvmHotSpot -MinimumMajorVersion $minimumMajorVersion9
    $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'java_' -PostfixName '_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jdk9AndGreaterNameAdoptOpenJREEclipseFoundation -ValueName 'Path' -Value ([ref]$latestJre) -VersionSubdirectory $jvmHotSpot -MinimumMajorVersion $minimumMajorVersion9
    $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'java_' -PostfixName '_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jdk9AndGreaterNameAdoptOpenJRESemeru -ValueName 'Path' -Value ([ref]$latestJre) -VersionSubdirectory $jvmOpenj9 -MinimumMajorVersion $minimumMajorVersion9
}

if ($latestJre) {
    # Favor x64.
    Write-Capability -Name 'java' -Value $latestJre
}

# Check for JDK.
$latestJdk = $null
$null = Add-CapabilityFromRegistry -Name 'jdk_6' -Hive 'LocalMachine' -View 'Registry32' -KeyName $jdk6KeyName -ValueName 'JavaHome' -Value ([ref]$latestJdk)
$null = Add-CapabilityFromRegistry -Name 'jdk_7' -Hive 'LocalMachine' -View 'Registry32' -KeyName $jdk7KeyName -ValueName 'JavaHome' -Value ([ref]$latestJdk)
$null = Add-CapabilityFromRegistry -Name 'jdk_8' -Hive 'LocalMachine' -View 'Registry32' -KeyName $jdk8KeyName -ValueName 'JavaHome' -Value ([ref]$latestJdk)
$null = Add-CapabilityFromRegistry -Name 'jdk_6_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jdk6KeyName -ValueName 'JavaHome' -Value ([ref]$latestJdk)
$null = Add-CapabilityFromRegistry -Name 'jdk_7_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jdk7KeyName -ValueName 'JavaHome' -Value ([ref]$latestJdk)
$null = Add-CapabilityFromRegistry -Name 'jdk_8_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jdk8KeyName -ValueName 'JavaHome' -Value ([ref]$latestJdk)

if  (-not (Test-Path env:DISABLE_JAVA_CAPABILITY_HIGHER_THAN_9)) {
    try {
        $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'jdk_' -Hive 'LocalMachine' -View 'Registry32' -KeyName $jdk9AndGreaterName -ValueName 'JavaHome' -Value ([ref]$latestJdk) -MinimumMajorVersion $minimumMajorVersion9
        $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'jdk_' -Hive 'LocalMachine' -View 'Registry32' -KeyName $jdk9AndGreaterNameOracle -ValueName 'JavaHome' -Value ([ref]$latestJdk) -MinimumMajorVersion $minimumMajorVersion9
        $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'jdk_' -PostfixName '_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jdk9AndGreaterName -ValueName 'JavaHome' -Value ([ref]$latestJdk) -MinimumMajorVersion $minimumMajorVersion9
        $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'jdk_' -PostfixName '_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jdk9AndGreaterNameOracle -ValueName 'JavaHome' -Value ([ref]$latestJdk) -MinimumMajorVersion $minimumMajorVersion9
    } catch {
        Write-Host "An error occured while trying to check if there are JDK >= 9"
        Write-Host $_
    }
}

# Check default reg keys for AdoptOpenJDK in case we didn't find JDK in JavaSoft
if (-not $latestJdk) {
    # AdoptOpenJDK section
    $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'jdk_' -PostfixName '_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jdk9AndGreaterNameAdoptOpenJDK -ValueName 'Path' -Value ([ref]$latestJdk) -VersionSubdirectory $jvmHotSpot -MinimumMajorVersion $minimumMajorVersion9
    $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'jdk_' -PostfixName '_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jdk9AndGreaterNameAdoptOpenJDK -ValueName 'Path' -Value ([ref]$latestJdk) -VersionSubdirectory $jvmOpenj9 -MinimumMajorVersion $minimumMajorVersion9
    $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'jdk_' -PostfixName '_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jdk9AndGreaterNameAdoptOpenJDKEclipseAdoptium -ValueName 'Path' -Value ([ref]$latestJdk) -VersionSubdirectory $jvmHotSpot -MinimumMajorVersion $minimumMajorVersion9
    $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'jdk_' -PostfixName '_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jdk9AndGreaterNameAdoptOpenJDKEclipseFoundation -ValueName 'Path' -Value ([ref]$latestJdk) -VersionSubdirectory $jvmHotSpot -MinimumMajorVersion $minimumMajorVersion9
    $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'jdk_' -PostfixName '_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jdk9AndGreaterNameAdoptOpenJDKSemeru -ValueName 'Path' -Value ([ref]$latestJdk) -VersionSubdirectory $jvmOpenj9 -MinimumMajorVersion $minimumMajorVersion9
}

if ($latestJdk) {
    # Favor x64.
    Write-Capability -Name 'jdk' -Value $latestJdk

    if (!($latestJre)) {
        Write-Capability -Name 'java' -Value $latestJdk
    }
}

# SIG # Begin signature block
# MIIn0QYJKoZIhvcNAQcCoIInwjCCJ74CAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCDtdx6W3IWm4NNZ
# Y+FJnGe/lQhtti2MiuGIweZgtnCL46CCDYUwggYDMIID66ADAgECAhMzAAADri01
# UchTj1UdAAAAAAOuMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMjMxMTE2MTkwODU5WhcNMjQxMTE0MTkwODU5WjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQD0IPymNjfDEKg+YyE6SjDvJwKW1+pieqTjAY0CnOHZ1Nj5irGjNZPMlQ4HfxXG
# yAVCZcEWE4x2sZgam872R1s0+TAelOtbqFmoW4suJHAYoTHhkznNVKpscm5fZ899
# QnReZv5WtWwbD8HAFXbPPStW2JKCqPcZ54Y6wbuWV9bKtKPImqbkMcTejTgEAj82
# 6GQc6/Th66Koka8cUIvz59e/IP04DGrh9wkq2jIFvQ8EDegw1B4KyJTIs76+hmpV
# M5SwBZjRs3liOQrierkNVo11WuujB3kBf2CbPoP9MlOyyezqkMIbTRj4OHeKlamd
# WaSFhwHLJRIQpfc8sLwOSIBBAgMBAAGjggGCMIIBfjAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQUhx/vdKmXhwc4WiWXbsf0I53h8T8w
# VAYDVR0RBE0wS6RJMEcxLTArBgNVBAsTJE1pY3Jvc29mdCBJcmVsYW5kIE9wZXJh
# dGlvbnMgTGltaXRlZDEWMBQGA1UEBRMNMjMwMDEyKzUwMTgzNjAfBgNVHSMEGDAW
# gBRIbmTlUAXTgqoXNzcitW2oynUClTBUBgNVHR8ETTBLMEmgR6BFhkNodHRwOi8v
# d3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NybC9NaWNDb2RTaWdQQ0EyMDExXzIw
# MTEtMDctMDguY3JsMGEGCCsGAQUFBwEBBFUwUzBRBggrBgEFBQcwAoZFaHR0cDov
# L3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9jZXJ0cy9NaWNDb2RTaWdQQ0EyMDEx
# XzIwMTEtMDctMDguY3J0MAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQELBQADggIB
# AGrJYDUS7s8o0yNprGXRXuAnRcHKxSjFmW4wclcUTYsQZkhnbMwthWM6cAYb/h2W
# 5GNKtlmj/y/CThe3y/o0EH2h+jwfU/9eJ0fK1ZO/2WD0xi777qU+a7l8KjMPdwjY
# 0tk9bYEGEZfYPRHy1AGPQVuZlG4i5ymJDsMrcIcqV8pxzsw/yk/O4y/nlOjHz4oV
# APU0br5t9tgD8E08GSDi3I6H57Ftod9w26h0MlQiOr10Xqhr5iPLS7SlQwj8HW37
# ybqsmjQpKhmWul6xiXSNGGm36GarHy4Q1egYlxhlUnk3ZKSr3QtWIo1GGL03hT57
# xzjL25fKiZQX/q+II8nuG5M0Qmjvl6Egltr4hZ3e3FQRzRHfLoNPq3ELpxbWdH8t
# Nuj0j/x9Crnfwbki8n57mJKI5JVWRWTSLmbTcDDLkTZlJLg9V1BIJwXGY3i2kR9i
# 5HsADL8YlW0gMWVSlKB1eiSlK6LmFi0rVH16dde+j5T/EaQtFz6qngN7d1lvO7uk
# 6rtX+MLKG4LDRsQgBTi6sIYiKntMjoYFHMPvI/OMUip5ljtLitVbkFGfagSqmbxK
# 7rJMhC8wiTzHanBg1Rrbff1niBbnFbbV4UDmYumjs1FIpFCazk6AADXxoKCo5TsO
# zSHqr9gHgGYQC2hMyX9MGLIpowYCURx3L7kUiGbOiMwaMIIHejCCBWKgAwIBAgIK
# YQ6Q0gAAAAAAAzANBgkqhkiG9w0BAQsFADCBiDELMAkGA1UEBhMCVVMxEzARBgNV
# BAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jv
# c29mdCBDb3Jwb3JhdGlvbjEyMDAGA1UEAxMpTWljcm9zb2Z0IFJvb3QgQ2VydGlm
# aWNhdGUgQXV0aG9yaXR5IDIwMTEwHhcNMTEwNzA4MjA1OTA5WhcNMjYwNzA4MjEw
# OTA5WjB+MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UE
# BxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSgwJgYD
# VQQDEx9NaWNyb3NvZnQgQ29kZSBTaWduaW5nIFBDQSAyMDExMIICIjANBgkqhkiG
# 9w0BAQEFAAOCAg8AMIICCgKCAgEAq/D6chAcLq3YbqqCEE00uvK2WCGfQhsqa+la
# UKq4BjgaBEm6f8MMHt03a8YS2AvwOMKZBrDIOdUBFDFC04kNeWSHfpRgJGyvnkmc
# 6Whe0t+bU7IKLMOv2akrrnoJr9eWWcpgGgXpZnboMlImEi/nqwhQz7NEt13YxC4D
# dato88tt8zpcoRb0RrrgOGSsbmQ1eKagYw8t00CT+OPeBw3VXHmlSSnnDb6gE3e+
# lD3v++MrWhAfTVYoonpy4BI6t0le2O3tQ5GD2Xuye4Yb2T6xjF3oiU+EGvKhL1nk
# kDstrjNYxbc+/jLTswM9sbKvkjh+0p2ALPVOVpEhNSXDOW5kf1O6nA+tGSOEy/S6
# A4aN91/w0FK/jJSHvMAhdCVfGCi2zCcoOCWYOUo2z3yxkq4cI6epZuxhH2rhKEmd
# X4jiJV3TIUs+UsS1Vz8kA/DRelsv1SPjcF0PUUZ3s/gA4bysAoJf28AVs70b1FVL
# 5zmhD+kjSbwYuER8ReTBw3J64HLnJN+/RpnF78IcV9uDjexNSTCnq47f7Fufr/zd
# sGbiwZeBe+3W7UvnSSmnEyimp31ngOaKYnhfsi+E11ecXL93KCjx7W3DKI8sj0A3
# T8HhhUSJxAlMxdSlQy90lfdu+HggWCwTXWCVmj5PM4TasIgX3p5O9JawvEagbJjS
# 4NaIjAsCAwEAAaOCAe0wggHpMBAGCSsGAQQBgjcVAQQDAgEAMB0GA1UdDgQWBBRI
# bmTlUAXTgqoXNzcitW2oynUClTAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTAL
# BgNVHQ8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBRyLToCMZBD
# uRQFTuHqp8cx0SOJNDBaBgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3JsLm1pY3Jv
# c29mdC5jb20vcGtpL2NybC9wcm9kdWN0cy9NaWNSb29DZXJBdXQyMDExXzIwMTFf
# MDNfMjIuY3JsMF4GCCsGAQUFBwEBBFIwUDBOBggrBgEFBQcwAoZCaHR0cDovL3d3
# dy5taWNyb3NvZnQuY29tL3BraS9jZXJ0cy9NaWNSb29DZXJBdXQyMDExXzIwMTFf
# MDNfMjIuY3J0MIGfBgNVHSAEgZcwgZQwgZEGCSsGAQQBgjcuAzCBgzA/BggrBgEF
# BQcCARYzaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9kb2NzL3ByaW1h
# cnljcHMuaHRtMEAGCCsGAQUFBwICMDQeMiAdAEwAZQBnAGEAbABfAHAAbwBsAGkA
# YwB5AF8AcwB0AGEAdABlAG0AZQBuAHQALiAdMA0GCSqGSIb3DQEBCwUAA4ICAQBn
# 8oalmOBUeRou09h0ZyKbC5YR4WOSmUKWfdJ5DJDBZV8uLD74w3LRbYP+vj/oCso7
# v0epo/Np22O/IjWll11lhJB9i0ZQVdgMknzSGksc8zxCi1LQsP1r4z4HLimb5j0b
# pdS1HXeUOeLpZMlEPXh6I/MTfaaQdION9MsmAkYqwooQu6SpBQyb7Wj6aC6VoCo/
# KmtYSWMfCWluWpiW5IP0wI/zRive/DvQvTXvbiWu5a8n7dDd8w6vmSiXmE0OPQvy
# CInWH8MyGOLwxS3OW560STkKxgrCxq2u5bLZ2xWIUUVYODJxJxp/sfQn+N4sOiBp
# mLJZiWhub6e3dMNABQamASooPoI/E01mC8CzTfXhj38cbxV9Rad25UAqZaPDXVJi
# hsMdYzaXht/a8/jyFqGaJ+HNpZfQ7l1jQeNbB5yHPgZ3BtEGsXUfFL5hYbXw3MYb
# BL7fQccOKO7eZS/sl/ahXJbYANahRr1Z85elCUtIEJmAH9AAKcWxm6U/RXceNcbS
# oqKfenoi+kiVH6v7RyOA9Z74v2u3S5fi63V4GuzqN5l5GEv/1rMjaHXmr/r8i+sL
# gOppO6/8MO0ETI7f33VtY5E90Z1WTk+/gFcioXgRMiF670EKsT/7qMykXcGhiJtX
# cVZOSEXAQsmbdlsKgEhr/Xmfwb1tbWrJUnMTDXpQzTGCGaIwghmeAgEBMIGVMH4x
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01p
# Y3Jvc29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTECEzMAAAOuLTVRyFOPVR0AAAAA
# A64wDQYJYIZIAWUDBAIBBQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQw
# HAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIIrd
# MDE2ulW85JcpVHAlHy107l9gBeuxbWNBJsVcDX6kMEIGCisGAQQBgjcCAQwxNDAy
# oBSAEgBNAGkAYwByAG8AcwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20wDQYJKoZIhvcNAQEBBQAEggEAuOXsG74ndR6oWs7BqMWv8BxNs09kIKSNBrkr
# XIk/N0VgrmYBCc8aEc+Z3kswjj31j5OZyrMZIIhVXSec1xAMajJiDtDWTIsV7fa1
# 2O9TcUkST9lvM7aOCbQi9q/9i9voteqer377KzRO/rTNHFvCAZVIs5hna3pE0uvq
# UIdG0jPMojHu+9UIbqnVSq/Co80KI15i4Xq1KSeQUquCc1n+ni81xDI+gEK4MDea
# KX1FTO7Jj4bMB4vbGqEYHqmj9LBjWzmbpnOkCXgVq2mBwga0ucunGV7ywe22rwlM
# lUNoJWYZh2w15kgKUu/knJIW1qRXdlbVAnD7aAK8SAileB+WHqGCFywwghcoBgor
# BgEEAYI3AwMBMYIXGDCCFxQGCSqGSIb3DQEHAqCCFwUwghcBAgEDMQ8wDQYJYIZI
# AWUDBAIBBQAwggFZBgsqhkiG9w0BCRABBKCCAUgEggFEMIIBQAIBAQYKKwYBBAGE
# WQoDATAxMA0GCWCGSAFlAwQCAQUABCDecljC+9Zan64Lbmy6Y5KocVySYVvyCMmr
# 3EwwiNEzOAIGZbqig7qLGBMyMDI0MDIwODEzMzEwMC4xMzRaMASAAgH0oIHYpIHV
# MIHSMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMS0wKwYDVQQL
# EyRNaWNyb3NvZnQgSXJlbGFuZCBPcGVyYXRpb25zIExpbWl0ZWQxJjAkBgNVBAsT
# HVRoYWxlcyBUU1MgRVNOOjNCRDQtNEI4MC02OUMzMSUwIwYDVQQDExxNaWNyb3Nv
# ZnQgVGltZS1TdGFtcCBTZXJ2aWNloIIRezCCBycwggUPoAMCAQICEzMAAAHlj2rA
# 8z20C6MAAQAAAeUwDQYJKoZIhvcNAQELBQAwfDELMAkGA1UEBhMCVVMxEzARBgNV
# BAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jv
# c29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAg
# UENBIDIwMTAwHhcNMjMxMDEyMTkwNzM1WhcNMjUwMTEwMTkwNzM1WjCB0jELMAkG
# A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQx
# HjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEtMCsGA1UECxMkTWljcm9z
# b2Z0IElyZWxhbmQgT3BlcmF0aW9ucyBMaW1pdGVkMSYwJAYDVQQLEx1UaGFsZXMg
# VFNTIEVTTjozQkQ0LTRCODAtNjlDMzElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUt
# U3RhbXAgU2VydmljZTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAKl7
# 4Drau2O6LLrJO3HyTvO9aXai//eNyP5MLWZrmUGNOJMPwMI08V9zBfRPNcucreIY
# SyJHjkMIUGmuh0rPV5/2+UCLGrN1P77n9fq/mdzXMN1FzqaPHdKElKneJQ8R6cP4
# dru2Gymmt1rrGcNe800CcD6d/Ndoommkd196VqOtjZFA1XWu+GsFBeWHiez/Pllq
# cM/eWntkQMs0lK0zmCfH+Bu7i1h+FDRR8F7WzUr/7M3jhVdPpAfq2zYCA8ZVLNgE
# izY+vFmgx+zDuuU/GChDK7klDcCw+/gVoEuSOl5clQsydWQjJJX7Z2yV+1KC6G1J
# VqpP3dpKPAP/4udNqpR5HIeb8Ta1JfjRUzSv3qSje5y9RYT/AjWNYQ7gsezuDWM/
# 8cZ11kco1JvUyOQ8x/JDkMFqSRwj1v+mc6LKKlj//dWCG/Hw9ppdlWJX6psDesQu
# QR7FV7eCqV/lfajoLpPNx/9zF1dv8yXBdzmWJPeCie2XaQnrAKDqlG3zXux9tNQm
# z2L96TdxnIO2OGmYxBAAZAWoKbmtYI+Ciz4CYyO0Fm5Z3T40a5d7KJuftF6CTocc
# c/Up/jpFfQitLfjd71cS+cLCeoQ+q0n0IALvV+acbENouSOrjv/QtY4FIjHlI5zd
# JzJnGskVJ5ozhji0YRscv1WwJFAuyyCMQvLdmPddAgMBAAGjggFJMIIBRTAdBgNV
# HQ4EFgQU3/+fh7tNczEifEXlCQgFOXgMh6owHwYDVR0jBBgwFoAUn6cVXQBeYl2D
# 9OXSZacbUzUZ6XIwXwYDVR0fBFgwVjBUoFKgUIZOaHR0cDovL3d3dy5taWNyb3Nv
# ZnQuY29tL3BraW9wcy9jcmwvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUy
# MDIwMTAoMSkuY3JsMGwGCCsGAQUFBwEBBGAwXjBcBggrBgEFBQcwAoZQaHR0cDov
# L3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9jZXJ0cy9NaWNyb3NvZnQlMjBUaW1l
# LVN0YW1wJTIwUENBJTIwMjAxMCgxKS5jcnQwDAYDVR0TAQH/BAIwADAWBgNVHSUB
# Af8EDDAKBggrBgEFBQcDCDAOBgNVHQ8BAf8EBAMCB4AwDQYJKoZIhvcNAQELBQAD
# ggIBADP6whOFjD1ad8GkEJ9oLBuvfjndMyGQ9R4HgBKSlPt3pa0XVLcimrJlDnKG
# gFBiWwI6XOgw82hdolDiMDBLLWRMTJHWVeUY1gU4XB8OOIxBc9/Q83zb1c0RWEup
# gC48I+b+2x2VNgGJUsQIyPR2PiXQhT5PyerMgag9OSodQjFwpNdGirna2rpV23EU
# wFeO5+3oSX4JeCNZvgyUOzKpyMvqVaubo+Glf/psfW5tIcMjZVt0elswfq0qJNQg
# oYipbaTvv7xmixUJGTbixYifTwAivPcKNdeisZmtts7OHbAM795ZvKLSEqXiRUjD
# YZyeHyAysMEALbIhdXgHEh60KoZyzlBXz3VxEirE7nhucNwM2tViOlwI7EkeU5hu
# dctnXCG55JuMw/wb7c71RKimZA/KXlWpmBvkJkB0BZES8OCGDd+zY/T9BnTp8si3
# 6Tql84VfpYe9iHmy7PqqxqMF2Cn4q2a0mEMnpBruDGE/gR9c8SVJ2ntkARy5Sflu
# uJ/MB61yRvT1mUx3lyppO22ePjBjnwoEvVxbDjT1jhdMNdevOuDeJGzRLK9HNmTD
# C+TdZQlj+VMgIm8ZeEIRNF0oaviF+QZcUZLWzWbYq6yDok8EZKFiRR5otBoGLvaY
# FpxBZUE8mnLKuDlYobjrxh7lnwrxV/fMy0F9fSo2JxFmtLgtMIIHcTCCBVmgAwIB
# AgITMwAAABXF52ueAptJmQAAAAAAFTANBgkqhkiG9w0BAQsFADCBiDELMAkGA1UE
# BhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAc
# BgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEyMDAGA1UEAxMpTWljcm9zb2Z0
# IFJvb3QgQ2VydGlmaWNhdGUgQXV0aG9yaXR5IDIwMTAwHhcNMjEwOTMwMTgyMjI1
# WhcNMzAwOTMwMTgzMjI1WjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGlu
# Z3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBv
# cmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDCC
# AiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAOThpkzntHIhC3miy9ckeb0O
# 1YLT/e6cBwfSqWxOdcjKNVf2AX9sSuDivbk+F2Az/1xPx2b3lVNxWuJ+Slr+uDZn
# hUYjDLWNE893MsAQGOhgfWpSg0S3po5GawcU88V29YZQ3MFEyHFcUTE3oAo4bo3t
# 1w/YJlN8OWECesSq/XJprx2rrPY2vjUmZNqYO7oaezOtgFt+jBAcnVL+tuhiJdxq
# D89d9P6OU8/W7IVWTe/dvI2k45GPsjksUZzpcGkNyjYtcI4xyDUoveO0hyTD4MmP
# frVUj9z6BVWYbWg7mka97aSueik3rMvrg0XnRm7KMtXAhjBcTyziYrLNueKNiOSW
# rAFKu75xqRdbZ2De+JKRHh09/SDPc31BmkZ1zcRfNN0Sidb9pSB9fvzZnkXftnIv
# 231fgLrbqn427DZM9ituqBJR6L8FA6PRc6ZNN3SUHDSCD/AQ8rdHGO2n6Jl8P0zb
# r17C89XYcz1DTsEzOUyOArxCaC4Q6oRRRuLRvWoYWmEBc8pnol7XKHYC4jMYcten
# IPDC+hIK12NvDMk2ZItboKaDIV1fMHSRlJTYuVD5C4lh8zYGNRiER9vcG9H9stQc
# xWv2XFJRXRLbJbqvUAV6bMURHXLvjflSxIUXk8A8FdsaN8cIFRg/eKtFtvUeh17a
# j54WcmnGrnu3tz5q4i6tAgMBAAGjggHdMIIB2TASBgkrBgEEAYI3FQEEBQIDAQAB
# MCMGCSsGAQQBgjcVAgQWBBQqp1L+ZMSavoKRPEY1Kc8Q/y8E7jAdBgNVHQ4EFgQU
# n6cVXQBeYl2D9OXSZacbUzUZ6XIwXAYDVR0gBFUwUzBRBgwrBgEEAYI3TIN9AQEw
# QTA/BggrBgEFBQcCARYzaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9E
# b2NzL1JlcG9zaXRvcnkuaHRtMBMGA1UdJQQMMAoGCCsGAQUFBwMIMBkGCSsGAQQB
# gjcUAgQMHgoAUwB1AGIAQwBBMAsGA1UdDwQEAwIBhjAPBgNVHRMBAf8EBTADAQH/
# MB8GA1UdIwQYMBaAFNX2VsuP6KJcYmjRPZSQW9fOmhjEMFYGA1UdHwRPME0wS6BJ
# oEeGRWh0dHA6Ly9jcmwubWljcm9zb2Z0LmNvbS9wa2kvY3JsL3Byb2R1Y3RzL01p
# Y1Jvb0NlckF1dF8yMDEwLTA2LTIzLmNybDBaBggrBgEFBQcBAQROMEwwSgYIKwYB
# BQUHMAKGPmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2kvY2VydHMvTWljUm9v
# Q2VyQXV0XzIwMTAtMDYtMjMuY3J0MA0GCSqGSIb3DQEBCwUAA4ICAQCdVX38Kq3h
# LB9nATEkW+Geckv8qW/qXBS2Pk5HZHixBpOXPTEztTnXwnE2P9pkbHzQdTltuw8x
# 5MKP+2zRoZQYIu7pZmc6U03dmLq2HnjYNi6cqYJWAAOwBb6J6Gngugnue99qb74p
# y27YP0h1AdkY3m2CDPVtI1TkeFN1JFe53Z/zjj3G82jfZfakVqr3lbYoVSfQJL1A
# oL8ZthISEV09J+BAljis9/kpicO8F7BUhUKz/AyeixmJ5/ALaoHCgRlCGVJ1ijbC
# HcNhcy4sa3tuPywJeBTpkbKpW99Jo3QMvOyRgNI95ko+ZjtPu4b6MhrZlvSP9pEB
# 9s7GdP32THJvEKt1MMU0sHrYUP4KWN1APMdUbZ1jdEgssU5HLcEUBHG/ZPkkvnNt
# yo4JvbMBV0lUZNlz138eW0QBjloZkWsNn6Qo3GcZKCS6OEuabvshVGtqRRFHqfG3
# rsjoiV5PndLQTHa1V1QJsWkBRH58oWFsc/4Ku+xBZj1p/cvBQUl+fpO+y/g75LcV
# v7TOPqUxUYS8vwLBgqJ7Fx0ViY1w/ue10CgaiQuPNtq6TPmb/wrpNPgkNWcr4A24
# 5oyZ1uEi6vAnQj0llOZ0dFtq0Z4+7X6gMTN9vMvpe784cETRkPHIqzqKOghif9lw
# Y1NNje6CbaUFEMFxBmoQtB1VM1izoXBm8qGCAtcwggJAAgEBMIIBAKGB2KSB1TCB
# 0jELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1Jl
# ZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEtMCsGA1UECxMk
# TWljcm9zb2Z0IElyZWxhbmQgT3BlcmF0aW9ucyBMaW1pdGVkMSYwJAYDVQQLEx1U
# aGFsZXMgVFNTIEVTTjozQkQ0LTRCODAtNjlDMzElMCMGA1UEAxMcTWljcm9zb2Z0
# IFRpbWUtU3RhbXAgU2VydmljZaIjCgEBMAcGBSsOAwIaAxUA942iGuYFrsE4wzWD
# d85EpM6RiwqggYMwgYCkfjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGlu
# Z3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBv
# cmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDAN
# BgkqhkiG9w0BAQUFAAIFAOlvArMwIhgPMjAyNDAyMDgxNTM1MTVaGA8yMDI0MDIw
# OTE1MzUxNVowdzA9BgorBgEEAYRZCgQBMS8wLTAKAgUA6W8CswIBADAKAgEAAgII
# /wIB/zAHAgEAAgISxjAKAgUA6XBUMwIBADA2BgorBgEEAYRZCgQCMSgwJjAMBgor
# BgEEAYRZCgMCoAowCAIBAAIDB6EgoQowCAIBAAIDAYagMA0GCSqGSIb3DQEBBQUA
# A4GBAGofwOyrLk3gGclHorDshP7Z+26CXoN/2qr2scl14VSYok4ulcZQkLpYdZnv
# iSOJ0qZ0mp9kVSTLjTJtaPMJd6g8v6qJlYjviIDZZYhNLhSDtQ1bNJsu5XDKA1BA
# P6KDj7pH0gJY1SEU+fKNXtMmYlWFTHEUETxVFj2jcM3HnKggMYIEDTCCBAkCAQEw
# gZMwfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcT
# B1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UE
# AxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTACEzMAAAHlj2rA8z20C6MA
# AQAAAeUwDQYJYIZIAWUDBAIBBQCgggFKMBoGCSqGSIb3DQEJAzENBgsqhkiG9w0B
# CRABBDAvBgkqhkiG9w0BCQQxIgQgNK3j7Dek6ywFrNvVO4bSuJdliAlsHxM80D3+
# JmZYDTswgfoGCyqGSIb3DQEJEAIvMYHqMIHnMIHkMIG9BCAVqdP//qjxGFhe2Ybo
# EXeb8I/pAof01CwhbxUH9U697TCBmDCBgKR+MHwxCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1w
# IFBDQSAyMDEwAhMzAAAB5Y9qwPM9tAujAAEAAAHlMCIEILmfrK/4O3FDFyEhvpYC
# 6LVaqSVFsfNGGcICeGSS+k5kMA0GCSqGSIb3DQEBCwUABIICAGTRRPVnmluPGwKD
# 2eZm90pAiiHYjuiVwy7j70kw31hNgkINpYhOZrTqqW2u+ZMiUiW0hIzcYwvRJ2Ww
# V2cUBwiF+t89nNmCoPvuI5aM2bPZC0CzBnbb8RJnysq62B2hkRoHpxIwjTMuT+ow
# KnRB7CN9VNl0DCp//fVN33KUZFLGZ6ZrhDz/90zXkfRXKTfLYMBgyVaQ5yjeMwFN
# c9KXsQXLVoUiu15SFxREYIAXBzW5/zzyq5y1cq1e8ktqscqUarEfOMIstAh+9QiJ
# L3oymoNQHfPPImxCNQhCb4l2jylzNCC+iUNT9CJPNJ2YiqlwbmxjvDh6/xxU6/m/
# LE0zad0M62GbgvffNAZwGxaIa2HkFl7C3WZHp0P6K0aZn+Ngd7mvVYwlocZWjDmw
# bgSOuqp39uQ+NJ0B0OFqYMyKWCovNtdeDAs85rvCbuFxTCMwGiEelTNjvcJEt4vL
# g47TLTl5QPGj5dCNM+Al/EIVHjD/7Vyr6sL86+/oU57obSQFz3ofGkgorCAWDpK8
# xFmaRFwnNbpDwXo6Eb6rZtmmvAPZl6c54EIOePJWu4VA7pZbdF+xUDSZ+6MQ6oil
# WQXUVziuCN6oKM8QPKTcxBEdf9DOXmdZ9jTWCGP1lbC6nqVgwE+Hh2aagTeRGH13
# ApZZ6hqEF3NZ9R0t+loZzKLqBk/y
# SIG # End signature block
