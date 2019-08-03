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
    
    struct MetaGeneDrugRelation {
        string geneName;
        uint variantNumber;
        string drugName;
        string outcome;
        bool suspectedRelation;
        bool seriousSideEffect;
    }
    
    
    
    
    
    //Code here
    GeneDrugRelation[] geneDrugRelation;
    MetaGeneDrugRelation[] public metaGeneDrugRelation;
    
    MetaGeneDrugRelation metaGeneDrugRelationInstance = MetaGeneDrugRelation({
            geneName: "geneName",
            variantNumber: 5,
            drugName: "drugName",
            outcome: "outcome",
            suspectedRelation: true,
            seriousSideEffect: false
          });
    
    
    function getMetaGeneDrugRelation(uint index) public view returns (MetaGeneDrugRelation memory) {
        return metaGeneDrugRelation[index];
    }
    
    function addMetaGeneDrugRelation(string memory geneName, uint variantNumber, string memory drugName, string memory outcome,  // IMPROVED, UNCHANGED, DETERIORATED. This will always be capitalized, you don't have to worry about case. 
        bool suspectedRelation, bool seriousSideEffect) public {
            metaGeneDrugRelation.push(MetaGeneDrugRelation({
                    geneName: geneName,
                    variantNumber: variantNumber,
                    drugName: drugName,
                    outcome: outcome,
                    suspectedRelation: suspectedRelation,
                    seriousSideEffect: seriousSideEffect
                }));
        }
    
    
    mapping (address => uint) public observationCountOf;
    
    /** Insert an observation into your contract, following the format defined in the data readme. 
        This function has no return value. If it completes it will be assumed the observations was recorded successfully. 

        Note: case matters for geneName and drugName. GyNx3 and gynx3 are treated as different genes.
     */
     /**
    function insertObservation (
        string memory geneName,
        uint variantNumber,
        string memory drugName,
        string memory outcome,  // IMPROVED, UNCHANGED, DETERIORATED. This will always be capitalized, you don't have to worry about case. 
        bool suspectedRelation,
        bool seriousSideEffect
    ) public {
        // Code here
        for(uint i = 0; i < geneDrugRelation.length; i++) {
            if(keccak256(abi.encodePacked(geneDrugRelation[i].geneName)) == keccak256(abi.encodePacked(geneName)) && keccak256(abi.encodePacked(geneDrugRelation[i].variantNumber)) == keccak256(abi.encodePacked(variantNumber)) && keccak256(abi.encodePacked(geneDrugRelation[i].drugName)) == keccak256(abi.encodePacked(drugName))) {
                geneDrugRelation[i].totalCount++;
                if(keccak256(abi.encodePacked(outcome)) == keccak256(abi.encodePacked("IMPROVED"))) {
                    geneDrugRelation[i].improvedCount++;
                    uint percent = (geneDrugRelation[i].improvedCount / geneDrugRelation[i].totalCount)*100;
                    geneDrugRelation[i].improvedPercent = uintToString(percent);
                }
                if(keccak256(abi.encodePacked(outcome)) == keccak256(abi.encodePacked("UNCHANGED"))) {
                    geneDrugRelation[i].unchangedCount++;
                    uint percent = (geneDrugRelation[i].unchangedCount / geneDrugRelation[i].totalCount)*100;
                    geneDrugRelation[i].unchangedPercent = uintToString(percent);
                }
                if(keccak256(abi.encodePacked(outcome)) == keccak256(abi.encodePacked("DETERIORATED"))) {
                    geneDrugRelation[i].deterioratedCount++;
                    uint percent = (geneDrugRelation[i].deterioratedCount / geneDrugRelation[i].totalCount)*100;
                    geneDrugRelation[i].deterioratedPercent = uintToString(percent);
                }
                if(suspectedRelation == true) {
                    geneDrugRelation[i].suspectedRelationCount++;
                    uint percent = (geneDrugRelation[i].suspectedRelationCount / geneDrugRelation[i].totalCount)*100;
                    geneDrugRelation[i].suspectedRelationPercent = uintToString(percent);
                }
                if(seriousSideEffect == true) {
                    geneDrugRelation[i].sideEffectCount++;
                    uint percent = (geneDrugRelation[i].sideEffectCount / geneDrugRelation[i].totalCount)*100;
                    geneDrugRelation[i].sideEffectPercent = uintToString(percent);
                }
            }
            else {
                geneDrugRelation.push(GeneDrugRelation({
                    geneName: geneName,
                    variantNumber: variantNumber,
                    drugName: drugName,
                    totalCount: 1,
                    improvedCount: 0,
                    improvedPercent: "0",
                    unchangedCount: 0,
                    unchangedPercent: "0",
                    deterioratedCount: 0,
                    deterioratedPercent: "0",
                    suspectedRelationCount: 0,
                    suspectedRelationPercent: "0",
                    sideEffectCount: 1,
                    sideEffectPercent: "1"
                }));
            }
            
            
        }
        
        observationCountOf[msg.sender] = observationCountOf[msg.sender] + 1;
    }
    */
    /** Takes geneName, variant-number, and drug-name as strings. A value of "*" for any name should be considered as a wildcard or alternatively as a null parameter.
        Returns: An array of GeneDrugRelation Structs which match the query parameters

        To clarify here are some example queries:
        query("CYP3A5", "52", "pegloticase") => An array of the one relation that matches all three parameters
        query("CYP3A5","52","*") => An array of all relations between geneName, CYP3A5, variant 52, and any drug
        query("CYP3A5","*","pegloticase") => An array of all relations between geneName, CYP3A5 and drug pegloticase, regardless of variant
        query("*","*","*") => An array of all known relations. 

        Note that capitalization matters. 
    */
    /**
    function query(
        string memory geneName,
        string memory variantNumber,
        string memory drug
    ) public view returns (GeneDrugRelation[] memory) {
        // Code here
        GeneDrugRelation[] memory _geneDrugRelation;
        delete _geneDrugRelation;
        if(keccak256(abi.encodePacked(geneName)) == keccak256(abi.encodePacked("*")) && keccak256(abi.encodePacked(variantNumber)) == keccak256(abi.encodePacked("*")) && keccak256(abi.encodePacked(drug)) == keccak256(abi.encodePacked("*"))) return geneDrugRelation;
        
        if(keccak256(abi.encodePacked(geneName)) == keccak256(abi.encodePacked("*")) && keccak256(abi.encodePacked(variantNumber)) == keccak256(abi.encodePacked("*"))) {
            
            for(uint i = 0; i < geneDrugRelation.length; i++) {
                if(keccak256(abi.encodePacked(geneDrugRelation[i].drugName)) == keccak256(abi.encodePacked(drug))) {
                    //_geneDrugRelation.push(GeneDrugRelation({
                    //    geneName: geneDrugRelation[i].geneName
                    //    }));
                }
            }
            return geneDrugRelation;
        }
        if(keccak256(abi.encodePacked(geneName)) == keccak256(abi.encodePacked("*")) && keccak256(abi.encodePacked(drug)) == keccak256(abi.encodePacked("*"))) {
            for(uint i = 0; i < geneDrugRelation.length; i++) {
                //if(geneDrugRelation[i].variantNumber == stringToUint(variantNumber)) _geneDrugRelation.push(geneDrugRelation[i]);
            }
            return geneDrugRelation;
        }
        if(keccak256(abi.encodePacked(variantNumber)) == keccak256(abi.encodePacked("*")) && keccak256(abi.encodePacked(drug)) == keccak256(abi.encodePacked("*"))) {
            for(uint i = 0; i < geneDrugRelation.length; i++) {
                //if(keccak256(abi.encodePacked(geneDrugRelation[i].geneName)) == keccak256(abi.encodePacked(geneName))) _geneDrugRelation.push(geneDrugRelation[i]);
            }
            return geneDrugRelation;
        }
        if(keccak256(abi.encodePacked(variantNumber)) == keccak256(abi.encodePacked("*"))) {
            for(uint i = 0; i < geneDrugRelation.length; i++) {
                //if(keccak256(abi.encodePacked(geneDrugRelation[i].geneName)) == keccak256(abi.encodePacked(geneName)) && keccak256(abi.encodePacked(geneDrugRelation[i].drugName)) == keccak256(abi.encodePacked(drug))) _geneDrugRelation.push(geneDrugRelation[i]);
            }
            return geneDrugRelation;
        }
    }
*/
    /** Takes: geneName,-name, variant-number, and drug-name as strings. Accepts "*" as a wild card, same rules as query
        Returns: A boolean value. True if the relation exists, false if not. If a wild card was used, then true if any relation exists which meets the non-wildcard criteria.
     */
    function entryExists(
        string memory geneName,
        string memory variantNumber,
        string memory drug
    ) public view returns (bool){
        // Code here
        if(keccak256(abi.encodePacked(geneName)) == keccak256(abi.encodePacked("*")) && keccak256(abi.encodePacked(variantNumber)) == keccak256(abi.encodePacked("*")) && keccak256(abi.encodePacked(drug)) == keccak256(abi.encodePacked("*"))) return true;
        if(keccak256(abi.encodePacked(geneName)) == keccak256(abi.encodePacked("*")) && keccak256(abi.encodePacked(variantNumber)) == keccak256(abi.encodePacked("*"))) {
            for(uint i = 0; i < metaGeneDrugRelation.length; i++) {
                if(keccak256(abi.encodePacked(metaGeneDrugRelation[i].drugName)) == keccak256(abi.encodePacked(drug))) return true;
            }
        }
        if(keccak256(abi.encodePacked(geneName)) == keccak256(abi.encodePacked("*")) && keccak256(abi.encodePacked(drug)) == keccak256(abi.encodePacked("*"))) {
            uint _variantNumber = stringToUint(variantNumber);
            for(uint i = 0; i < metaGeneDrugRelation.length; i++) {
                if(metaGeneDrugRelation[i].variantNumber == _variantNumber) return true;
            }
        }
        if(keccak256(abi.encodePacked(variantNumber)) == keccak256(abi.encodePacked("*")) && keccak256(abi.encodePacked(drug)) == keccak256(abi.encodePacked("*"))) {
            for(uint i = 0; i < metaGeneDrugRelation.length; i++) {
                if(keccak256(abi.encodePacked(metaGeneDrugRelation[i].geneName)) == keccak256(abi.encodePacked(geneName))) return true;
            }
        }
        // Incomplete Remaining: if 1 field is a *, if no field is a *
        return false;
    }
    
    /** Return the total number of known relations, a.k.a. the number of unique geneName,-name, variant-number, drug-name pairs
     */
     /**
    function getNumRelations () public view returns(uint){
        // Code here
        return geneDrugRelation.length;
    }
    */
    /** Return the total number of recorded observations, regardless of sender.
     */
     /**
    function getNumObservations() public view returns (uint) {
        // Code here
        uint numObservations = 0;
        for (uint i = 0; i < geneDrugRelation.length; i++) {
            numObservations += geneDrugRelation[i].totalCount;
        }
        return numObservations;
    }
*/
    /** Takes: A wallet address.
        Returns: The number of observations recorded from the provided wallet address
     */
     /**
    function getNumObservationsFromSender(address sender) public view returns (uint) {
        // Code here
        return observationCountOf[sender];
    }
    */
    /** Utilities Code here
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
