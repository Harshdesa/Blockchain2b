pragma solidity ^0.5.8;
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
    
    //Code here
    GeneDrugRelation[] public geneDrugRelation;
    
    mapping (address => uint) observationCountOf;
    
    /** Insert an observation into your contract, following the format defined in the data readme. 
        This function has no return value. If it completes it will be assumed the observations was recorded successfully. 

        Note: case matters for geneName and drugName. GyNx3 and gynx3 are treated as different genes.
     */
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
            if(geneDrugRelation[i].geneName == geneName && geneDrugRelation[i].variantNumber == variantNumber && geneDrugRelation[i].drugName = drugName) {
                geneDrugRelation[i].totalCount++;
                if(outcome == "IMPROVED") {
                    geneDrugRelation[i].improvedCount++;
                    geneDrugRelation[i].improvedPercent = (geneDrugRelation[i].improvedCount / geneDrugRelation[i].totalCount)*100;
                }
                if(outcome == "UNCHANGED") {
                    geneDrugRelation[i].unchangedCount++;
                    geneDrugRelation[i].unchangedPercent = (geneDrugRelation[i].unchangedCount / geneDrugRelation[i].totalCount)*100;
                }
                if(outcome == "DETERIORATED") {
                    geneDrugRelation[i].deterioratedCount++;
                    geneDrugRelation[i].deterioratedPercent = (geneDrugRelation[i].deterioratedCount / geneDrugRelation[i].totalCount)*100;
                }
                if(suspectedRelation == true) {
                    geneDrugRelation[i].suspectedRelationCount++;
                    geneDrugRelation[i].suspectedRelationPercent = (geneDrugRelation[i].suspectedRelationCount / geneDrugRelation[i].totalCount)*100;
                }
                if(seriousSideEffect == true) {
                    geneDrugRelation[i].sideEffectCount++;
                    geneDrugRelation[i].sideEffectPercent = (geneDrugRelation[i].sideEffectCount / geneDrugRelation[i].totalCount)*100;
                }
            }
            else {
                geneDrugRelation.push(GeneDrugRelation({
                    geneName: geneName,
                    variantNumber: variantNumber,
                    drugName: drugName,
                    totalCount: 1,
                    improvedCount: 0,
                    improvedPercent: 0,
                    unchangedCount: 0,
                    unchangedPercent: 0,
                    deterioratedCount: 0,
                    deterioratedPercent: 0,
                    suspectedRelationCount: 0,
                    suspectedRelationPercent: 0,
                    sideEffectCount: 1,
                    sideEffectPercent: 1
                }));
            }
            
            
        }
        
        observationCountOf(msg.sender) = observationCountOf(msg.sender) + 1;
    }

    /** Takes geneName, variant-number, and drug-name as strings. A value of "*" for any name should be considered as a wildcard or alternatively as a null parameter.
        Returns: An array of GeneDrugRelation Structs which match the query parameters

        To clarify here are some example queries:
        query("CYP3A5", "52", "pegloticase") => An array of the one relation that matches all three parameters
        query("CYP3A5","52","*") => An array of all relations between geneName, CYP3A5, variant 52, and any drug
        query("CYP3A5","*","pegloticase") => An array of all relations between geneName, CYP3A5 and drug pegloticase, regardless of variant
        query("*","*","*") => An array of all known relations. 

        Note that capitalization matters. 
    */
    function query(
        string memory geneName,
        string memory variantNumber,
        string memory drug
    ) public view returns (GeneDrugRelation[] memory) {
        // Code here
        if(geneName == "*" && variantNumber == "*" && drug == "*") return geneDrugRelation;
        
        if(geneName == "*" && variantNumber == "*") {
            GeneDrugRelation[] _geneDrugRelation;
            for(uint i = 0; i < geneDrugRelation.length; i++) {
                if(geneDrugRelation[i].drugName == drug) _geneDrugRelation.push(geneDrugRelation[i]);
            }
            return _geneDrugRelation;
        }
        if(geneName == "*" && drug == "*") {
            GeneDrugRelation[] _geneDrugRelation;
            for(uint i = 0; i < geneDrugRelation.length; i++) {
                if(geneDrugRelation[i].variantNumber == variantNumber) _geneDrugRelation.push(geneDrugRelation[i]);
            }
            return _geneDrugRelation;
        }
        if(variantNumber == "*" && drug == "*") {
            GeneDrugRelation[] _geneDrugRelation;
            for(uint i = 0; i < geneDrugRelation.length; i++) {
                if(geneDrugRelation[i].geneName == geneName) _geneDrugRelation.push(geneDrugRelation[i]);
            }
            return _geneDrugRelation;
        }
        if(variantNumber == "*") {
            GeneDrugRelation[] _geneDrugRelation;
            for(uint i = 0; i < geneDrugRelation.length; i++) {
                if(geneDrugRelation[i].geneName == geneName && geneDrugRelation[i].drugName == drug) _geneDrugRelation.push(geneDrugRelation[i]);
            }
            return _geneDrugRelation;
        }
    }

    /** Takes: geneName,-name, variant-number, and drug-name as strings. Accepts "*" as a wild card, same rules as query
        Returns: A boolean value. True if the relation exists, false if not. If a wild card was used, then true if any relation exists which meets the non-wildcard criteria.
     */
    function entryExists(
        string memory geneName,
        string memory variantNumber,
        string memory drug
    ) public view returns (bool){
        // Code here
        if(geneName == "*" && variantNumber == "*" && drug == "*") return true;
        if(geneName == "*" && variantNumber == "*") {
            for(uint i = 0; i < geneDrugRelation.length; i++) {
                if(geneDrugRelation[i].drug == drug) return true;
            }
        }
        return false;
    }
    
    /** Return the total number of known relations, a.k.a. the number of unique geneName,-name, variant-number, drug-name pairs
     */
    function getNumRelations () public view returns(uint){
        // Code here
        return geneDrugRelation.length;
    }
    
    /** Return the total number of recorded observations, regardless of sender.
     */
    function getNumObservations() public view returns (uint) {
        // Code here
        uint numObservations = 0;
        for (uint i = 0; i < geneDrugRelation.length; i++) {
            numObservations += geneDrugRelation[i].totalCount;
        }
        return numObservations;
    }

    /** Takes: A wallet address.
        Returns: The number of observations recorded from the provided wallet address
     */
    function getNumObservationsFromSender(address sender) public view returns (uint) {
        // Code here
        return observationCountOf(sender);
    }
    
}
