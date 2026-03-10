// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AfterERC20 {
    error NotOwner();
    error Paused();
    error ZeroAddress();
    error ZeroAmount();
    error InsufficientBalance();
    error InsufficientAllowance();
    error LengthMismatch();

    string public constant name = "After Token";
    string public constant symbol = "AFTER";
    uint8 public constant decimals = 18;
    uint8 public constant transferFeePercent = 5;

    address public immutable owner;
    bool public paused;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner_, address indexed spender, uint256 amount);
    event TaxBurn(address indexed from, uint256 taxAmount);

    constructor(uint256 initialSupply) {
        owner = msg.sender;
        totalSupply = initialSupply;
        balanceOf[msg.sender] = initialSupply;

        emit Transfer(address(0), msg.sender, initialSupply);
    }

    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    function setPaused(bool newPaused) external onlyOwner {
        paused = newPaused;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        if (paused) revert Paused();
        if (spender == address(0)) revert ZeroAddress();

        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        if (paused) revert Paused();
        _transfer(msg.sender, to, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        if (paused) revert Paused();
        uint256 allowed = allowance[from][msg.sender];
        if (allowed < amount) revert InsufficientAllowance();

        unchecked {
            allowance[from][msg.sender] = allowed - amount;
        }

        emit Approval(from, msg.sender, allowance[from][msg.sender]);
        _transfer(from, to, amount);
        return true;
    }

    function _transfer(address from, address to, uint256 amount) internal {
        if (to == address(0)) revert ZeroAddress();
        if (amount == 0) revert ZeroAmount();

        uint256 fromBal = balanceOf[from];
        if (fromBal < amount) revert InsufficientBalance();

        uint256 taxAmount = (amount * transferFeePercent) / 100;
        uint256 sendAmount = amount - taxAmount;

        unchecked {
            balanceOf[from] = fromBal - amount;
            balanceOf[to] += sendAmount;
            totalSupply -= taxAmount;
        }

        emit Transfer(from, to, sendAmount);
        emit TaxBurn(from, taxAmount);
        emit Transfer(from, address(0), taxAmount);
    }

    function transferMany(address[] calldata recipients, uint256[] calldata amounts) external returns (bool) {
        if (paused) revert Paused();
        uint256 len = recipients.length;
        if (len != amounts.length) revert LengthMismatch();

        for (uint256 i; i < len; ) {
            _transfer(msg.sender, recipients[i], amounts[i]);
            unchecked {
                ++i;
            }
        }

        return true;
    }

    function duplicateTotalSupply() external view returns (uint256) {
        return totalSupply;
    }
}