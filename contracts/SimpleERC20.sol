//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {SafeMath} from "@openzeppelin/contracts/utils/math/SafeMath.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";


contract SimpleERC20 is ERC20, Ownable {

    using SafeMath for uint256;
    uint private immutable maxSupply;
    uint private immutable tokenPerEther;
    uint private constant ETHER_TO_WEI = 1000000000000000000;


    constructor () ERC20("SimpleERC20", "SERC20"){
        maxSupply = 1000000 * 10 ** decimals();
        tokenPerEther = 1000 * 10 ** decimals();
    }

    function buyToken(address reciever) public payable {
        require(valueIsWholeNumberEther(msg.value), "ether must be a whole number" );
        uint amount = valueToToken(msg.value);
        require(maxSupplyNotReached(amount), "Total Supply limit Reached");
        _mint(reciever, amount);
    }

    function valueIsWholeNumberEther(uint value) internal pure returns(bool) {
        return value % ETHER_TO_WEI == 0;
    }

    function valueToToken(uint value) internal view returns (uint) {
        return (value / ETHER_TO_WEI) * tokenPerEther;
    }

    function maxSupplyNotReached(uint amount) internal view returns (bool) {
        return amount + totalSupply() <= maxSupply;
    }

    function withdraw() public onlyOwner {
        (bool sent, bytes memory data) = payable(owner()).call{value: address(this).balance}("");
        require(sent, "Failed to send Ether");
    }
}