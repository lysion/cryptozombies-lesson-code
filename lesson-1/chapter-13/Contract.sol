pragma solidity ^0.4.25;        //明确Solidity编译器版本

contract ZombieFactory {        //建立名为“僵尸工厂”的合约

    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;                    //定义僵尸DNA数字的位数为16位
    uint dnaModulus = 10 ** dnaDigits;      //为确保僵尸DNA数值位数为16位，需构造一个数值等于10^16，任意整数对其取模后都不超过16位

    struct Zombie {                         //建立名为“Zombie”的结构体
        string name;                        //结构体包括2个属性“name”,“dna”
        uint dna;
    }

    Zombie[] public zombies;                //建立数据类型为结构体“Zombie”的数组，命名为“zombies”的公共变量
    
    //Solidity对函数和状态变量提供了四种可见性。分别是external,public,internal,private。其中函数默认是public。状态变量默认的可见性是internal。
    //interal - 函数只能通过内部访问（当前合约或者继承的合约），可在当前合约或继承合约中调用。
    //public - public标识的函数是合约接口的一部分。可以通过内部，或者消息来进行调用。
    //external - external标识的函数是合约接口的一部分。函数只能通过外部的方式调用。外部函数在接收大的数组时更有效。Java中无与此对应的关键字。
    //private - 只能在当前合约内访问，在继承合约中都不可访问。


    function _createZombie(string _name, uint _dna) private {       //建立函数“_createZombie（创建僵尸）”，函数参数包括“name”和“dna”，函数状态为私有
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        emit NewZombie(id, _name, _dna);
    }

    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string _name) public {
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}
