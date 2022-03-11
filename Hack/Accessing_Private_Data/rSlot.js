const { ethers } = require("ethers");
const web3 = require("web3");

const url = "http://127.0.0.1:7545";
const contracAddr = "0xbc66f9045e2C095e05946a6715Bc38acAC7190b2";

// ethers
const providerEthers = new ethers.providers.JsonRpcProvider(url);

// web3
const providerWeb3 = new web3(url);

(async function () {
  console.log();

  // var slot = 0;
  // var txt = await providerEthers.getStorageAt(contracAddr, slot); // slot 1
  // console.log(txt)
  // var slot = 1;
  // var txt = await providerEthers.getStorageAt(contracAddr, slot); // slot 1
  // console.log(txt)
  // var slot = 2;
  // var txt = await providerEthers.getStorageAt(contracAddr, slot); // slot 1
  // console.log(txt)
  // var slot = 3;
  // var txt = await providerEthers.getStorageAt(contracAddr, slot); // slot 1
  // console.log(txt) // error reason : 'hex data is odd-length' 
  // return 

  var slot = 0;
  var txt = await providerWeb3.eth.getStorageAt(contracAddr, slot); // slot 1
  console.log(`slot ${slot}:`, txt);
  console.log(`slot ${slot}:`, Number(txt));
  console.log("=========================================================\n");

  var slot = 1;
  var txt = await providerWeb3.eth.getStorageAt(contracAddr, slot); // slot 2
  console.log(`slot ${slot}:`, txt);
  txt = txt.slice(2); // '0x1234'.substing(2) >>> '1234
  console.log(`uint16 u16    :`, txt.slice(0, 2));
  console.log(`bool isTrue   :`, txt.slice(2, 4));
  console.log(`address owner :`, txt.slice(4));
  console.log("=========================================================\n");

  var slot = 2;
  var txt = await providerWeb3.eth.getStorageAt(contracAddr, slot);
  console.log(`slot ${slot}:`, txt);
  console.log("password:", ethers.utils.parseBytes32String(txt));
  console.log("=========================================================\n");

  var slot = 3;
  var txt = await providerWeb3.eth.getStorageAt(contracAddr, slot); // slot 3
  console.log(`slot ${slot}:`, txt);
  var txt = await providerWeb3.eth.getStorageAt(contracAddr, ++slot); // slot 4
  console.log(`slot ${slot}:`, txt);
  var txt = await providerWeb3.eth.getStorageAt(contracAddr, ++slot); // slot 5
  console.log(`slot ${slot}:`, txt);
  console.log("=========================================================\n");

  /**
   * slot 6 - length of array
   * starting from slot keccak256(6) - array elements
   * slot where element is stored = keccak256(slot) + (index * elementSize)
   * where slot = 6 and elementSize = 2 (1 uint + 1 bytes32)
   */
  var slot = 6;
  var txt = await providerWeb3.eth.getStorageAt(contracAddr, slot); // slot 6
  console.log(`slot ${slot}:`, txt);

  // '0xf652222313e28459528d920b65115c16c04f3efc82aaedc97be59f3f377c0d3f'
  var slot6Hash = ethers.utils.solidityKeccak256(["uint"], [6]);
  var txt = await providerWeb3.eth.getStorageAt(contracAddr, slot6Hash); // keccak256(6)
  console.log("user0 id      :", txt);

  // '0x' + 'f652222313e28459528d920b65115c16c04f3efc82aaedc97be59f3f377c0d40'
  var slot6Hash = ethers.BigNumber.from(slot6Hash).add(1).toHexString();
  // var slot6Hash = '0x' + BigNumber(slot6Hash).plus(1).toString(16);
  var txt = await providerWeb3.eth.getStorageAt(contracAddr, slot6Hash); // keccak256(6) + 1
  console.log("user0 password:", txt);

  var slot6Hash = ethers.BigNumber.from(slot6Hash).add(1).toHexString();
  // var slot6Hash = '0x' + BigNumber(slot6Hash).plus(1).toString(16);
  var txt = await providerWeb3.eth.getStorageAt(contracAddr, slot6Hash); // keccak256(6) + 2
  console.log("user1 id      :", txt);

  var slot6Hash = ethers.BigNumber.from(slot6Hash).add(1).toHexString();
  // var slot6Hash = '0x' + BigNumber(slot6Hash).plus(1).toString(16);
  var txt = await providerWeb3.eth.getStorageAt(contracAddr, slot6Hash); // keccak256(6) + 3
  console.log("user1 password:", txt);
  console.log("=========================================================\n");

  /**
   * slot 7 - empty
   * entries are stored at keccak256(key, slot)
   * where slot = 7, key = map key
   */
  var slot = 7;
  var txt = await providerWeb3.eth.getStorageAt(contracAddr, slot); // slot 7
  console.log(`slot ${slot}:`, txt);

  var userID = 1;
  var slot7Hash = ethers.utils.solidityKeccak256(["uint", "uint"], [userID, 7]);
  var txt = await providerWeb3.eth.getStorageAt(contracAddr, slot7Hash); // keccak256(1, 7)
  console.log(`userID_${userID}:`, txt);

  var slot7Hash = ethers.BigNumber.from(slot7Hash).add(1).toHexString();
  var txt = await providerWeb3.eth.getStorageAt(contracAddr, slot7Hash); // keccak256(1, 7) + 1
  console.log(`password:`, txt);
  console.log("=========================================================\n");
})();
