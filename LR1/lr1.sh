#!/bin/sh

for repository in "$@"
do
#; s/:.*//	
	git remote add testRef $repository
	git fetch testRef
	
	branch_arr=$(git branch -r)
	file_name_postfix=$(echo "$repository" | sed 's:.*/::')
	file_name=Commits_$file_name_postfix.txt
	echo $file_name_postfix
	echo > $file_name
	for i in ${branch_arr[@]}
	do
		if [[ $i == testRef* ]] then
			echo -e '\n' ALL COMMITS FROM BRANCH $i '\n' >> $file_name
			git log $i --graph --pretty=format:"|%h |%an |%ae |%s" >> $file_name
		fi
	done
	git remote remove testRef
done

