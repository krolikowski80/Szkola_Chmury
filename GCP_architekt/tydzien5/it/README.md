# [Instance Templates](https://szkolachmury.pl/google-cloud-platform-droga-architekta/tydzien-5-instance-groups-i-autoskalowanie/instance-templates-hands-on/)

* [Deterministic instance templates](https://cloud.google.com/compute/docs/instance-templates/deterministic-instance-templates)

```bash
#Create template - template1
gcloud compute instance-templates create template1 \
--image-family debian-9 \
--image-project debian-cloud \
--machine-type=f1-micro

# Resize autoscaler
gcloud compute instance-groups managed set-autoscaling <GROUP_NAME> \
--min-num-replicas 5 \
--max-num-replicas 10 --zone <ZONE>
```