// • 属性：.balance （ether）
// • 成员 x.transfer() / send()
// • 2300 gas 限制
// • 底层调用：call，staticcall（不修改状态）、delegatecall，
// • 底层调用失败不会冒泡异常（ revert），而是用返回值表示
// • call()： 切换上下文
// • delegatecall()： 保持上下文