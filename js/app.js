$(function() {
    $(window).load(function() {
        PrepareNetwork();

    });
});

async function PrepareNetwork() {
    await loadWeb3();
    await LoadDataSmartContract();
}
async function loadWeb3() {
    if (window.ethereum) {
        window.web3 = new Web3(window.ethereum);
        await ethereum.request({ method: 'eth_requestAccounts' }).then(function(accounts) {
            CurrentAccount = accounts[0];
            web3.eth.defaultAccount = CurrentAccount;
            console.log('current account: ' + CurrentAccount);
            setCurrentAccount();
        });
    } else if (window.web3) {
        window.web3 = new Web3(window.web3.currentProvider);
    } else {
        window.alert('Non-Ethereum browser detected. You should consider trying MetaMask!');
    }
    ethereum.on('accountsChanged', handleAccountChanged);
    ethereum.on('chainChanged', handleChainChanged);

    web3.eth.handleRevert = true;
}

function setCurrentAccount() {
    $('#Address').text(CurrentAccount);

}

async function handleAccountChanged() {
    await ethereum.request({ method: 'eth_requestAccounts' }).then(function(accounts) {
        CurrentAccount = accounts[0];
        web3.eth.defaultAccount = CurrentAccount;
        // console.log('current account: ' + CurrentAccount);
        setCurrentAccount();
        window.location.reload();
    });
}

async function handleChainChanged(_chainId) {

    window.location.reload();
    console.log('Chain Changed: ', _chainId);
}
async function LoadDataSmartContract() {
    await $.getJSON('Storage.json', function(contractData) {
        JsonContract = contractData;
        console.log('JsonContract : ' + JsonContract);

    });
    await $.getJSON('ConstructionSupplyChain.json', function(CScontractData) {
        CSJsonContract = CScontractData;
        console.log('CSJsonContract : ' + CSJsonContract);

    });
    web3 = await window.web3;

    const networkId = await web3.eth.net.getId();

    const CSnetworkId = await web3.eth.net.getId();
    console.log('networkId : ' + networkId);
    const networkData = JsonContract.networks[networkId];
    console.log('networkData : ' + networkData);

    const CSnetworkData = CSJsonContract.networks[CSnetworkId];
    console.log('CSnetworkData : ' + CSnetworkData);

    if (CSnetworkData) {
        CSMyContract = new web3.eth.Contract(CSJsonContract.abi, CSnetworkData.address);
        // alert('CS');
        console.log('CSMyContract : ' + CSMyContract);
        getCementSupplierByAddress = await CSMyContract.methods.retrieve().call();
        console.log('getCementSupplierByAddress : ' + getCementSupplierByAddress);

    }


    if (networkData) {
        MyContract = new web3.eth.Contract(JsonContract.abi, networkData.address);

        console.log('MyContract : ' + MyContract);

        retrieve = await MyContract.methods.retrieve().call();
        console.log('retrieve : ' + retrieve);

    }

    $(document).on('click', '#registerCementSupplier', registerCementSupplier);
    $(document).on('click', '#registerBrokerOrder', registerBrokerOrder);
    $(document).on('click', '#registerScoreSuplier', registerScoreSuplier);
    $(document).on('click', '#searchCementSupplier', searchCementSupplier);
    $(document).on('click', '#OrderShipment', OrderShipment);
    $(document).on('click', '#orderShipmentCP', orderShipmentCP);
    AddCementProduct
    $(document).on('click', '#AddCementProduct', AddCementProduct);
}
let Oaddress;


async function AddCementProduct() {

    var cementid = $("#cementid").val();
    var cementname = $("#cementname").val();
    var price = $("#price").val();
    var lat = $("#lat").val();
    var weight = $("#weight").val();
    var dateproduce = $("#dateproduce").val();
    var long = $("#long").val();


    let contractData;
    await $.getJSON('ConstructionSupplyChain.json', function(data) {
        contractData = data;
        alert('aaa');
    });

    const web3 = new Web3(window.ethereum);
    const networkId = await web3.eth.net.getId();
    alert(networkId);
    const networkData = contractData.networks[networkId];
    if (!networkData) {
        alert('Smart contract not deployed to detected network.');
        return;
    }

    const contract = new web3.eth.Contract(contractData.abi, networkData.address);
    const accounts = await web3.eth.getAccounts();
    alert(cementid);
    alert(cementname);
    alert(price);

    alert(weight);
    alert(dateproduce);
    alert(lat);
    alert(long);

    alert(accounts[0]);
    contract.methods.addproductcement(cementid, cementname, price, weight,
            dateproduce,
            lat,
            long).send({ from: accounts[0] })
        .on('receipt', function(receipt) {
            if (receipt.events.CementSupplierRegistered) {
                alert('Cement Supplier Registered: ' + receipt.events.CementSupplierRegistered.returnValues[0]);
            }
        })
        .on('error', function(error, receipt) {
            alert('Error registering cement supplier.');
        });
}


