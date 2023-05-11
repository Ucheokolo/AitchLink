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
        string name;
        uint totalSupply;
        uint proposalTime;
        uint launchStart;
        uint duration;
        uint launchEnd;
        status launchpadStatus;
    }
    
    mapping(address => launchpadDetails) public launchpadDetail;

    // investor amounts
    mapping(address => bool) public Investor;
    mapping(address => uint) public etherInvestment;
    mapping(address => uint) public aitchInvestment;

    constructor(address _tokenAddr, string memory _tokenName, address _factoryOwner, address _aitchToken) {
        // ethPriceFeed = AggregatorV3Interface(0x1a81afB8146aeFfCFc5E50e8479e826E7D55b910);
        factoryOwner = _factoryOwner;
        launchPadCreator = msg.sender; // msg.sender calling the function in factory
        launchPadToken = _tokenAddr; 
        tokenName = _tokenName;
        aitchToken = _aitchToken;
        proposeStart();
    }

    function admin() view internal {
        require(msg.sender == factoryOwner, "Unauthorized Operation" );
    }
    // function creator() view internal{
    //     require(msg.sender == launchPadCreator, "Unauthorized Operation");
    // }

    function launchPadStatus() view public returns(status){
        status currentStatus = launchpadDetail[launchPadToken].launchpadStatus;
        return currentStatus;
    }
    function proposeStart() internal {
        launchpadDetails memory _launch;
        _launch.token = launchPadToken;
        _launch.name = tokenName;
        _launch.proposalTime = block.timestamp;
        _launch.launchpadStatus = status.processing;
        launchpadDetail[launchPadToken] = _launch;
    }

    function activateLaunchpad() public {
        admin();
        launchPadTokenSupply = IERC20(launchPadToken).balanceOf(address(this));
        require(launchPadTokenSupply > 0, "Token Unavailable");
        launchpadDetails memory _launch;
        _launch.launchStart = block.timestamp;
        _launch.totalSupply = launchPadTokenSupply;
        _launch.duration = 2 days;
        _launch.launchEnd = block.timestamp + 2 days;
        _launch.launchpadStatus = status.active;

        launchpadDetail[launchPadToken] = _launch;
        


    }

    function investAitch(uint _amount) public {
        require(IERC20(aitchToken).balanceOf(msg.sender) > 0, "Insufficient Fund");
        investConditions();
        IERC20(aitchToken).transferFrom(msg.sender, address(this), _amount);
        Investor[msg.sender] = true;
        aitchInvestment[msg.sender] += _amount;
    }

    function investEther() payable public{
        require(msg.value > 0, "Insuficient Fund");
        investConditions();
        Investor[msg.sender] = true;
        etherInvestment[msg.sender] = msg.value;
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
        require(Investor[msg.sender] == true, "Invalid user");
        require(aitchInvestment[msg.sender] > 0, "No purchace records");
        if(block.timestamp > startTime + duration){
            launchpadDetail[launchPadToken].launchpadStatus = status.concluded;
        }
        require(launchpadDetail[launchPadToken].launchpadStatus == status.concluded, "launchpad Inprogress");
        uint rate = setTokenPrice();
        uint investment = aitchInvestment[msg.sender];
        console.log("investment", investment);
        uint claimable = investment / rate;
        IERC20(launchPadToken).transfer(msg.sender, claimable);
        aitchInvestment[msg.sender] = 0;
        
    }

    function setTokenPrice() view internal returns(uint){
        uint totalRevenue = IERC20(aitchToken).balanceOf(address(this));
        uint price = (totalRevenue * (10 ** 18)) / launchPadTokenSupply;
        console.log(launchPadTokenSupply);
        return price;

    }


}
