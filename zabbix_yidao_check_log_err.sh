#!/bin/sh
#Yidao_zabbix_check_log_error
#POWERED BY YuYang
#MAIL:yuyangx6@gmail.com

ERR_SUM=3

#充反项目的错误监控，日志梳理
REBATE_REBATE_ERR_LOG() {
	DATE=`date +%Y%m%d`
	DATE_PRE=`date "+%d %H:%M" -d "- 1 min"`
	ERR_LOG="/var/log/yongche/rebate/rebate_rebate_ERROR_log-${DATE}"
	if [ ! -f ${ERR_LOG} ];then
	    ERR_NUM=''
	else
		ERR_NUM=`tail -n 20000 ${ERR_LOG}|grep "${DATE_PRE}"|grep ERROR | wc -l`
		if [ ${ERR_NUM} -ge 1 ];then
			echo ${ERR_LOG},${ERR_NUM}
		fi
	fi

}


#CHARGE
CHARGE_ERR_LOG() {
	DATE=`date +%Y%m%d`
	DATE_PRE=`date "+%d %H:%M" -d "- 1 min"`
	ERR_LOG="/var/log/httpd/charge_error_log-${DATE}"
	if [ ! -f ${ERR_LOG} ];then
	    ERR_NUM=''
	else
		ERR_NUM=`tail -n 20000 ${ERR_LOG}|grep "${DATE_PRE}"|grep -iE "Fatal|read error" | wc -l`
		if [ ${ERR_NUM} -ge ${ERR_SUM} ];then
			echo ${ERR_LOG}
		fi
	fi

}


#2
APP_API_ERR_LOG() {
	DATE_PRE=`date "+%d %H:%M" -d "- 1 min"`
	ERR_LOG='/var/log/nginx/yongche-app-api/yongche-app-api_error_log'
	if [ ! -f ${ERR_LOG} ];then
	    ERR_NUM=''
	else
		ERR_NUM=`tail -n 20000 ${ERR_LOG}|grep "${DATE_PRE}"|grep [error] | wc -l`
		if [ ${ERR_NUM} -ge ${ERR_SUM} ];then
			echo ${ERR_LOG}
		fi
	fi

}

#3
DRIVER_API_ERR_LOG() {
	DATE_PRE=`date "+%d %H:%M" -d "- 1 min"`
	ERR_LOG='/var/log/nginx/driver-api/driver-api_error_log'
	if [ ! -f ${ERR_LOG} ];then
	    ERR_NUM=''
	else
		ERR_NUM=`tail -n 20000 ${ERR_LOG}|grep "${DATE_PRE}"|grep [error] | wc -l`
		if [ ${ERR_NUM} -ge ${ERR_SUM} ];then
			echo ${ERR_LOG}
		fi
	fi
}

#4
MERCHANT_ERR_LOG() {
	DATE_PRE=`date "+%d %H:%M" -d "- 1 min"`
	ERR_LOG='/var/log/httpd/merchant_error_log'
	if [ ! -f ${ERR_LOG} ];then
	    ERR_NUM=''
	else
		ERR_NUM=`tail -n 20000 ${ERR_LOG}|grep "${DATE_PRE}"|grep [error] | wc -l`
		if [ ${ERR_NUM} -ge ${ERR_SUM} ];then
			echo ${ERR_LOG}
		fi
	fi
}

#5
#支付模块
ACCOUNT_ERR_LOG() {
	DATE_PRE=`date "+%d %H:%M" -d "- 1 min"`
        ERR_LOG='/var/log/nginx/account-platform/account_error_log'
        if [ ! -f ${ERR_LOG} ];then
                ERR_NUM=0
        else
            ERR_NUM=`tail -n 20000 ${ERR_LOG} | grep "${DATE_PRE}" | grep -E "Fatal|read error|The instance is NULL|Socket error|AMQPQueueException|DBException" | wc -l`
                if [ ${ERR_NUM} -ge ${ERR_SUM} ];then
                        echo ${ERR_LOG}
                fi
        fi
}


#message
MESSAGE_WATCHD_LOG() {
	DATE_PRE=`date "+%d %H:%M" -d "- 1 min"`
	FILE=`ls /home/y/var/watchd/logs/*.log|grep -v "access"`
	for LOG in ${FILE};
	do
	ERR_NUM=`tail -n 20000 ${LOG}|grep "${DATE_PRE}"|grep ERROR | wc -l`
	if [ ${ERR_NUM} -lt ${ERR_SUM} ];then
            continue
        else
                if [ -z ${LOG_ALERT} ];then
                        LOG_ALERT=${LOG}
                else
                        LOG_ALERT=${LOG_ALERT},${LOG}
                fi
        fi
        done
	[ ! -z ${LOG_ALERT} ] && echo ${LOG_ALERT}
}