async function registerScoreSuplier() {

    var addressupplier = $("#addressupplier").val();
    var score = $("#score").val();



    let contractData;
    await $.getJSON('ConstructionSupplyChain.json', function(data) {
        contractData = data;
        alert('aaa');
    });

    const web3 = new Web3(window.ethereum);
    const networkId = await web3.eth.net.getId();
    alert(networkId);
    const networkData = contractData.networks[networkId];
    if (!networkData) {
        alert('Smart contract not deployed to detected network.');
        return;
    }

    const contract = new web3.eth.Contract(contractData.abi, networkData.address);
    const accounts = await web3.eth.getAccounts();
    alert(score);
    alert(addressupplier);
    alert(accounts[0]);
    contract.methods.calculateRep(fname, family, city,
            phone,
            international,
            lat, long).send({ from: accounts[0] })
        .on('receipt', function(receipt) {
            if (receipt.events.CementSupplierRegistered) {
                alert('Cement Supplier Registered: ' + receipt.events.CementSupplierRegistered.returnValues[0]);
            }
        })
        .on('error', function(error, receipt) {
            alert('Error registering cement supplier.');
        });
}


async function registerCementSupplier() {
    alert('ddsss');
    var fname = $("#fname").val();
    var family = $("#family").val();
    var city = $("#city").val();
    var international = $("#international").val();
    var phone = $("#phone").val();
    var lat = $("#lat").val();
    var long = $("#long").val();



    let contractData;
    await $.getJSON('ConstructionSupplyChain.json', function(data) {
        contractData = data;
        alert('aaa');
    });

    const web3 = new Web3(window.ethereum);
    const networkId = await web3.eth.net.getId();
    alert(networkId);
    const networkData = contractData.networks[networkId];
    if (!networkData) {
        alert('Smart contract not deployed to detected network.');
        return;
    }

    const contract = new web3.eth.Contract(contractData.abi, networkData.address);
    const accounts = await web3.eth.getAccounts();
    alert(family);
    alert(fname);
    alert(city);
    alert(international);
    alert(phone);
    alert(lat);
    alert(long);

    alert(accounts[0]);
    contract.methods.registercementSupplier(fname, family, city,
            phone,
            international,
            lat, long).send({ from: accounts[0] })
        .on('receipt', function(receipt) {
            if (receipt.events.CementSupplierRegistered) {
                alert('Cement Supplier Registered: ' + receipt.events.CementSupplierRegistered.returnValues[0]);
            }
        })
        .on('error', function(error, receipt) {
            alert('Error registering cement supplier.');
        });
}

async function OrderShipment() {
    alert('ddsss');
    var Address = $("#Address").val();
    var orderId = $("#orderId").val();
    var deliveryDate = $("#deliveryDate").val();
    var carrier = $("#carrier").val();
    var payment = $("#payment").val();
    var lat = $("#lat").val();
    var long = $("#long").val();



    let contractData;
    await $.getJSON('ConstructionSupplyChain.json', function(data) {
        contractData = data;
        alert('aaa');
    });

    const web3 = new Web3(window.ethereum);
    const networkId = await web3.eth.net.getId();
    alert(networkId);
    const networkData = contractData.networks[networkId];
    if (!networkData) {
        alert('Smart contract not deployed to detected network.');
        return;
    }

    const contract = new web3.eth.Contract(contractData.abi, networkData.address);
    const accounts = await web3.eth.getAccounts();


    alert(accounts[0]);
    const timestamp = 10;

    alert(orderId);
    alert(deliveryDate);
    alert(carrier);
    alert(payment);
    alert(lat);
    alert(long);
    alert(timestamp);

    contract.methods.shipOrder(orderId, deliveryDate, carrier, payment, lat, long, timestamp).send({ from: accounts[0] })
        .on('receipt', function(receipt) {
            if (receipt.events.ShipmentCreated) {
                alert('Order Shipment Registered: ' + receipt.events.ShipmentCreated.returnValues[1]);
            }
        })
        .on('error', function(error, receipt) {
            alert('Error registering OrderShipment.');
        });
}

