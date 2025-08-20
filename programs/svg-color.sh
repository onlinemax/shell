#!/usr/bin/bash

relative_input_file=$1
relative_output_file=$2
color=$3
option=$4


sanitize_relative_output_file="${relative_output_file//'#'}"
input_file="$HOME/.config/quickshell/assets/$relative_input_file"
output_file="$HOME/.config/quickshell/assets/generated/$sanitize_relative_output_file"

# stroke=".+"
cp $input_file $output_file
sed -i -e "s/$option=\"[^\"]\+\"/$option=\"$color\"/" $output_file
