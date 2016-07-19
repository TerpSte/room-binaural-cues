function result = roundTo5(num)

result = round(num);
if mod(result,5)<2.5
    result = result-mod(result,5);
else
    result = result+5-mod(result,5);
end
