# Method to get a list of flavors from Azure
begin
  
  def log(level, message)  
    @method = 'get_resource_group'
    $evm.log(level, "#{@method} - #{message}")  
  end   
  # dump_root  
  def dump_root()  
    log(:info, "Root:<$evm.root> Begin $evm.root.attributes")  
    $evm.root.attributes.sort.each { |k, v| log(:info, "Root:<$evm.root> Attribute - #{k}: #{v}")}  
    log(:info, "Root:<$evm.root> End $evm.root.attributes")  
    log(:info, "")  
  end  
  
prov=$evm.vmdb(:ems).find_by_type("ManageIQ::Providers::Azure::CloudManager")

flavors=prov.flavors.map { |x| [x["id"],x["name"]]}

$evm.log(:info, "Inspecting Resource Group  Names: #{flavors.inspect}")  

    dialog_field = $evm.object  
  
    # set the values  
    dialog_field['values'] = flavors.to_a
  
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

