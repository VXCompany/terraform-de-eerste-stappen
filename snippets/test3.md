```bash
curl "$(func azure functionapp list-functions terraformfunc --show-keys | grep url | cut -f 11 -d " ")&name=World"
```
