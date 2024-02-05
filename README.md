# クロスアカウントパイプラインのソースコードサンプル

## 実行時
- prd環境のデプロイ時には，
```bash
terraform apply -auto-approve -var 'dev_account_id=<dev環境のアカウントのID>' -var 'prd_account_id=<prd環境のアカウントのID>'
```
で実行すること．

## ファイル構成
- environments
    - dev
    - devonly
    - prd
    - prdonly
        - dev
        - prd
- modules

## 参考
- [クロスアカウントでのCodePipelineメモ](https://github.com/VXdora/CheatSheet/blob/main/AWS/CI-CD/CodePipelineForCrossAccount.md)
- [Terraformによる複数アカウントへの同時apply](https://github.com/VXdora/CheatSheet/blob/main/terraform/ApplyForMultipleAccount.md)