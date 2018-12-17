#!/bin/bash
source init.config
echo $BUILD_TOOL
echo $KEY_STORE
echo $OUT_PUT

var=`env|grep ANDROID_HOME`

build_tool_path
if [ -z "$var" ]; then 
	echo "没有配置android环境变量"
	exit 0
else 
    echo "$var"
	path="${var##*=}"
	#build_tool_path=${path}${build_tool}
	build_tool_path="${path}\build-tools\\${BUILD_TOOL}"
	echo "$build_tool_path"
	if [ ! -d $build_tool_path ];then
		echo "build-tools 工具包不存在"
		exit 0
	fi
	
fi

echo " --------------------"
echo "$build_tool_path"

work_path=$(pwd)
apk_dir_path="$work_path/apk"
apk_abslute_path
apk_name
if [ ! -d $apk_dir_path ];then
	echo "apk包文件不存在"
	exit 0
else
	cd $apk_dir_path
	echo "apk_dir_path path ---------> $apk_dir_path" 
	fileNum=$(ls -l |grep "^-"|wc -l)
	echo $fileNum
	if [ &fileNum -ne 1];then
		echo "apk目录要有且只能有一个待加签名的apk包"
		exit 0
	else
		echo "apk目录正确"
		for file in $(ls *)
		do
			echo $file
			apk_name=$file
			apk_abslute_path="${apk_dir_path}/$apk_name"
		done
		echo $apk_name
		
		apk_name=${apk_name%.*}
		echo $apk_name
	fi
fi

if [ -z "$apk_name" ]; then
	echo "apk目录要有且只能有一个待加签名的apk包"
	exit 0
else 
	cd $build_tool_path
	align_file="${apk_dir_path}/${apk_name}_align.apk"
    zipalign_cmd="zipalign -v -p 4 ${apk_abslute_path} $align_file"
	echo $zipalign_cmd
	eval $zipalign_cmd
	out_dir=${work_path}/${OUT_PUT}
	if [ ! -d $out_dir ];then
		mkdir $out_dir
	fi
	apksigner_cmd="apksigner.bat sign --ks  $KEY_STORE  --ks-key-alias $KEY_ALIAS  --ks-pass pass:$STORE_PASSWORD  --key-pass pass:$KEY_PASSWORD --out ${out_dir}/${apk_name}_align_signed.apk  $align_file"
	echo $apksigner_cmd
	eval $apksigner_cmd
	
   
fi


