# [Uruchamianie skryptów startowych](https://cloud.google.com/compute/docs/startupscript)

```bash
#Skrypt w pliku
gcloud compute instances create instance2  \
--metadata-from-file startup-script=my_repos/admin_scripts/docker.sh

#Skrypt w linii poleceń
gcloud compute instances create example-instance --tags http-server \
  --metadata startup-script='#! /bin/bash
# Installs apache and a custom homepage
  sudo su -
  apt update
  apt -y install apache2
  cat <<EOF > /var/www/html/index.html
  <html><body><h1>Hello World</h1>
  <p>This page was created from a start up script.</p>
  </body></html>
  EOF'
  ```