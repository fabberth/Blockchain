
var url = window.location.origin;

window.onload = function loadAccount()
{
    var user = document.getElementById("UserName").innerText;
    const options = {
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
            },
            method: "POST",
            body: JSON.stringify({
                userName: user
            })
    };

    fetch(url+'/getAccount',options)
    .then(async msg => 
    {   
        try
        {
            var json = await msg.json()
            var array = json.accounts;
            if(json.error=="")
            {
                for(var i=0;i<array.length;i++){ 
                    document.getElementById("selectAccount").innerHTML += "<option value='"+array[i].address+"'>"+array[i].address+"</option>";
                }
            }
            else
            {
                document.getElementById("UserName").style.display = "none";
                alert(json.error)
            }

        }
        catch(err)
        {
            console.log(err)
        }
        

    })
    .catch(e =>
    {
        alert(e)
    })

}


function ActiveAccon()
{

    var account = document.getElementById('selectAccount').value;
    var addressActiveAccount = document.getElementById('addressActiveAccount').value;
    //console.log(searchUserName)

    const options = {
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
            },
            method: "POST",
            body: JSON.stringify({
                account: account,
                addressActiveAccount: addressActiveAccount
            })
    };

    fetch(url+'/searchName',options)
}



function SearchName()
{
    var account = document.getElementById('selectAccount').value;
    var searchUserName = document.getElementById('searchUserName').value;
    var user = document.getElementById("UserName").innerText;
    //console.log(searchUserName)

    const options = {
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
            },
            method: "POST",
            body: JSON.stringify({
                userName: user,
                account: account,
                searchUserName: searchUserName                
            })
    };

    fetch(url+'/searchName',options)
    .then(async msg => 
    {
        var json = await msg.json()
        var y = json.result

        if (y[0].exito == 'true')
        {
            try
            {
                if(y[0].mensaje != "")
                {
                    var x = (y[0].mensaje).split('%')
                    var tabla = document.getElementById('tbodyTable');
                    document.getElementById('alert').style.display = 'none';
                    document.getElementById('tbodyTable').innerHTML = "";

                    for (var i = 0; i < x.length; i++)
                    {
                        var hilera = document.createElement("tr");
                        var datos = x[i].split(',,,')
                        var nume = document.createElement("td");
                        nume.appendChild(document.createTextNode(i+1));
                        hilera.appendChild(nume);

                        var Owen = document.createElement("td");
                        Owen.appendChild(document.createTextNode(""));
                        hilera.appendChild(Owen);

                        var id = document.createElement("td");
                        id.appendChild(document.createTextNode(datos[0]));
                        hilera.appendChild(id);

                        var userName = document.createElement("td");
                        userName.appendChild(document.createTextNode(datos[1]));
                        hilera.appendChild(userName);

                        var action = document.createElement("td");
                        action.appendChild(document.createTextNode(datos[2]));
                        hilera.appendChild(action);

                        var date = document.createElement("td");
                        date.appendChild(document.createTextNode(datos[3]));
                        hilera.appendChild(date);

                        var ip = document.createElement("td");
                        ip.appendChild(document.createTextNode(datos[4]));
                        hilera.appendChild(ip);

                        var target = document.createElement("td");
                        target.appendChild(document.createTextNode(datos[5]));
                        hilera.appendChild(target);

                        var targetName = document.createElement("td");
                        targetName.appendChild(document.createTextNode(datos[6]));
                        hilera.appendChild(targetName);

                        var TargetId = document.createElement("td");
                        TargetId.appendChild(document.createTextNode(datos[7]));
                        hilera.appendChild(TargetId);

                        var modulee	= document.createElement("td");
                        modulee.appendChild(document.createTextNode(datos[8]));
                        hilera.appendChild(modulee);

                        var description = document.createElement("td");
                        description.appendChild(document.createTextNode(datos[9]));
                        hilera.appendChild(description);

                        var parameters = document.createElement("td");
                        parameters.appendChild(document.createTextNode(datos[10]));
                        hilera.appendChild(parameters);

                        tabla.appendChild(hilera);
                        
                    }
                }
                else
                {
                    //alert('No se encontro resultado')
                    document.getElementById('alert').style.display = 'block';
                    document.getElementById('msgError').innerHTML = "No se entontro eventos";
                    document.getElementById('tbodyTable').innerHTML = "";
                    //window.alert('No se encontro resultado')
                }
            }
            catch(error)
            {
                document.getElementById('alert').style.display = 'block';
                document.getElementById('tbodyTable').innerHTML = "";
                //alert(y[0].mensaje)
            }
        }
        else
        {
            document.getElementById('alert').style.display = 'block';
            document.getElementById('tbodyTable').innerHTML = "";
            document.getElementById('msgError').innerHTML = y[0].mensaje;
            //alert(y[0].mensaje)
        }
    
    })
    .catch(error =>
    {
        console.log(error);
    })
}


