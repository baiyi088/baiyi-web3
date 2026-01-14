Cast - Wallet

### 生成keystore
生成密钥到本地，带密码的一个钱包到本地。是加密的，不直接面向密钥，而是面向一个密码。
```
cast wallet -h # 查看所有的命令选项

cast wallet new [DIR] <ACCOUNT_NAME> # Create a new random keypair

cast wallet new-mnemonic # mnemonic phrase

cast wallet address [PRIVATE_KEY] # private key to an address

cast wallet import -i -k <KEYSTORE_DIR> <ACCOUNT_NAME>

cast wallet import --mnemonic "hedgehog unaware measure eight laptop skate member lion empower display marine dumb" -k ./keystores wallet9

test junk” -k <KEYSTORE_DIR> <ACCOUNT_NAME>

```

密钥默认存储在 `~/.foundry/keystores` 目录下


wallet1:
0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266


### 给没有余额的钱包转账或查看余额

查看 eth 余额：
cast balance 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266

转账：
cast send toAddr --value 1ether --private-key <private-key>

查看 erc20 余额 cast call
cast call 0x5FbDB2315678afecb367f032d93F642f64180aa3 “number()”

参数编码：
cast abi-encode "constructor(string,string)" "OpenSpace S6" “OS6”

更多： https://book.getfoundry.sh/reference/cast/


