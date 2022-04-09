import json
from zeep import Client
import xmltodict
import callContract
import funciones

def soap ():

    config = funciones.getConfig()

    Wsdl = 'http://cbox.adapting.com/intranet/document-api.svc?wsdl'

    client = Client (Wsdl)

    server = client.service.IniciaSesion('partner','Pti12ada','{Create}','false')

    eventos = client.service.GetEventLog(server['exitvalue'],config["DateFrom"],config["DateTo"])

    try:
        xml = xmltodict.parse(eventos['exitvalue'])

        eventJson = json.dumps(xml)

        jsonFinal = json.loads(eventJson)

        eventslog = jsonFinal['eventLog']['events']['event']

        datos = funciones.getAccount("partner")["accounts"]
        cuenta = datos[0]["address"]
        key = datos[0]["key"]

        for i in eventslog:

            Id = i['id']

            userName = i['userName']

            action = i['action']
            if not action:

                action = "vacio"

            date = i['date']

            ip = i['IP']

            target = i['target']
            if not target:

                target = "vacio"

            targetName = i['targetName']
            if not targetName:

                targetName = "vacio"
                
            TargetId = i['TargetId']
            module = i['module']
            try:
                module = module +" ,,, "+i['description']
            except Exception as er :
                module = module+" ,,, "+"vacio"
            try:
                module = module+" ,,, "+i['parameters']
            except Exception as er :
                module = module+" ,,, "+"vacio"

            #print(Id,userName,".\n")
            x = callContract.saveEventoContract(cuenta,key,Id,userName,action,date,ip,target,targetName,TargetId,module)
            print(x)
            #description = eventslog[n]['description']
            #parameters = eventslog[n]['parameters']

    except Exception as e :
        print(eventos['exitvalue'])      

soap()





def searchEventById():
    cuenta = "0xB6C9850db1C92442d0523974DeecDA26f156B664"
    key = "39f55c54f2265b48cd8ff1240076f30ece5451923f5a8179b427527d7b564856"
    iD = "cd30885f-97f4-47c6-a62c-adfa00979b5c"
    result = callContract.busquedaId(cuenta,key,iD)
    print(result)

#searchEventById()



def searchEventByName():
    cuenta = "0xC2d9cd9D8f0bDBB95eF2dAE11fEF8e4dfcc75b4F"
    key = "5933bc694242a34b45d046027ce9f95ad29c6f52691cd76a47ede78a5e1b973b"
    userName = "Web Service"
    result = callContract.busquedaUserName(cuenta,key,userName)
    print(result)

#searchEventByName()




