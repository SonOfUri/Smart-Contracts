// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
// Source: https://ethereum.org/developers/docs/standards/tokens/erc-20
// function name() public view returns (string)
// function symbol() public view returns (string)
// function decimals() public view returns (uint8)
// function totalSupply() public view returns (uint256)
// function balanceOf(address _owner) public view returns (uint256 balance)
// function transfer(address _to, uint256 _value) public returns (bool success)
// function transferFrom(address _from, address _to, uint256 _value) public returns (bool success)
// function approve(address _spender, uint256 _value) public returns (bool success)
// function allowance(address _owner, address _spender) public view returns (uint256 remaining)

// event Transfer(address indexed _from, address indexed _to, uint256 _value)
// event Approval(address indexed _owner, address indexed _spender, uint256 _value)

contract ERC20{
    string public tokenName;
    string public tokenSymbol;
    uint8 public immutable decimals;
    uint256 public immutable totalSupply;
    // Mapping of all the balancves of all the holders of a token
    mapping (address => uint) _balances;
    // Mapping to allow others spend from holdings
    // spender => (owner => no of tokens allowed)
    mapping (address => mapping (address => uint256)) _allowances;
    // My Wallet For Taxes
    address public dev_wallet;


    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed owner, address indexed _spender, uint256 _value);

    constructor(string memory _name, string memory _symbol, uint256 _totalSupply, address _dev_wallet) {
        tokenName = _name;
        dev_wallet = _dev_wallet;
        tokenSymbol = _symbol;
        decimals = 18;
        totalSupply = _totalSupply;
        _balances[msg.sender] = _totalSupply;

    }

    function balanceOf(address _owner) public view returns (uint256) {
        require(_owner != address(0), "No!");
        return _balances[_owner];
    }

   function transfer(address _to, uint256 _value) public returns (bool) {
    uint256 fee = _value * 10 / 100; // Calculate 10% fee
    uint256 amountPlusFee = _value + fee; // Amount after deducting the fee
    uint256 amountAfterFee = _value - fee; // Amount after deducting the fee

    require(_balances[msg.sender] >= amountPlusFee, "Not Enough Balance!");
   

    // Deduct the full amount (including fee) from the sender
    _balances[msg.sender] -= amountPlusFee;

    // Add the amount after fee to the recipient
    _balances[_to] += amountAfterFee;

    // Transfer the fee to the dev_wallet
    _balances[dev_wallet] += fee;

    emit Transfer(msg.sender, _to, amountPlusFee);
    emit Transfer(msg.sender, dev_wallet, fee); // Emit an event for the fee transfer

    return true;
}


    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        uint256 fee = _value * 10 / 100; // Calculate 10% fee
        uint256 totalDebit = _value + fee; // Total amount to debit from the _from address

        require(_balances[_from] >= totalDebit, "Not Enough Balance!");
        require(_allowances[_from][msg.sender] >= totalDebit, "Insufficient Allowance!");

        // Deduct the total amount (including the fee) from the _from address
        _balances[_from] -= totalDebit;

        // Update the allowance
        _allowances[_from][msg.sender] -= totalDebit;

        // Add the original transfer amount to the _to address
        _balances[_to] += _value;

        // Transfer the fee to the dev_wallet
        _balances[dev_wallet] += fee;

        emit Transfer(_from, _to, _value);
        emit Transfer(_from, dev_wallet, fee); // Emit an event for the fee transfer

        return true;
}


    function approve(address _spender, uint256 _value) public returns (bool){
        require(_balances[msg.sender] >= _value , "NO Balance!");
        _allowances[_spender][msg.sender] = _value;

        emit Approval(msg.sender, _spender, _value);

        return true;
    }

    function allowance(address _owner, address _spender) public view returns(uint256) {
        return _allowances[_spender][_owner];
    }
}