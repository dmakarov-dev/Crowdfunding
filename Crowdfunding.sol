pragma solidity ^0.8.0;

contract Crowdfunding {
    address payable public creator;
    uint256 public goal;
    uint256 public deadline;
    uint256 public raised;
    mapping(address => uint256) public contributions;
    bool public goalReached;
    bool public open;
    
    constructor(uint256 _goal, uint256 _durationDays) {
        creator = payable(msg.sender);
        goal = _goal;
        deadline = block.timestamp + (_durationDays * 1 days);
        raised = 0;
        goalReached = false;
        open = true;
    }
    
    function contribute() public payable {
        require(open, "Campaign is closed");
        require(block.timestamp < deadline, "Deadline has passed");
        
        contributions[msg.sender] += msg.value;
        raised += msg.value;
        
        if (raised >= goal) {
            goalReached = true;
            open = false;
        }
    }
    
    function withdrawFunds() public {
        require(msg.sender == creator, "Only creator can withdraw funds");
        require(goalReached, "Goal not reached");
        
        creator.transfer(address(this).balance);
        open = false;
    }
    
    function cancelCampaign() public {
        require(msg.sender == creator, "Only creator can cancel campaign");
        require(!goalReached, "Goal already reached");
        
        open = false;
    }
}
