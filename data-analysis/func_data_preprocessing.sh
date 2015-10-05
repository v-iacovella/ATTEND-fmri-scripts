#!/bin/bash

participant=$1
session=$2
task=$3
run=$4

dummy_scans=$5

tmp_yes_no=$6

#my_curr_root=$(pwd)
#curr_file=$(basename $1 .nii)
#curr_dir=$(dirname $1)
#target_dir=$2

#mkdir -p $target_dir

#curr_part=$(echo $curr_file | awk -F "." '{print $1}')
#curr_task=$(echo $curr_file | awk -F "." '{print $2}')
#curr_sess=$(echo $curr_file | awk -F "." '{print $3}')



target_dir="./results/preproc/"$participant
current_directory=$(pwd)
mkdir $target_dir
curr_file=$participant"_"$task"_"$run"_bold"
echo $curr_file

cd ./data/$participant/$session/func

	n_scans=$(fslinfo $curr_file | grep ^dim4 | awk '{print $2}')

	tot_scans=$(echo $n_scans-$dummy_scans | bc)
	echo $tot_scans

	# Dummy Scans
	fslroi $curr_file.nii.gz $target_dir"/tmp.ds."$curr_file.nii.gz $5 $tot_scans


	# Slice Timing
	slicetimer -i $target_dir"/tmp.ds."$curr_file.nii.gz -o $target_dir"/tmp.ds.st."$curr_file.nii.gz -r 2 -d 2 --odd


	# Brain Extraction
	bet $target_dir"/tmp.ds.st."$curr_file.nii.gz $target_dir"/tmp.ds.st.bet."$curr_file.nii.gz -F

	# Motion Correction
	mcflirt -in $target_dir"/tmp.ds.st.bet."$curr_file.nii.gz -o $target_dir"/tmp.ds.st.bet.moco."$curr_file.nii.gz

cd $current_directory
