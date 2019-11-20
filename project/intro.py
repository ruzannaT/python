number = int(input())
hour = (number // 60)
days = 0
if hour > 24:
    days = hour//24
    hour = hour % 24

minutes = number % 60

print(hour, minutes)
