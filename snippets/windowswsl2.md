```bash
# Installeer Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
# Installeer func voor Ubuntu 18.04
# (andere versies: https://github.com/Azure/azure-functions-core-tools#linux)
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install azure-functions-core-tools-3
```
