# File for Grafana Installation



sudo apt-get update

sudo apt-get install -y apt-transport-https software-properties-common

wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -

echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list

sudo apt-get update

sudo apt-get -y install grafana

sudo systemctl enable grafana-server

sudo systemctl start grafana-server

sudo systemctl status grafana-server




--- new 2026

# Update system
sudo apt-get update

# Install prerequisites
sudo apt-get install -y apt-transport-https software-properties-common

# Add Grafana GPG key (apt-key is deprecated, use gpg instead)
wget -q -O - https://packages.grafana.com/gpg.key | \
  sudo gpg --dearmor -o /usr/share/keyrings/grafana.gpg

# Add Grafana repository
echo "deb [signed-by=/usr/share/keyrings/grafana.gpg] https://packages.grafana.com/oss/deb stable main" | \
  sudo tee /etc/apt/sources.list.d/grafana.list

# Update and install Grafana
sudo apt-get update
sudo apt-get -y install grafana

# Enable and start Grafana service
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
sudo systemctl status grafana-server


