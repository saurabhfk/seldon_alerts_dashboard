require 'rest-client'
require 'yaml'
require 'json'
require 'net/ssh'
@hosts = YAML::load_file('seldon_alerts_dashboard/config/apps/seldon_apps.yml')
@cpuidle = {}
@network_latency={}
@db_status={}
@machines = YAML::load_file(@hosts["deployed_path"][0]+'/seldon_alerts_dashboard/config/apps/seldon_machines.yml')


@machines["machines"].each do |ip|
  begin
    Net::SSH.start(ip, 'saurabh.g', {:timeout => 3}) do |ssh|
      output = ssh.exec!("top -b -n1 | grep 'Cpu' | awk '{print $2 + $4}'")
      @cpuidle[ip] = 100 - output.to_i
    end
  rescue
    next
  end
  begin
    output = `ping -c 1 #{ip}`
    output = output.split
    @network_latency[ip]=output[13].split('=').last+output[14]
  rescue
    next
  end
end

File.open(@hosts["deployed_path"][0]+"/seldon_alerts_dashboard/app/scripts/cpu_free_file.yml", "w") do |file|
  file.write @cpuidle.to_yaml
end

File.open(@hosts["deployed_path"][0]+"/seldon_alerts_dashboard/app/scripts/network_latency.yml", "w") do |file|
  file.write @network_latency.to_yaml
end
