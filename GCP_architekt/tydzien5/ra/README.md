# [Rolling Updates](https://szkolachmury.pl/google-cloud-platform-droga-architekta/tydzien-5-instance-groups-i-autoskalowanie/rolling-updates-hands-on/)

* [nstance Groups Rolling updates](https://cloud.google.com/compute/docs/instance-groups/rolling-out-updates-to-managed-instance-groups)

```bash
#zmienne
template1="tk-template-1"
template2="tk-template-2"
nameGroup="grupa-instancji"
zoneGroup="us-central1-a"

#Utwórz szablon - template1
gcloud compute instance-templates create $template1 \
--image-family debian-9 \
--image-project debian-cloud \
--machine-type=f1-micro

#Utwórz zarządzaną grupę instancji
gcloud compute instance-groups managed create $nameGroup \
--base-instance-name=$nameGroup \
--template=$template1 \
--size=3 \
--zone=$zoneGroup

#Utwórz szablon - szablon2
gcloud compute instance-templates create $template2 \
--image-family debian-10 \
--image-project debian-cloud \
--machine-type=f1-micro

#Zaktualizuj grupę instancji przy użyciu szablonu 2
gcloud compute instance-groups managed rolling-action start-update $nameGroup \
--version template=$template2 \
--max-unavailable 2 \
--zone $zoneGroup

#Usuwanie zasobów
gcloud compute instance-groups managed delete $nameGroup \
--zone=$zoneGroup

gcloud compute instance-templates delete $template1

gcloud compute instance-templates delete $template2
```