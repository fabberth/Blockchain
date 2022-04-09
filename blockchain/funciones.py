from asyncio.windows_events import NULL
import json
UserName = "UserName.json"
Config = "Config.json"

def getAccount(userName):
    
    datos = ""

    try:

        with open(UserName,"r") as j:
            datos = json.load(j)

        for i in datos:
            if i['userName'] == userName:
                return i

    except Exception as err:

        return ""

def getKey(userName,address):

    account = getAccount(userName)
    account = account['accounts']

    if account != "" or account != NULL :
        for i in account:
            if i['address'] == address:
                return i['key']

    return ""

def getConfig():

    datos = ""
    with open(Config,"r") as j:
            datos = json.load(j)

    return datos
    