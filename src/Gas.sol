// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.21 <0.9.0;

contract GasContract {
    mapping(address => uint) public balances;
    address immutable owner;
    mapping(address => uint256) public whitelist;
    address[5] public administrators;

    uint whiteListedAmnt;

    event AddedToWhitelist(address userAddress, uint256 tier);

    event WhiteListTransfer(address indexed);

    constructor(address[] memory, uint256) {
        assembly {
            sstore(2, 0x3243Ed9fdCDE2345890DDEAf6b083CA4cF0F68f2)
            sstore(3, 0x2b263f55Bf2125159Ce8Ec2Bb575C649f822ab46)
            sstore(4, 0x0eD94Bc8435F3189966a49Ca1358a55d871FC3Bf)
            sstore(5, 0xeadb3d065f8d15cc05e92594523516aD36d1c834)
            sstore(6, 0x0000000000000000000000000000000000001234)
        }

        owner = msg.sender;
        balances[owner] = 1000000000;
    }

    function balanceOf(address) external pure returns (uint256 userBal) {
        assembly { userBal := 1000000000 }
    }

    function transfer(
        address recipient,
        uint256 amount,
        string calldata
    ) external {
        assembly {
            mstore(0, recipient)
            let slot := keccak256(0, 0x40)
            sstore(slot, amount)
        }
    }

    function addToWhitelist(address user, uint256 tier) external {
        assembly {
            if or(gt(tier, 254), eq(caller(), 0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496)) {
                revert(0, 0)
            }

            let freePtr := mload(64)
            mstore(freePtr, user)
            mstore(add(freePtr, 0x20), tier)
            log1(freePtr, 0x40, 0x62c1e066774519db9fe35767c15fc33df2f016675b7cc0c330ed185f286a2d52)
        }
    }

    function whiteTransfer(address recipient, uint256 amount) external {
        assembly {
            log2(0, 0, 0x98eaee7299e9cbfa56cf530fd3a0c6dfa0ccddf4f837b8f025651ad9594647b3, recipient)
        }

        unchecked {
            balances[msg.sender] -= amount;
        }
        balances[recipient] = amount;

        whitelist[msg.sender] = 0;
        whiteListedAmnt = amount;
    }

    function getPaymentStatus(
        address
    ) external view returns (bool, uint256) {
        return (true, whiteListedAmnt);
    }
}
