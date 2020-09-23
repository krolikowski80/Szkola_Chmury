# [Canary Testing ](https://szkolachmury.pl/google-cloud-platform-droga-architekta/tydzien-5-instance-groups-i-autoskalowanie/canary-testing-hands-on/)

* [Canary updates](https://martinfowler.com/bliki/CanaryRelease.html)

```bash
#zmienne
template1="tk-template-1"
template2="tk-template-2"
nameGroup="grupa-instancji"
zoneGroup="us-central1-a"

# Utwórz szablon - template1
gcloud compute instance-templates create $template1 \
--image-family debian-9 \
--image-project debian-cloud \
--tags=http-server \
--machine-type=f1-micro \
--metadata=startup-script=\#\!/bin/bash$'\n'sudo\ apt-get\ update\ $'\n'sudo\ apt-get\ install\ -y\ nginx\ $'\n'sudo\ service\ nginx\ start\ $'\n'sudo\ sed\ -i\ --\ \"s/Welcome\ to\ nginx/Version:1\ -\ Welcome\ to\ \$HOSTNAME/g\"\ /var/www/html/index.nginx-debian.html

# Utwórz szablon - szablon2
gcloud compute instance-templates create $template2 \
--image-family debian-9 \
--image-project debian-cloud \
--tags=http-server \
--machine-type=f1-micro \
--metadata=startup-script=\#\!/bin/bash$'\n'sudo\ apt-get\ update\ $'\n'sudo\ apt-get\ install\ -y\ nginx\ $'\n'sudo\ service\ nginx\ start\ $'\n'sudo\ sed\ -i\ --\ \"s/Welcome\ to\ nginx/Version:2\ -\ Welcome\ to\ \$HOSTNAME/g\"\ /var/www/html/index.nginx-debian.html

#Utwórz zarządzaną grupę instancji
gcloud compute instance-groups managed create $nameGroup \
--base-instance-name=$nameGroup \
--template=$template1 \
--size=4 \
--zone $zoneGroup

#Utwórz canary update dla połowy instancji
gcloud compute instance-groups managed rolling-action start-update $nameGroup \
--version template=$template1 \
--canary-version template=$template2,target-size=50% \
--zone $zoneGroup

#Zaktualizuj resztę instancji za pomocą nowego szablonu
gcloud compute instance-groups managed rolling-action start-update $nameGroup \
--version template=$template2 \
--max-unavailable 100% \
--zone $zoneGroup
```