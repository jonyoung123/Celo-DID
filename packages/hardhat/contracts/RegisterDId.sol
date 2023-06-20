pragma solidity ^0.8.6;

contract CeloDIDRegistry {
    struct Identity {
        bytes32 did;
        string identifier;
        bool isVerified;
    }

    mapping(address => Identity) identities;
    mapping(address => bool) addressExists;

    event DIDSet(address indexed wallet, bytes32 did);
    event DIDChanged(address indexed wallet, bytes32 newDid);
    event DIDVerified(address indexed wallet);

    
    // 1. Register DID
    function registerDID(address _address, string memory _did, string memory _identifier) public returns (bytes32) {
        require(!addressExists[_address], "Address already registered");
        require(!identities[_address].isVerified, "DID already registered and verified");
        bytes32 did = keccak256(abi.encodePacked(_did));
        identities[_address] = Identity(did, _identifier, false);
        addressExists[_address] = true;
        
        emit DIDSet(_address, did);

        return did;
    }

   // 2. Change DID
    function changeDID(address _address, bytes32 _currentDID, string memory _newDID, string memory _identifier, string memory _newIdentifier) public returns (bytes32){
        require(addressExists[_address], "Address not registered");
        require(identities[_address].did == _currentDID, "Invalid current DID");
        require(identities[_address].isVerified, "Not verified");
        require(keccak256(abi.encodePacked(identities[_address].identifier)) == keccak256(abi.encodePacked(_identifier)), "Invalid identifier");

        bytes32 newDID = keccak256(abi.encodePacked(_newDID));
        identities[_address].did = newDID;
        identities[_address].identifier = _newIdentifier;

        emit DIDChanged(_address, newDID);

        return newDID;
    }

     // 3. Verify DID
    function verifyDID(address _address, bytes32 _did, string memory _identifier) public  returns (bool){
        require(addressExists[_address], "Address not registered");
        require(identities[_address].did == _did, "Invalid DID");
        require(!identities[_address].isVerified, "DID already registered and verified");
        require(keccak256(abi.encodePacked(identities[_address].identifier)) == keccak256(abi.encodePacked(_identifier)), "Invalid identifier");
        
        identities[_address].isVerified = true;

        emit DIDVerified(_address);

        return identities[_address].isVerified;
    }

    // 4. Get DID by Address
    function getDIDByAddress(address _address, string memory _identifier) public view returns (bytes32) {
        require(identities[_address].did != 0, "Address does not exist");
        require(keccak256(abi.encodePacked(identities[_address].identifier)) == keccak256(abi.encodePacked(_identifier)), "Invalid identifier");

        return identities[_address].did;
    }

    // 5. Authenticate User
    function authenticateUser(address _address, bytes32 _did) public view returns (bool) {
        require(addressExists[_address], "Address not registered");
        require(identities[_address].isVerified, "User is not verified");

        if (identities[_address].did == _did) {
            return true;
        }

        return false;
    }
}