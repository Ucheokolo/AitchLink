// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "lib/foundry-starter-kit/lib/chainlink-brownie-contracts/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "lib/forge-std/src/console.sol";

contract LaunchPad {
    address public factoryOwner;
    address public launchPadCreator;
    address public aitchToken;
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
    // mapping(address => bool) public investorEth;
    // mapping(address => uint) public investorAmountEth;

    // Aitch Investors
    mapping(address => bool) public investorReceipt;
    mapping(address => uint) public investorAmount;

    constructor(address _tokenAddr, string memory _tokenName, address _factoryOwner, address _aitchToken) {
        // ethPriceFeed = AggregatorV3Interface(0x1a81afB8146aeFfCFc5E50e8479e826E7D55b910);
        factoryOwner = _factoryOwner;
        launchPadCreator = msg.sender; // msg.sender calling the function in factory
        launchPadToken = _tokenAddr; 
        tokenName = _tokenName;
        aitchToken = _aitchToken;
        proposeStart();
        console.log(launchPadTokenSupply);
    }

    function admin() view internal {
        require(msg.sender == factoryOwner, "Unauthorized Operation" );
    }
    // function creator() view internal{
    //     require(msg.sender == launchPadCreator, "Unauthorized Operation");
    // }

    function proposeStart() internal {
        
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
        launchPadTokenSupply = IERC20(launchPadToken).balanceOf(address(this));


    }

    function investLaunchpad(uint _amount) public {
        require(IERC20(aitchToken).balanceOf(msg.sender) > 0, "Insufficient Fund");
        investConditions();
        IERC20(aitchToken).transferFrom(msg.sender, address(this), _amount);
        investorReceipt[msg.sender] = true;
        investorAmount[msg.sender] += _amount;
    }

     function claimTokens() public {
        claimConditions();
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
        uint startTime = launchpadDetail[launchPadToken].launchStart;
        uint duration = launchpadDetail[launchPadToken].duration;
        require(investorReceipt[msg.sender] == true, "Invalid user");
        require(investorAmount[msg.sender] > 0, "No purchace records");
        if(block.timestamp > startTime + duration){
            launchpadDetail[launchPadToken].launchpadStatus = status.concluded;
        }
        require(launchpadDetail[launchPadToken].launchpadStatus == status.concluded, "launchpad Inprogress");
        uint rate = setTokenPrice();
        uint investment = investorAmount[msg.sender];
        uint claimable = rate * investment;
        IERC20(launchPadToken).transfer(msg.sender, claimable);
    }

    function setTokenPrice() view internal returns(uint){
        uint totalRevenue = IERC20(aitchToken).balanceOf(address(this));
        uint price = totalRevenue / launchPadTokenSupply;
        return price;

    }


}
