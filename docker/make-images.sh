set -x
set -u
set -e

. setting.sh

# Create config file of mysql
mkdir -p $ROOT_DIR_OF_INSTALLATION/mysql/conf.d \
         $ROOT_DIR_OF_INSTALLATION/mysql/data   \
         $ROOT_DIR_OF_INSTALLATION/mysql/logs
cat /dev/null > $ROOT_DIR_OF_INSTALLATION/mysql/conf.d/my.cnf
cat << EOF    > $ROOT_DIR_OF_INSTALLATION/mysql/conf.d/my.cnf
[mysqld]
event_scheduler=ON
EOF

# Create an installation file for use by the Add command in the Dockerfile
mkdir -p roudi
cp $ROOT_DIR_OF_3RDPARTY/iceoryx/src/iceoryx-2.0.2/build/iox-roudi ./roudi/

# Pack the zip file and extract it to a specific directory for use by Add in the Dockerfile
make_inst_pkg() {
  rm -rf $1 && mkdir -p $1
  tar -cvzf $1.tar.gz \
    $(find ../bin | grep -v logs | grep $1 | grep -v '\-d \|\-d\-v' | grep -v '/config/\|/plugin/')
  tar -xvzf $1.tar.gz -C $1
  rm -rf $1.tar.gz
}

# Create an installation file for use by the Add command in the Dockerfile
readonly BQMD_SIM=bqmd-sim
make_inst_pkg $BQMD_SIM

# Create an installation file for use by the Add command in the Dockerfile
readonly BQMD_BINANCE=bqmd-binance
make_inst_pkg $BQMD_BINANCE

# Create an installation file for use by the Add command in the Dockerfile
readonly BQTD_BINANCE=bqtd-binance
make_inst_pkg $BQTD_BINANCE

# Create an installation file for use by the Add command in the Dockerfile
readonly BQTD_SRV=bqtd-srv
make_inst_pkg $BQTD_SRV

# Create an installation file for use by the Add command in the Dockerfile
readonly BQRISK_MGR=bqriskmgr
make_inst_pkg $BQRISK_MGR

# Create an installation file for use by the Add command in the Dockerfile
readonly BQWEB_SRV=bqweb-srv
make_inst_pkg $BQWEB_SRV

mkdir -p $ROOT_DIR_OF_INSTALLATION/betterquant/
cp -r $ROOT_DIR_OF_SOLUTION/bin/config $ROOT_DIR_OF_INSTALLATION/betterquant/
cp -r $ROOT_DIR_OF_SOLUTION/bin/plugin $ROOT_DIR_OF_INSTALLATION/betterquant/

# Modify the configuration required by the docker environment
sed -i 's/host=192.168.222.188/host=mysql/g' \
  $(grep 'host=192.168.222.188' $ROOT_DIR_OF_INSTALLATION/betterquant/config -rl | grep yaml)
sed -i "s/password=.*/password=$DB_PASSWD/g" \
  $(grep 'password=.*' $ROOT_DIR_OF_INSTALLATION/betterquant/config -rl | grep yaml)

# Modify the configuration in the development environment
cd $ROOT_DIR_OF_SOLUTION
sed -i "s/password=.*/password=$DB_PASSWD/g" \
  $(find . -type f | grep '\.yaml$' | grep -v 'bin/' | \
  grep -v build | grep -v 3rdparty | grep -v docker)
cd -

docker-compose build --no-cache

echo "Make images success!"
docker images

rm -rf roudi
rm -rf $BQTD_SRV
rm -rf $BQRISK_MGR
rm -rf $BQMD_SIM
rm -rf $BQMD_BINANCE
rm -rf $BQTD_BINANCE
rm -rf $BQWEB_SRV
