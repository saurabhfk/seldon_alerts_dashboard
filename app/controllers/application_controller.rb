class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  layout "application"
  def add_app
    puts "Inside form"
    puts params['Appname']
  end

  def main_dashboard
    @url = {}
    @machines = []
    @machine_status = {}
    $elb_to_machines_mapping = {}
    @elb_to_percentage_up = {}
    @elb_to_disk_free ={}
    @dashboard_links = {}
    @slow_queries = {}
    @hosts = YAML::load_file('config/apps/seldon_apps.yml')
    puts @hosts
    puts @hosts["apps"]
    @hosts["apps"].each do |x|
      total_machines_in_elb = 0
      machines_up_in_elb = 0
      $elb_to_machines_mapping[x] = []
      details = RestClient.get("http://10.47.0.100/apps/"+x+"/global/backendServices/"+x+"-bs/health")
      details = JSON.parse(details)
      details.each do |key, value|
        # next if y[:exclusion_list].include? key
        @machines << key
        $elb_to_machines_mapping[x] << key
        @machine_status[key] = value
        machines_up_in_elb += 1 if value == "true"
        total_machines_in_elb+=1
      end
      @all_machines = YAML::load_file('config/apps/seldon_machines.yml')
      @machines.each do |machine|
        next if @all_machines["machines"].include? machine
        @all_machines["machines"] << machine
      end
      # @all_machines["machines"] << @machines
      File.open('config/apps/seldon_machines.yml','w') do |h|
        h.write @all_machines.to_yaml
      end
      @elb_to_percentage_up[x] =  total_machines_in_elb > 0 ? (machines_up_in_elb*100)/total_machines_in_elb : 0
    end
    puts "hello!!!"
    puts $elb_to_machines_mapping
    puts "hello2!!!"
    puts @elb_to_percentage_up
    @diskfree = YAML::load_file(@hosts["deployed_path"][0]+'/seldon_alerts_dashboard/app/scripts/disk_free_file.yml')
    @memoryfree = YAML::load_file(@hosts["deployed_path"][0]+'/seldon_alerts_dashboard/app/scripts/mem_free_file.yml')
    @cpuidle = YAML::load_file(@hosts["deployed_path"][0]+'/seldon_alerts_dashboard/app/scripts/cpu_free_file.yml')
    @network_latency = YAML::load_file(@hosts["deployed_path"][0]+'/seldon_alerts_dashboard/app/scripts/network_latency.yml')
    render "application/main_dashboard"
  end


end

