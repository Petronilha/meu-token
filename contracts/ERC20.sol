// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "./IERC20.sol";

/// @title ERC20 Token Implementation
/// @author Daniel Petronilha
/// @notice Basic ERC20 token implementation with Mint(restricted) and Burn(public) capabilities.
contract ERC20 is IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    address public owner;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    string public name;
    string public symbol;
    uint8 public decimals;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    constructor(string memory _name, string memory _symbol, uint8 _decimals) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        owner = msg.sender;
    }

    function transfer(address recipient, uint256 amount) external returns (bool success) {
        require(balanceOf[msg.sender] >= amount, "Insufficient funds.");
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool success) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool success) {
        require(balanceOf[sender] >= amount, "Insufficient funds");
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    // --- Public Functions ---

    function totalAmountAddress() public view returns (uint256) {
        return balanceOf[msg.sender];
    }

    // --- Internal Functions --- 

    function _mint(address to, uint256 amount) internal {
        balanceOf[to] += amount;
        totalSupply += amount;
        emit Transfer(address(0), to, amount);
    }

    function _burn(address from, uint256 amount) internal {
        balanceOf[from] -= amount;
        totalSupply-= amount;
        emit Transfer(from, address(0), amount);
    }

    // --- Administrative Functions ---

    /// @notice Mints new tokens. Only the owner can call this.
    /// @param to The address that will receive the minted tokens.
    /// @param amount The amount of tokens to mint.
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    /// @notice Allows any user to burn their own tokens to reduce supply.
    /// @dev Uses msg.sender to ensure users can only burn their own funds.
    /// @param amount The amount of tokens to burn.
    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }
}