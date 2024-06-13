// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.9.0;
import "./Strings.sol";


contract ConstructionSupplyChain {
struct Cement {
        uint256 id;
        string name;
        uint256 manufacturingDate;
        uint256 price;
        string lat ;
        string long;
        string city;
    }
struct Stone {
        uint256 id;
        string name;
        uint256 Date;
        uint256 price;
        string lat ;
        string long;
        string city;
    }


struct Order {
         uint256 id;
   address owner;
address producer;  
uint256 productid;
uint256 weight;
    string   deliveryDate;
    address carrier;
    string  Lat;
    string Long;
    string payment;
}
struct product_cement{
uint cementid;

string cementname;
uint price;
uint dateproduce;
uint    lat;
uint   long;
uint weight;
    }
mapping(uint=>product_cement) productcement;
event ReputationUpdated(address addresswallet, string avgscore);
event addStoneevent(uint nextStoneId);
event OrderCreated(uint nextOrderId);
event TrakingCodeevent(uint256 TrCode);
struct Bank {
        string name;
        string accountNumber;
        address accountOwner;
    }


struct ConstructionCompany {
    uint256 id;
    address addr;
    string name;
    string phone;
    string city;
    string lat;
    string long;
}

struct ProducerCompany {
    uint256 id;
    address addr;
    string name;
    string phone;
    string city;
    string lat;
    string long;
}
struct Garantee{
address bankaddress;
address owner;
uint256 payment;
uint256 TrackingCode;

}



    //
//name: نام بانک مربوطه.
//accountNumber: شماره حساب بانکی.
//accountOwner: آدرس صاحب حساب بانکی.

    // تعریف متغیرهای مربوط به قرارداد
mapping(uint256 => Cement) public cements;

mapping(uint256 => Stone) public stones;
uint256 public nextCementId = 1;
 uint256 public nextStoneId = 1;
uint256 public nextOrderId=1;

uint256 public nextCementSupplierId = 1;
uint256 public nextProducerCompanyId = 1;
uint256 public nextConstructionCompanyId = 1;

mapping(address=>bool) public constructioncompanys;
mapping(address=>ProducerCompany) public producercompany;
mapping(uint=>Order) public orders;

mapping(uint=>ConstructionCompany) construction_company;
event ConstructionCompanyRegistered(address constructioncompanys);///
 


 
Bank public bank;
Garantee public garantee;
event CementSupplierbyAddress(address owner);
event ADDCementProduct(uint cementid);
event CementSupplierRegistered(address owner);
event ProducerCompanyRegistered(address owner);

enum SupplyChainStage {
        Manufacturing,
        Sale,
        Shipped
    } 
struct CementSupplier {
        uint256 id;
        address walletAddress;
        string fname;
        string family;
        string lat;
        string long;
        uint256 score;
        uint256 numberscore;
    }


 
address private owner;
mapping(address => CementSupplier) public cementsuppliers;
mapping(address => ConstructionCompany) public constructioncompany;
   
event SupplyChainUpdate(uint256 indexed _cementId, SupplyChainStage _stage);
 
event ShipmentCreated(uint256 indexed _shipmentId);

 event ShipmentPCreated(uint256 _productId );
 
event PaymentTransferred(uint256 indexed _orderId, address indexed _seller, uint256 _amount);
    constructor(){
                owner = msg.sender;
    }
    

function registercementSupplier(
    string memory _fname, 
    string memory _family , 
     string  memory  _city , 
     string memory _phone,
    string memory  _international , 
    string memory  _lat , 
    string memory _long) public  {
    cementsuppliers[msg.sender] = CementSupplier({
        id: nextCementSupplierId,
        walletAddress: msg.sender,
        fname: _fname,
        family: _family,
      
        lat: _lat,
        long: _long,
        score:0,
        numberscore:0
    });

    emit CementSupplierRegistered(msg.sender);
    nextCementSupplierId++;
}

function registerConstructionCompany(
    string memory _fname, 
    string  memory  _city , 
      string memory _phone,
    string memory  _lat , 
    string memory _long) public  {
    constructioncompany[msg.sender] = ConstructionCompany({
        id: nextConstructionCompanyId,
        addr: msg.sender,
         name:_fname,
         city: _city , 
        phone: _phone,
        lat:_lat,
        long:_long
    });

    emit ConstructionCompanyRegistered(msg.sender);
    nextConstructionCompanyId++;
}


function registerProducerCompany(
    string memory _fname, 
    string  memory  _city , 
    string memory _phone,
    string memory  _lat , 
    string memory _long) public  {
    producercompany[msg.sender] = ProducerCompany({
        id: nextProducerCompanyId,
        addr: msg.sender,
         name:_fname,
         city: _city , 
        phone: _phone,
        lat:_lat,
        long:_long
    });

    emit ProducerCompanyRegistered(msg.sender);
    nextProducerCompanyId++;
}


function getCementSupplierByAddress(address _address) public returns (uint256 id,
 string memory fname, string memory family,
  string memory lat, string memory long) {
    for (uint256 i = 1; i < nextCementSupplierId; i++) {
        if (cementsuppliers[_address].walletAddress == _address) {
            CementSupplier storage supplier = cementsuppliers[_address];
            emit CementSupplierbyAddress(_address);
            return (supplier.id, supplier.fname, supplier.family,supplier.lat, supplier.long);
        }
    }
    return (0, "", "", "", "");
}




    // اضافه کردن محصول جدید سیمان
    function addCement(string memory _name, uint256 _manufacturingDate,
     uint256 _price, string memory _lat,
           string memory _long ,
          string memory  _city ) public {
        cements[nextCementId] = Cement({
            id: nextCementId,
            name: _name,
            manufacturingDate: _manufacturingDate,
            price: _price,
            lat:_lat,
            long:_long,
            city:_city
        });
        emit SupplyChainUpdate(nextCementId, SupplyChainStage.Manufacturing);
        nextCementId++;
    } 
    function addStone(string memory _name, uint256 _Date,
     uint256 _price, string memory _lat,
           string memory _long ,
          string memory  _city ) public {
        stones[nextStoneId] = Stone({
            id: nextStoneId,
            name: _name,
           Date: _Date,
            price: _price,
            lat:_lat,
            long:_long,
            city:_city
        });
        emit addStoneevent(nextStoneId);
        nextStoneId++;
    }
// خرید سیمان توسط خریدار
    function OrderConstructionfromProducer(address _producer,  uint256 _productid, uint256 _weight,
    string memory _deliveryDate,
    address _carrier, string memory _Lat,
     string memory _Long ,string memory _payment) public  {
      
      orders[nextOrderId] = Order({
            id: nextOrderId,
            owner  :msg.sender,
            producer: _producer,
            productid: _productid,
            weight: _weight,
            deliveryDate: _deliveryDate,
            carrier: _carrier,
            Lat: _Lat,
            Long: _Long,
            payment:_payment
        });

      emit OrderCreated(nextOrderId);
    nextOrderId++;
    }
  
    function OrderProducerFromCement(address _producer,  uint256 _productid, uint256 _weight,
    string memory _deliveryDate,
    address _carrier, string memory _Lat,
     string memory _Long ,string memory  _payment) public  {
      
      orders[nextOrderId] = Order({
            id: nextOrderId,
            owner  :msg.sender,
            producer: _producer,
            productid: _productid,
            weight: _weight,
            deliveryDate: _deliveryDate,
            carrier: _carrier,
            Lat: _Lat,
            Long: _Long,
            payment:_payment
        });

      emit OrderCreated(nextOrderId);
    nextOrderId++;
    }
 
function addproductcement(uint _cementid, 
    uint _price,
    uint _lat, uint _long,uint _weight) public {
   uint itemNum=0;
        if(productcement[itemNum].cementid!=_cementid)
        {
        productcement[itemNum].weight=_weight;
            if(_price!=0){
                productcement[itemNum].price=_price;
            }
        productcement[itemNum].cementid=_cementid;
       // productcement[itemNum].cementname=_cementname;
       //productcement[itemNum].dateproduce=_dateproduce;
        productcement[itemNum].lat=_lat;
        productcement[itemNum].long=_long;
        }
        else
        {
        productcement[itemNum].weight+=_weight;
            if(_price!=0){
                productcement[itemNum].price=_price;
                }
        productcement[itemNum].cementid=_cementid;
       
        productcement[itemNum].lat=_lat;
        productcement[itemNum].long=_long; 
        }
    emit ADDCementProduct(_cementid);
}
 

function calculateRep (uint256 score, address addresswallet) external {
    string memory AvgScore;
    if(cementsuppliers[addresswallet].walletAddress == addresswallet) {
        cementsuppliers[addresswallet].score += score;
        cementsuppliers[addresswallet].numberscore += 1;
        uint256 aaa = cementsuppliers[addresswallet].score;
        uint256 bbb = cementsuppliers[addresswallet].numberscore;
        AvgScore = Strings.toString((aaa * 100) / bbb);
    }
    emit ReputationUpdated(addresswallet, AvgScore);
}



    // تعیین بانک برای قرارداد هوشمند
function RegisterBank(string memory _bankName, string memory _bankAccountNumber, address _bankAccountOwner) public {
        bank = Bank({
           name: _bankName,
            accountNumber: _bankAccountNumber,
           accountOwner: _bankAccountOwner
        });
     }



function BankGarantee(address _actorsOfCSC , uint256 _payment,bool Flag) public returns (uint256  TrackingCode){
uint256 TC;
if(Flag){
TC=uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,msg.sender))) % _payment;
    }
garantee = Garantee({
           bankaddress: msg.sender,
            owner: _actorsOfCSC,
           payment: _payment,
           TrackingCode:TC
        });
 emit TrakingCodeevent(TC);

return TC;

}

}

