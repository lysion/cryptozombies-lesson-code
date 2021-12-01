pragma solidity ^0.4.25;        //明确Solidity编译器版本

contract ZombieFactory {        //建立名为“ZombieFactory（僵尸工厂）”的“合约”

    event NewZombie(uint zombieId, string name, uint dna);          // 定义一个“事件”叫做“NewZombie”，包括3个参数：“zombieId”，“name”和“dna”。

    uint dnaDigits = 16;                    //定义僵尸DNA数字的位数为16位
    uint dnaModulus = 10 ** dnaDigits;      //为确保僵尸DNA数值位数为16位，需构造一个数“dnaModulus”，其数值等于10^16，任意整数对其取模后都不超过16位

    struct Zombie {                         //建立名为“Zombie”的结构体
        string name;                        //结构体内包括2个属性“name”和“dna”
        uint dna;
    }

    Zombie[] public zombies;                //建立数据类型为结构体“Zombie”的数组，定义为公共变量“zombies”
    
    //Solidity对函数和状态变量提供了四种可见性。分别是external,public,internal,private。其中函数默认是public。状态变量默认的可见性是internal。
    //interal - 函数只能通过内部访问（当前合约或者继承的合约），可在当前合约或继承合约中调用。
    //public - public标识的函数是合约接口的一部分。可以通过内部，或者消息来进行调用。
    //external - external标识的函数是合约接口的一部分。函数只能通过外部的方式调用。外部函数在接收大的数组时更有效。Java中无与此对应的关键字。
    //private - 只能在当前合约内访问，在继承合约中都不可访问。


    function _createZombie(string _name, uint _dna) private {       //建立函数“_createZombie（创建僵尸）”，函数参数包括“_name”和“_dna”，函数状态为私有（只能在当前合约内访问）
        uint id = zombies.push(Zombie(_name, _dna)) - 1;            //定义僵尸id，具体方法见下方拆分操作
            //上一行代码内容可拆分如下：
            //Zombie aZombie = Zombie(_name, _dna)；                    //创建结构体“Zombie”类型的结构，将其名称定义为“aZombie”，其“name”和“dna”来自函数的参数“_name”和“_dna”
            //zombies.push(aZombie);                                    //将“aZombie”添加到数组"zobies"之中
            //uint id = zombies.push(aZombie) - 1;                      //zombies.push(aZombie)的返回值为数组长度，加入元素后数值加1（待验证确认）；此处定义id为数组长度减1，因为数组的第一个元素的数值为0
        emit NewZombie(id, _name, _dna);                            //此处触发事件“NewZombie”
    }

    function _generateRandomDna(string _str) private view returns (uint) {          //建立函数“_generateRandomDna（生成随机DNA）”，参数为字符类型（string）的“_str”，函数状态为私有，包含数据类型为uint的返回值
                                                                                    //函数定义为“view”（只能读取数据不能更改数据），另一种函数定义为“pure”（函数不读取应用里的状态，返回值完全取决于输入参数）
        uint rand = uint(keccak256(abi.encodePacked(_str)));                        //使用keccak256散列函数生成伪随机十六进制数，存入“rand”，并将十六进制数转换为十进制的uint（abi.encodePacked对给定参数执行紧打包编码，是更准确的计算方法）
        return rand % dnaModulus;                                                   //将数值rand对之前定义的“dnaModulus”进行取模，使其位数不超过16位
    }

    function createRandomZombie(string _name) public {                              //建立函数“createRandomZombie（创建随机僵尸）”，参数为字符类型（string）的“_name”，函数状态为公开
        uint randDna = _generateRandomDna(_name);                                   //调用“_generateRandomDna”函数，返回randDna
        _createZombie(_name, randDna);                                              //调用“_createZombie”函数

}
