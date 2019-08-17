pragma solidity ^0.5.1;
pragma experimental ABIEncoderV2;

contract GeneDrugRepo {
    
    // This structure is how the data should be returned from the query function.
    // You do not have to store relations this way in your contract, only return them.
    // geneName and drugName must be in the same capitalization as it was entered. E.g. if the original entry was GyNx3 then GYNX3 would be considered incorrect.
    // Percentage values must be acurrate to 6 decimal places and will not include a % sign. E.g. "35.123456"
    struct GeneDrugRelation {
        string geneName;
        uint variantNumber;
        string drugName;
        uint totalCount;
        uint improvedCount;
        string improvedPercent; 
        uint unchangedCount;
        string unchangedPercent; 
        uint deterioratedCount;
        string deterioratedPercent; 
        uint suspectedRelationCount;
        string suspectedRelationPercent;
        uint sideEffectCount;
        string sideEffectPercent;
    }
    
    struct GeneDrugRelationSub {
        string geneName;
        uint variantNumber;
        string drugName;
        uint totalCount;
        uint improvedCount;
        uint unchangedCount;
        uint deterioratedCount;
        uint suspectedRelationCount;
        uint sideEffectCount;
    }
    
    
    //Code here
    mapping (bytes32 => GeneDrugRelationSub) public gene;
    GeneDrugRelation public _geneDrugRelation;
    //bytes32 public hashFunt;
    
    function insertObservation(string memory _geneName, uint _variantNumber, string memory _drugName,string memory outcome,  // IMPROVED, UNCHANGED, DETERIORATED. This will always be capitalized, you don't have to worry about case. 
        bool suspectedRelation, bool seriousSideEffect) public {
        bytes32 hashFun = keccak256(abi.encode(_geneName, _drugName, _variantNumber));
        //If hashfun exists, increase totalCount adn blah blah
        if(gene[hashFun].totalCount > 0) {
            gene[hashFun].totalCount++;
        } else {
            gene[hashFun] = GeneDrugRelationSub({
                    geneName: _geneName,
                    variantNumber: _variantNumber,
                    drugName: _drugName,
                    totalCount: 1,
                    improvedCount: 0,
                    unchangedCount: 0,
                    deterioratedCount: 0,
                    suspectedRelationCount: 0,
                    sideEffectCount: 0
                });
        }        
        if (keccak256(abi.encodePacked(outcome)) == keccak256(abi.encodePacked("IMPROVED"))) gene[hashFun].improvedCount++;
        if (keccak256(abi.encodePacked(outcome)) == keccak256(abi.encodePacked("UNCHANGED"))) gene[hashFun].unchangedCount++;
        if (keccak256(abi.encodePacked(outcome)) == keccak256(abi.encodePacked("DETERIORATED"))) gene[hashFun].deterioratedCount++;
        if (suspectedRelation) gene[hashFun].suspectedRelationCount++;
        if (seriousSideEffect) gene[hashFun].sideEffectCount++;
        
    }
    
    
    function getHash(string memory _geneName, uint _variantNumber, string memory _drugName) public pure returns(bytes32) {
        
        bytes32 hashFun = keccak256(abi.encode(_geneName, _drugName, _variantNumber));
        return hashFun;
    }
    
    function query(
        string memory geneName,
        string memory variantNumber,
        string memory drug
    ) public returns (GeneDrugRelation memory) {
        bytes32 hashFun = keccak256(abi.encode(geneName, drug, stringToUint(variantNumber)));
        return queryMain(hashFun);
        
    }
    
    function queryMain(
        bytes32 hashFunt
    ) public returns (GeneDrugRelation memory) {
        //GeneDrugRelation memory _geneDrugRelation;
        
         //hashFunt = keccak256(abi.encode(geneName, drug, stringToUint(variantNumber)));
        _geneDrugRelation = GeneDrugRelation({
            geneName: gene[hashFunt].geneName,
            variantNumber: gene[hashFunt].variantNumber,
            drugName: gene[hashFunt].drugName,
            totalCount: gene[hashFunt].totalCount,
            improvedCount: gene[hashFunt].improvedCount,
            improvedPercent: "imp",
            unchangedCount: gene[hashFunt].unchangedCount,
            unchangedPercent: "unch",
            deterioratedCount: gene[hashFunt].deterioratedCount,
            deterioratedPercent: "det",
            suspectedRelationCount: gene[hashFunt].suspectedRelationCount,
            suspectedRelationPercent: "sus",
            sideEffectCount: gene[hashFunt].sideEffectCount,
            sideEffectPercent: "side"
            
        });
        
        //TO DO: Return arrray instead of just 1 struct
        return _geneDrugRelation;
        
    }

    //function getGeneName () public returns (string memory __geneName){
    //    return _geneDrugRelation.geneName;
    //}

    
    

    
    
    /** HD Utilities Code here 1. uint to String (for variantNumber) 2. String to uint (for variantNumber)
    */
     //TESTED
    function uintToString(uint _i) pure public returns (string memory _uintAsString) {
        if (_i == 0) { return "0"; }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (_i != 0) {
            bstr[k--] = byte(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }
    
    //TESTED
    function stringToUint(string memory s) pure public returns (uint result) {
        bytes memory b = bytes(s);
        uint i;
        result = 0;
        for (i = 0; i < b.length; i++) {
            uint c = uint(uint8(b[i]));
            if (c >= 48 && c <= 57) {
                result = result * 10 + (c - 48);
            }
        }
    }
}