#message
MESSAGE_PSF_ATM_MESSAGE_LOG() {
	DATE_PRE=`date "+%d %H:%M" -d "- 1 min"`
	FILE=`ls /home/y/var/psf/logs/message.log /home/y/var/psf/logs/atm2.log`
	for LOG in ${FILE};
	do
	ERR_NUM=`tail -n 20000 ${LOG}|grep "${DATE_PRE}"|grep ERROR | wc -l`
	if [ ${ERR_NUM} -lt ${ERR_SUM} ];then
                continue
        else
                if [ -z ${LOG_ALERT} ];then
                        LOG_ALERT=${LOG}
                else
                        LOG_ALERT=${LOG_ALERT},${LOG}
                fi
        fi
        done
	[ ! -z ${LOG_ALERT} ] && echo ${LOG_ALERT}
}

#设备中心
#mengine
MENGINE_PSF_LOG() {
	DATE_PRE=`date "+%d %H:%M" -d "- 1 min"`
	FILE=`ls /home/y/var/psf/logs/mengine.log /home/y/var/psf/logs/meproxy.log /home/y/var/psf/logs/mrouter.log`
	for LOG in ${FILE};
	do

	ERR_NUM=`tail -n 20000 ${LOG} | grep "${DATE_PRE}"|grep ERROR | wc -l`
	if [ ${ERR_NUM} -lt ${ERR_SUM} ];then
                continue
        else
                if [ -z ${LOG_ALERT} ];then
                        LOG_ALERT=${LOG}
                else
                        LOG_ALERT=${LOG_ALERT},${LOG}
                fi
        fi
        done
	[ ! -z ${LOG_ALERT} ] && echo ${LOG_ALERT}
}

#mengine
MENGINE_WATCHD_LOG() {
	DATE_PRE=`date "+%d %H:%M" -d "- 1 min"`
	FILE=`ls /home/y/var/watchd/logs/*.log|grep -v "access"|grep -iE "mrouter|meproxy-meproxy|mengine-mengine|dcenter"`
	for LOG in ${FILE};
	do
	ERR_NUM=`tail -n 20000 ${LOG} | grep "${DATE_PRE}"|grep ERROR | wc -l`
	    if [ ${ERR_NUM} -lt ${ERR_SUM} ];then
            continue
        else
            if [ -z ${LOG_ALERT} ];then
                LOG_ALERT=${LOG}
            else
                LOG_ALERT=${LOG_ALERT},${LOG}
            fi
        fi
    done
    [ ! -z ${LOG_ALERT} ] && echo ${LOG_ALERT}
}

#订单中心
ORD_ERROR_LOG() {
	DATE_PRE=`date "+%d %H:%M" -d "- 1 min"`
	#FILE=`ls /home/y/var/psf/logs/*.log`
	FILE=`ls /home/y/var/psf/logs/order.log /home/y/var/psf/logs/oc.log`
	for LOG in ${FILE};
	do
	ERR_NUM=`tail -n 20000 ${LOG}|grep "${DATE_PRE}"|grep -iE "failed by http method|server has gone away" | wc -l`
	if [ ${ERR_NUM} -lt ${ERR_SUM} ];then
        continue
    else
        if [ -z ${LOG_ALERT} ];then
                LOG_ALERT=${LOG}
        else
                LOG_ALERT=${LOG_ALERT},${LOG}
        fi
    fi
    done
    [ ! -z ${LOG_ALERT} ] && echo ${LOG_ALERT}
}

#派单-DSC
DSC_ERR_LOG() {
	DATE_PRE=`date "+%d %H:%M" -d "- 1 min"`
	ERR_LOG='/home/y/var/psf/logs/dispatch.log'
	if [ ! -f ${ERR_LOG} ];then
		ERR_NUM=0
	else
	    ERR_NUM=`tail -n 20000 ${ERR_LOG}|grep "${DATE_PRE}"|grep ERROR | wc -l`
		if [ ${ERR_NUM} -ge ${ERR_SUM} ];then
			echo ${ERR_LOG}
		fi
	fi
}

#派单-DSCM
DSCM_ERR_LOG() {
	DATE_PRE=`date "+%d %H:%M" -d "- 1 min"`
	FILE=`ls /home/y/var/watchd/logs/dispatch-*.log`
	for LOG in ${FILE};
	do
	ERR_NUM=`tail -n 20000 ${LOG}|grep "${DATE_PRE}"|grep ERROR | wc -l`
        if [ ${ERR_NUM} -lt ${ERR_SUM} ];then
                continue
        else
                if [ -z ${LOG_ALERT} ];then
                        LOG_ALERT=${LOG}
                else
                        LOG_ALERT=${LOG_ALERT},${LOG}
                fi
        fi
    done
    [ ! -z ${LOG_ALERT} ] && echo ${LOG_ALERT}
}

