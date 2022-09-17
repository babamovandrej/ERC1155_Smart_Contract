// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;


import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Create_Object is ERC1155, Ownable, ReentrancyGuard  {
    uint private objectCounter = 1; 
    uint public objectprice = 0 ether;
    //Mapping each object
    mapping(uint256 => Object) public Objects;

    //Creating struct object for each id created
    struct Object{
        uint256 quantity;
        string name; 
        string uri;
        uint256 minted;
    }
    constructor(string memory _name, string memory _symbol) ERC1155("") {}

    modifier callerIsAUser() {
        require(tx.origin == msg.sender, "The function caller is not a user but a contract.");
        _;
    }

    modifier MintCompliance(uint256 _id, uint256 amount) {
        require(Objects[_id].quantity != 0);
        require(msg.value >= objectprice, "Insufficient ETH for transaction");
        require(Objects[_id].minted < Objects[_id].quantity, "Object already claimed");
        require(Objects[_id].minted + amount <= Objects[_id].quantity,"Supply is exceeded");
        _;
    }
    // CREATE AND EDIT OBJECTS FUNCTION
    function addObject(
        uint256  _quantity, 
        string memory _name,
        string memory _uri
    ) public onlyOwner {
        Object storage elem = Objects[objectCounter];
        elem.quantity = _quantity;
        elem.name = _name;
        elem.uri = _uri;
        objectCounter += 1;
    }
    //Edit existing fragment only available to contract owner
    function editObject(
        uint256 _quantity, 
        string memory _name,        
        uint256 element,
        string memory _uri
    ) external onlyOwner {
        Objects[element].quantity = _quantity;    
        Objects[element].name = _name;    
        Objects[element].uri = _uri;    
    }     

    // TOKEN URI AND NUMBER OF OBJECTS MINTED FUNCTIONS
    function uri(uint256 _id) public view override returns (string memory) {
        return string(Objects[_id].uri);
    }
    // OBJECT MINTING FUNCTION
    function mintobject(uint256 _id, uint256 amount) public payable callerIsAUser MintCompliance(_id,amount){
        Objects[_id].minted += amount;
         _mint(msg.sender, _id, amount, "");
    }

    //WITHDRAWAL OF FUNDS
    function withdraw() public onlyOwner nonReentrant {
        uint balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }
}

