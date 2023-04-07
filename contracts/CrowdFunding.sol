//创建不同的募资活动，用来募集以太坊
//记录相应活动下的募资总体信息（参与人数，募集的以太坊数量），以及记录参与的用户地址及投入数量
//业务逻辑（用户参与，添加新的募集活动，活动结束后进行资金领取）

pragma solidity 0.8.19;

contract CrowdFundingStorage {
    struct Campaign{
         address payable receiver;  //募资接收地址
         uint numFunders;   //募捐人数
         uint fundingGoal;  //募捐目标金额
         uint totalAmount;  //募捐实际总金额
     }

     struct Funder{
         address addr;  //募捐人地址
         uint amount;   //募捐人募捐总金额
     }

    //活动数量
    uint public numCampaigns;
     //k 募资活动编号，v 募捐活动
     mapping(uint => Campaign) campaigns;
     //k 募资活动编号，v 募捐人列表
     mapping(uint => Funder[]) funders;

    //k1 募资活动编号，k2 参与人地址，v false 未参与，true 已参与
    mapping(uint => mapping(address => bool)) public isParticipate;
}

//支持多继承
contract CrowdFunding is CrowdFundingStorage{
    address immutable onwer;
    constructor(){
        //谁发布合约谁就是onwer
        onwer = msg.sender;
    }
     
     //判定用户不能参与因此相同活动
     modifier judgeParticipate(uint compaignID) {
         require(isParticipate[compaignID][msg.sender] == false);
         _; //通过require后，继续执行函数内容
     }

     //只有合约创建人才能创建募资活动
     modifier isOwner() {
         require(msg.sender == onwer);
         _;
     }

     //创建募资活动(入参：receiver 募捐活动接收地址，goal 募捐目标金额；返回参数：募捐活动编号)
     function newCampaign(address payable receiver, uint goal) external isOwner() returns(uint compaignID) {
        compaignID = numCampaigns++;    //todo compaignID算是定义了嘛？？？
        Campaign storage c = campaigns[compaignID]; //campaigns 不会数组越界嘛？？？
        c.receiver = receiver;
        c.fundingGoal = goal;
     }

    //参与募资活动
    function bid(uint campaignID) external payable judgeParticipate(campaignID){
        Campaign storage c = campaigns[campaignID];
        c.totalAmount += msg.value;
        c.numFunders += 1;
        //
        funders[campaignID].push(
            Funder({
                addr: msg.sender,
                amount: msg.value
            })
        );
        //
        isParticipate[campaignID][msg.sender] = true;
    }

     //活动结束后领取资金
     function withdraw(uint campaignID) external returns(bool reached) {
         Campaign storage c = campaigns[campaignID];
         if (c.fundingGoal > c.totalAmount) {
             return false;
         }
         uint amount = c.totalAmount;
         c.totalAmount = 0;
         c.receiver.transfer(amount);   //todo 转账过程是：募捐人钱包地址转到合约地址，合约地址再转到最终某钱包地址，这样是不是太消耗gas费用了？？？

         return true;
     }

}