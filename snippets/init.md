```bash
# Aanmaken folder
mkdir -p function_app/
mkdir -p tf_config/
cd function_app/
# Initialiseren functie Hello World obv een HTTP Trigger
func init --worker-runtime typescript
func new --language typescript --template "HTTP trigger" -n "hello_world_http"
cd ..
npm install
# Initialiseer de file waarin je de Terraform Configuratie wilt plakken
cd tf_config/
touch main.tf
```
