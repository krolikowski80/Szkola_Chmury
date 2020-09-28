# [Managed Instance Groups](https://szkolachmury.pl/google-cloud-platform-droga-architekta/tydzien-5-instance-groups-i-autoskalowanie/managed-instance-groups-deep-dive/)

# [Regional and Zonal Managed Instance Groups](https://szkolachmury.pl/google-cloud-platform-droga-architekta/tydzien-5-instance-groups-i-autoskalowanie/regional-and-zonal-managed-instance-groups-hands-on/)

* [Instance Groups concepts](https://cloud.google.com/compute/docs/instance-groups/)

* [Creating Instance Groups](https://cloud.google.com/compute/docs/instance-groups/creating-groups-of-managed-instances)

```bash
# Utwórz szablon za pomocą polecenia
gcloud compute instance-templates create example-template

# Tworzy regionalną zarządzaną grupę VM w trzech strefach w regionie us-east1
gcloud compute instance-groups managed create example-rmig \
--template example-template \
--base-instance-name example-instances \
--size 30 \
--region us-east1

# Jeśli chcesz wybrać określone strefy, których ma używać grupa, podaj flagę --zones
gcloud compute instance-groups managed create example-rmig \
--template example-template \
--base-instance-name example-instances \
--size 30 \
--zones us-east1-b,us-east1-c

# Bez zrównoważonej dystrybucji
gcloud beta compute instance-groups managed create example-rmig \
--template example-template \
--base-instance-name example-instances \
--size 30 \
--instance-redistribution-type NONE
```