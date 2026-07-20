#!/usr/bin/env bash
# Repair this script. Do not change the intended values below.

team_name='NightShift'
sector='alpha'
key_prefix='TT-MAP'
key_suffix='6194'

# Hint:
# Variables expand only inside double quotes.
# Single quotes print the text literally.
# So replace '' with "" wherever needed
#
# Example:
# echo "$name" prints the value stored in the variable named name.
# echo '$name' prints the characters $name.
#
# The two lines below are intentionally broken. Repair the quoting.
echo 'Dispatching $team_name to $sector'
echo "Access key: ${key_prefix}-$key_suffix"
