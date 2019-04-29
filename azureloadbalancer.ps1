$ErrorActionPreference = 'stop'
#Existing Load Balancer resource Id Sample format:
#$LBresourceId="/subscriptions/subscriptionsid/resourceGroups/sam-test02/providers/Microsoft.Network/Loadbalancers/jhlb-pub"

$Loadbalancerconfig = get-azurermresource -resourceid $LBresourceId
$SubscriptionId= $Loadbalancerconfig.SubscriptionId
Select-AzureRmSubscription -SubscriptionId $SubscriptionId | Set-AzureRmContext
Get-AzureRmSubscription -SubscriptionId $SubscriptionId | Select-AzureRmSubscription
$AzureRmResourceGroupName=$Loadbalancerconfig.ResourceGroupName
$SubscriptionId=$Loadbalancerconfig.SubscriptionId

Get-AzureRmSubscription -SubscriptionId $SubscriptionId | Select-AzureRmSubscription
Select-AzureRmSubscription -SubscriptionId $SubscriptionId | Set-AzureRmContext

$Loadbalancer = Get-AzureRMLoadbalancer -Name $Loadbalancerconfig.Name -ResourceGroupName $AzureRmResourceGroupName
$LoadbalancerFrontEndName=(Get-AzureRmLoadbalancerFrontendIPConfig -Loadbalancer $Loadbalancer).Name
$BackendPools=Get-AzureRmLoadbalancerBackendAddressPoolConfig -Loadbalancer $Loadbalancer

#$BackendPoold is the defaul back end pool, it can be repace with another one if required

$BackendPoold="BackendPool1"
$FrontendIP =  Get-AzureRmLoadbalancerFrontendIPConfig -Name $LoadbalancerFrontEndName -Loadbalancer $Loadbalancer
$BackendPool = Get-AzureRmLoadbalancerBackendAddressPoolConfig -Name $BackendPoold -Loadbalancer $Loadbalancer


function LB_AddProbeAndRule {

Param(

    [Parameter(Mandatory=$True)][String]$LBresourceId,
    [Parameter(Mandatory=$True)][String]$RuleName,
    [Parameter(Mandatory=$True)][String]$ProbeName,
    [Parameter(Mandatory=$True)][String]$Protocol,
    [Parameter()][String]$LoadbalancerFrontEndName="LoadbalancerFrontEnd", # default
    [Parameter()][String]$BackendPoold= "BackendPool1", # default
    [Parameter(Mandatory=$True)][INT]$IntervalInSeconds,
    [Parameter(Mandatory=$True)][INT]$FrontendPort,
    [Parameter(Mandatory=$True)][INT]$BackendPort,
    [Parameter(Mandatory=$True)][INT]$ProbePort
  
    )

   # Add a new Probe configuration to the load balancer
    $Probe = new-AzureRmLoadbalancerProbeConfig -Name $ProbeName  -Protocol $Protocol -Port $ProbePort -IntervalInSeconds $IntervalInSeconds -ProbeCount 2
    $Loadbalancer | Add-AzureRmLoadbalancerProbeConfig  -Name $ProbeName -Protocol $Protocol -Port $ProbePort -IntervalInSeconds $IntervalInSeconds -ProbeCount 2 | Set-AzureRmLoadbalancer
    Set-AzureRmLoadbalancer -Loadbalancer $Loadbalancer

    # Add a new Rule configuration to the load balancer
    New-AzureRmLoadbalancerRuleConfig -Name $RuleName -FrontendIPConfiguration $Loadbalancer.FrontendIPConfigurations[0] -Protocol $Protocol -FrontendPort $FrontendPort -BackendPort $BackendPort -BackendAddressPool $BackendPool -Probe $Probe -EnableFloatingIP
    $Loadbalancer |Add-AzureRmLoadbalancerRuleConfig -Name $RuleName -FrontendIPConfiguration $Loadbalancer.FrontendIPConfigurations[0] -Protocol $Protocol -FrontendPort $FrontendPort -BackendPort $BackendPort  -BackendAddressPool $BackendPool -Probe $Probe -EnableFloatingIP
    $Loadbalancer |Set-AzureRmLoadbalancerRuleConfig -Name $RuleName -FrontendIPConfiguration $Loadbalancer.FrontendIPConfigurations[0] -Protocol $Protocol -FrontendPort $FrontendPort -BackendPort $BackendPort  -BackendAddressPool $BackendPool -Probe $Probe
    Set-AzureRmLoadbalancer -Loadbalancer $Loadbalancer
}


