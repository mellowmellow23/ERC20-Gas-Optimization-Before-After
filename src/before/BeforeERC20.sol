// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BeforeERC20 {
    string public name;
    string public symbol;
    uint8 public decimals;

    uint256 public totalSupply;
    uint256 public duplicateTotalSupply;
    uint256 public transferFeePercent;

    address public owner;
    bool public paused;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner_, address indexed spender, uint256 amount);
    event TaxBurn(address indexed from, uint256 taxAmount);
    event DebugTransfer(address indexed from, address indexed to, uint256 grossAmount, uint256 netAmount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier notPaused() {
        require(paused == false, "Paused");
        _;
    }

    constructor(uint256 initialSupply) {
        name = "Before Token";
        symbol = "BEFORE";
        decimals = 18;
        owner = msg.sender;
        transferFeePercent = 5;
        paused = false;

        totalSupply = initialSupply;
        duplicateTotalSupply = initialSupply;
        balanceOf[msg.sender] = initialSupply;

        emit Transfer(address(0), msg.sender, initialSupply);
    }

    function setPaused(bool newPaused) external onlyOwner {
        paused = newPaused;
    }

    function approve(address spender, uint256 amount) external notPaused returns (bool) {
        require(spender != address(0), "Zero spender");

        allowance[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);
        emit Approval(msg.sender, spender, amount);

        return true;
    }

    function transfer(address to, uint256 amount) external notPaused returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external notPaused returns (bool) {
        require(allowance[from][msg.sender] >= amount, "Allowance exceeded");

        allowance[from][msg.sender] = allowance[from][msg.sender] - amount;
        emit Approval(from, msg.sender, allowance[from][msg.sender]);

        _transfer(from, to, amount);
        return true;
    }

    function _transfer(address from, address to, uint256 amount) internal {
        require(to != address(0), "Zero address");
        require(balanceOf[from] >= amount, "Insufficient balance");
        require(amount > 0, "Zero amount");

        uint256 feeRate = transferFeePercent;
        uint256 taxAmount = (amount * feeRate) / 100;
        uint256 sendAmount = amount - taxAmount;

        uint256 senderBalance = balanceOf[from];
        uint256 receiverBalance = balanceOf[to];
        uint256 supplyA = totalSupply;
        uint256 supplyB = duplicateTotalSupply;

        senderBalance = senderBalance - amount;
        receiverBalance = receiverBalance + sendAmount;
        supplyA = supplyA - taxAmount;
        supplyB = supplyB - taxAmount;

        balanceOf[from] = senderBalance;
        balanceOf[to] = receiverBalance;
        totalSupply = supplyA;
        duplicateTotalSupply = supplyB;

        emit Transfer(from, to, sendAmount);
        emit TaxBurn(from, taxAmount);
        emit Transfer(from, address(0), taxAmount);
        emit DebugTransfer(from, to, amount, sendAmount);
    }

    function transferMany(address[] calldata recipients, uint256[] calldata amounts) external notPaused returns (bool) {
        require(recipients.length == amounts.length, "Length mismatch");

        for (uint256 i = 0; i < recipients.length; i++) {
            _transfer(msg.sender, recipients[i], amounts[i]);
        }

        return true;
    }
}