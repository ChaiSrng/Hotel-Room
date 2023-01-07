pragma solidity ^0.6.0;

//ether - pay sc
//modifiers
//visibility
//events
//enums 


contract HotelRoomPayment{

    address payable public owner;  //this address can receive payments so payable

    //we use enum to track the status of room
    //enums are used to keep the collection of statuses/options that never change. we can change within the mentioned list of optins in the enum to check any status of concerned
    enum RoomStatus {Vacant,Occupied}
    RoomStatus roomState;

    //event to notify room is booked
    event Occupy(address _occupant,uint _value);

    //constructor gets called only once wen the sc is created n deployed to the bc
    constructor() public{
        owner = msg.sender;         //msg.sender-ethereum address of user to calls the func in solidity

        //setting default value of room status to Vacant
        roomState = RoomStatus.Vacant;
    }

    modifier onlyWhileVacant{
        require(roomState == RoomStatus.Vacant, "Room not available");
        _;
    }

    modifier correctAmt(uint _amount){
        require(msg.value >= _amount , "Not enough ether provided");
        _;
    }

    //transfer money for booking room to the owner i.e who deployed the sc
    //while testing msg.value is the value of ether u have provided above deploy buton
    function book() public payable onlyWhileVacant correctAmt(2 ether){
        //instead of using the usual function call for book we can use a shorthand in solidity by calling receive
        //receive() will create a func tat will get called wenevr u pay this sc
        //external because it can be called outside
        //while testing for receive u put the amt in low level interactions bcus this is special func in slidity
    //receive() external payable onlyWhileVacant correctAmt(2 ether){
        
        //instead of having a requirement in the function we can create a modifier that does the same before entering inside the function
        //check room status
        //require(roomState == RoomStatus.Vacant, "Room not available");
        
        //check amt transfering
        //require(msg.value >= 2 ether, "Not enough ether provided");
        //adding modifier insetaed of require

        roomState= RoomStatus.Occupied;
        owner.transfer(msg.value);
        emit Occupy(msg.sender,msg.value);
    }

    function releaseRoom() public{
        require(roomState == RoomStatus.Occupied,"Room is already available");
        roomState = RoomStatus.Vacant;      
    }
}