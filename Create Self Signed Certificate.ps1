$cert = New-SelfSignedCertificate -CertStoreLocation Cert:\LocalMachine\My -DnsName weather.io
$cert
$pwd = ConvertTo-SecureString -String "P@ssw0rd" -Force -AsPlainText
$certpath = "Cert:\LocalMachine\My\$($cert.Thumbprint)"
$certpath
Export-PfxCertificate -Cert $certpath -FilePath c:\weather.pfx -Password $pwd
