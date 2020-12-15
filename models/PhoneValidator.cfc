component accessors="true" implements="cbvalidation.models.validators.IValidator" hint="Validates a phone number" singleton {

	property name="name";
    property name="PhoneNumber" inject="PhoneNumber@libphonenumber";

	PhoneValidator function init(){
		name        = "PhoneValid";
		return this;
	}

	/**
	* Will check if an incoming value validates
	* @validationResult.hint The result object of the validation
	* @target.hint The target object to validate on
	* @field.hint The field on the target object to validate on
	* @targetValue.hint The target value to validate
	* @validationData.hint The validation data the validator was created with
	*/
	boolean function validate(required any validationResult, required any target, required string field, any targetValue, any validationData, struct rules){
		// Only validate simple values and if they have length, else ignore.
		if( isSimpleValue( arguments.targetValue ) AND len( trim( arguments.targetValue ) ) ){
			local.phonenumber = PhoneNumber.parse(arguments.targetValue);
			if (isnull(local.phonenumber.getRegionCode()) || !local.phonenumber.isValidForRegion(local.phonenumber.getRegionCode())) {
				var args = {
					message        = "The value you entered, #arguments.targetValue#, is not a valid phone number for the country/region you selected.",
					field          = arguments.field,
					validationType = getName(),
					validationData = arguments.validationData,
					rejectedValue  = arguments.targetValue
				};
				validationResult.addError( validationResult.newError( argumentCollection=args ) );
				return false;
			}
		}

		return true;
	}

	/**
	* Get the name of the validator
	*/
	string function getName(){
		return name;
	}

}