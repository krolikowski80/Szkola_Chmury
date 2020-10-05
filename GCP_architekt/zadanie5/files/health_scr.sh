sudo apt update && sudo apt -y install git gunicorn3 python3-pip
git clone https://github.com/GoogleCloudPlatform/python-docs-samples.git
cd python-docs-samples/compute/managed-instances/demo
sudo pip3 install -r requirements.txt
sudo gunicorn3 --bind 0.0.0.0:80 app:app --daemon
