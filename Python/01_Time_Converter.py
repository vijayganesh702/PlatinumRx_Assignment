time=int(input())
hours=time//60
minutes=time%60
if hours>1:
    hours=str(hours)+" hrs "

elif hours==1:
    hours=str(1)+" hr "
    
else:
    hours=""

print(hours+str(minutes)+" minutes")
