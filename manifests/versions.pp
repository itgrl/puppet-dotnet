# Author::    Liam Bennett (mailto:liamjbennett@gmail.com)
# Copyright:: Copyright (c) 2014 Liam Bennett
# License::   MIT

# == Class dotnet::versions
#
# This class is meant to be called from `dotnet`
# It sets variables according to platform
#
class dotnet::versions {
  $list = lookup('dotnet::versions', DotNet::Hash, 'deep')
}
