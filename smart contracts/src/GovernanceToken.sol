// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract GovernanceToken is ERC20 {
    event MintTokens(address _minter, address _to, uint _amount);

    address public admin;
    uint public mintCount;

    constructor(
        string memory _name,
        string memory _symbol,
        address _factoryOwner,
        address _recipient,
        uint _amount
    ) ERC20(_name, _symbol) {
        admin = _factoryOwner;
        mintTokens(_recipient, _amount);
        mintCount = _amount;
    }

    function onlyAdmin() internal view {
        require(msg.sender == admin, "Unauthorized Operation");
    }

    function mintTokens(address _recipient, uint _amount) internal {
        require(_recipient != address(0), "Invalid Address");
        _mint(_recipient, _amount);
        mintCount += _amount;

        emit MintTokens(msg.sender, _recipient, _amount);
    }

    function mintExtra(address _recipient, uint _amount) external {
        onlyAdmin();
        require(_recipient != address(0), "Invalid Address");
        _mint(_recipient, _amount);

        emit MintTokens(msg.sender, _recipient, _amount);
    }

    /**
     * @dev Being non transferrable, the Governance token does not implement any of the
     * standard ERC20 functions for transfer and allowance.
     **/
    function allowance(
        address owner,
        address spender
    ) public view virtual override returns (uint256) {
        owner;
        spender;
        revert("ALLOWANCE_NOT_SUPPORTED");
    }

    function approve(
        address spender,
        uint256 amount
    ) public virtual override returns (bool) {
        spender;
        amount;
        revert("APPROVAL_NOT_SUPPORTED");
    }

    function transfer(
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        recipient;
        amount;
        revert("TRANSFER_NOT_SUPPORTED");
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        sender;
        recipient;
        amount;
        revert("TRANSFER_NOT_SUPPORTED");
    }
}
