component {
	processingdirective preserveCase=true;

	function init() {
		var libs = [
			 expandpath("/libphonenumber/lib/libphonenumber-8.12.14.jar")
		];

		variables.phoneUtil = createObject("java", "com.google.i18n.phonenumbers.PhoneNumberUtil", libs).getInstance();
		variables.phoneUtilType = createObject("java", "com.google.i18n.phonenumbers.PhoneNumberUtil$PhoneNumberType", libs);
		variables.phoneUtilFormat = createObject("java", "com.google.i18n.phonenumbers.PhoneNumberUtil$PhoneNumberFormat", libs);

		return this;
	}

	private function getUtils() {
		return variables.phoneUtil;
	}	

	private function getTypes() {
		return variables.phoneUtilType;
	}	

	private function getFormats() {
		return variables.phoneUtilFormat;
	}

	public any function getNumber() {
		return variables.number?:nullValue();
	}

	public void function setNumber(required number) {
		variables.number = arguments.number;
		return;
	}

	PhoneNumber function parse(required string number, string defaultRegion="US") {
		this.setNumber( getUtils().parse(javacast("string",arguments.number), javacast("string",arguments.defaultRegion)) );
		return this;
	}

	PhoneNumber function getExampleNumber(required string regionCode) {
		setNumber(getUtils().getExampleNumber(javaCast("string", ucase(arguments.regionCode))));
		return this;
	}

	PhoneNumber function getExampleNumberForType(required string regionCode, required string type) {
		var enums = getTypes().values();
		var types = {}
		loop array="#enums#" item="value" {
			types[value.name()] = getTypes()[value][value.name()];
		}

		if (!types.keyExists(arguments.type))
			throw(type:"libphonenumber.PhoneNumber", message:"Invalid type.", detail:"Valid types are #types.keyList()#");

		setNumber(getUtils().getExampleNumberForType(javaCast("string", arguments.regionCode), types[arguments.type]));
		return this;
	}

	string function getFormatted(required string format) {
		var enums = getFormats(); 
		var formats = [
			 "RFC3966":enums.RFC3966
			,"E164":enums.E164
			,"NATIONAL":enums.NATIONAL
			,"INTERNATIONAL":enums.INTERNATIONAL
		];

		if (!formats.keyExists(arguments.format))
			throw(type:"libphonenumber.PhoneNumber", message:"Invalid format.", detail:"Valid formats are E164, INTERNATIONAL, NATIONAL and RFC3966");

		return getUtils().format(getNumber(),formats[arguments.format]);
	}

	string function getNumberType() {
		return getUtils().getNumberType(getNumber()).toString();
	}

	string function getRegionCode() {
		return getUtils().getRegionCodeForNumber(getNumber());
	}

	numeric function getCountryCode() {
		return getNumber().getCountryCode();
	}

	boolean function isValid() {
		return getUtils().isValidNumber(getNumber());
	}

	boolean function isValidForRegion(required string regionCode) {
		return getUtils().isValidNumberForRegion(getNumber(), javaCast("string", ucase(arguments.regionCode)));
	}

	numeric function getCountryCodeForRegion(required string regionCode) {
		return getUtils().getCountryCodeForRegion(javaCast("string", ucase(arguments.regionCode)));
	}
}