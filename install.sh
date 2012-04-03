#!/bin/bash

cd "$(dirname "$0")"
	
rsync --exclude ".git/" --exclude ".DS_Store" --exclude "install.sh" --exclude "README" --exclude "TODO" -av . ~
