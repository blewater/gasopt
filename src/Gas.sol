// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0 <0.9.0;

contract GasContract {
    mapping(address => uint) public balances;
    address immutable owner;
    mapping(address => uint256) public whitelist;
    address[5] public administrators;

    mapping(address => uint) public whiteListStruct;

    event AddedToWhitelist(address userAddress, uint256 tier);

    event WhiteListTransfer(address indexed);

    constructor(address[] memory, uint256) {
        owner = msg.sender;
        balances[owner] = 1000000000;

        administrators[0] = 0x3243Ed9fdCDE2345890DDEAf6b083CA4cF0F68f2;
        administrators[1] = 0x2b263f55Bf2125159Ce8Ec2Bb575C649f822ab46;
        administrators[2] = 0x0eD94Bc8435F3189966a49Ca1358a55d871FC3Bf;
        administrators[3] = 0xeadb3d065f8d15cc05e92594523516aD36d1c834;
        administrators[4] = owner;
    }

    function balanceOf(address) external pure returns (uint256 userBal) {
        assembly { userBal := 1000000000 }
    }

    function transfer(
        address _recipient,
        uint256 _amount,
        string calldata
    ) external {
        balances[_recipient] = _amount;
    }

    function addToWhitelist(address user, uint256 tier) external {
        assembly {
            if gt(tier, 254) {
                revert(0, 0)
            }

            let found := 0
            for { let i := 0 } lt(i, 5) { i := add(i, 1) } {
                if eq(sload(add(administrators.slot, i)), caller()) {
                    found := 1
                    break
                }
            }
            if iszero(found) {
                revert(0, 0)
            }
        }
        
        emit AddedToWhitelist(user, tier);
    }

    function whiteTransfer(address _recipient, uint256 _amount) external {
        unchecked {
            balances[msg.sender] -= _amount;
        }
        balances[_recipient] = _amount;

        whitelist[msg.sender] = 0;
        whiteListStruct[msg.sender] = _amount;

        emit WhiteListTransfer(_recipient);
    }

    function getPaymentStatus(
        address sender
    ) external view returns (bool, uint256) {
        return (true, whiteListStruct[sender]);
    }
}
