  // SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.18;

/////////////////786 starting with project/////////////////////

contract landRegistry{
    
    address public inspector;
    

    ////////////first making struct//////////////

    //land details

    struct Land
    {
    address Owner;
    uint Area;
    string City;
    string State;
    uint LandPrice; 
    uint PropertyId;
    
    }
    
    //buyer details
     struct Buyer
     {
    address id;
    string Name;
    uint Age;
    string City;
    uint Cnic;
    string Email;

    }
    
    //seller details
    struct Seller 

    {
    address id;
    string Name;
    uint Age;
    string City;
    uint Cnic;
    string Email;
    }

    //Landinspector details
    struct LandInspector

    {    
    address id;
    string name;
    uint age;
    string designation;
    }
    
    //////////////end struct//////////////////


   /*...........................PART 1...........................*/
   
                 //////////seller & land/////////////

    


    //////////////////mapping////////////////////
     

    mapping(uint => Land) private LandMapping;
    mapping(address=> Buyer) private BuyerMapping;
    mapping(address => Seller) private Sellermapping;
    mapping (address => bool) private VerifiedSeller;
    mapping(address => bool) private VerifiedBuyer;
    mapping (uint => bool) private VerifyLand;
    mapping(uint => address ) private LandOwner;
    mapping(address => bool) private registeredAddresses;


     ////////////LAND INSPECTOR/////////////

     constructor(){

         inspector = msg.sender;
     }

     //////////modifer for buyer and seller verification/////////


    modifier onlyInspector
    
     {

    require(msg.sender == inspector, "Only the inspector can perform this action");
    _;

    }

     ////////////function for seller registration///////////////////

    
    function addSeller(
        address _id,
        string memory _Name,
        uint _Age,
        string memory _City,
        uint _Cnic,
        string memory _Email) 
        public 
        {  
        //THIS REQUIRE WILL CHEAK IF SELLER IS REGISTERED
        require(!registeredAddresses[msg.sender]);
        registeredAddresses[msg.sender] = true;
        Sellermapping[msg.sender] = Seller (_id,
        _Name,
        _Age,
        _City,
        _Cnic,
        _Email);
         //seller is yet not verified by inspector
        VerifiedSeller[msg.sender]=false;
        
        }


        //lets make function for seller verification
    function sellerVerification(address _SellerId) public onlyInspector{ 
    VerifiedSeller[_SellerId]= true;
    }
        
        //reject seller 
    function SellerReject(address _SellerId) public onlyInspector {
    VerifiedSeller[_SellerId] = false;
    }
    
    /////////////////////UPDATE SELLER//////////////////////////

    
    
    
    
    function updateSeller(address _id,string memory _Name,
            uint _Age,string memory _City, uint _Cnic,string memory _Email) public {
                require(registeredAddresses[msg.sender], "you are already register address");
                Sellermapping[_id].Name=_Name;
                Sellermapping[_id].Age= _Age;
                Sellermapping[_id].City=_City;
                Sellermapping[_id].Cnic=_Cnic;
                Sellermapping[_id].Email=_Email;
           }
          
          



    //////////////////////LAND REGISTRY/////////////////////////

    function addLand

    (uint _LandId,
    uint _area,
    string memory _City, 
    string memory _State,
    uint _LandPrice,
    uint _PropertyId)
    public{
       LandMapping[_LandId] = Land(msg.sender, _area, _City, _State, _LandPrice, _PropertyId);
             VerifyLand[_LandId] = false;
    }

    /////////////////////LAND VERIFICATION//////////////////////
    function LandVerification(uint _landId) public onlyInspector {
    VerifyLand[_landId]= true;
    }


    ////////////////////LAND REJECTION/////////////////////////
    
    function RejectLand(uint _LandId) public onlyInspector{
    VerifyLand[_LandId] = false;
    }
   
    



    ////////////////////BUYER REGISTRATION/////////////////////

    
    
    function RegisterBuyer
    (address _id,
     string memory _Name,
     uint _Age,
     string memory _City,
     uint _Cnic,
     string memory  _Email)
     public {
          BuyerMapping[_id] = Buyer(_id,_Name,_Age,_City,_Cnic,_Email);
          VerifiedBuyer[msg.sender] = false;
          }


    

    /////////////////////BUYER VERIFICATION//////////////////////
      

    function BuyerVerification(address _id) public onlyInspector {
    VerifiedBuyer[_id] = true;
    }
   


    ////////////////////BUYER REJECTION////////////////////////

    function BuyerRejection(address _id) public onlyInspector{
    VerifiedBuyer[_id]= false;
    }
    
    ////////////////////UPDATE BUYER///////////////////////////

    function UpdateBuyer
      (address _addr,
       string memory _Name,
       uint _Age,
       string memory _City,
       uint _Cnic,
       string memory _Email)
       public 
       {
           require(registeredAddresses[msg.sender],"your are already register");
                 BuyerMapping[_addr].Name=_Name;
                 BuyerMapping[_addr].Age= _Age;
                 BuyerMapping[_addr].City=_City;
                 BuyerMapping[_addr].Cnic=_Cnic;
                 BuyerMapping[_addr].Email=_Email;
           }



    //////////////////////BUYLAND////////////////////////////
    
      function BuyLand(uint _LandId) public payable{
        require(VerifiedBuyer[msg.sender] == true,"buyer is isnt verified");
        require(VerifyLand[_LandId] == true,"error in seller");
        payable(LandMapping[_LandId].Owner).transfer(msg.value);
        LandMapping[_LandId].Owner=msg.sender;

          }

    ///////////////////TRANSER OWNERSHIP//////////////////////

    function NewOwner(uint _landId, address _newLandOwner) public{
        require(LandOwner[_landId]==msg.sender,"YOU ARE NOT AN OWNER");
        LandOwner[_landId] = _newLandOwner;
    }


    //we can individually cheak verification

    function cheaksellerVerification(address _SellerId) public view returns(bool){
        if(VerifiedSeller[_SellerId]){
            return true;
        }
            return false;
    }

    
    function CheakBuyerVerification()  public view returns(bool){
        return VerifiedBuyer[msg.sender];
    }

    function checkLandVerification(uint _landId) public view returns (bool) {
        if(VerifyLand[_landId]){
            return true;
        }
        return false;
    }

     //We can also get individual details of Seller ,Buyer and Lands (area,city,price,owner)
   
    function getLandOwner(uint _landId) public view returns (address) {
        return LandMapping[_landId].Owner;
    }

    function GetArea(uint _landId) public view returns (uint) {
        return LandMapping[_landId].Area;
    }

    function GetLandCity(uint _landId) public view returns (string memory) {
        return LandMapping[_landId].City;
    }

     function getLandState(uint _landId) public view returns (string memory) {
        return LandMapping[_landId].State;
    }
   
    function GetLandPrice(uint _landId) public view returns (uint) {
        return LandMapping[_landId].LandPrice;
    }
    
}

    
    
    
    


     