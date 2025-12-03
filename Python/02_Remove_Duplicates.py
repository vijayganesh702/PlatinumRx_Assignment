seq=input()
result=""
for num in seq:
    if num in result:
        continue
    else:
        result=result+num

print(result)
