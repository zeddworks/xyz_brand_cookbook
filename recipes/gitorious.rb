#
# Cookbook Name:: brand
# Recipe:: gitorious
#
# Copyright 2011, ZeddWorks
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

gitorious = Chef::EncryptedDataBagItem.load("apps", "gitorious")
xyz_brand = Chef::EncryptedDataBagItem.load("env", "xyz_brand")

git_user = gitorious["user"]
git_group = gitorious["group"]

file "/tmp/logo.b64" do
  content xyz_brand["logo"]
  owner git_user
  group git_group
end

execute "cat /tmp/logo.b64 | base64 -d > /srv/rails/gitorious.zeddworks.com/current/public/img/logo.png" do
  user git_user
  group git_group
end

execute "cat /tmp/logo.b64 | base64 -d > /srv/rails/gitorious.zeddworks.com/current/public/img/external/logo.png" do
  user git_user
  group git_group
end

file "/tmp/logo.b64" do
  action :delete
end

execute "sed -i -e '58s/height: 45px;/height: 49px;/' -e '67s/height: 45px;/height: 49px;/' /srv/rails/gitorious.zeddworks.com/current/public/stylesheets/external.css" do
  user git_user
  group git_group
end
