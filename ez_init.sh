EZ_DIR = '../ezpublish-4.2.0/'

#rm -r autoload
ln -s $EZ_DIR/autoload autoload

#rm -r bin
ln -s $EZ_DIR/bin bin

#rm -r cronjobs
ln -s $EZ_DIR/cronjobs cronjobs

#cd design
#rm -r standard
mkdir design
ln -s ../$EZ_DIR/design/standard design/standard
#rm -r base
ln -s ../$EZ_DIR/design/base design/base
#rm -r admin
ln -s ../$EZ_DIR/design/admin design/admin
#cd ..

#rm -r kernel
ln -s $EZ_DIR/kernel kernel

#rm -r lib
ln -s $EZ_DIR/lib lib

#rm -r packages
ln -s $EZ_DIR/packages packages

#rm -r schemas
ln -s $EZ_DIR/schemas schemas

#rm -r share
ln -s $EZ_DIR/share share

#rm settings/*.ini
mkdir settings
cp $EZ_DIR/settings/*.ini settings

#rm -r doc
#rm -r support
#rm -r update
ln -s $EZ_DIR/support support
ln -s $EZ_DIR/update update
ln -s $EZ_DIR/doc doc

cp $EZ_DIR/index* ./
cp $EZ_DIR/access.php ./
cp $EZ_DIR/autoload.php ./
cp $EZ_DIR/ezpm.php ./
cp $EZ_DIR/runcronjobs.php ./
cp $EZ_DIR/soap.php ./
cp $EZ_DIR/webdav.php ./
cp $EZ_DIR/pre_check.php ./
cp $EZ_DIR/LICENSE ./
cp $EZ_DIR/README.txt ./
cp $EZ_DIR/ezpublish.cron ./

cp ../ez4_skel/.gitignore .

mkdir var
mkdir extension


#chown -R git.www-data *
#chmod -R 770 var/ settings/ design/ autoload/

#php bin/php/ezcache.php --clear-all --purge