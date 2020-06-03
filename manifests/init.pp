# Author::    Liam Bennett (mailto:liamjbennett@gmail.com)
# Copyright:: Copyright (c) 2014 Liam Bennett
# License::   MIT

# == Define: dotnet
#
# Module to install the Microsoft .NET framework on windows
#
# === Requirements/Dependencies
#
# Currently reequires the puppetlabs/stdlib module in order
# to validate much of the the provided configuration.
#
# === Parameters
#
# [*ensure*]
# Control the state of the .NET installation
#
# [*version*]
# The version of .NET to be managed
#
# [*package_dir*]
# If installing .NET from a directory or a mounted network location then this is that directory
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
  DotNet::Ensure      $ensure      = 'present',
  DotNet::Package_Dir $package_dir = '',
  String              $version     = $name,
) {
  include dotnet::versions
  case $dotnet::versions::list[$version] {
    Dotnet::Feature: {
      dotnet::install::feature { "dotnet-feature-${version}":
        ensure  => $ensure,
        version => $version,
      }
    }
    Dotnet::Package: {
      dotnet::install::package { "dotnet-package-${version}":
        ensure      => $ensure,
        package_dir => $package_dir,
        version     => $version,
      }
    }
    default: {
      err(
        sprintf(
          'dotnet %s is not supported on %s %s',
          $facts['os']['family'],
          $facts['os']['release']['major']
        )
      )
    }
  }
}
