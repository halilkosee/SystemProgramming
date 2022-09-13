#!/bin/bash  
 
#check arguments count 
if [[ $# -ne 5 ]]; then
    echo "erro: wrong number of parameters on dataGenerator.sh" >&2
    exit 2
fi


#assign arguments
cities=$1;
types=$2;
directoryPath=$3;
filesPerDirectory=$4;
rowsPerFile=$5;
 

# echo "$cities"  
# echo "$types"  
# echo "$directoryPath"  
# echo "$filesPerDirectory"  
# echo "$rowsPerFile"


#check file path validty
if [[ ! -f $cities ]] ; then
    echo  "error: Path '$cities' is not found, aborting..." 
    exit
fi

if [[ ! -f $types ]] ; then
    echo  "error: Path '$types' is not found, aborting..." 
    exit
fi


mkdir -p "$directoryPath" || {
    echo "error: $directoryPath has not been created"
    exit
}

   
#check integer arguments
exp='^[0-9]+$'
if ! [[ $filesPerDirectory =~ $exp ]] || (( $filesPerDirectory < 1)) ; then
	echo "error: $filesPerDirectory not a correct number" 
	exit
fi

exp='^[0-9]+$'
if ! [[ $rowsPerFile =~ $exp ]] || (( $rowsPerFile < 1)) ; then
	echo "error: $rowsPerFile not a correct number"
	exit
fi


#find line count of types.file
((typecount=0))
while read lineC; do  
	((typecount++))
done < $types


((idnum=1000))

#Reading lines in sequence in cities
while read line; do  
	#echo $line 
	#create cities directory
	mkdir -p $directoryPath/$line 
	
	#create files filesPerDirectort times
	for (( c=1; c<= $filesPerDirectory; c++ ))
	do 
		#construct file name as date
		DD=$[ $RANDOM % 30 + 1 ]
		MM=$[ $RANDOM % 12 + 1 ]
		YYYY=$[1950 + $RANDOM % 100]
		
		if(($DD < 10)) ; then
			DD="0$DD"
		fi

		if(($MM < 10)) ; then
			MM="0$MM"
		fi

		filedate="$DD-$MM-$YYYY"

		filename=$directoryPath/$line/$filedate


		#check if file is exist; regenerate filename or create file		
		if [ -e ${filename} ]
		then
			((c--))
		else
			
			#fill file content uniqly

			if (($typecount == 0));then
				echo "error: type count is zero"
				exit
			fi
			
			#loop for rows per file
			for (( j=1; j<= $rowsPerFile; j++ ))
			do
				#chose random type in types.file
				next_type_num=$(( $RANDOM % $typecount + 1 ))
				
				#choose a type in types acording to random num
				((i=0))
				while read lineintype; do 
					((i++))		
					if((i==$next_type_num)); then
						#write to file for random type
						randomstring=$(tr -dc A-Z </dev/urandom|head -c $(( $RANDOM % 10 + 3 )))
						num1=$(shuf -i 35-1000 -n 1)
						num2=$(shuf -i 100000-10000000 -n 1)
						echo $idnum $lineintype $randomstring $num1 $num2 >> ${filename}

						((idnum++))
						break
					fi 
					
				done < $types
			
			done
		fi

	done
	 
done < $cities