function LB_RemoveProbeandRule {

    Param(
    [Parameter(Mandatory=$True)][String]$LBresourceId,
    [Parameter(Mandatory=$True)][String]$RuleName,
    [Parameter(Mandatory=$True)][String]$ProbeName
    )

    # Load function to Remove Probe and Rule in memory
    Remove-AzureRmLoadBalancerProbeConfig -Name $ProbeName -LoadBalancer $loadbalancer
    Remove-AzureRmLoadBalancerRuleConfig -Name $RuleName -LoadBalancer $loadbalancer
    Set-AzureRmLoadBalancer -LoadBalancer $loadbalancer  
}


#Usage
<#
Try
{
 #Example to Create a probe and its rule: 
 LB_RemoveProbeandRule -LBresourceId $LBresourceId -RuleName "r5220" -ProbeName "p5221"
}
Catch
{
$ErrorMessage=$_.Exception
echo $ErrorMessage
#write to log
}
#>
<#
Try
{
    #Example to Create a probe and its rule: 
 LB_AddProbeAndRule -LBresourceId $LBresourceId -RuleName "r5220" -ProbeName "p5221" -Protocol "TCP" -LoadBalancerFrontEndName $LoadbalancerFrontEndName -BackendPool $BackendPoold -IntervalInSeconds 15 -FrontendPort 5220 -BackendPort 5221 -ProbePort 5222
}
Catch
{
$ErrorMessage=$_.Exception
echo $ErrorMessage
#write to log
}
#>
############################################################

Modules:
####### 

function LB_AddProbeAndRule {

Param(

    [Parameter(Mandatory=$True)][String]$LBresourceId,
    [Parameter(Mandatory=$True)][String]$RuleName,
    [Parameter(Mandatory=$True)][String]$ProbeName,
    [Parameter(Mandatory=$True)][String]$Protocol,
    [Parameter()][String]$LoadbalancerFrontEndName="LoadbalancerFrontEnd", # default
    [Parameter()][String]$BackendPoold= "BackendPool1", # default
    [Parameter(Mandatory=$True)][INT]$IntervalInSeconds,
    [Parameter(Mandatory=$True)][INT]$FrontendPort,
    [Parameter(Mandatory=$True)][INT]$BackendPort,
    [Parameter(Mandatory=$True)][INT]$ProbePort
  
    )
    
$ErrorActionPreference = 'stop'

#Existing Load Balancer resource Id Sample format:
#$LBresourceId="/subscriptions/f77ff0fd-11af-4a46-b3ee-9f92c52bcbdb/resourceGroups/sam-test02/providers/Microsoft.Network/Loadbalancers/jhlb-pub"

$Loadbalancerconfig = get-azurermresource -resourceid $LBresourceId
$SubscriptionId= $Loadbalancerconfig.SubscriptionId
Select-AzureRmSubscription -SubscriptionId $SubscriptionId | Set-AzureRmContext
Get-AzureRmSubscription -SubscriptionId $SubscriptionId | Select-AzureRmSubscription
$AzureRmResourceGroupName=$Loadbalancerconfig.ResourceGroupName
$SubscriptionId=$Loadbalancerconfig.SubscriptionId

Get-AzureRmSubscription -SubscriptionId $SubscriptionId | Select-AzureRmSubscription
Select-AzureRmSubscription -SubscriptionId $SubscriptionId | Set-AzureRmContext

$Loadbalancer = Get-AzureRMLoadbalancer -Name $Loadbalancerconfig.Name -ResourceGroupName $AzureRmResourceGroupName
$LoadbalancerFrontEndName=(Get-AzureRmLoadbalancerFrontendIPConfig -Loadbalancer $Loadbalancer).Name
$BackendPools=Get-AzureRmLoadbalancerBackendAddressPoolConfig -Loadbalancer $Loadbalancer

#$BackendPoold is the defaul back end pool, it can be repace with another one if required

$BackendPoold="BackendPool1"
$FrontendIP =  Get-AzureRmLoadbalancerFrontendIPConfig -Name $LoadbalancerFrontEndName -Loadbalancer $Loadbalancer
$BackendPool = Get-AzureRmLoadbalancerBackendAddressPoolConfig -Name $BackendPoold -Loadbalancer $Loadbalancer

   # Add a new Probe configuration to the load balancer
    $Probe = new-AzureRmLoadbalancerProbeConfig -Name $ProbeName  -Protocol $Protocol -Port $ProbePort -IntervalInSeconds $IntervalInSeconds -ProbeCount 2
    $Loadbalancer | Add-AzureRmLoadbalancerProbeConfig  -Name $ProbeName -Protocol $Protocol -Port $ProbePort -IntervalInSeconds $IntervalInSeconds -ProbeCount 2 | Set-AzureRmLoadbalancer
    Set-AzureRmLoadbalancer -Loadbalancer $Loadbalancer

    # Add a new Rule configuration to the load balancer
    New-AzureRmLoadbalancerRuleConfig -Name $RuleName -FrontendIPConfiguration $Loadbalancer.FrontendIPConfigurations[0] -Protocol $Protocol -FrontendPort $FrontendPort -BackendPort $BackendPort -BackendAddressPool $BackendPool -Probe $Probe -EnableFloatingIP
    $Loadbalancer |Add-AzureRmLoadbalancerRuleConfig -Name $RuleName -FrontendIPConfiguration $Loadbalancer.FrontendIPConfigurations[0] -Protocol $Protocol -FrontendPort $FrontendPort -BackendPort $BackendPort  -BackendAddressPool $BackendPool -Probe $Probe -EnableFloatingIP
    $Loadbalancer |Set-AzureRmLoadbalancerRuleConfig -Name $RuleName -FrontendIPConfiguration $Loadbalancer.FrontendIPConfigurations[0] -Protocol $Protocol -FrontendPort $FrontendPort -BackendPort $BackendPort  -BackendAddressPool $BackendPool -Probe $Probe
    Set-AzureRmLoadbalancer -Loadbalancer $Loadbalancer
}


