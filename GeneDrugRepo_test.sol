pragma solidity >=0.4.0 <0.6.0;
      import "remix_tests.sol"; // this import is automatically injected by Remix.
      import "./GeneDrugRepo.sol";
      // file name has to end with '_test.sol'
      contract GeneDrugRepo_test {

        function beforeAll() public {
          // here should instantiate tested contract
          
          Assert.equal(uint(4), uint(3), "error in before all function");
        }

        function testEntryExists() public {
          // use 'Assert' to test the contract
          GeneDrugRepo geneDrugRepoInstance = new GeneDrugRepo();
          Assert.equal(geneDrugRepoInstance.entryExists("*","*","*"), true, "Any entry Found");
          Assert.equal(geneDrugRepoInstance.entryExists("b","b","b"), false, "Any entry Found");
          //Assert.equal(uint(2), uint(1), "error message");
          Assert.equal(uint(2), uint(2), "error message");
        }

        function testUintToString() public {
            GeneDrugRepo geneDrugRepoInstance = new GeneDrugRepo();
            Assert.equal(geneDrugRepoInstance.uintToString(5), "str 5", "uintToString does not work fine");
            Assert.equal(geneDrugRepoInstance.uintToString(5), "4", "uintToString works fine");
        }
      }
