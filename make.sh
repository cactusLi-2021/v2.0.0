#!/bin/bash
WORK_DIR=$(cd "$(dirname "$0")"; pwd)
platform=$(uname -p)
kernel=$(uname -r)
platform=$(uname -p)
kernel=$(uname -r)
if [ "x$platform" = "xaarch64" ] #AK arm
then
	CURR_ARRCH=arm_64	
	CURR_ARRCH_POST=_arm_64
elif [[ "x$kernel" =~ "x2.6.32" ]] #old x86
then
	CURR_ARRCH=x86_64
	CURR_ARRCH_POST=
else	# other version x86,current is v4
	CURR_ARRCH=x86_64_v4
	CURR_ARRCH_POST=_x86_64_v4
fi

CODE_FOLDER=AUDIT_BUILD
#BASE_DIR=$WORK_DIR/$CODE_FOLDER
BASE_DIR=$WORK_DIR/pack
install_dir=$BASE_DIR/install
CODE_IASSRC_DIR=$BASE_DIR/../../ias_src
CODE_SCRIPT_DIR=$BASE_DIR/../../script
COMM_DSTDIR=$BASE_DIR/usr/local/nswcf
NS_AUDIT_DSTDIR=$COMM_DSTDIR/ns_audit
BLOCK_PROXY_DSTDIR=$NS_AUDIT_DSTDIR/browser_proxy
CRON_DIR=$BASE_DIR/etc/cron.d/
DEP_ENV_DSTDIR=$NS_AUDIT_DSTDIR/env
SMTP_DELAY_DSTDIR=$COMM_DSTDIR/smtp_delay
TOOLS_DSTDIR=$COMM_DSTDIR
TARGET_FILE=ns_audit_install.tgz
SIGNATURE_TRANSFER=signature_transfer.tgz
DEV_BRANCH=AK_base_SWG_v3_0_0_Hotfix16_Dev_Branch/ns_audit

DEP_ENV_SRCDIR=$BASE_DIR/../../depend_src/target_${CURR_ARRCH}/so
DEP_CONF_SRCDIR=$BASE_DIR/../../depend_src/target_${CURR_ARRCH}/conf
QOWL_ENGINE_SRCDIR=$BASE_DIR/../../qowl_server/engine_${CURR_ARRCH}/so/
QOWL_DEF_SRCDIR=$BASE_DIR/../../qowl_server/def/
QOWL_ENGINE_DSTDIR=$BASE_DIR/icg/data/qowl_engine
CRONTAB_DSTDIR=$BASE_DIR/usr/local/nswcf/crontab
DM_SRCDIR=$BASE_DIR/../../data_masking/target_${CURR_ARRCH}/so
WMK_SRCDIR=$BASE_DIR/../../watermark/so/${CURR_ARRCH}
DI_SRCDIR=$BASE_DIR/../../data_identifier/target${CURR_ARRCH_POST}/so
#filetype_transfer
TOOL_DIR=


QOWL_DEF_DSTDIR=$QOWL_ENGINE_DSTDIR/def
#SHELL_DIR=$WORK_DIR/$CODE_FOLDER/build
SHELL_DIR=$WORK_DIR
SVNVERSION=$1
PARANUM=$#

export_source()
{
cd
cd $WORK_DIR
echo `pwd`
#if [ -d $CODE_FOLDER ]
#then
#   echo Remove $CODE_FOLDER
#   rm -rf $CODE_FOLDER
#fi
#error pack dir not exist.
if [ -d $BASE_DIR ]
then
   echo Remove $BASE_DIR
   rm -rf $BASE_DIR
fi
mkdir $BASE_DIR
if [ ! -d $BASE_DIR ]
then
   echo "error:$BASE_DIR creat fail."
   exit 1
fi

if [ -f $TARGET_FILE ]
then
   echo Remove $TARGET_FILE
   rm -rf $TARGET_FILE
fi
}


