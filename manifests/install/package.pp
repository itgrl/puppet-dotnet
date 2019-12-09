#
define dotnet::install::package(
  DotNet::Version     $version,
  DotNet::Ensure      $ensure      = 'present',
  DotNet::Package_Dir $package_dir = '',
) {
  include dotnet::versions
  $key = sprintf(
    'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{%s}',
    $dotnet::versions::list[$version]['key']
  )
  $url = $dotnet::versions::list[$version]['url']
  $exe = $url.regsubst(/\A.*\/([^\/]+)\z/, '\1')

  if "x${package_dir}x" == 'xx' {
    $source_dir = 'C:\Windows\Temp'
    if $ensure == 'present' {
      download_file { "download-dotnet-${version}" :
        url                   => $url,
        destination_directory => $source_dir,
      }
    } else {
      file { "C:/Windows/Temp/${exe}":
        ensure => 'absent',
      }
    }
  } else {
    $source_dir = $package_dir
  }

  if $ensure == 'present' {
    exec { "install-dotnet-${version}":
      command   => "& ${source_dir}\\${exe} /q /norestart",
      provider  => powershell,
      logoutput => true,
      unless    => "if ((Get-Item -LiteralPath \'${key}\' -ErrorAction SilentlyContinue).GetValue(\'DisplayVersion\')) { exit 0 }",
    }
  } else {
    exec { "uninstall-dotnet-${version}":
      command   => "& ${source_dir}\\${exe} /x /q /norestart",
      provider  => powershell,
      logoutput => true,
      unless    => "if ((Get-Item -LiteralPath \'${key}\' -ErrorAction SilentlyContinue).GetValue(\'DisplayVersion\')) { exit 1 }",
    }
  }

}
