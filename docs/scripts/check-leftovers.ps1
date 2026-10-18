<#
.SYNOPSIS
  Post-destroy check: counts billable ShopFast resources left in the AWS account.

.DESCRIPTION
  Run after `terraform destroy`. Every line should print 0.
  Expected exceptions:
    secrets        may show 1 for a few days (deleted secrets wait in a recovery window)
    OIDC providers may show 1 if the account already had a GitHub OIDC provider before ShopFast
  Prints counts only: no account ID, no secrets.

.EXAMPLE
  .\scripts\check-leftovers.ps1
  .\scripts\check-leftovers.ps1 -Profile default
#>
param(
  [string]$Profile = "tf-dev",
  [string]$Region  = "us-east-1"
)

$o = "--region",$Region,"--profile",$Profile,"--output","text"
function c($n,$a){ "{0,-24}{1}" -f $n, (& aws @a @o) }

c "load balancers"   @("elbv2","describe-load-balancers","--query","length(LoadBalancers)")
c "target groups"    @("elbv2","describe-target-groups","--query","length(TargetGroups)")
c "RDS instances"    @("rds","describe-db-instances","--query","length(DBInstances)")
c "RDS manual snaps" @("rds","describe-db-snapshots","--snapshot-type","manual","--query","length(DBSnapshots)")
c "ECS clusters"     @("ecs","list-clusters","--query","length(clusterArns)")
c "VPC endpoints"    @("ec2","describe-vpc-endpoints","--filters","Name=vpc-endpoint-state,Values=pending,pendingAcceptance,available","--query","length(VpcEndpoints)")
c "NAT gateways"     @("ec2","describe-nat-gateways","--filter","Name=state,Values=pending,available","--query","length(NatGateways)")
c "Elastic IPs"      @("ec2","describe-addresses","--query","length(Addresses)")
c "ShopFast VPC"     @("ec2","describe-vpcs","--filters","Name=cidr,Values=10.0.0.0/16","--query","length(Vpcs)")
c "security groups"  @("ec2","describe-security-groups","--filters","Name=group-name,Values=shopfast-*","--query","length(SecurityGroups)")
c "ECR repos"        @("ecr","describe-repositories","--query","length(repositories)")
c "log groups"       @("logs","describe-log-groups","--log-group-name-prefix","/ecs/shopfast","--query","length(logGroups)")
c "alarms"           @("cloudwatch","describe-alarms","--alarm-name-prefix","shopfast","--query","length(MetricAlarms)")
c "SNS topics"       @("sns","list-topics","--query","length(Topics[?contains(TopicArn,'shopfast')])")
c "IAM roles"        @("iam","list-roles","--query","length(Roles[?starts_with(RoleName,'shopfast')])")
c "OIDC providers"   @("iam","list-open-id-connect-providers","--query","length(OpenIDConnectProviderList)")
c "secrets"          @("secretsmanager","list-secrets","--include-planned-deletion","--filters","Key=name,Values=shopfast","--query","length(SecretList)")
