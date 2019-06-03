$ErrorActionPreference = 'stop'
#Existing Load Balancer resource Id Sample format:
#$LbResourceId="/subscriptions/subscriptionsid/resourceGroups/sam-test02/providers/Microsoft.Network/Loadbalancers/jhlb-pub"
$SubscriptionID="81a9ea66-6119-4aa3-8322-fd4abfd5faae"
$ResourceGroupName="jenkins"
$Location="Central US"
$virtualNetworkName= "Vnet02"
$AddressPrefix1= "10.0.2.0/24"
$backendSubnetPrefix1="10.0.0.0/16"
$PrivateIpAddress = "10.0.2.5"
$LBFrontend="LB-Frontend"
$LBBackend="LB-backend"
$LBName="lb03"
$backEndPoolConfig1= "backEndPoolConfig02"
$LBSubnet="LB-Subnet-BEo"


$Subscription = Get-AzureRmSubscription -SubscriptionID $SubscriptionID | Select-AzureRmSubscription
Select-AzureRmSubscription -SubscriptionID $SubscriptionID | Set-AzureRmContext

$BackEndAddressPool=  New-AzurermLoadBalancerBackendAddressPoolConfig -Name $LBBackend 
# $BackEndAddressPool=  Get-AzurermLoadBalancerBackendAddressPoolConfig -Name $LBBackend -LoadBalancer $lb

$backendSubnet = New-AzurermVirtualNetworkSubnetConfig -Name $LBSubnet -AddressPrefix $AddressPrefix1
#$backendSubnet = Get-AzureRmVirtualNetworkSubnetConfig -Name $LBSubnet -VirtualNetwork $virtualNetworkName
$virtualNetwork= New-AzurermVirtualNetwork -Name $virtualNetworkName -ResourceGroupName $ResourceGroupName -Location $Location -AddressPrefix $backendSubnetPrefix1 -Subnet $backendSubnet -Force
$virtualNetwork =get-AzurermVirtualNetwork -Name $virtualNetworkName -ResourceGroupName $ResourceGroupName
$InBoundNATRule1= New-AzurermLoadBalancerInboundNatRuleConfig -Name "RDP1" -FrontendIpConfiguration $frontendIP -Protocol TCP -FrontendPort 3441 -BackendPort 3389
$InBoundNATRule2= New-AzurermLoadBalancerInboundNatRuleConfig -Name "RDP2" -FrontendIpConfiguration $frontendIP -Protocol TCP -FrontendPort 3442 -BackendPort 3389

$HealthProbe = New-AzurermLoadBalancerProbeConfig -Name "HealthProbe" -RequestPath "HealthProbe.aspx" -Protocol http -Port 80 -IntervalInSeconds 15 -ProbeCount 2
$LbRule = New-AzurermLoadBalancerRuleConfig -Name "HTTP" -FrontendIpConfiguration $frontendIP -BackendAddressPool $beAddressPool -Probe $healthProbe -Protocol Tcp -FrontendPort 80 -BackendPort 80
$Lb = New-AzurermLoadBalancer -ResourceGroupName $ResourceGroupName -Name $LBName -Location $Location -FrontendIpConfiguration $frontendIP -InboundNatRule $inboundNATRule1,$inboundNatRule2 -LoadBalancingRule $lbrule -BackendAddressPool $beAddressPool -Probe $healthProbe
$Lb = Get-AzurermLoadBalancer -ResourceGroupName $ResourceGroupName -Name $LBName
$LbResourceId=$Lb.Id
$Lbconfig = Get-azurermresource -resourceid $LbResourceId
$frontendIP = New-AzurermLoadBalancerFrontendIpConfig -Name $LBFrontend -PrivateIpAddress $PrivateIpAddress -SubnetId $virtualNetwork.subnets[0].Id


Get-AzureRmLoadBalancerProbeConfig
########################################################################################################

$ResourceGroupName="jenkins"
$SubscriptionID="81a9ea66-6119-4aa3-8322-fd4abfd5faae"
$ResourceGroupName="jenkins"
$LBName="lb03"
$LBBackend="LB-backend"
$LbResourceId= (Get-AzurermLoadBalancer -ResourceGroupName $ResourceGroupName -Name $LBName).Id
Select-AzureRmSubscription -SubscriptionId $SubscriptionId | Set-AzureRmContext
Get-AzureRmSubscription -SubscriptionId $SubscriptionId | Select-AzureRmSubscription
$Lbconfig = get-azurermresource -resourceid $LbResourceId
$Lb = Get-AzureRMLoadbalancer -Name $LBName -ResourceGroupName $ResourceGroupName