build_ns_audit()
{
cd ${SHELL_DIR}
echo build ns_audit begin!

[ -f /etc/profile_gcc482  ] && source /etc/profile_gcc482

#make ns_audit 
echo $WORK_DIR
./release.sh ns_audit
cd $CODE_IASSRC_DIR/
if [ ! -f ./UMP/ns_audit ];then
	echo make ns_audit error!
	exit 1;
fi

cp -f ./UMP/ns_audit ./UMP/ns_audit_lt12g


cp -f ./macros.mk ./macros.mk.bak
cp -f ./macros_ge12g.mk ./macros.mk
cd ${SHELL_DIR}
./release.sh ns_audit
cd $CODE_IASSRC_DIR/
if [ ! -f ./UMP/ns_audit ];then
	echo make ns_audit error!
	exit 1;
fi

cp -f ./UMP/ns_audit ./UMP/ns_audit_ge12g
cp -f ./macros.mk.bak ./macros.mk


#cd ${SHELL_DIR}
#make dm_sample_tool
#cd ../ias_src/tool/dm_sample_tool/
#make clean -f Makefile > /dev/null 
#echo "dm_sample_tool make clean done"
#make -f Makefile${CURR_ARRCH_POST} > /dev/null  && echo "dm_sample_tool make release done"
#cp -f dm_sample_tool $CODE_SCRIPT_DIR/tools_${CURR_ARRCH}/dm_sample_tool
}



