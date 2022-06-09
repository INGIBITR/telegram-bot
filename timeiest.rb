delay = 5
time_difference = Time.now.to_i - (Time.now.to_i - 2*50*60)
hours = time_difference/60/60
minutes = time_difference/60
if time_difference < delay * 60 * 60
    print "govno"
end

    while minutes >= 60
        minutes -= 60
    end

print Time.now.to_i
print "\n\n"
print "#{time_difference} \n\n"
print "Arseniy, please wait #{(hours)} hours #{(minutes)} minutes"