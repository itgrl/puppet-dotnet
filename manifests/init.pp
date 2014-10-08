# Author::    Liam Bennett (mailto:liamjbennett@gmail.com)
# Copyright:: Copyright (c) 2014 Liam Bennett
# License::   MIT

# == Define: dotnet
#
# Module to install the Microsoft .NET framework on windows
#
# === Requirements/Dependencies
#
# Currently reequires the puppetlabs/stdlib module on the Puppet Forge in
# order to validate much of the the provided configuration.
#
# === Parameters
#
# [*ensure*]
# Control the state of the .NET installation
#
# [*version*]
# The version of .NET to be managed
#
# === Examples
#
#  Installing .NET 4.5
#
#    dotnet { 'dotnet45':
#      version => '4.5',
#    }
#
define dotnet(
  $ensure  = 'present',
  $version = ''
) {

  validate_re($ensure,['^(present|absent)$'])
  validate_re($version,['^(3.5|4|4.5)$'])

  include dotnet::params

  if $ensure == 'present' {
    case $version {
      '3.5': {
        case $::operatingsystemversion {
          'Windows Server 2008','Windows Server 2008 R2','Windows Server 2008 R2 Standard','Windows Server 2008 R2 Enterprise',
          'Windows Server 2008 R2 Datacenter','Windows Server 2012': {
            exec { 'install-feature-3.5':
              command   => "${dotnet::params::ps_command} Import-Module ServerManager; Add-WindowsFeature as-net-framework",
              provider  => windows,
              logoutput => true,
              unless    => "${dotnet::params::ps_command} Test-Path C:\\Windows\\Microsoft.NET\\Framework\\v3.5",
            }
          }
          'Windows XP','Windows Vista','Windows 7','Windows 8': {
            exec { 'install-dotnet-35':
              command   => "& ${dotnet::params::deployment_root}\\dotNet\\dotNetFx35setup.exe /q /norestart",
              provider  => powershell,
              logoutput => true,
              unless    => "if ((Get-Item -LiteralPath \'${dotnet::params::t_reg_key}\' -ErrorAction SilentlyContinue).GetValue(\'DisplayVersion\')) { exit 0 }"
            }
          }
          default: {
            err('dotnet 3.5 is not support on this version of windows')
          }
        }
      }
      '4': {
        case $::operatingsystemversion {
          'Windows Server 2008', 'Windows Server 2008 R2','Windows Server 2008 R2 Standard','Windows Server 2008 R2 Enterprise',
          'Windows Server 2008 R2 Datacenter', 'Windows Server 2012','Windows XP','Windows Vista','Windows 7','Windows 8': {
            exec { 'install-dotnet-4':
              command   => "& ${dotnet::params::deployment_root}\\dotNet\\dotNetFx40_Full_x86_x64.exe /q /norestart",
              provider  => powershell,
              logoutput => true,
              unless    => "if ((Get-Item -LiteralPath \'${dotnet::params::f_reg_key}\' -ErrorAction SilentlyContinue).GetValue(\'DisplayVersion\')) { exit 0 }"
            }
          }
          default: {
            err('dotnet 4 is not supported on this version of windows')
          }
        }
      }
      '4.5': {
        case $::operatingsystemversion {
          'Windows Server 2008', 'Windows Server 2008 R2','Windows Server 2008 R2 Standard','Windows Server 2008 R2 Enterprise',
          'Windows Server 2008 R2 Datacenter', 'Windows Server 2012','Windows Vista','Windows 7','Windows 8': {
            exec { 'install-dotnet-45':
              command   => "& ${dotnet::params::deployment_root}\\dotNet\\dotnetfx45_full_x86_x64.exe /q /norestart",
              provider  => powershell,
              logoutput => true,
              unless    => "if ((Get-Item -LiteralPath \'${dotnet::params::ff_reg_key}\' -ErrorAction SilentlyContinue).GetValue(\'DisplayVersion\')) { exit 0 }"
            }
          }
          default: {
            err('dotnet 4.5 is not supported on this version of windows')
          }
        }
      }
      default: {
        err("dotnet does not have a version: ${version}")
      }
    }
  }
  elsif $ensure == 'absent' {
    case $version {
      '3.5': {
        case $::operatingsystemversion {
          'Windows Server 2008', 'Windows Server 2008 R2','Windows Server 2008 R2 Standard','Windows Server 2008 R2 Enterprise',
          'Windows Server 2008 R2 Datacenter', 'Windows Server 2012': {
            exec { 'uninstall-feature-3.5':
              command   => "${dotnet::params::ps_command} Import-Module ServerManager; Remove-WindowsFeature as-net-framework",
              provider  => windows,
              logoutput => true,
              onlyif    => "${dotnet::params::ps_command} Test-Path C:\\Windows\\Microsoft.NET\\Framework\\v3.5",
            }
          }
          'Windows XP','Windows Vista','Windows 7','Windows 8': {
            exec { 'uninstall-dotnet-35':
              command   => "& ${dotnet::params::deployment_root}\\dotNet\\dotNetFx35setup.exe /x /q /norestart",
              provider  => powershell,
              logoutput => true,
              unless    => "if ((Get-Item -LiteralPath \'${dotnet::params::t_reg_key}\' -ErrorAction SilentlyContinue).GetValue(\'DisplayVersion\')) { exit 1 }"
            }
          }
          default: {
            err('dotnet 3.5 is not supported on this version of windows')
          }
        }
      }
      '4': {
        case $::operatingsystemversion {
          'Windows Server 2008', 'Windows Server 2008 R2','Windows Server 2008 R2 Standard','Windows Server 2008 R2 Enterprise',
          'Windows Server 2008 R2 Datacenter', 'Windows Server 2012','Windows XP','Windows Vista','Windows 7','Windows 8': {
            exec { 'uninstall-dotnet-4':
              command   => "& ${dotnet::params::deployment_root}\\dotNet\\dotNetFx40_Full_x86_x64.exe /x /q /norestart",
              provider  => powershell,
              logoutput => true,
              unless    => "if ((Get-Item -LiteralPath \'${dotnet::params::f_reg_key}\' -ErrorAction SilentlyContinue).GetValue(\'DisplayVersion\')) { exit 1 }"
            }
          }
          default: {
            err('dotnet 4 is not supported on this version of windows')
          }
        }
      }
      '4.5': {
        case $::operatingsystemversion {
          'Windows Server 2008', 'Windows Server 2008 R2','Windows Server 2008 R2 Standard','Windows Server 2008 R2 Enterprise',
          'Windows Server 2008 R2 Datacenter', 'Windows Server 2012','Windows Vista','Windows 7','Windows 8': {
            exec { 'uninstall-dotnet-45':
              command   => "& ${dotnet::params::deployment_root}\\dotNet\\dotnetfx45_full_x86_x64.exe /x /q /norestart",
              provider  => powershell,
              logoutput => true,
              unless    => "if ((Get-Item -LiteralPath \'${dotnet::params::ff_reg_key}\' -ErrorAction SilentlyContinue).GetValue(\'DisplayVersion\')) { exit 1 }"
            }
          }
          default: {
            err('dotnet 4.5 is not supported on this version of windows')
          }
        }
      }
    }
  }
}
