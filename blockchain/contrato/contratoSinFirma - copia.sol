// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;
contract EventsLog 
{
    address private owner;

    constructor()
    {
        owner = msg.sender;
        activeAccounts[owner]= true;
    }

    modifier onlyOwner
    {
        require(msg.sender == owner);
        _;
    }


    /*-------------------------------------------------------------------------------------------------------------------------

                                          FUNCIONES PARA LAS CUENTAS

    --------------------------------------------------------------------------------------------------------------------------*/

    mapping(address => bool) private activeAccounts;
    mapping(address => mapping(uint256 => bool)) usedNonces;

    function stateAccount(address addr)public view returns(bool)
    {
        return activeAccounts[addr];
    }


    function activateAccount(address addr) public onlyOwner
    {
        activeAccounts[addr]= true;
    }


    function deactivateAccount(address addr) public onlyOwner
    {
        activeAccounts[addr]= false;
    }



    /*-------------------------------------------------------------------------------------------------------------------------

                                          FUNCIONES PARA LOS EVENTOS

    --------------------------------------------------------------------------------------------------------------------------*/

    struct permission
    {
        bool read;
        bool update;
        bool del;
    }

    struct register
    {
        string idRegister;
        string userName;
        string action;
        string date;
        string ip;
        string target;
        string targetName;
        string TargetId;
        string module;
        string description;
        string parameters;
        address owner;
        mapping(address => bool) activeAcl;
        mapping(address => permission) acl;
    }

    mapping (uint256 => register) private registers;
    mapping (uint256 => bool) private activeRegisters;

    struct Map {
        uint256[] keys;
        mapping(uint256 => uint) indexOf;
        mapping(uint256 => bool) inserted;
    }
    mapping (uint256 => Map) private names;
    mapping (address => Map) private regPerAccount;

    function saveEvent(string memory idRegister, string memory userName, string memory action, string memory date, string memory ip, string memory target, string memory targetName,
                        string memory TargetId, string memory module, string memory description, string memory parameters) public returns(string memory)
    {
        require(activeAccounts[msg.sender],"Esta cuenta no tiene permiso para guardar eventos");

        uint256 idHash = uint(keccak256(abi.encodePacked(idRegister)));

        registers[idHash].idRegister = idRegister;
        registers[idHash].userName = userName;
        registers[idHash].action = action;
        registers[idHash].date = date;
        registers[idHash].ip = ip;
        registers[idHash].target = target;
        registers[idHash].targetName = targetName;
        registers[idHash].TargetId = TargetId;
        registers[idHash].module = module;
        registers[idHash].description = description;
        registers[idHash].parameters = parameters;
        registers[idHash].owner = msg.sender;
        registers[idHash].activeAcl[msg.sender]=true;
        registers[idHash].acl[msg.sender]=permission(true,true, true);
        registers[idHash].activeAcl[owner]=true;
        registers[idHash].acl[owner]=permission(true,true, true);

        string memory nombre = upper(userName);
        uint256 idHashName = uint(keccak256(abi.encodePacked(nombre)));
        set(names[idHashName],idHash);

        set(regPerAccount[msg.sender], idHash);

        activeRegisters[idHash] = true;

        return nombre;
    }



    /*-------------------------------------------------------------------------------------------------------------------------

                                          FUNCIONES PARA BUSQUEDAS

    --------------------------------------------------------------------------------------------------------------------------*/

    function searchEventById(string memory idRegister) public view returns(address, string memory, string memory, string memory, string memory, string memory, string memory, string memory, string memory, string memory, string memory, string memory)
    {
        uint256 res = uint(keccak256(abi.encodePacked(idRegister)));

        require (registers[res].activeAcl[msg.sender] && registers[res].acl[msg.sender].read,"Usted no tiene permiso para ver este registro");

        return(registers[res].owner,registers[res].idRegister,registers[res].userName,registers[res].action,registers[res].date,registers[res].ip,registers[res].target,registers[res].targetName,registers[res].TargetId,registers[res].module,registers[res].description,registers[res].parameters);
    }


    function searchEventByName(string memory userName) public view returns (string memory)
    {
        string memory nombre = upper(userName);
        uint256 idHashName = uint(keccak256(abi.encodePacked(nombre)));
        string memory resultEvent = "";
        uint i;
        uint256 idEvent = 0;

        for (i = 0; i<size(names[idHashName]); i++)
        {
            idEvent = getKeyAtIndex(names[idHashName], i);
            if (activeRegisters[idEvent])
            {
                if (registers[idEvent].activeAcl[msg.sender] && registers[idEvent].acl[msg.sender].read)
                {
                    string memory x =  string(abi.encodePacked(registers[idEvent].idRegister,", ",registers[idEvent].userName,", ",
                                                                registers[idEvent].action,", ",registers[idEvent].date,", ",registers[idEvent].ip,", ",
                                                                registers[idEvent].target,", ",registers[idEvent].targetName,", ",registers[idEvent].TargetId,", ",
                                                                registers[idEvent].module,", ",registers[idEvent].description,", ",registers[idEvent].parameters));

                    resultEvent = concat(concat(resultEvent," - "),x);
                
                }
            }
        }

        return resultEvent;
    }

    /*-------------------------------------------------------------------------------------------------------------------------

                                          FUNCIONES PARA FIRMAS

    --------------------------------------------------------------------------------------------------------------------------*/

    function prefixed(bytes32 hash) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }
    
    function recoverSigner(bytes32 _ethSignedMessageHash, bytes memory _signature)public pure returns (address)
    {
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);

        return ecrecover(_ethSignedMessageHash, v, r, s);
    }

    function splitSignature(bytes memory sig)public pure returns(bytes32 r,bytes32 s,uint8 v)
    {
        require(sig.length == 65, "invalid signature length");

        assembly {
            /*
            First 32 bytes stores the length of the signature

            add(sig, 32) = pointer of sig + 32
            effectively, skips first 32 bytes of signature

            mload(p) loads next 32 bytes starting at the memory address p into memory
            */

            // first 32 bytes, after the length prefix
            r := mload(add(sig, 32))
            // second 32 bytes
            s := mload(add(sig, 64))
            // final byte (first byte of the next 32 bytes)
            v := byte(0, mload(add(sig, 96)))
        }

        // implicitly return (r, s, v)
    }




    /*-------------------------------------------------------------------------------------------------------------------------

                                          FUNCIONES PARA MAPPING

    --------------------------------------------------------------------------------------------------------------------------*/

    function getKeyAtIndex(Map storage map, uint index) private view returns (uint256)
    {
        return map.keys[index];
    }

    function size(Map storage map) private view returns (uint)
    {
        return map.keys.length;
    }

    function set(Map storage map,uint256 key) private
    {
        if (! map.inserted[key]) {
            
            map.inserted[key] = true;
            map.indexOf[key] = map.keys.length;
            map.keys.push(key);
        }
    }

    function remove(Map storage map, uint256 key) private
    {
        if (!map.inserted[key]) {
            return;
        }

        delete map.inserted[key];

        uint index = map.indexOf[key];
        uint lastIndex = map.keys.length - 1;
        uint256 lastKey = map.keys[lastIndex];

        map.indexOf[lastKey] = index;
        delete map.indexOf[key];

        map.keys[index] = lastKey;
        map.keys.pop();
    }


    function upper(string memory _base)internal pure returns (string memory)
    {
        bytes memory _baseBytes = bytes(_base);
        for (uint i = 0; i < _baseBytes.length; i++) {
            _baseBytes[i] = _upper(_baseBytes[i]);
        }
        return string(_baseBytes);
    }
    
    function _upper(bytes1 _b1) private pure returns (bytes1)
    {
        if (_b1 >= 0x61 && _b1 <= 0x7A) {
            return bytes1(uint8(_b1) - 32);
        }

        return _b1;
    }

    function concat(string memory _base, string memory _value)internal pure returns (string memory)
    {
        bytes memory _baseBytes = bytes(_base);
        bytes memory _valueBytes = bytes(_value);

        assert(_valueBytes.length > 0);

        string memory _tmpValue = new string(_baseBytes.length +
            _valueBytes.length);
        bytes memory _newValue = bytes(_tmpValue);

        uint i;
        uint j;

        for (i = 0; i < _baseBytes.length; i++) {
            _newValue[j++] = _baseBytes[i];
        }

        for (i = 0; i < _valueBytes.length; i++) {
            _newValue[j++] = _valueBytes[i];
        }

        return string(_newValue);
    }
}