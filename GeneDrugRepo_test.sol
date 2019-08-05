pragma solidity >=0.4.0 <0.6.0;
pragma experimental ABIEncoderV2;
      //import "remix_tests.sol"; // this import is automatically injected by Remix.
      import "../contracts/GeneDrugRepo.sol";
      import "truffle/Assert.sol";
      import "truffle/DeployedAddresses.sol";
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
/*          GeneDrugRepo.MetaGeneDrugRelation memory metaGeneDrugRelationInstance = geneDrugRepoInstance.getMetaGeneDrugRelation(0);
          Assert.equal(metaGeneDrugRelationInstance.geneName,"geneName", "Bad gene name");
          Assert.equal(metaGeneDrugRelationInstance.variantNumber,5, "Bad variant number");
          Assert.equal(metaGeneDrugRelationInstance.drugName, "drugName", "Bad drugName");
          Assert.notEqual(metaGeneDrugRelationInstance.variantNumber,6,"Bad variant number 2");
          Assert.isTrue(metaGeneDrugRelationInstance.suspectedRelation, "this was true");
          Assert.isTrue(!metaGeneDrugRelationInstance.seriousSideEffect, "this was false");
*/          
          //TEST 2ND ENTRY
 /*         metaGeneDrugRelationInstance = geneDrugRepoInstance.getMetaGeneDrugRelation(1);
          Assert.equal(metaGeneDrugRelationInstance.geneName,"geneName2", "Bad gene name");
          Assert.equal(metaGeneDrugRelationInstance.variantNumber,50, "Bad variant number");
          Assert.equal(metaGeneDrugRelationInstance.drugName, "drugName2", "Bad drugName");
          Assert.equal(metaGeneDrugRelationInstance.outcome,"IMPROVED", "Bad outcome");
          Assert.notEqual(metaGeneDrugRelationInstance.variantNumber,6,"Bad variant number 2");
          Assert.isTrue(!metaGeneDrugRelationInstance.suspectedRelation, "this was true");
          Assert.isTrue(metaGeneDrugRelationInstance.seriousSideEffect, "this was false");
          
          Assert.isTrue(geneDrugRepoInstance.entryExists("*","*","*"), "Any entry Found");
          Assert.isTrue(!geneDrugRepoInstance.entryExists("*","*","b"), "drugName b Found??");
          Assert.isTrue(geneDrugRepoInstance.entryExists("*","*","drugName2"), "drugName2 entry not Found");
          Assert.isTrue(geneDrugRepoInstance.entryExists("*","50","*"),"variantNumber is incorrect");
          Assert.isTrue(geneDrugRepoInstance.entryExists("geneName2","*","*"),"geneName is incorrect");
*/

        }
        
        
        function testQuery() public {
            geneDrugRepoInstance.addMetaGeneDrugRelation("geneName", 5, "drugName", "UNCHANGED", true, false);
            geneDrugRepoInstance.addMetaGeneDrugRelation("geneName2", 50, "drugName2", "DETERIORATED", false, true);
            geneDrugRepoInstance.addMetaGeneDrugRelation("geneName", 5, "drugName2", "IMPROVED", false, true);
 
            GeneDrugRepo.GeneDrugRelation[] memory geneDrugRelationInstance = geneDrugRepoInstance.query("*","*","*");
//            Assert.equal(geneDrugRelationInstance[0].geneName, "geneName", "Something is wrong");
//	    Assert.equal(geneDrugRelationInstance[1].geneName, "geneName2", "Something is wrong");
//            Assert.equal(geneDrugRelationInstance[1].variantNumber, 50, "Something is wrong");
//            Assert.equal(geneDrugRelationInstance[2].geneName, "geneName", "Something is wrong");
            Assert.equal(geneDrugRelationInstance.length, 3, "Something is wrong");

/*
	    geneDrugRepoInstance.addMetaGeneDrugRelation("geneName", 5, "drugName2", "UNCHANGED", false, true);
            geneDrugRelationInstance = geneDrugRepoInstance.query("geneName","5","drugName2");
	    Assert.equal(geneDrugRelationInstance[0].geneName, "geneName", "Something is wrong");
	    Assert.equal(geneDrugRelationInstance[1].geneName, "geneName", "Something is wrong");
	    Assert.equal(geneDrugRelationInstance.length, 2, "Something is wrong");
            Assert.notEqual(geneDrugRelationInstance.length, 3, "Something is wrong");

	    geneDrugRelationInstance = geneDrugRepoInstance.query("*","50","drugName2");
	    Assert.equal(geneDrugRelationInstance[0].geneName, "geneName2", "Something is wrong");
	    Assert.equal(geneDrugRelationInstance.length, 2, "Something is wrong");

	    geneDrugRelationInstance = geneDrugRepoInstance.query("*","*","drugName2");
	    Assert.equal(geneDrugRelationInstance.length, 2, "Something is wrong");

*/

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
