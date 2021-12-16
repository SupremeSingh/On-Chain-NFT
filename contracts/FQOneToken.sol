// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FQOneToken is ERC20, Ownable {

    uint8 private immutable _decimals;
    address private ownerAddress = 0x3Dd7050e65a2557a78d9ddb3eD796860be735435;

    constructor(
        uint256 initialBalance,
        uint8 decimals_
    ) payable ERC20("Financial Quarter One", "FQ1") {
        _mint(ownerAddress, initialBalance);
         _decimals = decimals_;
    }

    function mint(address account, uint256 amount) public onlyOwner {
        _mint(account, amount);
    }

    function burn(address account, uint256 amount) public onlyOwner {
        _burn(account, amount);
    }

    function decimals() public view virtual override returns (uint8) {
        return _decimals;
    }

    function transferInternal(
        address from,
        address to,
        uint256 value
    ) public {
        _transfer(from, to, value);
    }

    function approveInternal(
        address owner,
        address spender,
        uint256 value
    ) public {
        _approve(owner, spender, value);
    }
}