***Notes: Terraform***

Network settings that we added:

- We created a rt-brainbank-ne-prod-002:

  1) Name -> udr-internet , Address Prefix -> 0.0.0.0/0, Next Hop Type -> Internet
  2) Name -> udr-intranet , Address Prefix -> 10.227..0.0/16, Next Hop Type -> Virtual appliance , Next hop Ip Address -> 10.227.34.4

  - We add to the nsg-brainbank-ne-prod-001 the following rules:
    1) Name -> AllowAnyCustom65200-65535Inbound , Source -> Service Tag , Source Service Tag -> Gateway Manager , Destination -> Any , Destination Port Range -> 65200-65535 , Action -> Allow

*
