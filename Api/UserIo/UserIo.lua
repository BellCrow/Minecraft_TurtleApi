function int_ReadInt(str_initalMessage,bool_repeatTillCorrect, str_wrongInputMessage, int_lowerBound, int_uppderBound)
    b_repeatTillCorrect = bool_repeatTillCorrect or false
    if(b_repeatTillCorrect and str_wrongInputMessage == nil) then
        error("You need to supply a message to output to the user if you want to make the input repeatOnError")
    end

    readInput = read("*")
    parsedVal = tonumber(readInput)
    if(str_initalMessage ~= nil)then
        print(str_initalMessage)
    end
    
    while(bool_repeatOnError and (parsedVal == nil))do
        print(str_initalMessage)
        readInput = io.read()
        parsedVal = tonumber(readInput)
    end
    return parsedVal
end

---tests whether a given number is inbetween a given bounds or above or below a given bound
--@param num_numberToTest the number to test for being in a range
--@param num_lowerBound the inclusive lower bound to test against. Can be nil if the upper bound is not nil
--@param num_upperBound the inclusive upper bound to test against. Can be nil if the lower bound is not nil
local function bool_IsNumberInBounds(num_numberToTest, num_lowerBound, num_upperBound)
    if(num_numberToTest == nil) then
        error("Supplied argument num_numberToTest cannot be null")
    end
    if(num_lowerBound == nil and num_numberToTest == nil) then
        error("Supplied arguments num_lowerBound and num_upperBound cannot both be null")
    end
    assert(type(num_numberToTest) == "number", "Argument num_numberToTest is not a number")
    assert(type(num_lowerBound) == "number", "Argument num_lowerBound is not a number")
    assert(type(num_upperBound) == "number", "Argument num_upperBound is not a number")
    if(num_lowerBound >= num_upperBound)then
        error("lower bounds cannot be smaller then upper bounds")
    end

    if(num_lowerBound ~= nil and not (num_lowerBound <= num_numberToTest)) then
        return false
    end
    if(type(num_upperBound) ~= type(nil) and not (num_numberToTest <= num_upperBound))then
        return false
    end
    return true
end

---------------------------Tests---------------------
function test_MainTest()
test_IsNumberInBounds()
end

function test_IsNumberInBounds()

    local function testNumbers(testNumber,lowerBound,upperBound,bool_excpectedResult)
        assert(bool_IsNumberInBounds(testNumber,lowerBound,upperBound) == bool_excpectedResult,"Test with "..tostring(lowerBound).." <= "..tostring(testNumber).." <= "..tostring(upperBound).." failed!")
    end
    testNumbers(5,3,7,true)
    testNumbers(5,6,7,false)
    testNumbers(5,3,4,false)
    print("All tests succesfull")
end