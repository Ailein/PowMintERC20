// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/access/Ownable2Step.sol";

contract PowERC20 is ERC20Capped, Ownable2Step {
    uint256 public price;
    bytes public workc;
    uint256 public limitPerMint;
    bytes32 public prevHash;

    constructor(
        bytes memory _workc,
        uint256 _limitPerMint,
        string memory name_,
        string memory symbol_,
        uint256 cap_,
        uint256 price_,
        address owner_
    ) ERC20Capped(cap_) ERC20(name_, symbol_) Ownable(owner_) {
        require(_workc.length <= 16, "too long");
        workc = _workc;
        limitPerMint = _limitPerMint;
        price = price_;
    }

    function withdrow(uint256 amount) public onlyOwner {
        payable(msg.sender).transfer(amount);
    }

    function setPrice(uint256 price_) public onlyOwner {
        price = price_;
    }

    function mint(uint256 nonce) public payable {
        require(msg.value >= price, "low price");
        bytes32 currentHash = keccak256(
            abi.encode(prevHash, msg.sender, msg.value, nonce)
        );

        uint256 length = workc.length;
        bool r = true;
        for (uint256 i = 0; i < length; ++i) {
            if (currentHash[i] != workc[i]) {
                r = false;
                break;
            }
        }
        if (r) {
            prevHash = currentHash;
            _mint(msg.sender, limitPerMint);
        }
    }
}
