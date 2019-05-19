Powershell Example:

# This powershell script will add and remove Azure lb probes and rules with parameters
Copy each custom module to the modules folder path :


C:\Program Files\WindowsPowerShell\Modules\PowerShellGet\2.1.2\Modules
with the same name of the module
to  
C:\Program Files\WindowsPowerShell\Modules\PowerShellGet\2.1.2\Modules\LB_AddProbeAndRule
 and
 C:\Program Files\WindowsPowerShell\Modules\PowerShellGet\2.1.2\Modules\LB_RemoveProbeandRul

Import-module C:\Program Files\WindowsPowerShell\Modules\PowerShellGet\2.1.2\Modules\LB_RemoveProbeandRul
Import-module C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules\LB_RemoveProbeandRul


Another module flder path :
C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules

S C:\lb> get-module LB_AddProbeAndRule

ModuleType Version    Name                                ExportedCommands                                                                                                                   
---------- -------    ----                                ----------------                                                                                                                   
Script     0.0        LB_AddProbeAndRule                  LB_AddProbeAndRule 


PS C:\lb>  get-module LB_RemoveProbeandRule

ModuleType Version    Name                                ExportedCommands                                                                                                                   
---------- -------    ----                                ----------------                                                                                                                   
Script     0.0        LB_RemoveProbeandRule               LB_RemoveProbeandRule   

##############################################################################################################
Note:

use  install-modules in order to download modules from remote , in our case is not needed


# Sam Soud
