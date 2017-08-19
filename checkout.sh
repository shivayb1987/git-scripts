function confirm {
	echo "Press Enter to proceed ..."
	read proceed
}

function checkout {
	echo "Enter the number of each file to checkout with a space b/w them ..."
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++" 
	git status | grep "modified\|deleted" | cut -d":" -f2 | grep -n .
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++" 
	read numbers
	files="";
	touch files.txt
	re='^[0-9]+$'
	range='^[0-9]+-[0-9]+'
	for i in $numbers
	do 
		if [[ $i =~ $range ]]
		then
			echo i is $i
			str1=`echo $i |cut -d'-' -f1`
			str2=`echo $i |cut -d'-' -f2`
			noOfLines=`expr $str2 - $str1 + 1`;
			git status | grep "modified\|deleted" | cut -d":" -f2 | head -$str2 | tail -$noOfLines | while read file
			do 
				# echo fiels $files
				# echo "$file " >> files.txt
				files1+=`echo " $file "`
				echo $files1 > files.txt
			done
		elif [[ $i =~ $re ]]; 
		then
			files+=`git status | grep "modified\|deleted" | cut -d":" -f2 | head -$i | tail -1`;
			files+=`echo " "`;
		else 
		   files1+=`git status | grep "modified|\deleted" | cut -d":" -f2 | grep $i`
			echo $files1 > files.txt
		fi
	done
	
	if [[ $files == "" ]] 
	then
		files=`cat files.txt`
	else 
		files+=`cat files.txt`
	fi
	rm files.txt
	echo "Checking out $files";
	confirm
	git checkout $files
}

# git status | grep modified | cut -d":" -f2 | while read file; 
# do 
# 	echo "Show the difference for $file?[y|n]"
# 	read answ < /dev/tty
# 	if [[ $answ != "n" ]]; then
# 		git diff $file
# 	fi
# done

checkout