$LbFrontEndName=(Get-AzureRmLoadbalancerFrontendIPConfig -Loadbalancer $Lb).Name
$FrontendIP =   Get-AzureRmLoadbalancerFrontendIPConfig -Name $LbFrontEndName -Loadbalancer $Lb


New-AzureRmLoadBalancerBackendAddressPoolConfig -Name "BackendAddressPool02"
Get-AzureRmLoadBalancerBackendAddressPoolConfig -Name "BackendAddressPool02" -LoadBalancer $Lb


####
$BackendAddressPoolConfig=  New-AzureRmLoadBalancerBackendAddressPoolConfig -Name "BackendAddressPool02" -loadbalancer $Lb
$BackendAddressPoolConfig=  New-AzureRmLoadBalancerBackendAddressPoolConfig -name "test3"
$BackendAddressPoolConfig=  Get-AzureRmLoadBalancerBackendAddressPoolConfig -loadbalancer $Lb
                          
#$BackendPools=  Get-AzureRmLoadbalancerBackendIPConfig -Loadbalancer $Lb
foreach($BackendPool in $BackendPools)
{
echo ($BackendPool.Name)
$BackendPool = Get-AzureRmLoadbalancerBackendAddressPoolConfig -Name $LBBackend -Loadbalancer $Lb


}



Get-AzureRmLoadBalancerBackendAddressPoolConfig -Name  $bkend -LoadBalancer $Lb


function LB_AddProbeAndRule {

Param(

    [Parameter(Mandatory=$True)][String]$LbResourceId,
    [Parameter(Mandatory=$True)][String]$RuleName,
    [Parameter(Mandatory=$True)][String]$ProbeName,
    [Parameter(Mandatory=$True)][String]$Protocol,
    [Parameter()][String]$LbFrontEndName="LoadbalancerFrontEnd", # default
    [Parameter()][String]$BackendPoold= "BackendPool1", # default
    [Parameter(Mandatory=$True)][INT]$IntervalInSeconds,
    [Parameter(Mandatory=$True)][INT]$FrontendPort,
    [Parameter(Mandatory=$True)][INT]$BackendPort,
    [Parameter(Mandatory=$True)][INT]$ProbePort
  
    )

   # Add a new Probe configuration to the load balancer
    $Probe = new-AzureRmLoadbalancerProbeConfig -Name $ProbeName  -Protocol $Protocol -Port $ProbePort -IntervalInSeconds $IntervalInSeconds -ProbeCount 2
    $Lb | Add-AzureRmLoadbalancerProbeConfig  -Name $ProbeName -Protocol $Protocol -Port $ProbePort -IntervalInSeconds $IntervalInSeconds -ProbeCount 2 | Set-AzureRmLoadbalancer
    Set-AzureRmLoadbalancer -Loadbalancer $Lb

    # Add a new Rule configuration to the load balancer
    New-AzureRmLoadbalancerRuleConfig -Name $RuleName -FrontendIPConfiguration $Lb.FrontendIPConfigurations[0] -Protocol $Protocol -FrontendPort $FrontendPort -BackendPort $BackendPort -BackendAddressPool $BackendPool -Probe $Probe -EnableFloatingIP
    $Lb |Add-AzureRmLoadbalancerRuleConfig -Name $RuleName -FrontendIPConfiguration $Lb.FrontendIPConfigurations[0] -Protocol $Protocol -FrontendPort $FrontendPort -BackendPort $BackendPort  -BackendAddressPool $BackendPool -Probe $Probe -EnableFloatingIP
    $Lb |Set-AzureRmLoadbalancerRuleConfig -Name $RuleName -FrontendIPConfiguration $Lb.FrontendIPConfigurations[0] -Protocol $Protocol -FrontendPort $FrontendPort -BackendPort $BackendPort  -BackendAddressPool $BackendPool -Probe $Probe
    Set-AzureRmLoadbalancer -Loadbalancer $Lb
}