#加价
BID_ERR_LOG() {
	DATE_PRE=`date "+%d %H:%M" -d "- 1 min"`
	ERR_LOG='/home/y/var/psf/logs/bidding.log'
	if [ ! -f ${ERR_LOG} ];then
		ERR_NUM=0
	else
	    ERR_NUM=`tail -n 20000 ${ERR_LOG}|grep "${DATE_PRE}"|grep ERROR | wc -l`
		if [ ${ERR_NUM} -ge ${ERR_SUM} ];then
			echo ${ERR_LOG}
		fi
	fi
}

#支付
SA_PAY_ERR_LOG() {
	DATE_PRE=`date "+%d %H:%M" -d "- 1 min"`
	FILE=`ls -l /var/log/nginx/driver-settlement/settlement_error_log /var/log/yongched/ds-order_compute_distribute.error.log /var/log/yongched/ds-async_notice.error.log|awk '{print $NF}'`
	for LOG in ${FILE};
	do
	ERR_NUM=`tail -n 20000 ${LOG}|grep "${DATE_PRE}"|grep -i "PHP Fatal error" | wc -l`
	if [ ${ERR_NUM} -lt ${ERR_SUM} ];then
            continue
    else
            if [ -z ${LOG_ALERT} ];then
                    LOG_ALERT=${LOG}
            else
                    LOG_ALERT=${LOG_ALERT},${LOG}
            fi
    fi
    done
        [ ! -z ${LOG_ALERT} ] && echo ${LOG_ALERT}
}

#SC
SC_ERR_LOG() {
    DATE_PRE=`date "+%d %H:%M" -d "- 1 min"`
    ERR_LOG='/home/y/var/psf/logs/psf_service_centerd.log'
    if [ ! -f ${ERR_LOG} ];then
        ERR_NUM=0
    else
        ERR_NUM=`tail -n 20000 ${ERR_LOG}|grep "${DATE_PRE}"|grep ERROR | wc -l`
            if [ ${ERR_NUM} -ge ${ERR_SUM} ];then
                    echo ${ERR_LOG}
            fi
    fi
}

#UC_MALL
UC_MALL_ERR_LOG() {
	DATE=`date +%Y%m%d`
    DATE_PRE=`date "+%d %H:%M" -d "- 1 min"`
    FILE=`ls  /var/log/yongche/UC/UC_MALL_*ERROR_log*| grep ${DATE}`
    for LOG in ${FILE};
    do
    ERR_NUM=`tail -n 20000 ${LOG} | grep "${DATE_PRE}" | grep -i "ERROR" | wc -l`
        if [ ${ERR_NUM} -lt ${ERR_SUM} ];then
            continue
        else
	       if [ -z ${LOG_ALERT} ];then
		        LOG_ALERT=${LOG}
	       else
		        LOG_ALERT=${LOG_ALERT},${LOG}
	       fi
        fi
	done
	[ ! -z ${LOG_ALERT} ] && echo ${LOG_ALERT}
}

#派单重构
DISPATCH_REFACTOR() {
	DATE=`date +%Y%m%d`
    DATE_PRE=`date "+%H:%M" -d "- 1 min"`
	FILE=`ls  /yongche/logs/dispatch*.log | grep ${DATE}`
    for LOG in ${FILE};
    do
    ERR_NUM=`tail -n 20000 ${LOG} | grep "${DATE_PRE}" | grep -i "ERROR" | wc -l`
    if [ ${ERR_NUM} -lt ${ERR_SUM} ];then
        continue
    else
	    if [ -z "${LOG_ALERT}" ];then
		    LOG_ALERT=${LOG}
	    else
		    LOG_ALERT=${LOG_ALERT},${LOG}
	    fi
    fi
	done
	[ ! -z "${LOG_ALERT}" ] && echo ${LOG_ALERT}
}


#评价与收藏
FEED_LAN_CHECK_LOG() {
    DATE=`date +%Y%m%d`
    DATE_PRE=`date "+%d %H:%M" -d "- 1 min"`
    FILE=`ls  /home/y/var/logs/feed-web/yc_feed.log`
    for LOG in ${FILE};
    do
    ERR_NUM=`tail -n 20000 ${LOG} | grep "${DATE_PRE}" | grep -i "系统异常|读取配置中心错误|ret_code='500'" | wc -l`
        if [ ${ERR_NUM} -lt ${ERR_SUM} ];then
            continue
        else
	       if [ -z "${LOG_ALERT}" ];then
		        LOG_ALERT=${LOG}
	       else
		        LOG_ALERT=${LOG_ALERT},${LOG}
	       fi
        fi
	done
	[ ! -z "${LOG_ALERT}" ] && echo ${LOG_ALERT}

}

