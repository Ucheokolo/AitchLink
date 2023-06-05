// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "lib/foundry-starter-kit/lib/chainlink-brownie-contracts/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "lib/forge-std/src/console.sol";

contract LaunchPad {
    ///// Events /////
    event LaunchpadProposed(address _proposer, address _token, uint _time);
    event LaunchpadActivated(address _activator, uint _time);
    event UserInvestment(address _investor, uint _amount);
    event TokenClaim(address _claimer, address _token, uint _amount);
    event CancelLaunchpad(address _admin, uint _time);
    event SuspendLaunchpad(address _admin, uint _time);
    event AdminWithdrawal(address _admin, uint _amount, uint _time);

    ///// Basic information /////
    address public factoryOwner;
    address public launchPadCreator;
    address public aitchToken;
    address public launchPadToken;
    string public tokenName;
    uint public launchPadTokenSupply;
    AggregatorV3Interface internal ethPriceFeed;

    ///// launchpad Status Details /////
    enum status {
        processing,
        active,
        concluded,
        canceled,
        suspended
    }

    ///// Launchpad Details /////
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

    ///// investor Participation /////
    mapping(address => bool) public Investor;
    mapping(address => uint) public etherInvestment;
    mapping(address => uint) public aitchInvestment;

    ///// Confirm Token claims /////
    mapping(address => bool) public investorClaimed;
    bool private commissionClaimed;

    constructor(
        address _tokenAddr,
        string memory _tokenName,
        address _factoryOwner,
        address _creator,
        address _aitchToken
    ) {
        ethPriceFeed = AggregatorV3Interface(
            0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        );
        factoryOwner = _factoryOwner;
        launchPadCreator = _creator; // msg.sender calling the function in factory
        launchPadToken = _tokenAddr;
        tokenName = _tokenName;
        aitchToken = _aitchToken;
        proposeStart();
    }

    ///// Function Modifiers /////

    function admin() internal view {
        require(msg.sender == factoryOwner, "Unauthorized Operation");
    }

    function creatorAdmin() internal view {
        require(msg.sender == launchPadCreator, "Unauthorized Operation");
    }

    ///// Read functions /////

    function launchpadName() public view returns (string memory) {
        return (string.concat(tokenName, " Launchpad"));
    }

    function launchPadTokenSupply_() public view returns (uint) {
        return launchPadTokenSupply;
    }

    function launchPadStatus() public view returns (status) {
        status currentStatus = launchpadDetail[launchPadToken].launchpadStatus;
        return currentStatus;
    }

    function getUserInvestment() public view returns (uint, uint) {
        uint investmentAmountEther = etherInvestment[msg.sender];
        uint investmentAmountAitch = aitchInvestment[msg.sender];
        return (investmentAmountEther, investmentAmountAitch);
    }

    function hasClaimed(address _investor) public view returns (bool) {
        return investorClaimed[_investor];
    }

    ///// Write functions /////

    function proposeStart() internal {
        launchpadDetails memory _launch;
        _launch.token = launchPadToken;
        _launch.name = tokenName;
        _launch.proposalTime = block.timestamp;
        _launch.launchpadStatus = status.processing;
        launchpadDetail[launchPadToken] = _launch;

        emit LaunchpadProposed(msg.sender, launchPadToken, block.timestamp);
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

        emit LaunchpadActivated(msg.sender, block.timestamp);
    }

    function investAitch(uint _amount) public {
        require(
            IERC20(aitchToken).balanceOf(msg.sender) > 0,
            "Insufficient Fund"
        );
        investConditions();
        IERC20(aitchToken).transferFrom(msg.sender, address(this), _amount);
        Investor[msg.sender] = true;
        aitchInvestment[msg.sender] += _amount;

        emit UserInvestment(msg.sender, _amount);
    }

    function investEther() public payable {
        require(msg.value > 0, "Insuficient Fund");
        investConditions();

        Investor[msg.sender] = true;
        etherInvestment[msg.sender] = msg.value;

        emit UserInvestment(msg.sender, msg.value);
    }

    function claimTokens() public {
        require(Investor[msg.sender] == true, "Invalid user");
        require(investorClaimed[msg.sender] == false, "Token Claimed");

        userWithdrawCondition();

        investorClaimed[msg.sender] = true;
    }

    function cancelLaunchpad() public {
        admin();
        status contractStatus = launchpadDetail[launchPadToken].launchpadStatus;
        require(
            contractStatus != status.canceled ||
                contractStatus != status.concluded,
            "Launchpad Finalized"
        );

        launchpadDetail[launchPadToken].launchpadStatus = status.canceled;

        emit CancelLaunchpad(msg.sender, block.timestamp);
    }

    function suspendLaunchpad() public {
        admin();
        if (launchpadDetail[launchPadToken].launchpadStatus == status.active) {
            launchpadDetail[launchPadToken].launchpadStatus = status.suspended;
        } else if (
            launchpadDetail[launchPadToken].launchpadStatus == status.suspended
        ) {
            launchpadDetail[launchPadToken].launchpadStatus = status.active;
        } else return;

        emit SuspendLaunchpad(msg.sender, block.timestamp);
    }

    function payCreator(address _recipient, uint _amount) public {
        admin();
        require(commissionClaimed == true, "Withdraw Commissions First");
        require(_recipient == launchPadCreator, "Unauthorized Recipient");
        PayCreatorConditions();
        IERC20(aitchToken).transfer(launchPadCreator, _amount);

        emit AdminWithdrawal(msg.sender, _amount, block.timestamp);
    }

    function withdrawCommission() public {
        admin();
        commissionConditions();

        commissionClaimed = true;
    }

    ///// Internal functions /////

    function investConditions() internal {
        uint startTime = launchpadDetail[launchPadToken].launchStart;
        uint duration = launchpadDetail[launchPadToken].duration;

        require(
            msg.sender != launchPadCreator && msg.sender != factoryOwner,
            "Admins Prohibited"
        );

        require(msg.sender != address(0), "Unauthorized Operation");

        if (
            launchpadDetail[launchPadToken].launchpadStatus == status.processing
        ) revert("Coming Soon");
        if (launchpadDetail[launchPadToken].launchpadStatus == status.canceled)
            revert("launchPad Canceled");
        if (launchpadDetail[launchPadToken].launchpadStatus == status.suspended)
            revert("launchPad Suspended");

        if (block.timestamp > startTime + duration) {
            launchpadDetail[launchPadToken].launchpadStatus = status.concluded;
        }
        require(
            launchpadDetail[launchPadToken].launchpadStatus == status.active,
            "launchpad Concluded"
        );
    }

    function userWithdrawCondition() internal {
        uint duration = launchpadDetail[launchPadToken].launchEnd;

        if (block.timestamp > duration) {
            if (
                launchpadDetail[launchPadToken].launchpadStatus !=
                status.canceled
            ) {
                launchpadDetail[launchPadToken].launchpadStatus = status
                    .concluded;
            }
        }

        require(
            launchpadDetail[launchPadToken].launchpadStatus ==
                status.concluded ||
                launchpadDetail[launchPadToken].launchpadStatus ==
                status.canceled,
            "launchpad Inprogress"
        );
        status contractStatus = launchpadDetail[launchPadToken].launchpadStatus;
        // console.log(contractStatus);
        if (contractStatus == status.concluded) {
            claimLauchpadTokenConditions();
        }
        if (contractStatus == status.canceled) {
            retrieveConditions();
        }
    }

    function claimLauchpadTokenConditions() internal {
        uint aitchI = aitchInvestment[msg.sender];
        uint ethI = etherInvestment[msg.sender];
        uint rate = setTokenPrice();
        if (aitchI > 0) {
            uint claimable = (aitchI * rate) / (10 ** 18);
            IERC20(launchPadToken).transfer(msg.sender, claimable);

            emit TokenClaim(msg.sender, launchPadToken, claimable);
        }
        if (ethI > 0) {
            uint ethAitchRates = uint(getLatestPrice()) / (10 ** 8);
            uint userInvInAitch = ethAitchRates * ethI;
            uint claimable = (userInvInAitch * rate) / (10 ** 18);
            IERC20(launchPadToken).transfer(msg.sender, claimable);
            emit TokenClaim(msg.sender, launchPadToken, claimable);
        }
    }

    function retrieveConditions() internal {
        uint ethInv = etherInvestment[msg.sender];
        uint aitchInv = aitchInvestment[msg.sender];

        if (aitchInv > 0) {
            // aitchInvestment[msg.sender] = 0;
            IERC20(aitchToken).transfer(msg.sender, aitchInv);
        }
        if (ethInv > 0) {
            // etherInvestment[msg.sender] = 0;
            (bool sent, ) = payable(msg.sender).call{value: ethInv}("");
            require(sent, "Failed to send Ether");
        }
    }

    function commissionConditions() internal {
        status launchpadState = launchpadDetail[launchPadToken].launchpadStatus;
        uint totalRevenueAitch = IERC20(aitchToken).balanceOf(address(this));
        uint totalRevenueEth = address(this).balance;
        uint percentage = 5e16;

        if (launchpadState == status.canceled) revert("Launchpad Canceled");
        require(
            launchpadState == status.concluded,
            "Withdrawal Unavailable at this Time"
        );
        require(commissionClaimed == false, "Already Withdrawn");

        uint commissionAitch = (totalRevenueAitch * percentage) / 1e18;

        uint commissionEth = (totalRevenueEth * percentage) / 1e18;

        if (totalRevenueAitch > 0) {
            IERC20(aitchToken).transfer(factoryOwner, commissionAitch);
        }
        if (totalRevenueEth > 0) {
            (bool sent, ) = payable(msg.sender).call{value: commissionEth}("");
            require(sent, "Failed to send Ether");
        }
    }

    function PayCreatorConditions() internal view {
        status contractStatus = launchpadDetail[launchPadToken].launchpadStatus;
        require(
            contractStatus == status.concluded ||
                contractStatus == status.canceled,
            "Launchpad inprogress"
        );
        require(
            IERC20(aitchToken).balanceOf(address(this)) > 0,
            "Insufficient Funds"
        );
    }

    function setTokenPrice() internal view returns (uint) {
        uint ethBal = address(this).balance;
        uint ethAitchRates = uint(getLatestPrice()) / (10 ** 8);
        uint revenueEther = ethBal * ethAitchRates;
        // console.log(revenueEther);

        uint revenueAitch = IERC20(aitchToken).balanceOf(address(this));
        uint totalRevenue = revenueAitch + revenueEther;
        uint price = (launchPadTokenSupply * (10 ** 18)) / totalRevenue;
        return price;
    }

    function getLatestPrice() public view returns (int) {
        // prettier-ignore
        (
            /* uint80 roundID */,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = ethPriceFeed.latestRoundData();
        return price;
    }
}
