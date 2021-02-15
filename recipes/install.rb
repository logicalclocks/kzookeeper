case node['platform_family']
when "rhel"
  bash "install_patch_and_other_devtools" do
    user "root"
    code <<-EOF
      yum groupinstall 'Development Tools' -y
  EOF
  end
end
