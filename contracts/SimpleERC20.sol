//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {SafeMath} from "@openzeppelin/contracts/utils/math/SafeMath.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract SimpleERC20 is ERC20, Ownable {

    using SafeMath for uint256;
    uint private constant maxSupply = 1000000 * 10 ** 18;


    constructor () ERC20("SimpleERC20", "SERC20"){}

    // 1 ether equals 1000 tokens in the major currency of this token
    // Since this token uses 18 decimals,
    // in the minor currency, 1 wei equals tokens
    // No conversions are needed since msg.value is already in wei
    function buyToken(address reciever) public payable {
        require(msg.value > 0, "You didn't provide any ether");
        require(maxSupplyNotReached(msg.value), "Total Supply limit Reached");
        _mint(reciever, msg.value);

        withdrawPayment();
    }

    function maxSupplyNotReached(uint amount) internal view returns (bool) {
        return amount + totalSupply() <= maxSupply;
    }

    function withdrawPayment() internal {
        (bool sent, bytes memory data) = payable(owner()).call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }
}