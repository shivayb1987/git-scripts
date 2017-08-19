function confirm {
	echo "Press Enter to proceed ..."
	read proceed
}

function addChanges {
	echo "Enter the number of each file to be added with a space b/w them ..."
	read numbers
	files="";
	touch files.txt
	re='^[0-9]+$'
	range='^[0-9]+-[0-9]+'
	for i in $numbers
	do 
		if [[ $i =~ $range ]]
		then
			str1=`echo $i |cut -d'-' -f1`
			str2=`echo $i |cut -d'-' -f2`
			noOfLines=`expr $str2 - $str1 + 1`;
			git status | grep -A20 "Untracked files:" | grep -A20 ^$ | grep -v "no changes added to commit" | grep -v ^$ | cut -d":" -f2 | head -$str2 | tail -$noOfLines | while read file
			do 
				# echo fiels $files
				# echo "$file " >> files.txt
				files1+=`echo " $file "`
				echo $files1 > files.txt
			done
		elif [[ $i =~ $re ]]; 
		then
			files+=`git status | grep -A20 "Untracked files:"  | grep -A20 ^$ | grep -v "no changes added to commit" | grep -v ^$ | cut -d":" -f2 | head -$i | tail -1`;
			files+=`echo " "`;
		fi
	done
	
	if [[ $files == "" ]] 
	then
		files=`cat files.txt`
	else 
		files+=`cat files.txt`
	fi
	echo "Adding $files"
	confirm
	git add $files
	rm files.txt
}


function untracked {
	echo "These are the untracked changes ..."
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++" 
	git status | grep -A20 "Untracked files:" | grep -A20 ^$ | grep -v "no changes added to commit" | grep -v ^$ | grep -n .
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++" 
}

function add {
	untracked

	echo -e "\033[01m\033[31mWant to add any file?[y|n] \033[00m"
	read answ
	if [[ $answ == "y" ]]; 
	then
		addChanges
	fi
}

function staged {
	echo -e "\033[01m\033[31m\n\nThese changes have been staged for commit ... \033[00m"
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	git status | grep "modified\|new file\|deleted" | cut -d":" -f2
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++" 
}

function commit {
	# staged
	# echo -e "\033[01m\033[31mDo you want to commit all files?[y|n] \033[00m"
	# read answ

	# if [[ $answ == "y" ]]; 
	# then
	# 	commitAll
	# else
	commitSelected
	# fi
}

function commitAll {
	echo -e "\n\n\033[01m\033[32mCommitting all files ... \033[00m"
	echo -e "\033[01m\033[31mPlease enter a comment for the commit ... \033[00m"
	read comment;
	confirm;
	git commit -a -m "$comment"
}

function commitSelected {
	echo -e "\033[01m\033[31mEnter the number of each file to be committed with a space b/w them ...\033[00m"
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++" 
	git status | grep "modified\|new file\|deleted" | cut -d":" -f2 | grep -n .
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
			str1=`echo $i |cut -d'-' -f1`
			str2=`echo $i |cut -d'-' -f2`
			noOfLines=`expr $str2 - $str1 + 1`;
			git status | grep "modified\|new file\|deleted" | cut -d":" -f2 | head -$str2 | tail -$noOfLines | while read file
			do 
				# echo fiels $files
				# echo "$file " >> files.txt
				files1+=`echo " $file "`
				echo $files1 > files.txt
			done
		elif [[ $i =~ $re ]]; 
		then
			files+=`git status | grep "modified\|new file\|deleted" | cut -d":" -f2 | head -$i | tail -1`;
			files+=`echo " "`;
		else 
		   commitAll
		   git push
		   exit;
		fi
	done
	
	if [[ $files == "" ]] 
	then
		files=`cat files.txt`
	else 
		files+=`cat files.txt`
	fi
	echo "Committing $files";
	echo -e "\033[01m\033[31mPlease enter a comment for the commit ...\033[00m"
	read comment
	confirm
	git commit -m "$comment" $files
	rm files.txt
}

#BEGIN
# git checkout build/css/index.css build/css/index.css.map

git status
add
commit
confirm
git push




