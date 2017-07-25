###################################  
#  
# Method for logging  
begin  
  @method = 'ZoneDesc'  
  
  $evm.log(:info, "#{@method} - EVM Automate Method Started")  
  
  # Turn of verbose logging  
  @debug = false  
  
  
  ###################################  
  # Method: dumpRoot  
  #  
  ###################################  
  def dumpRoot  
    $evm.log(:info, "#{@method} - Root:<$evm.root> Begin Attributes")  
    $evm.root.attributes.sort.each { |k, v| $evm.log(:info, "#{@method} - Root:<$evm.root> Attributes - #{k}: #{v}")}  
    $evm.log(:info, "#{@method} - Root:<$evm.root> End Attributes")  
    $evm.log(:info, "")  
  end  
  
  dumpRoot  
  
  $evm.log(:info, "#{@method} - ================================= EVM Automate Method Started")  
  zones=$evm.vmdb(:miq_server).all.map{|x| [x.zone_id, x.zone_description]}.uniq
  $evm.log(:info, "Inspecting MIQ Zones: #{zones.inspect}")  
  list_values = {  
    'sort_by' => :none,  
    'data_type'  => :string,  
    'required'   => false,  
    'values'     => [[nil, nil]] + zones.to_a,  
    }  
  $evm.log(:info, "Dynamic drop down values: Names drop-down: [#{list_values}]")   
  list_values.each { |k,v| $evm.object[k] = v }  
    
  # Exit method  
  $evm.log(:info, "CFME Automate Method Ended")  
  exit MIQ_OK  
  
    # Set Ruby rescue behavior  
rescue => err  
  $evm.log(:error, "[#{err}]\n#{err.backtrace.join("\n")}")  
  exit MIQ_STOP  
end  
