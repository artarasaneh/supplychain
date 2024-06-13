// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.9.0;
//import "./Strings.sol";


// تعریف قرارداد هوشمند
contract OrderContract {
    // تعریف ساختار داده‌ای برای سفارش خرید سیمان
    struct Order {
        uint256 id;
        uint256 productId;
        address addresscs;
        uint256 weight;
        uint256 totalPrice;
        bool isCompleted;
        bool isShipped;
    }

struct OrderBrocker{
    address addressCS; 
    uint256 productid;
     uint256 weight;
      string   deliverydate;
     string  destination;
}
 struct OrderP {
        uint256 id;
        uint256 productId;
       // address addressproducer;
       // address  addressconstructioncompany;
       // address  addresscarrier;
        uint256  payment;
        uint256 weight;
       // uint256 totalPrice;
        //bool isCompleted;
        //bool isShipped;
       // string deliveryDate;
        uint lat;
        uint256 long; 
        //uint256 timestamp;

    }


    // تعریف ساختار داده‌ای برای شیپمنت سیمان
struct Shipment {
        uint256 id;
        uint256 orderId;
        address carrier;
       // string deliveryDate;
       // bool isDelivered;
       // address addressProducer;
        //address addressCarrier;
        uint256 payment;
        uint256 weight;
        uint lat ;
        uint256 long;
       /// uint256 timestamp;
       // uint256 totalPrice;
    }

struct ShipmentCP{
    uint256 _productId;
     //address _addressproducer;
   // address _addresscarrier;
    uint256 _weight;
   // address _carrier; 
   //string  _deliveryDate;
    uint256 _payment;
    uint _lat;
     uint256 _long; 
    uint256 _timestamp;
    // uint256 _totalPrice;
}


//id: شناسه یکتای سفارش خرید در سیستم زنجیره تامین.
//cementId: شناسه محصول سیمان مورد سفارش خرید.
//uyer: آدرس خریدار سفارش خرید.
//quantity: تعداد واحدهای سفارش خرید.
//totalPrice: مبلغ کل قرارداد سفارش خرید.
//isCompleted: وضعیت تکمیل شده بودن سفارش خرید.
//isShipped: وضعیت ارسال شده بودن سفارش خرید.

mapping(uint256 => Order) public orders;
mapping(uint256 => OrderP) public ordersp;
uint256 public nextOrderId = 1;


mapping(uint256 => Shipment) public shipments;
uint256 public nextShipmentId = 1;
    // تعریف رویداد برای ایجاد سفارش جدید
event OrderCreated(uint256 indexed _orderId);
event ShipmentDelivered(uint256 indexed _shipmentId, uint256 indexed _orderId);


   // تعریف رویداد برای تحویل بار به واحد باربری
event ShipmentPCreated(uint256  _productId);

  // حمل و نقل بار به وسیله باربری
function shipOrorderShipmentCP(ShipmentCP memory _shipmentcp)
     public {
       // require(orders[_orderId].id != 0, "Order not found");
       // require(!orders[_orderId].isShipped, "Order already shipped");
        ordersp[nextOrderId] = OrderP({
            id: nextOrderId,
            productId: _shipmentcp._productId,
           // addressproducer:_shipmentcp._addressproducer,
            //addressconstructioncompany:msg.sender,
           // addresscarrier :_shipmentcp._addresscarrier,
            payment :_shipmentcp._payment,
            weight: _shipmentcp._weight,
           // totalPrice: _shipmentcp._totalPrice, 
            //deliveryDate : _shipmentcp._deliveryDate,
            lat: _shipmentcp._lat,
        long: _shipmentcp._long
       // timestamp: _shipmentcp._timestamp,
           // isCompleted: false,
           // isShipped: false
        });
    emit ShipmentPCreated(
     _shipmentcp._productId);
     nextShipmentId++;
}


function shipOrorderShipmentCP(Shipment memory shipment) public {
    ordersp[nextOrderId] = OrderP({
        id: nextOrderId,
        productId: shipment.id,
       // addressproducer: shipment.addressProducer,
       // addressconstructioncompany: msg.sender,
        //addresscarrier: shipment.addressCarrier,
        payment: shipment.payment,
        weight: shipment.weight,
       // totalPrice: shipment.totalPrice, 
       // deliveryDate: shipment.deliveryDate,
        lat: shipment.lat,
        long: shipment.long
        //timestamp: shipment.timestamp,
       // isCompleted: false,
       // isShipped: false
    });
    emit ShipmentPCreated(shipment.id);
    nextShipmentId++;
}
  // تایید رسیدن بار به مقصد
function confirmDelivery(uint256 _shipmentId) public {
        require(shipments[_shipmentId].id != 0, "Shipment not found");
    //    require(shipments[_shipmentId].carrier == msg.sender, "Only carrier can confirm delivery");
       // require(!shipments[_shipmentId].isDelivered, "Shipment already delivered");

        uint256 orderId = shipments[_shipmentId].orderId;
        orders[orderId].isCompleted = true;
       // shipments[_shipmentId].isDelivered = true;
        emit ShipmentDelivered(_shipmentId, orderId);

        // واریز مبلغ قرارداد به فروشنده
       // uint256 amount = orders[orderId].totalPrice;
       // payable(cements[orders[orderId].productid].manufacturer).transfer(amount);
        //emit PaymentTransferred(orderId, cements[orders[orderId].productid].manufacturer, amount);
    }

function registerBrokerOrder(OrderBrocker memory orderbroker) public payable {
      
      //اینکه چک گند ادرس ورودی ادرس تامین گننده باشد ریکوابر بابت 
       // require(cements[_cementId].id != 0, "Cement not found");
      // require(msg.value == cements[_cementId].price * _quantity, "Incorrect payment amount");

       // cements[_cementId].stage = SupplyChainStage.Sale;

        orders[nextOrderId] = Order({
            id: nextOrderId,
            productId:orderbroker.productid,
            addresscs: orderbroker.addressCS,
            weight: orderbroker.weight,
            totalPrice: orderbroker.weight*1 ,//قیمت محصول باید ارسال شود
            isCompleted: false,
            isShipped: false
        });

      emit OrderCreated(nextOrderId);
        nextOrderId++;
    }
    
}