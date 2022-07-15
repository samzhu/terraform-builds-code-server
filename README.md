# terraform-builds-code-server

提供開發者 網頁版 VSCode 進行開發

## Deployment

``` bash
terraform init

terraform plan

terraform apply --auto-approve
```

## Access IDE after deployment

Generate coder.md after deployment.  
  
Content example  

``` md
# Code server

開啟下列網址  
http://34.81.247.227/?tkn=xofmf6VV

預設已安裝好  
JDK 17、Docker、Docker-compose
```

## Clean

``` bash
terraform destroy --auto-approve
```

## Reference

[OpenVSCode Server](https://github.com/gitpod-io/openvscode-server)
