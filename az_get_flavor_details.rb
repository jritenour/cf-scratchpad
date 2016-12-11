# Method to get a list of flavor info from Azure
begin
  
  def log(level, message)  
    @method = 'az_get_flav_details'
    $evm.log(level, "#{@method} - #{message}")  
  end   
  # dump_root  
  def dump_root()  
    log(:info, "Root:<$evm.root> Begin $evm.root.attributes")  
    $evm.root.attributes.sort.each { |k, v| log(:info, "Root:<$evm.root> Attribute - #{k}: #{v}")}  
    log(:info, "Root:<$evm.root> End $evm.root.attributes")  
    log(:info, "")  
  end  
  dump_root
  attributes = $evm.root.attributes
  instance_type = attributes['dialog_instance_type']  
    
prov=$evm.vmdb(:ems).find_by_type("ManageIQ::Providers::Azure::CloudManager")
selflav=prov.flavors.find { |x| x["id"] == instance_type.to_i}
#mem=selflav.memory/1048576
#cpus=selflav.cpus
#disk=selflav.root_disk_size/1048576

#flavinfo =  [mem.to_s+"GB Memory",cpus.to_s+"CPUS",disk.to_s+" GB root disk"],[mem.to_s+"GB Memory",cpus.to_s+"CPUS",disk.to_s+" GB root disk"]
values_hash = {}
values_hash['Memory']=selflav.memory/1048576
values_hash['CPUs']=selflav.cpus  
values_hash['disk']=selflav.root_disk_size/1048576

  dialog_field = $evm.object  
  
    # set the values  
    dialog_field['values'] = [values_hash, values_hash]
  
    # sort_by: value / description / none  
    dialog_field["sort_by"] = "description"  
    # sort_order: ascending / descending  
    dialog_field["sort_order"] = "ascending"  
    # data_type: string / integer  
    dialog_field["data_type"] = "string"  
    # required: true / false  
    dialog_field["required"] = "true"  
    log(:info, "Dynamic drop down values: #{dialog_field['values']}")  
end
