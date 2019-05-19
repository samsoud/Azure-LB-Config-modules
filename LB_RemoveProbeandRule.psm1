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