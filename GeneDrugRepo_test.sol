pragma solidity >=0.4.0 <0.6.0;
pragma experimental ABIEncoderV2;
      import "remix_tests.sol"; // this import is automatically injected by Remix.
      import "./GeneDrugRepo.sol";
      // file name has to end with '_test.sol'
      contract GeneDrugRepo_test {

        GeneDrugRepo geneDrugRepoInstance;
        
        function beforeAll() public {
          // here should instantiate tested contract
          geneDrugRepoInstance = new GeneDrugRepo();
        }

        function testEntryExists() public {
          // use 'Assert' to test the contract
          //ADD DATA
          geneDrugRepoInstance.addMetaGeneDrugRelation("geneName", 5, "drugName", "UNCHANGED", true, false);
          geneDrugRepoInstance.addMetaGeneDrugRelation("geneName2", 50, "drugName2", "IMPROVED", false, true);
          
          //TEST 1ST ENTRY
          GeneDrugRepo.MetaGeneDrugRelation memory metaGeneDrugRelationInstance = geneDrugRepoInstance.getMetaGeneDrugRelation(0);
          Assert.equal(metaGeneDrugRelationInstance.geneName,"geneName", "Bad gene name");
          Assert.equal(metaGeneDrugRelationInstance.variantNumber,5, "Bad variant number");
          Assert.equal(metaGeneDrugRelationInstance.drugName, "drugName", "Bad drugName");
          Assert.notEqual(metaGeneDrugRelationInstance.variantNumber,6,"Bad variant number 2");
          Assert.ok(metaGeneDrugRelationInstance.suspectedRelation, "this was true");
          Assert.ok(!metaGeneDrugRelationInstance.seriousSideEffect, "this was false");
          
          //TEST 2ND ENTRY
          metaGeneDrugRelationInstance = geneDrugRepoInstance.getMetaGeneDrugRelation(1);
          Assert.equal(metaGeneDrugRelationInstance.geneName,"geneName2", "Bad gene name");
          Assert.equal(metaGeneDrugRelationInstance.variantNumber,50, "Bad variant number");
          Assert.equal(metaGeneDrugRelationInstance.drugName, "drugName2", "Bad drugName");
          Assert.equal(metaGeneDrugRelationInstance.outcome,"IMPROVED", "Bad outcome");
          Assert.notEqual(metaGeneDrugRelationInstance.variantNumber,6,"Bad variant number 2");
          Assert.ok(!metaGeneDrugRelationInstance.suspectedRelation, "this was true");
          Assert.ok(metaGeneDrugRelationInstance.seriousSideEffect, "this was false");
          
          Assert.ok(geneDrugRepoInstance.entryExists("*","*","*"), "Any entry Found");
          Assert.ok(!geneDrugRepoInstance.entryExists("*","*","b"), "drugName b Found??");
          Assert.ok(geneDrugRepoInstance.entryExists("*","*","drugName2"), "drugName2 entry not Found");
          Assert.ok(geneDrugRepoInstance.entryExists("*","50","*"),"variantNumber is incorrect");
          Assert.ok(geneDrugRepoInstance.entryExists("geneName2","*","*"),"geneName is incorrect");


        }

        function testUintToString() public {
            Assert.equal(geneDrugRepoInstance.uintToString(5), "5", "uintToString does not work fine");
            Assert.notEqual(geneDrugRepoInstance.uintToString(5), "4", "uintToString does not work fine");
        }
        
        function testStringToUint() public {
            Assert.equal(geneDrugRepoInstance.stringToUint("5"), 5, "bad string to uint");
            Assert.notEqual(geneDrugRepoInstance.stringToUint("5"), 4, "bad string to uint");
        }
      }
