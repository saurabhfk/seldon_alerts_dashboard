require 'rest-client'
require 'yaml'
require 'json'
require 'net/ssh'
@hosts = YAML::load_file('seldon_alerts_dashboard/config/apps/seldon_apps.yml')
@memfree = {}
@machines = YAML::load_file(@hosts["deployed_path"][0]+'/seldon_alerts_dashboard/config/apps/seldon_machines.yml')

@machines["machines"].each do |ip|
  begin
    Net::SSH.start(ip, 'saurabh.g', {:timeout => 3}) do |ssh|
      output = ssh.exec!("free -m")
      output = output.split
      @memfree[ip] = output[9].to_i*100/output[7].to_i
    end
  rescue
    next
  end
end


File.open(@hosts["deployed_path"][0]+"/seldon_alerts_dashboard/app/scripts/mem_free_file.yml", "w") do |file|
  file.write @memfree.to_yaml
end
