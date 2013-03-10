# Cookbook Name:: buildbot
# Recipe:: _common
#
# Copyright 2012, Juanje Ojeda <juanje.ojeda@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Needed to install Python packages
include_recipe "python::pip"
include_recipe "user"

# Add user and group for Buildbot
group node['buildbot']['group']

# Create user with a home directory, preset .ssh/authorized_keys, and a
# generated .ssh/id_rsa. In order to enable buildbot masters and slaves to
# access a private repository, the public key for each master and slave will
# need to registered as a deploy key with the repository.
user_account node['buildbot']['user'] do
  comment "Buildbot user."
  ssh_keys node['buildbot']['authorized_keys']
  system_user true
  manage_home true
  ssh_keygen true
  gid node['buildbot']['group']
  action :create
end

# Install the system's dependencies
packages = value_for_platform(
  ["centos", "redhat", "suse", "fedora" ] => {
    "default" => %w{ git python-devel }
  },
  ["ubuntu", "debian"] => {
    "default" => %w{ git-core python-dev }
  }
)

packages.each do |pkg|
  package pkg
end
