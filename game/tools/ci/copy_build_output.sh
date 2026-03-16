#!/bin/bash

mkdir -p \
    $1/../assets/icons \
    $1/../interface/compiled \

cp tgstation.dmb tgstation.rsc $1/
cp -r ../assets/icons/* $1/../assets/icons/
cp -r ../interface/compiled/* $1/../interface/compiled/
