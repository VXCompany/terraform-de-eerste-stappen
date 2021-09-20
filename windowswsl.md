```bash
# installeer unzip
sudo apt-get install unzip
# check voor de laatste versie van Terraform hier: https://www.terraform.io/downloads.html
wget https://releases.hashicorp.com/terraform/0.12.26/terraform_0.12.26_linux_amd64.zip
# pak de zip uit
unzip terraform_0.12.18_linux_amd64.zip
# stop de binary in je bin folder
sudo mv terraform /usr/local/bin/
# werkt het?
terraform --version
# Werk directory voor de tutorial
mkdir ~/Documents/terraform_intro
cd ~/Documents/terraform_intro
```
