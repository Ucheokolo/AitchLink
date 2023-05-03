// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "lib/foundry-starter-kit/lib/chainlink-brownie-contracts/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract LaunchPad {
    address public factoryOwner;
    address public launchPadCreator;
    address public launchPadToken;
    string public tokenName;
    uint public launchPadID;
    mapping(address => bool) public launchPadParticipant;
    uint public launchPadTokenSupply;
    AggregatorV3Interface internal ethPriceFeed;

    enum status{
        processing,
        active,
        concluded,
        canceled,
        suspended
    }

    struct launchpadDetails {
        uint id;
        address token;
        uint totalSupply;
        uint proposalTime;
        uint launchStart;
        uint duration;
        uint launchEnd;
        status launchpadStatus;
    }
    uint public launchID;
    mapping(address => launchpadDetails) public launchpadDetail;

    constructor(address _tokenAddr, string memory _tokenName, uint _Amount, address _factoryOwner) {
        ethPriceFeed = AggregatorV3Interface(0x1a81afB8146aeFfCFc5E50e8479e826E7D55b910);
        factoryOwner = _factoryOwner;
        // factoryAddr = address(this); // get this from factory contract(this will hold transferred launchpad token)
        launchPadCreator = msg.sender; // msg.sender calling the function in factory
        launchPadToken = _tokenAddr;
        launchPadTokenSupply = _Amount;
        tokenName = _tokenName;
        launchID = launchID + 1; // this should be implemented in factory contract
        proposeStart();
        IERC20(_tokenAddr).transferFrom(msg.sender, address(this), _Amount);

    }

    function admin() view internal {
        require(msg.sender == factoryOwner, "Unauthorized Operation" );
    }
    function creator() view internal{
        require(msg.sender == launchPadCreator, "Unauthorized Operation");
    }

    function proposeStart() internal {
        creator();
        require(launchPadTokenSupply > 0, "launchPadTokenSupply");
        launchpadDetails memory _launch;
        _launch.id = launchID;
        _launch.token = launchPadToken;
        _launch.proposalTime = block.timestamp;
        _launch.launchpadStatus = status.processing;
        launchpadDetail[launchPadToken] = _launch;
    }

    function activateLaunchpad() public {
        admin();
        launchpadDetails memory _launch;
        _launch.launchStart = block.timestamp;
        _launch.duration = 2 days;
        _launch.launchEnd = block.timestamp + 2 days;
        _launch.launchpadStatus = status.active;

        launchpadDetail[launchPadToken] = _launch;

    }

    function investInLaunchpad() public {

    }

//     function launchDeposit() public payable {
//         require(msg.value > 0, "Insufficient particitpation fund");
//         require(msg.sender != address(0), "Address zero!!!!");
//         require(totalPoolToken > 0, "launchPad token exhausted");
//         require(
//             msg.value <= totalPoolToken,
//             "Not enough tokens left, consider reducing purchase amount"
//         );
//         if (block.timestamp > launchpad.endLaunch) {
//             launchpad.inProgress = false;
//         }
//         require(launchpad.inProgress == true, "LaunchPad ended");

//         uint transferAmt = tokenEquivalent();
//         _mint(msg.sender, transferAmt);
//         totalPoolToken -= transferAmt;
//         if (participated[msg.sender] != true) {
//             lauchpadParticipants.push(msg.sender);
//         }
//     }

//     function retreiveFunds() public payable onlyOwner {
//         if (block.timestamp > launchpad.endLaunch) {
//             launchpad.inProgress = false;
//         }
//         require(launchpad.inProgress == false, "Sales in progress");
//         uint _amount = withdrawFunds();
//         (bool sent, bytes memory data) = address(msg.sender).call{
//             value: _amount
//         }("");
//         require(sent, "Failed to send Ether");
//     }

//     function withdrawFunds() internal view returns (uint) {
//         uint contractBal = address(this).balance;
//         return contractBal;
//     }

//     function tokenEquivalent() internal returns (uint) {
//         uint equiAmt = msg.value * 1;
//         return equiAmt;
//     }

function setRate() public returns(uint){
    uint contractEthBal = address(this).balance;
    // uint contractAitchBal = IERC20();

}

function getEthtPrice() internal view returns (int) {
        (
            /* uint80 roundID */,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = ethPriceFeed.latestRoundData();
        return price;
    }

    function getAitchPrice() pure internal returns(uint){
        uint price = 0.33 * 1000;
        return price;
        // when calling this, remember to divide by 1000 to reflect actual value.
    }



}