function LB_RemoveProbeandRule {

Param(
[Parameter(Mandatory=$True)][String]$LBresourceId,
[Parameter(Mandatory=$True)][String]$RuleName,
[Parameter(Mandatory=$True)][String]$ProbeName
)
$ErrorActionPreference = 'stop'
#Existing Load Balancer resource Id Sample format:
#$LBresourceId="/subscriptions/f77ff0fd-11af-4a46-b3ee-9f92c52bcbdb/resourceGroups/sam-test02/providers/Microsoft.Network/loadBalancers/jhlb-pub"
$loadbalancerconfig = get-azurermresource -resourceid $LBresourceId
$SubscriptionId= $loadbalancerconfig.SubscriptionId
Select-AzureRmSubscription -SubscriptionId $SubscriptionId | Set-AzureRmContext
Get-AzureRmSubscription -SubscriptionId $SubscriptionId | Select-AzureRmSubscription
$AzureRmResourceGroupName=$loadbalancerconfig.ResourceGroupName
$SubscriptionId=$loadbalancerconfig.SubscriptionId

Get-AzureRmSubscription -SubscriptionId $SubscriptionId | Select-AzureRmSubscription
Select-AzureRmSubscription -SubscriptionId $SubscriptionId | Set-AzureRmContext

$loadbalancer = Get-AzureRMLoadBalancer -Name $loadbalancerconfig.Name -ResourceGroupName $AzureRmResourceGroupName
$LoadBalancerFrontEndName=(Get-AzureRmLoadBalancerFrontendIpConfig -LoadBalancer $loadbalancer).Name
$BackendPools=Get-AzureRmLoadBalancerBackendAddressPoolConfig -LoadBalancer $loadbalancer

#$BackendPooldefault is the defaul back end pool, it can be repace with another one if required

$BackendPooldefault="BackendPool1"

# Load function to Remove Probe and Rule in memory
    Remove-AzureRmLoadBalancerProbeConfig -Name $ProbeName -LoadBalancer $loadbalancer
    Remove-AzureRmLoadBalancerRuleConfig -Name $RuleName -LoadBalancer $loadbalancer
    Set-AzureRmLoadBalancer -LoadBalancer $loadbalancer  
}