require 'rest-client'
require 'yaml'
require 'json'
require 'net/ssh'
@hosts = YAML::load_file('seldon_alerts_dashboard/config/apps/seldon_apps.yml')
@machines = YAML::load_file(@hosts["deployed_path"][0]+'/seldon_alerts_dashboard/config/apps/seldon_machines.yml')
@diskfree = {}
@vgroot_var = {}
@mysql_tmp_free ={}
@mysql_disk_free ={}
@turbo_machine_status ={}

puts @machines
@machines["machines"].each do |ip|
  begin
    Net::SSH.start(ip, 'saurabh.g', {:timeout => 3}) do |ssh|
      output = ssh.exec!("timeout 2 df -h")
	puts output
      output = output.split
      @diskfree[ip] = 100-(output[11].split('%').first.to_i)
      # 'df -h' returns an extra top line in the following two cron servers
      if ip == '10.85.123.4'
        @diskfree[ip] = 100-(output[19].split('%').first.to_i)
      else if ip == '10.85.170.39'
             @diskfree[ip] = 100-(output[17].split('%').first.to_i)
           end
      end
    end
  rescue
    next
  end
end

File.open(@hosts["deployed_path"][0]+"/seldon_alerts_dashboard/app/scripts/disk_free_file.yml", "w") do |file|
  file.write @diskfree.to_yaml
end




