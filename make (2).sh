#!/bin/bash


BASE_DIR=$(cd "$(dirname "$0")"; pwd)
HS_COMPILE=$BASE_DIR/../hs_compile/
TARGET_DIR=
TARGET_FILE=
WORK_DIR=

PARAM_BRANCH=$1
PARAM_BUILD=$2
PARAM_NUM = $#

if [ ${PARAM_NUM} -ne 2 ]; then
	echo "Parameter abnormality!"
fi

if [ -f $TARGET_FILE ];then
	rm $TARGET_FILE -rf
fi

build_db_compile()
{
	cd ${HS_COMPILE}/src
	echo build ips_rules_dbcompile begin!
	make clean && make 

	if [ ! -f ${HS_COMPILE}/bin/ips_rules_dbcompile ];then
		echo "make ips_rules_dbcompile error!"
		exit 1;
	fi

	cd -
}

hyperscan_db_generate()
{
	
}
ips_rules_packet()
{
	cd ${BASE_DIR}
	if [ ! -f ${TARGET_DIR}/${TARGET_FILE} ];then
		echo "${TARGET_DIR}/${TARGET_FILE} error!"
		exit 1;
	fi
	cp ${TARGET_DIR}/${TARGET_FILE}/ ./ -rf
	cd -
}


build_db_compile
hyperscan_db_generate
ips_rules_packet