# Copyright 2013 SUSE Linux Products GmbH
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

if !node[:updater].has_key?(:one_shot_run) || !node[:updater][:one_shot_run]

  case node[:platform]
  when "suse"
    zypper_params = ["--non-interactive"]
    if not node[:updater][:zypper][:gpg_checks]
      zypper_params << "--no-gpg-checks"
    end

    case node[:updater][:zypper][:method]
    when "patch"
      if node[:updater][:zypper][:patch][:include_reboot_patches]
        zypper_params << "--non-interactive-include-reboot-patches"
      end
    end

    # Butt-ugly, enhance Chef::Provider::Package::Zypper later on...
    Chef::Log.info("Executing zypper #{node[:updater][:zypper][:method]}")
    execute "zypper #{zypper_params.join(' ')} #{node[:updater][:zypper][:method]}" do
      action :run
    end
  end

  node[:updater][:one_shot_run] = true
  node.save
end
