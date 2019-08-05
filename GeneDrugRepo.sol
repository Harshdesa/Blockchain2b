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
        //string improvedPercent; -> Removed due to out of gas exception
        uint unchangedCount;
        //string unchangedPercent; -> Removed due to out of gas exception
        uint deterioratedCount;
        //string deterioratedPercent; -> Removed due to out of gas exception
        uint suspectedRelationCount;
        //string suspectedRelationPercent; -> Removed due to out of gas exception
        uint sideEffectCount;
        //string sideEffectPercent; -> Removed due to out of gas exception
    }
    
    //HD custom struct to add data
    struct MetaGeneDrugRelation {
        string geneName;
        uint variantNumber;
        string drugName;
        string outcome;
        bool suspectedRelation;
        bool seriousSideEffect;
    }
    
    
    
    
    
    //Code here
    GeneDrugRelation[] _geneDrugRelation;
    MetaGeneDrugRelation[] public metaGeneDrugRelation;
    MetaGeneDrugRelation[] _metaGeneDrugRelation;
    string _geneName;
    uint _variantNumber;
    string _drugName;
    
    //TESTED
    function getMetaGeneDrugRelation(uint index) public view returns (MetaGeneDrugRelation memory) {
        return metaGeneDrugRelation[index];
    }
    
    
    //TESTED  HD This function can be replaced with insertObservation below
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
    

    // HD Highly inefficient query code, need to optimize this function
    function query(
        string memory geneName,
        string memory variantNumber,
        string memory drug
    ) public /*view*/ returns (GeneDrugRelation[] memory /*MetaGeneDrugRelation[] memory*/) {
        // Code here

            delete _metaGeneDrugRelation;
	    delete _geneDrugRelation; 



        // create dataset 
            for(uint i = 0; i < metaGeneDrugRelation.length; i++) {
                
		if(keccak256(abi.encodePacked(metaGeneDrugRelation[i].geneName)) == keccak256(abi.encodePacked(geneName)) && metaGeneDrugRelation[i].variantNumber == stringToUint(variantNumber) && keccak256(abi.encodePacked(metaGeneDrugRelation[i].drugName)) == keccak256(abi.encodePacked(drug))) {
                    //a a a
                    _metaGeneDrugRelation.push(MetaGeneDrugRelation({
                    geneName: metaGeneDrugRelation[i].geneName,
                    variantNumber: metaGeneDrugRelation[i].variantNumber,
                    drugName: metaGeneDrugRelation[i].drugName,
                    outcome: metaGeneDrugRelation[i].outcome,
                    suspectedRelation: metaGeneDrugRelation[i].suspectedRelation,
                    seriousSideEffect: metaGeneDrugRelation[i].seriousSideEffect
                    }));
                }
                if(keccak256(abi.encodePacked("*")) == keccak256(abi.encodePacked(geneName))) {
                    if(metaGeneDrugRelation[i].variantNumber == stringToUint(variantNumber) && keccak256(abi.encodePacked(metaGeneDrugRelation[i].drugName)) == keccak256(abi.encodePacked(drug))) {
                       //* a a
                        _metaGeneDrugRelation.push(MetaGeneDrugRelation({
                        geneName: metaGeneDrugRelation[i].geneName,
                        variantNumber: metaGeneDrugRelation[i].variantNumber,
                        drugName: metaGeneDrugRelation[i].drugName,
                        outcome: metaGeneDrugRelation[i].outcome,
                        suspectedRelation: metaGeneDrugRelation[i].suspectedRelation,
                        seriousSideEffect: metaGeneDrugRelation[i].seriousSideEffect
                        }));
                    }
                    if(keccak256(abi.encodePacked("*")) == keccak256(abi.encodePacked(variantNumber))) {
                        if(keccak256(abi.encodePacked(metaGeneDrugRelation[i].drugName)) == keccak256(abi.encodePacked(drug))) {
                            // * * a
                            _metaGeneDrugRelation.push(MetaGeneDrugRelation({
                            geneName: metaGeneDrugRelation[i].geneName,
                            variantNumber: metaGeneDrugRelation[i].variantNumber,
                            drugName: metaGeneDrugRelation[i].drugName,
                            outcome: metaGeneDrugRelation[i].outcome,
                            suspectedRelation: metaGeneDrugRelation[i].suspectedRelation,
                            seriousSideEffect: metaGeneDrugRelation[i].seriousSideEffect
                            }));
                        }
                    }
                    if(keccak256(abi.encodePacked("*")) == keccak256(abi.encodePacked(drug))) {
                        if(metaGeneDrugRelation[i].variantNumber == stringToUint(variantNumber)) {
                            // * a *
                            _metaGeneDrugRelation.push(MetaGeneDrugRelation({
                            geneName: metaGeneDrugRelation[i].geneName,
                            variantNumber: metaGeneDrugRelation[i].variantNumber,
                            drugName: metaGeneDrugRelation[i].drugName,
                            outcome: metaGeneDrugRelation[i].outcome,
                            suspectedRelation: metaGeneDrugRelation[i].suspectedRelation,
                            seriousSideEffect: metaGeneDrugRelation[i].seriousSideEffect
                            }));
                        }
                    }
                    
                }
                if(keccak256(abi.encodePacked("*")) == keccak256(abi.encodePacked(variantNumber))) {
                    if(keccak256(abi.encodePacked(metaGeneDrugRelation[i].geneName)) == keccak256(abi.encodePacked(geneName)) && keccak256(abi.encodePacked(metaGeneDrugRelation[i].drugName)) == keccak256(abi.encodePacked(drug))) {
                        //a * a
                        _metaGeneDrugRelation.push(MetaGeneDrugRelation({
                        geneName: metaGeneDrugRelation[i].geneName,
                        variantNumber: metaGeneDrugRelation[i].variantNumber,
                        drugName: metaGeneDrugRelation[i].drugName,
                        outcome: metaGeneDrugRelation[i].outcome,
                        suspectedRelation: metaGeneDrugRelation[i].suspectedRelation,
                        seriousSideEffect: metaGeneDrugRelation[i].seriousSideEffect
                        }));
                    }
                    
                    if(keccak256(abi.encodePacked("*")) == keccak256(abi.encodePacked(drug))) {
                        if(keccak256(abi.encodePacked(metaGeneDrugRelation[i].geneName)) == keccak256(abi.encodePacked(geneName))) {
                            //a * *
                            _metaGeneDrugRelation.push(MetaGeneDrugRelation({
                            geneName: metaGeneDrugRelation[i].geneName,
                            variantNumber: metaGeneDrugRelation[i].variantNumber,
                            drugName: metaGeneDrugRelation[i].drugName,
                            outcome: metaGeneDrugRelation[i].outcome,
                            suspectedRelation: metaGeneDrugRelation[i].suspectedRelation,
                            seriousSideEffect: metaGeneDrugRelation[i].seriousSideEffect
                            }));
                        }
                    }
                }

                if(keccak256(abi.encodePacked("*")) == keccak256(abi.encodePacked(drug))) {
                    if(keccak256(abi.encodePacked(metaGeneDrugRelation[i].geneName)) == keccak256(abi.encodePacked(geneName))) {
                        if(metaGeneDrugRelation[i].variantNumber == stringToUint(variantNumber)) {
                            //aa*
                            _metaGeneDrugRelation.push(MetaGeneDrugRelation({
                            geneName: metaGeneDrugRelation[i].geneName,
                            variantNumber: metaGeneDrugRelation[i].variantNumber,
                            drugName: metaGeneDrugRelation[i].drugName,
                            outcome: metaGeneDrugRelation[i].outcome,
                            suspectedRelation: metaGeneDrugRelation[i].suspectedRelation,
                            seriousSideEffect: metaGeneDrugRelation[i].seriousSideEffect
                            }));
                        }
                        
                    }
                    
                    if(keccak256(abi.encodePacked("*")) == keccak256(abi.encodePacked(variantNumber))) {
                        if(keccak256(abi.encodePacked("*")) == keccak256(abi.encodePacked(geneName))) {
			    _metaGeneDrugRelation.push(MetaGeneDrugRelation({
                            geneName: metaGeneDrugRelation[i].geneName,
                            variantNumber: metaGeneDrugRelation[i].variantNumber,
                            drugName: metaGeneDrugRelation[i].drugName,
                            outcome: metaGeneDrugRelation[i].outcome,
                            suspectedRelation: metaGeneDrugRelation[i].suspectedRelation,
                            seriousSideEffect: metaGeneDrugRelation[i].seriousSideEffect
                            }));
                        }
                    }
                }
            
            }
            
        // club duplicates

        for (uint i = 0; i < _metaGeneDrugRelation.length; i++) {
		while(_metaGeneDrugRelation[i].variantNumber == 0) {
			i++;
                        if(i == _metaGeneDrugRelation.length) return _geneDrugRelation;
		}
                _geneName = _metaGeneDrugRelation[i].geneName;
		_variantNumber = _metaGeneDrugRelation[i].variantNumber;
		_drugName = _metaGeneDrugRelation[i].drugName;
		
		uint _totalCount = 0;
		uint _improvedCount = 0;
		uint _unchangedCount = 0;
		uint _deterioratedCount = 0;
		uint _suspectedRelationCount = 0;
		uint _sideEffectCount = 0;
		string memory improvedPercent; string memory unchangedPercent; string memory deterioratedPercent; string memory suspectedRelationPercent; string memory sideEffectPercent; 
		for (uint j =0; j < _metaGeneDrugRelation.length; j++) {
			
			if(keccak256(abi.encodePacked(_geneName)) == keccak256(abi.encodePacked(_metaGeneDrugRelation[j].geneName)) &&
				_variantNumber == _metaGeneDrugRelation[j].variantNumber &&
					keccak256(abi.encodePacked(_drugName)) == keccak256(abi.encodePacked(_metaGeneDrugRelation[j].drugName))) {

				_totalCount++;
                    		if(keccak256(abi.encodePacked(_metaGeneDrugRelation[j].outcome)) == keccak256(abi.encodePacked("IMPROVED"))) {
                        		_improvedCount++;
                    		}
                    		if(keccak256(abi.encodePacked(_metaGeneDrugRelation[j].outcome)) == keccak256(abi.encodePacked("UNCHANGED"))) {
                        		_unchangedCount++;
                    		}
                    		if(keccak256(abi.encodePacked(_metaGeneDrugRelation[j].outcome)) == keccak256(abi.encodePacked("DETERIORATED"))) {
                        		_deterioratedCount++;
                    		}
                    		if(_metaGeneDrugRelation[j].suspectedRelation == true) {
                        		_suspectedRelationCount++;
                    		}
                    		if(_metaGeneDrugRelation[j].seriousSideEffect == true) {
                        		_sideEffectCount++;
                    		}
				delete _metaGeneDrugRelation[j];
                	}
		}
               uint percent = (_improvedCount / _totalCount)*100;
               	improvedPercent = uintToString(percent);
               	percent = (_unchangedCount / _totalCount)*100;
               	unchangedPercent = uintToString(percent);
               	percent = (_deterioratedCount / _totalCount)*100;
               	deterioratedPercent = uintToString(percent);
                percent = (_suspectedRelationCount / _totalCount)*100;
                suspectedRelationPercent = uintToString(percent);
                percent = (_sideEffectCount / _totalCount)*100;
                sideEffectPercent = uintToString(percent);

		_geneDrugRelation.push(GeneDrugRelation({
                    geneName: _geneName,
                    variantNumber: _variantNumber,
                    drugName: _drugName,
                    totalCount: _totalCount,
                    improvedCount: _improvedCount,
                    //improvedPercent: improvedPercent,  -> Removed due to out of gas exception
                    unchangedCount: _unchangedCount,
                    //unchangedPercent: unchangedPercent,  -> Removed due to out of gas exception
                    deterioratedCount: _deterioratedCount,
                    //deterioratedPercent: deterioratedPercent,   -> Removed due to out of gas exception
                    suspectedRelationCount: _suspectedRelationCount,
                    //suspectedRelationPercent: suspectedRelationPercent,  -> Removed due to out of gas exception
                    sideEffectCount: _sideEffectCount
                    //sideEffectPercent: sideEffectPercent  -> Removed due to out of gas exception
                }));
		}
		return _geneDrugRelation;
	}
        
    
    
    /** Takes: geneName,-name, variant-number, and drug-name as strings. Accepts "*" as a wild card, same rules as query
        Returns: A boolean value. True if the relation exists, false if not. If a wild card was used, then true if any relation exists which meets the non-wildcard criteria.
     */
     //TESTED
     // HD Will check if entry exists
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
            uint _variantNumberr = stringToUint(variantNumber);
            for(uint i = 0; i < metaGeneDrugRelation.length; i++) {
                if(metaGeneDrugRelation[i].variantNumber == _variantNumberr) return true;
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
