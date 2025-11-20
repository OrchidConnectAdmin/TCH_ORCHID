function validateForm(inputObj,component) {
    var isFormValid;
    for (var property in inputObj) {
        if (inputObj.hasOwnProperty(property)) {
            if (!component.find(property).validate()) {
                isFormValid = false;
            }
        }
    }
    if (isFormValid == undefined) {
        isFormValid = true;
    }
    return isFormValid;
}

function isUndefinedOrNull(valueToCheck) {
    if (typeof(variable) !== "undefined" && variable !== null) {
        return false;
    }

    return true;
}
