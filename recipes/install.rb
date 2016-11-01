# Nothing to do here...

user node.kzookeeper.user do
  action :create
  home "/home/#{node.kzookeeper.user}"
  shell "/bin/bash"
  manage_home true
  not_if "getent passwd #{node.kzookeeper.user}"
end

group node.kzookeeper.group do
  action :modify
  members ["#{node.kzookeeper.user}"]
  append true
end

directory "#{node.kzookeeper.install_dir}" do
  owner node.kzookeeper.user
  group node.kzookeeper.group
  mode "755"
  action :create
  recursive true
end


case node.platform_family

  when "rhel"

  bash "install_patch_and_other_devtools" do
    user "root"
    code <<-EOF
    yum groupinstall 'Development Tools' -y
  EOF
  end
end