function SearchId()
{
    var account = document.getElementById('selectAccount').value;
    var searchId = document.getElementById('searchId').value;
	var user = document.getElementById("UserName").innerText;

    const options = {
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
            },
            method: "POST",
            body: JSON.stringify({
                userName: user,
				account: account,
                id: searchId
            })
    };

    fetch(url+'/searchId',options)
    .then(async msg => 
    {
        var json = await msg.json()
        var y = json.result

        if (y[0].exito == 'true')
        {
            try
            {
                if(y[0].mensaje != "")
                {
                    document.getElementById('alert').style.display = 'none';
                    var tabla = document.getElementById('tbodyTable');
                    document.getElementById('tbodyTable').innerHTML = "";


                        var hilera = document.createElement("tr");
                        var nume = document.createElement("td");
                        nume.appendChild(document.createTextNode(1));
                        hilera.appendChild(nume);

                        var Owen = document.createElement("td");
                        Owen.appendChild(document.createTextNode(y[0].mensaje[0]));
                        hilera.appendChild(Owen);

                        var id = document.createElement("td");
                        id.appendChild(document.createTextNode(y[0].mensaje[1]));
                        hilera.appendChild(id);

                        var userName = document.createElement("td");
                        userName.appendChild(document.createTextNode(y[0].mensaje[2]));
                        hilera.appendChild(userName);

                        var action = document.createElement("td");
                        action.appendChild(document.createTextNode(y[0].mensaje[3]));
                        hilera.appendChild(action);

                        var date = document.createElement("td");
                        date.appendChild(document.createTextNode(y[0].mensaje[4]));
                        hilera.appendChild(date);

                        var ip = document.createElement("td");
                        ip.appendChild(document.createTextNode(y[0].mensaje[5]));
                        hilera.appendChild(ip);

                        var target = document.createElement("td");
                        target.appendChild(document.createTextNode(y[0].mensaje[6]));
                        hilera.appendChild(target);

                        var targetName = document.createElement("td");
                        targetName.appendChild(document.createTextNode(y[0].mensaje[7]));
                        hilera.appendChild(targetName);

                        var TargetId = document.createElement("td");
                        TargetId.appendChild(document.createTextNode(y[0].mensaje[8]));
                        hilera.appendChild(TargetId);

                        var spli = (y[0].mensaje[9]).split(',,,')

                        var modulee	= document.createElement("td");
                        modulee.appendChild(document.createTextNode(spli[0]));
                        hilera.appendChild(modulee);

                        var description = document.createElement("td");
                        description.appendChild(document.createTextNode(spli[1]));
                        hilera.appendChild(description);

                        var parameters = document.createElement("td");
                        parameters.appendChild(document.createTextNode(spli[2]));
                        hilera.appendChild(parameters);

                        tabla.appendChild(hilera);
                        
                    
                }
                else
                {
                    alert('No se encontro resultado')
                }
            }
            catch(error)
            {
                document.getElementById('alert').style.display = 'block';
                document.getElementById('tbodyTable').innerHTML = "";
            }
        }
        else
        {
            document.getElementById('alert').style.display = 'block';
            document.getElementById('tbodyTable').innerHTML = "";
            document.getElementById('msgError').innerHTML = y[0].mensaje;
        }
    })
    .catch(errr =>
    {
        console.log(errr)
    })
}
