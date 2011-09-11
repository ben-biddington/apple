describe("Query", function() {
    it("you can create one", function(){
	var x = new Query();
	expect(x).not.toBe(null);
    });
});