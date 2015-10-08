#!/bin/bash

participant=$1
session=$2
task=$3
run=$4

dummy_scans=$5

#tmp_yes_no=$6


target_dir="./results/preproc/"$participant
current_directory=$(pwd)
mkdir -pv $target_dir
curr_file=$participant"_"$task"_"$run"_bold"

n_scans=$(fslinfo ./data/$participant/$session/func/$curr_file".nii.gz" | grep ^dim4 | awk '{print $2}')
tot_scans=$(echo $n_scans-$dummy_scans | bc)
echo $tot_scans
echo

# Dummy Scans
fslroi ./data/$participant/$session/func/$curr_file".nii.gz" $target_dir"/tmp.ds."$curr_file.nii.gz $5 $tot_scans
echo Dummy Scans: DONE

# Slice Timing
slicetimer -i $target_dir"/tmp.ds."$curr_file.nii.gz -o $target_dir"/tmp.ds.st."$curr_file.nii.gz -r 2 -d 2 --odd
echo Slice Timing: DONE

# Brain Extraction
bet $target_dir"/tmp.ds.st."$curr_file.nii.gz $target_dir"/tmp.ds.st.bet."$curr_file.nii.gz -F
echo Brain Extraction: DONE

# Motion Correction
mcflirt -in $target_dir"/tmp.ds.st.bet."$curr_file.nii.gz -o $target_dir"/ds.st.bet.moco."$curr_file.nii.gz
echo Dummy Scans: DONE