async function orderShipmentCP() {
    alert('ddsss');
    var addressproducer = $("#addressproducer").val();

    var weight = $("#weight").val();
    var productId = $("#productId").val();
    var deliveryDate = $("#deliveryDate").val();
    var carrier = $("#carrier").val();
    var payment = $("#payment").val();
    var lat = $("#lat").val();
    var long = $("#long").val();

    // if (fname.trim() == '' || family.trim() == '' || international.trim() == '' || phone.trim() == '' || lat.trim() == '' || long.trim() == '' || city.trim() == '') {
    //    alert("Please Fill TextBox");
    //    return;
    // }

    const shipment = {
        productId: productId,
        addressProducer: addressproducer,
        addressCarrier: "0x...",
        weight: weight,
        carrier: carrier,
        deliveryDate: deliveryDate,
        payment: payment,
        lat: lat,
        long: long,
        timestamp: Date.now(),
        totalPrice: 10000
    };

    let contractData;
    await $.getJSON('ConstructionSupplyChain.json', function(data) {
        contractData = data;
        alert('aaa');
    });

    const web3 = new Web3(window.ethereum);
    const networkId = await web3.eth.net.getId();
    alert(networkId);
    const networkData = contractData.networks[networkId];
    if (!networkData) {
        alert('Smart contract not deployed to detected network.');
        return;
    }

    const contract = new web3.eth.Contract(contractData.abi, networkData.address);
    const accounts = await web3.eth.getAccounts();


    alert(accounts[0]);
    const timestamp = 10;

    alert(orderId);
    alert(deliveryDate);
    alert(carrier);
    alert(payment);
    alert(lat);
    alert(long);
    alert(timestamp);

    contract.methods.orderShipmentCP(shipment).send({ from: accounts[0] })
        .on('receipt', function(receipt) {
            if (receipt.events.ShipmentCreated) {
                alert('Order Shipment Registered: ' + receipt.events.ShipmentCreated.returnValues[2]);
            }
        })
        .on('error', function(error, receipt) {
            alert('Error registering OrderShipment.');
        });
}

async function searchCementSupplier() {
    var addresscement = $("#addresscement").val();
    if (addresscement.trim() == '') {
        alert("Please Fill TextBox");
    } else {

        alert('addresscement');
        let contractData;
        await $.getJSON('ConstructionSupplyChain.json', function(data) {
            contractData = data;
            alert('aaa');
        });

        const web3 = new Web3(window.ethereum);
        const networkId = await web3.eth.net.getId();
        alert(networkId);
        const networkData = contractData.networks[networkId];
        if (!networkData) {
            alert('Smart contract not deployed to detected network.');
            return;
        }
        const contract = new web3.eth.Contract(contractData.abi, networkData.address);
        const accounts = await web3.eth.getAccounts();
        const supplierData = await MyContract.methods.getCementSupplierByAddress(addresscement).call();

        if (supplierData.id != 0) {
            alert('Cement Supplier Found: ' + supplierData.fname);
        } else {
            alert('No Cement Supplier found with this address');
        }
    }
}

async function registerBrokerOrder() {

    var addressCS = $("#addressCS").val();
    var productid = $("#productid").val();
    var weight = $("#weight").val();
    var deliverydate = $("#deliverydate").val();

    var destination = $("#destination").val();
    alert(destination);

    if (destination.trim() == '' || addressCS.trim() == '' || productid.trim() == '' || weight.trim() == '' || deliverydate.trim() == '') {
        alert("Please Fill TextBox");
    }

    await $.getJSON('ConstructionSupplyChain.json', function(RCScontractData) {
        RCSJsonContract = RCScontractData;
        console.log('RCSJsonContract : ' + RCSJsonContract);

    });
    web3 = await window.web3;
    const RCSnetworkId = await web3.eth.net.getId();
    console.log('RCSnetworkId : ' + RCSnetworkId);

    const RCSnetworkData = RCSJsonContract.networks[RCSnetworkId];
    console.log('RCSnetworkData : ' + RCSnetworkData);

    RCSMyContract = new web3.eth.Contract(RCSJsonContract.abi,
        RCSnetworkData.address);
    console.log('RCSMyContract : ' + RCSMyContract);

    alert(CurrentAccount);
    RCSMyContract.methods.registerBrokerOrder(addressCS, productid, weight, deliverydate, destination, lat, long).send({ from: CurrentAccount }).then(function(Instance) {


    }).catch(function(error) {
        var msg = error.message;

        var idxbigin = msg.indexOf("ERC721");
        var idxend = msg.indexOf(",", idxbigin);
        var result = msg.slice(idxbigin, idxend - 1);

        alert('ERROR ========>' + result);

    });

}



async function searchCementSupplier() {

    var addresscement = $("#addresscement").val();
    if (addresscement.trim() == '') {
        alert("Please Fill TextBox");
    }

    var getCementSupplierByAddress = await MyContract.methods.getCementSupplierByAddress(addresscement).call();
    alert('getCementSupplierByAddress: ' + getCementSupplierByAddress);


}