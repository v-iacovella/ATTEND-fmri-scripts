#!/bin/bash

participant=$1
session=$2

echo $participant $session

target_dir="./results/preproc/"$participant
curr_file=$participant"_T1w"

bet ./data/$participant/$session/anat/$curr_file".nii.gz" $target_dir/$curr_file"_sess_"$session"_bet.nii.gz"

