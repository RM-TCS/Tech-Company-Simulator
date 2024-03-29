local ReplicatedStorage = game:GetService("ReplicatedStorage")

local loadModule = table.unpack(require(ReplicatedStorage.ZenithFramework))

return function()
	local String = loadModule("String")

	SKIP()
	
	describe("String", function()
		it("should remove all spaces from a string", function()
			local testString = "T h is Is a T e  s   t"
			expect(function()
				testString = String.removeSpaces(testString)
			end).never.to.throw()
			expect(testString).to.equal("ThisIsaTest")
			expect(function()
				String.removeSpaces(5)
			end).to.throw()
		end)

		it("should remove all punctuation from a string", function()
			local testString = "Th''isIs_*(aTest"
			expect(function()
				testString = String.removePunc(testString)
			end).never.to.throw()
			expect(testString).to.equal("ThisIsaTest")
			expect(function()
				String.removePunc(5)
			end).to.throw()
		end)

		it("should return all the matches in a string given a certain pattern", function()
			local matches
			local testString = "ThThTh"
			expect(function()
				matches = String.getStringMatches(testString, "Th")
			end).never.to.throw()
			expect(#matches).to.equal(3)
			expect(matches[1]).to.equal(1)
			expect(matches[2]).to.equal(3)
			expect(matches[3]).to.equal(5)
			expect(function()
				String.getStringMatches(5, "Th")
			end).to.throw()
			expect(function()
				String.getStringMatches(testString, 5)
			end).to.throw()
		end)

		it("should make the first letter of a string lowercase", function()
			local testString = "Test"
			expect(function()
				testString = String.lowerFirstLetter(testString)
			end).never.to.throw()
			expect(testString).to.equal("test")
			expect(function()
				String.lowerFirstLetter(5)
			end).to.throw()
		end)

		it("should make the first letter of a string uppercase", function()
			local testString = "test"
			expect(function()
				testString = String.upperFirstLetter(testString)
			end).never.to.throw()
			expect(testString).to.equal("Test")
			expect(function()
				String.upperFirstLetter(5)
			end).to.throw()
		end)

		it("should convert a number from seconds to 'mm:ss' format", function()
			local result1
			expect(function()
				result1 = String.convertToMS(120)
			end).never.to.throw()
			expect(result1).to.equal("02:00")
			local result2 = String.convertToMS(196)
			expect(result2).to.equal("03:16")
		end)

		it("should convert a number from seconds to 'hh:mm' format", function()
			local result1
			expect(function()
				result1 = String.convertToHM(5413)
			end).never.to.throw()
			expect(result1).to.equal("01:30")
			local result2 = String.convertToHM(54130)
			expect(result2).to.equal("15:02")
		end)

		it("should convert a number from seconds to 'hh:mm:ss' format", function()
			local result1
			expect(function()
				result1 = String.convertToHMS(5413)
			end).never.to.throw()
			expect(result1).to.equal("01:30:13")
			local result2 = String.convertToHMS(54130)
			expect(result2).to.equal("15:02:10")
		end)

		it("should convert a number to have commas", function()
			local result1
			expect(function()
				result1 = String.commaFormat(5413)
			end).never.to.throw()
			expect(result1).to.equal("5,413")
			local result2 = String.commaFormat(54130)
			expect(result2).to.equal("54,130")
			local result3 = String.commaFormat(546763864583)
			expect(result3).to.equal("546,763,864,583")
			local result4 = String.commaFormat(345)
			expect(result4).to.equal("345")
		end)
	end)
end