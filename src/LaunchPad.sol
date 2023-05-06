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
        address token;
        uint totalSupply;
        uint proposalTime;
        uint launchStart;
        uint duration;
        uint launchEnd;
        status launchpadStatus;
    }
    
    mapping(address => launchpadDetails) public launchpadDetail;

    // Eth investors
    mapping(address => bool) public investorEth;
    mapping(address => uint) public investorAmountEth;

    // Aitch Investors
    mapping(address => bool) public investorAitch;
    mapping(address => uint) public investorAmountAitch;

    constructor(address _tokenAddr, string memory _tokenName, uint _Amount, address _factoryOwner) {
        ethPriceFeed = AggregatorV3Interface(0x1a81afB8146aeFfCFc5E50e8479e826E7D55b910);
        factoryOwner = _factoryOwner;
        launchPadCreator = msg.sender; // msg.sender calling the function in factory
        launchPadToken = _tokenAddr;
        launchPadTokenSupply = _Amount;
        tokenName = _tokenName;
    }

    function admin() view internal {
        require(msg.sender == factoryOwner, "Unauthorized Operation" );
    }
    function creator() view internal{
        require(msg.sender == launchPadCreator, "Unauthorized Operation");
    }

    function proposeStart() external {
        creator();
        launchPadTokenSupply = IERC20(launchPadToken).balanceOf(address(this));
        require(launchPadTokenSupply > 0, "launchPadTokenSupply");
        launchpadDetails memory _launch;
        _launch.token = launchPadToken;
        _launch.totalSupply = launchPadTokenSupply;
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

    function investWithEth() public payable {
        
        require(msg.value > 0, "Insufficient Fund");
        investConditions();
        investorEth[msg.sender] = true;
        investorAmountEth[msg.sender] += msg.value;

    }

    function investWithAitch(uint _amount, address _aitchToken) public {
        address aitch = _aitchToken;
        require(IERC20(aitch).balanceOf(msg.sender) > 0, "Insufficient Fund");
        investConditions();
        IERC20(aitch).transferFrom(msg.sender, address(this), _amount);
        investorAitch[msg.sender] = true;
        investorAmountAitch[msg.sender] += _amount;
    }

    function claimTokens() public {
        require(launchpadDetail[launchPadToken].launchpadStatus == status.concluded || launchpadDetail[launchPadToken].launchpadStatus == status.canceled, "Launchpad In-progress");
        require(investorEth[msg.sender] == true || investorAitch[msg.sender] == true, "Non-participant");
        require(msg.sender != factoryOwner || msg.sender != launchPadCreator, "Admins Prohibited");

        if(launchpadDetail[launchPadToken].launchpadStatus == status.concluded){
        claimConditions();
        }
        if(launchpadDetail[launchPadToken].launchpadStatus == status.canceled){
            retreiveConditions();
        }
    }

    function cancelLaunchpad() public {
        admin();
        launchpadDetail[launchPadToken].launchpadStatus = status.canceled;
    }

    function suspendLaunchpad() public {
        admin();
        if(launchpadDetail[launchPadToken].launchpadStatus == status.active){
            launchpadDetail[launchPadToken].launchpadStatus = status.suspended;
        } else if(launchpadDetail[launchPadToken].launchpadStatus == status.suspended){
            launchpadDetail[launchPadToken].launchpadStatus = status.active;
        } else return;
    }

    function investConditions() internal {
        uint startTime = launchpadDetail[launchPadToken].launchStart;
        uint duration = launchpadDetail[launchPadToken].duration;

        require(msg.sender != launchPadCreator && msg.sender != factoryOwner, "Admins Prohibited");

        require(msg.sender != address(0), "Unauthorized Operation");

        if(launchpadDetail[launchPadToken].launchpadStatus == status.processing) revert("Coming Soon");
        if(launchpadDetail[launchPadToken].launchpadStatus == status.canceled) revert("launchPad Canceled");
        if(launchpadDetail[launchPadToken].launchpadStatus == status.suspended) revert("launchPad Suspended");

        if(block.timestamp > startTime + duration){
            launchpadDetail[launchPadToken].launchpadStatus = status.concluded;
        }
        require(launchpadDetail[launchPadToken].launchpadStatus == status.active, "launchpad Concluded");
    }

    function claimConditions() internal {
        bool ethInvestor = investorEth[msg.sender];
        uint ethInvAmt = investorAmountEth[msg.sender];
        uint ethUsd = uint(getEthtPrice());
        uint usdEquiEth = ethInvAmt * ethUsd;

        bool aitchInvestor = investorAitch[msg.sender];
        uint aitchInvAmt = investorAmountAitch[msg.sender];
        uint aitchUsd = getAitchPrice();
        uint usdEquiAitch = aitchInvAmt * aitchUsd;

        require(ethInvestor == true || aitchInvestor == true, "Unauthorized Person");
        uint rate = setRate();
        if(ethInvAmt > 0){
            uint amtToReceiveEth = (rate * usdEquiEth)/ 10 ** 18;
            IERC20(launchPadToken).transfer(msg.sender, amtToReceiveEth);
        }
        if(aitchInvAmt > 0){
            uint amtToReceiveAitch = (rate * usdEquiAitch)/10 ** 18;
            IERC20(launchPadToken).transfer(msg.sender, amtToReceiveAitch);
        }


    }

    function retreiveConditions() internal{
        uint ethInvAmt = investorAmountEth[msg.sender];
        uint aitchInvAmt = investorAmountAitch[msg.sender];

        if(ethInvAmt > 0){
            (bool sent, bytes memory data) = address (msg.sender).call{
            value: ethInvAmt
        }("");
        require(sent, "Failed to send Ether");
        }
        if(aitchInvAmt > 0){
            address aitch = 0xF3164AAcb3Ed9EEa02bed546EFbC693BDf130d36;
            IERC20(aitch).transfer(msg.sender, aitchInvAmt);
        }
    }

    function setRate() view internal returns(uint){
    address aitch = 0xF3164AAcb3Ed9EEa02bed546EFbC693BDf130d36;
    // get total ether equivalent in usd
    uint contractEthBal = address(this).balance;
    uint ethUsdRate = uint(getEthtPrice());
    uint totalEthInUsd = contractEthBal * ethUsdRate;

    // get total aitch equvalent in usd
    uint contractAitchBal = IERC20(aitch).balanceOf(address(this));
    uint aitchUsdRate = getAitchPrice();
    uint totalAitchInUsd = (aitchUsdRate * contractAitchBal) / 10 ** 18;

    // get total revenue
    uint launchPadRevenue = totalEthInUsd + totalAitchInUsd;

    // launchpad token rate
    uint rate = (launchPadTokenSupply/launchPadRevenue)* (10 ** 18);
    return rate;
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
        uint price = 0.33 * (10 ** 18);
        return price;
        // when calling this, remember to divide by 1000 to reflect actual value.
    }

}