#New merchant check_log
NEW_MERCHANT_CHECK_LOG() {
    DATE=`date +%Y%m%d`
    DATE_PRE=`date "+%d %H:%M" -d "- 1 min"`
    FILE=`ls /home/y/var/log/tomcat/catalina.out /home/y/var/log/merchant/merchant_logs.log`
    for LOG in ${FILE};
    do
    ERR_NUM=`tail -n 20000 ${LOG} | grep "${DATE_PRE}" | grep -i "Exception" | wc -l`
        if [ ${ERR_NUM} -lt ${ERR_SUM} ];then
            continue
        else
               if [ -z "${LOG_ALERT}" ];then
                        LOG_ALERT=${LOG}
               else
                        LOG_ALERT=${LOG_ALERT},${LOG}
               fi
        fi
        done
        [ ! -z "${LOG_ALERT}" ] && echo ${LOG_ALERT}

}


#run from hostname
#1
#UC_DAEMON_REBATE_JOB_ERR_LOG
if [ `echo ${HOSTNAME} | grep -E "ret[1-3].pcs" | wc -l` -eq 1 ];then
	REBATE_REBATE_ERR_LOG

#2
#APP_API_ERR_LOG
elif [ `echo ${HOSTNAME} | grep -E "appapi[1-9].car" | wc -l` -eq 1 ];then
	APP_API_ERR_LOG

#3
#DRIVER_API_ERR_LOG
elif [ `echo ${HOSTNAME} | grep -E "driver-api[1-9].car" | wc -l` -eq 1 ];then
	DRIVER_API_ERR_LOG

#4
#MERCHANT_ERR_LOG
elif [ `echo ${HOSTNAME} | grep -E "mer[1-9].car" | wc -l` -eq 1 ];then
	MERCHANT_ERR_LOG

#5
#ACCOUNT_ERR_LOG
elif [ `echo ${HOSTNAME} | grep -E "ap[3-6].sys" | wc -l` -eq 1 ];then
	ACCOUNT_ERR_LOG

#6,7
#MESSAGE_WATCHD_LOG
#MESSAGE_PSF_ATM_MESSAGE_LOG
elif [ `echo ${HOSTNAME} | grep -E "ms[1-9].arch" | wc -l` -eq 1 ];then
	MESSAGE_WATCHD_LOG
	MESSAGE_PSF_ATM_MESSAGE_LOG

#8,9
#MENGINE_PSF_LOG
#MENGINE_WATCHD_LOG
elif [ `echo ${HOSTNAME} | grep -E "mengine[1-9].arch" | wc -l` -eq 1 ];then
	MENGINE_PSF_LOG
	MENGINE_WATCHD_LOG

#10
#ORD_ERROR_LOG
elif [ `echo ${HOSTNAME} | grep -E "ord[1-9].arch" | wc -l` -eq 1 ];then
	ORD_ERROR_LOG

#11
#DSC_ERR_LOG
elif [ `echo ${HOSTNAME} | grep -E "dsc[1-9].arch" | wc -l` -eq 1 ];then
	DSC_ERR_LOG

#12
#DSCM_ERR_LOG
elif [ `echo ${HOSTNAME} | grep -E "dscm[1-9].arch" | wc -l` -eq 1 ];then
	DSCM_ERR_LOG

#13
#BID_ERR_LOG
elif [ `echo ${HOSTNAME} | grep -E "bid[1-9].pcs" | wc -l` -eq 1 ];then
	BID_ERR_LOG

#14
#CHARGE_ERR_LOG
elif [ `echo ${HOSTNAME} | grep -E "chrg[1-9].sys" | wc -l` -eq 1 ];then
	CHARGE_ERR_LOG

#15
#SA_PAY_ERR_LOG
elif [ `echo ${HOSTNAME} | grep -E "sa[1-9].arch" | wc -l` -eq 1 ];then
	SA_PAY_ERR_LOG

#16
#SC-SERVER
elif [ `echo ${HOSTNAME} | grep -E "sc[1-2].arch" | wc -l` -eq 1 ];then
	SC_ERR_LOG 

#UC_MALL
elif [ `echo ${HOSTNAME} | grep -E "fe[2-4].car" | wc -l` -eq 1 ];then
	UC_MALL_ERR_LOG

#DISPATCH_REFACTOR
elif [ `echo ${HOSTNAME} | grep -E "dsc[7-8].pcs" | wc -l` -eq 1 ];then
	DISPATCH_REFACTOR

#FEED.LAN
elif [ `echo ${HOSTNAME} | grep -E "ar[1-3].pcs" | wc -l` -eq 1 ];then
	FEED_LAN_CHECK_LOG

#NEW_MERCHANT_CHECK_LOG
elif [ `echo ${HOSTNAME} | grep -E "nmer[1-3].pcs" | wc -l` -eq 1 ];then
	NEW_MERCHANT_CHECK_LOG

fi
