// 编写一个 Bank 合约（代码提交到github）：
// • 通过 Metamask 向Bank合约存款（转账ETH）
// • 在Bank合约记录每个地址存款金额
// • 用数组记录存款金额前 3 名
// • 编写 Bank合约 withdraw(), 实现只有管理员提取出所有的 ETH
// 练习题
// https://decert.me/quests/c43324bc-0220-4e81-b533-668fa644c1c3

contract Bank {
    mapping(address => uint256) public balances;
    address[] public top3;
    address public admin;

    constructor() {
        admin = msg.sender;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        if (top3.length == 0) {
            top3.push(msg.sender);
        } else {
            for (uint256 i = 0; i < top3.length; i++) {
                if (balances[msg.sender] > balances[top3[i]]) {
                    // top3.insert(i, msg.sender);
                    if (top3.length > 3) {
                        top3.pop();
                    }
                    break;
                }
            }
        }
    }

    function withdraw() public {
        require(msg.sender == admin, "Only admin can withdraw");
        uint256 amount = address(this).balance;
        payable(admin).transfer(amount);
    }
}
