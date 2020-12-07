# [Understanding VPC Networks](https://szkolachmury.pl/google-cloud-platform-droga-architekta/tydzien-9-understanding-vpc-networks/understanding-vpc-networks-deep-dive/)

## [Using firewall rules.](https://cloud.google.com/vpc/docs/using-firewalls)

## [Using VPC routes.](https://cloud.google.com/vpc/docs/using-routes)

## [Shared VPC.](https://cloud.google.com/vpc/docs/shared-vpc)

## [Network Peering.](https://cloud.google.com/vpc/docs/vpc-peering)

## [Using VPC Flow logs](https://cloud.google.com/vpc/docs/using-flow-logs)

## [How to use firewall rules logging.](https://cloud.google.com/blog/products/identity-security/google-cloud-firewall-rules-logging-how-and-why-you-should-use-it)

### Peering pomiędy dwiema sieciami lokalnymi
```bash
#Tworzę sieci z customowym subnetem
gcloud compute networks create vpcnetwork1 \
--subnet-mode=custom

gcloud compute networks create vpcnetwork2 \
--subnet-mode=custom

#Tworzę podsieci (subnety)
gcloud compute networks subnets create vpcnetwork1-ew1 \
--network=vpcnetwork1 \
--region=europe-west1 \
--range=10.128.0.0/20

gcloud compute networks subnets create vpcnetwork2-ew1 \
--network=vpcnetwork2 \
--region=europe-west1 \
--range=172.16.0.0/20

#Reguły firewallowe - komunikacja pomiędzuy VM w podsieciach
gcloud compute firewall-rules create vpcnetwork1-alow-icmp \
--direction=INGRESS \
--priority=65534 \
--network=vpcnetwork1 \
--action=ALLOW \
--rules=icmp \
--source-ranges=0.0.0.0/0

gcloud compute firewall-rules create vpcnetwork2-alow-icmp \
--direction=INGRESS \
--priority=65534 \
--network=vpcnetwork2 \
--action=ALLOW \
--rules=icmp \
--source-ranges=0.0.0.0/0

#Reguły firewallowe - dostęp przez ssh
gcloud compute firewall-rules create vpcnetwork1-alow-ssh \
--direction=INGRESS \
--priority=65534 \
--network=vpcnetwork1 \
--action=ALLOW \
--rules=tcp:22 \
--source-ranges=0.0.0.0/0
```