#
define dotnet::install::feature(
  DotNet::Version $version,
  DotNet::Ensure  $ensure = 'present',
) {

  if $ensure == 'present' {
    exec { "install-feature-${version}":
      command   => 'Import-Module ServerManager; Add-WindowsFeature as-net-framework',
      provider  => powershell,
      logoutput => true,
      unless    => "Test-Path C:\\Windows\\Microsoft.NET\\Framework\\v${version}",
    }
  } else {
    exec { "uninstall-feature-${version}":
      command   => 'Import-Module ServerManager; Remove-WindowsFeature as-net-framework',
      provider  => powershell,
      logoutput => true,
      onlyif    => "Test-Path C:\\Windows\\Microsoft.NET\\Framework\\v${version}",
    }
  }

}
