pragma solidity >=0.4.0 <0.6.0;
pragma experimental ABIEncoderV2;
      //import "remix_tests.sol"; // this import is automatically injected by Remix.
      import "../contracts/GeneDrugRepo.sol";
      import "truffle/Assert.sol";
      import "truffle/DeployedAddresses.sol";
      // file name has to end with '_test.sol'
      contract GeneDrugRepo_test2 {

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
          
          //TEST 2ND ENTRY
          metaGeneDrugRelationInstance = geneDrugRepoInstance.getMetaGeneDrugRelation(1);
          

        }
        
        
        function testQuery() public {
            geneDrugRepoInstance.addMetaGeneDrugRelation("geneName", 5, "drugName", "UNCHANGED", true, false);
            geneDrugRepoInstance.addMetaGeneDrugRelation("geneName2", 50, "drugName2", "DETERIORATED", false, true);
            geneDrugRepoInstance.addMetaGeneDrugRelation("geneName", 5, "drugName2", "IMPROVED", false, true);


	    geneDrugRepoInstance.addMetaGeneDrugRelation("geneName", 5, "drugName2", "UNCHANGED", false, true);

        }
        

	function testQuery_2() public {

	    GeneDrugRepo.GeneDrugRelation[] memory geneDrugRelationInstance = geneDrugRepoInstance.query("*","5","*");
            Assert.equal(geneDrugRelationInstance.length, 2, "Something is wrong");

	    geneDrugRelationInstance = geneDrugRepoInstance.query("geneName2","*","drugName2");
            Assert.equal(geneDrugRelationInstance.length, 1, "Something is wrong");
            Assert.equal(geneDrugRelationInstance[0].totalCount, 2, "Something is wrong");
	    Assert.equal(geneDrugRelationInstance[0].improvedCount, 1, "Something is wrong");
            Assert.equal(geneDrugRelationInstance[0].deterioratedCount, 1, "Something is wrong");

//	    geneDrugRelationInstance = geneDrugRepoInstance.query("geneName","*","*");
//            Assert.equal(geneDrugRelationInstance.length, 2, "Something is wrong");

//	    geneDrugRelationInstance = geneDrugRepoInstance.query("geneName","5","*");
//            Assert.equal(geneDrugRelationInstance.length, 2, "Something is wrong");

	}

      }
