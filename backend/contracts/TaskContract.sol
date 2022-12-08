// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

contract TaskContract {
  // recipient:address is the wallet address
  // taskId:uint unsigned integer
   event AddTask(address recipient,uint taskId);
   event DeleteTask(uint taskId,bool isDeleted);

   // note: turns out that solidity has event and it has funcitons
   /*
    function addTask(string memory taskText, bool isDeleted)
      external
      external <-- this external thing seems to indicate that the function is accessible from the outside (.. i think)
          also external seems to mean that its void
      when you define a string parameter.. apparently you have to use the memory key word.. i dunno why
      
   */
  
 function addTask(string memory taskText, bool isDeleted)
  external  
  {
    uint taskId = tasks.length; 
    tasks.push(Task(taskId,taskText,isDeleted));
    taskToOwner[taskId] = msg.sender; // apparently msg.sender gives the wallet of whoever created it. 
    emit AddTask(msg.sender,taskId);
  }

// get tasks that are mines and not deleted
  function getMyTasks() external view returns (Task[] memory)
  {
   Task[] memory temporary  =  new Task[](tasks.length);
    uint counter =0 ;
    for(uint i =0 ;i<tasks.length;i++)
    {
      if(taskToOwner[i]== msg.sender && tasks[i].isDeleted== false)
      {
        temporary[counter] = tasks[i];
      // temporary.push(tasks[i]);
        counter++;
      }      
    }
    
    Task[] memory result  =  new Task[](counter);

    for(uint i =0 ;i<counter;i++)
    {    
      result[i]= temporary[i];
    }
    return result;
  }

   function deleteTask(uint taskId,bool isDeleted) external
  {
    if(taskToOwner[taskId] == msg.sender)
    {
      tasks[taskId].isDeleted = isDeleted;
      emit DeleteTask(taskId,isDeleted);
    }
  }

  
  struct Task{
    uint id;
    string taskText;
    bool isDeleted;
    
  }

  Task[] private tasks;

  // this mapping thing seems to look like a dictionry
  // therefore the the key is of type unsingnedInteger256 and the values is of type address
  mapping (uint256=>address) taskToOwner;


  // it seems that the key in the mapping of taksToOwner will also correspond to the id of the Task
}
