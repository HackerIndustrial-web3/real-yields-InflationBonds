// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/* import "@openzeppelin/contracts/token/ERC20/ERC20.sol"; */
import "OpenZeppelin/openzeppelin-contracts@4.0.0/contracts/token/ERC20/IERC20.sol";
import "OpenZeppelin/openzeppelin-contracts@4.0.0/contracts/utils/math/SafeMath.sol";
import "./InflationToken.sol";


contract InflationExchange  {
  IERC20 token;

  constructor(address token_addr){
    token = IERC20(token_addr);
  }

  uint256 public totalLiquidity;
  mapping (address => uint256) public liquidity;


  function init(uint256 tokens) public payable returns (uint256){
    require(totalLiquidity==0, "liquidity already innitiated");
    totalLiquidity = address(this).balance;
    liquidity[msg.sender] = totalLiquidity;
    require(token.transferFrom(msg.sender, address(this), tokens));
    return totalLiquidity;
  }

  function price(
    uint256 input_amount,
    uint256 input_reserve,
    uint256 output_reserve) public view returns (uint256){
      uint256 input_amount_with_fee = input_amount * 997;
      uint256 numerator = input_amount_with_fee * (output_reserve);
      uint256 denominator = input_reserve * (1000) + (input_amount_with_fee);
      return numerator / denominator;
    }

    function maticToToken() public payable returns (uint256){
      uint256 token_reserve = token.balanceOf(address(this));
      uint256 tokens_bought = price(msg.value, address(this).balance - msg.value, token_reserve);
      require(token.transfer(msg.sender, tokens_bought));

      return tokens_bought;

    }

    function ethToToken() public payable returns (uint256){
      uint256 token_reserve = token.balanceOf(address(this));
      uint256 tokens_bought = price(msg.value, address(this).balance - msg.value, token_reserve);
      return tokens_bought;
    }

    function tokenToMatic(uint256 tokens) public returns (uint256) {
      uint256 token_reserve = token.balanceOf(address(this));
      uint256 eth_bought = price(tokens, token_reserve, address(this).balance);
      payable(msg.sender).transfer(eth_bought);
      require(token.transferFrom(msg.sender, address(this), tokens));
      return eth_bought;
    }


  }