ns_audit_packet()
{
cd $BASE_DIR

mkdir -p $NS_AUDIT_DSTDIR
mkdir -p $NS_AUDIT_DSTDIR/log/logs
mkdir -p $DEP_ENV_DSTDIR

#mkdir -p $BLOCK_PROXY_DSTDIR/black_list
#mkdir -p $BLOCK_PROXY_DSTDIR/white_list
#mkdir -p $CRON_DIR

mkdir -p $QOWL_ENGINE_DSTDIR
mkdir -p $QOWL_DEF_DSTDIR
mkdir -p $CRONTAB_DSTDIR

cp $CODE_IASSRC_DIR/UMP/ns_audit_* $NS_AUDIT_DSTDIR/
cp $CODE_SCRIPT_DIR/conf/high_latency_thread_*.conf $NS_AUDIT_DSTDIR/
cp $CODE_SCRIPT_DIR/conf/ns_audit_32CPU_PPPOE.conf $NS_AUDIT_DSTDIR/
#cp $CODE_SCRIPT_DIR/filter_http_err_res_code.sh $NS_AUDIT_DSTDIR/filter_http_err_res_code.sh
cp $CODE_SCRIPT_DIR/conf/ns_audit_*CPU_HT.conf $NS_AUDIT_DSTDIR/
cp $CODE_SCRIPT_DIR/conf/ns_audit_*CPU_HT_VM.conf $NS_AUDIT_DSTDIR/
cp $CODE_SCRIPT_DIR/conf/ns_audit_*CPU.conf $NS_AUDIT_DSTDIR/
cp $CODE_SCRIPT_DIR/conf/high_latency_thread*.conf $NS_AUDIT_DSTDIR/
cp $CODE_SCRIPT_DIR/conf/log_*.conf $NS_AUDIT_DSTDIR/
#cp $CODE_SCRIPT_DIR/conf/FileTypeConfig.xml $NS_AUDIT_DSTDIR/
cp $CODE_SCRIPT_DIR/ns_audit_log_run $NS_AUDIT_DSTDIR/log/run
cp $CODE_SCRIPT_DIR/ns_audit_run $NS_AUDIT_DSTDIR/run
cp $CODE_SCRIPT_DIR/ns_audit_ctl $NS_AUDIT_DSTDIR/ns_audit_ctl
cp $CODE_SCRIPT_DIR/block_browser_proxy.sh $NS_AUDIT_DSTDIR/block_browser_proxy.sh
cp $CODE_SCRIPT_DIR/ns_audit_stat.sh $NS_AUDIT_DSTDIR
#cp $CODE_SCRIPT_DIR/connect_reuse_switch.sh $NS_AUDIT_DSTDIR/connect_reuse_switch.sh
#cp $CODE_SCRIPT_DIR/gdb_8.3_audit $NS_AUDIT_DSTDIR/gdb_8.3_audit
cp -f $CODE_SCRIPT_DIR/security_file_allow_ext.list 	$NS_AUDIT_DSTDIR/security_file_allow_ext.list
truncate -s 0 $NS_AUDIT_DSTDIR/security_file_allow_ext.list
cp -f $CODE_SCRIPT_DIR/data_masking_mime_content_type.list     $NS_AUDIT_DSTDIR/data_masking_mime_content_type.list


cp -f $CODE_SCRIPT_DIR/local_av_updator.sh 	$CRONTAB_DSTDIR
cp -f $CODE_SCRIPT_DIR/local_av_offline_updator.sh 	$CRONTAB_DSTDIR


cp $DEP_ENV_SRCDIR/* $DEP_ENV_DSTDIR
cp $DEP_CONF_SRCDIR/* $NS_AUDIT_DSTDIR/
cp $DI_SRCDIR/* $DEP_ENV_DSTDIR
cp $DM_SRCDIR/* $DEP_ENV_DSTDIR
cp $WMK_SRCDIR/* $DEP_ENV_DSTDIR

#cp $CODE_SCRIPT_DIR/cloud_sandbox.sql $NS_AUDIT_DSTDIR
#cp $CODE_SCRIPT_DIR/cloud_sandbox.conf $NS_AUDIT_DSTDIR

#cp $CODE_SCRIPT_DIR/browser_proxy/*.sh $BLOCK_PROXY_DSTDIR
#cp $CODE_SCRIPT_DIR/browser_proxy/black_list/*.list $BLOCK_PROXY_DSTDIR/black_list/
#cp $CODE_SCRIPT_DIR/browser_proxy/white_list/*.list $BLOCK_PROXY_DSTDIR/white_list/
#cp $CODE_SCRIPT_DIR/browser_proxy/cron_get_newest_ip_port_list $BLOCK_PROXY_DSTDIR
#cp $CODE_SCRIPT_DIR/browser_proxy/cron_get_newest_ip_port_list $CRON_DIR

echo "cp ${QOWL_ENGINE_SRCDIR}/* ${QOWL_ENGINE_DSTDIR}"
cp ${QOWL_ENGINE_SRCDIR}/* ${QOWL_ENGINE_DSTDIR}

echo "cp ${QOWL_DEF_SRCDIR}/* ${QOWL_DEF_DSTDIR}"
cp ${QOWL_DEF_SRCDIR}/* ${QOWL_DEF_DSTDIR}/

echo Pack ns_audit end!
}


tools_packet()
{

#new
cp -f $CODE_SCRIPT_DIR/tools_${CURR_ARRCH}/snapshot $TOOLS_DSTDIR/
cp -f $CODE_SCRIPT_DIR/tools_${CURR_ARRCH}/HS_TOOL $NS_AUDIT_DSTDIR/
#cp -f $CODE_SCRIPT_DIR/tools_${CURR_ARRCH}/dm_sample_tool $NS_AUDIT_DSTDIR/
cp -f $CODE_SCRIPT_DIR/tools_${CURR_ARRCH}/filetype_transfer $NS_AUDIT_DSTDIR/
#cp -f $CODE_SCRIPT_DIR/tools_${CURR_ARRCH}/watermark_tool $NS_AUDIT_DSTDIR/
#old
#cp -f $CODE_SCRIPT_DIR/tools_${CURR_ARRCH}/slice_clean $TOOLS_DSTDIR/
#cp -f $CODE_SCRIPT_DIR/tools_${CURR_ARRCH}/slice_combine $TOOLS_DSTDIR/
#cp -f $CODE_SCRIPT_DIR/tools_${CURR_ARRCH}/tohspans $TOOLS_DSTDIR/
#cp -f $CODE_SCRIPT_DIR/tools_${CURR_ARRCH}/code2u8 $TOOLS_DSTDIR/
#cp -f $CODE_SCRIPT_DIR/tools_${CURR_ARRCH}/signature_tool/signature_tool $TOOLS_DSTDIR/
#cp -f $CODE_SCRIPT_DIR/tools_${CURR_ARRCH}/signature_tool/$SIGNATURE_TRANSFER $NS_AUDIT_DSTDIR/



#filetype_transfer

echo Pack tools end!
}

maskpacket()
{
	cd $BASE_DIR
	
	if [  ! -d $NS_AUDIT_DSTDIR ];then
		echo make Faild!!!
	fi
	if [ -d $install_dir ]
	then
	   rm -rf $install_dir/*
	else
	   mkdir -p $install_dir
	fi

	chmod +x ${SHELL_DIR}/*.sh
	cp ${SHELL_DIR}/install_packet.sh  $install_dir/install.sh -rf
	rtn_code=$?
	if [ $rtn_code -ne 0 ];then
		echo "error:$install_dir is deleted by external scripts."
		exit 1
	fi
	cp ${SHELL_DIR}/install_cmd.sh  $BASE_DIR/ -rf

	if [ -f $TARGET_FILE ]
	then
	   echo Remove $TARGET_FILE
	   rm -f $TARGET_FILE
	fi

	#rm -rf build ias_src script dpdk_so ns_url_cate
	tar czf $TARGET_FILE *
	cp -f $TARGET_FILE $WORK_DIR
    cd $WORK_DIR
    #rm -rf $CODE_FOLDER
	echo Rar new packet success: $TARGET_FILE!!!
}
export_source
build_ns_audit
ns_audit_packet
tools_packet
maskpacket
