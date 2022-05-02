#!/bin/sh
#
# Script name: build-db.sh
# Description: Script for rebuilding the database for jpszc-repo.
# Github: https://github.com/JPszC/jpszc-repo 
# Contributors: Jaime Pereira

set -e

echo "###################################"
echo "Running Cleanup and Makepkg Scrips."
echo "###################################"

cd ../jpszc-pkgbuild/
./cleanup.sh
./build-packages.sh
cd ../jpszc-repo/

x86_pkgbuild=$(find ../jpszc-pkgbuild/x86_64 -type f -name "*.pkg.tar.zst*")

for x in ${x86_pkgbuild}
do
    mv "${x}" x86_64/
    echo "Moving ${x}"
done

echo "###########################"
echo "Building the repo database."
echo "###########################"

## Arch: x86_64
cd x86_64
rm -f jpszc-repo*

echo "###################################"
echo "Building for architecture 'x86_64'."
echo "###################################"

## repo-add
## -s: signs the packages
## -n: only add new packages not already in database
## -R: remove old package files when updating their entry
repo-add -n -R jpszc-repo.db.tar.gz *.pkg.tar.zst

# Removing the symlinks 
rm jpszc-repo.db
rm jpszc-repo.files

# Renaming the tar.gz files without the extension.
mv jpszc-repo.db.tar.gz jpszc-repo.db
mv jpszc-repo.files.tar.gz jpszc-repo.files

echo "#######################################"
echo "Packages in the repo have been updated!"
echo "#######################################"
