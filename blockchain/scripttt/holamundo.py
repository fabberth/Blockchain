from web3 import Web3
import json
f = open(r'C:\Users\adapting\Desktop\python\probando.txt','w')
f.write('hola mundo FABBERTH JUNIOR')
f.close()

j = open(r'C:\\Users\\adapting\\Desktop\\python\\REGISTRO.json', "r")
#print(j)
with open("REGISTRO.json","r") as d:
    mydata=json.load(d)
    #print(type(mydata))







"""
web3 = Web3(Web3.HTTPProvider('HTTP://127.0.0.1:7545'))

account_1 = web3.eth.accounts[2]
privateKey = "949e70995a9ac936be6706faffb075338a9f57838e29a9a70c52ac704a11311d"

account_2 = "0x9483116c23C1372333f36E274ff68169001e2174"

nonce = web3.eth.getTransactionCount(account_1)
print(account_1)
tx = {
    'nonce':nonce,
    'to': account_2,
    'value': web3.toWei(0.005,'ether'),
    'gas': 21000,
    'gasPrice': web3.toWei('50', 'gwei')
}

signed_tx = web3.eth.account.signTransaction(tx, privateKey)
tx_hash = web3.eth.sendRawTransaction(signed_tx.rawTransaction)
print(web3.eth.get_balance(account_2))"""

