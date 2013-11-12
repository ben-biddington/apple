Date.prototype.equals = function(otherDate) {
    return this-otherDate == 0;
}

Array.prototype.first = function(matching) {
    for (var i = 0; i < this.length; i++) {
	var entry = this[i];
        
	if (matching(entry) == true)
	    return this[i];
    }

    return null;
}