require 'json'
require 'winrm'

  def log(level, message)  
    @method = 'get_network'
    $evm.log(level, "#{@method} - #{message}")  
  end  

PS_SCRIPT = <<-PS_SCRIPT
Import-Module SQLPS -DisableNameChecking
$srv = New-Object 'Microsoft.SqlServer.Management.SMO.Server' WIN2012TEST\\sqlexpress
$db=$srv.Databases | select name -expandproperty name
$result = @{
"dbs" = $db
}
$result |ConvertTo-JSON
PS_SCRIPT


  server   =  $evm.root['vm'].ipaddresses.first 
  user = $evm.object['user']
  password = $evm.object.decrypt('password')


url_params = {
  :ipaddress => server,
  :port      => 5985                # Default port 5985
}

connect_params = {
  :user         => user,   # Example: domain\\user
  :pass         => password,
  :disable_sspi => true
}

url = "http://#{url_params[:ipaddress]}:#{url_params[:port]}/wsman"
$evm.log("info", "Connecting to WinRM on URL :#{url}")

winrm   = WinRM::WinRMWebService.new(url, :ssl, connect_params)
results = winrm.run_powershell_script(PS_SCRIPT)

# results is a hash with 2 keys:
# 1) The first key :data is an array with two hashes
#   :stderr
#   :stdout
# 2) the second key is the :exitcode.

errors = results[:data].collect { |d| d[:stderr] }.join
$evm.log("error", "WinRM returned stderr: #{errors}") unless errors.blank?

data = results[:data].collect { |d| d[:stdout] }.join
json_hash = JSON.parse(data, :symbolize_names => true)
$evm.log("info", "WinRM returned hash: #{json_hash.inspect}")

  $evm.log(:info, "Inspecting Resource Group  Names: #{json_hash.inspect}")  

    dialog_field = $evm.object  
  
    # set the values  
    dialog_field['values'] = json_hash.map { |x| [x] }
  
    # sort_by: value / description / none  
    dialog_field["sort_by"] = "description"  
    # sort_order: ascending / descending  
    dialog_field["sort_order"] = "ascending"  
    # data_type: string / integer  
    dialog_field["data_type"] = "string"  
    # required: true / false  
    dialog_field["required"] = "true"  
    log(:info, "Dynamic drop down values: #{dialog_field['values']}")  
  
  attributes = $evm.root.attributes
 vm = attributes['dialog_get_vm']  

