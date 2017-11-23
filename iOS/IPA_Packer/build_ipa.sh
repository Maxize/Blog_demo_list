# !/bin/bash
# 打包脚本
#

cur_path=$PWD
# ===============================项目自定义部分(自定义好下列参数后再执行该脚本)============================= #

target_name="template"
# 工程中 Target 对应的配置 plist 文件名称, Xcode 默认的配置文件为 Info.plist
info_plist_name="Info"
# 指定要打包编译的方式 : Release, Debug...
build_configuration="Debug"

# ===============================自动打包部分(无特殊情况不用修改)============================= #
# 导出 ipa 所需要的 plist 文件路径 (默认为 DevelopmentExportOptionsPlist.plist)
export_options_plist_path=${cur_path}"/DevelopmentExportOptionsPlist.plist"
# 返回上一级目录,进入项目工程目录
cd ..
# 获取项目名称
project_name=`find . -name *.xcodeproj | awk -F "[/.]" '{print $(NF-1)}'`
# 获取版本号, 内部版本号, bundleID
info_plist_path="$info_plist_name.plist"
bundle_version=`/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" $info_plist_path`
bundle_build_version=`/usr/libexec/PlistBuddy -c "Print CFBundleIdentifier" $info_plist_path`
bundle_identifier=`/usr/libexec/PlistBuddy -c "Print CFBundleVersion" $info_plist_path`


# ================ 开始打包 ================ #
echo "\033[36;1m请选择打包方式(输入序号,按回车即可) \033[0m"
echo "\033[33;1m1. Development \033[0m"
echo "\033[33;1m2. AppStore    \033[0m"
echo "\033[33;1m3. Enterprise  \033[0m"
# 读取用户输入并存到变量里
read parameter
sleep 0.5
method="$parameter"

# 判读用户是否有输入
if [ -n "$method" ]
then
    if [ "$method" = "1" ] ; then
    export_options_plist_path=${cur_path}"/DevelopmentExportOptionsPlist.plist"
    elif [ "$method" = "2" ] ; then
    export_options_plist_path=${cur_path}"/AppStoreExportOptionsPlist.plist"
    build_configuration="Release"
    elif [ "$method" = "3" ] ; then
    export_options_plist_path=${cur_path}"/EnterpriseExportOptionsPlist.plist"
    target_name="template_enterprise"
    build_configuration="Release"
    else
    echo "输入的参数无效!!!"
    exit 1
    fi
fi

echo "export_options_plist_path: "$export_options_plist_path
# 删除旧 .xcarchive 文件
rm -rf $cur_path/$target_name/$target_name.xcarchive
# 指定输出 ipa 路径
export_path="$cur_path/$target_name"
# 指定输出归档文件地址
export_archive_path="$export_path/$target_name.xcarchive"
dateName=`date +%Y-%m-%d-%H:%M:%S`
# 指定输出 ipa 地址
export_ipa_path="$export_path/$dateName"
# 指定输出 ipa 名称 : target_name + bundle_version
ipa_name="$target_name-v$bundle_version"

echo "$bundle_version $bundle_build_version $bundle_identifier"
echo "$export_path $export_archive_path $export_ipa_path"

# # 编译前清理工程
xcodebuild clean -project ${project_name}.xcodeproj \
                 -target ${target_name} \
                 -configuration ${build_configuration}

xcodebuild archive -project ${project_name}.xcodeproj \
                   -scheme ${target_name} \
                   -configuration ${build_configuration} \
                   -archivePath ${export_archive_path}

echo "\033[32m*************************  开始导出ipa文件  *************************  \033[0m"
xcodebuild  -exportArchive \
            -archivePath ${export_archive_path} \
            -exportPath ${export_ipa_path} \
            -exportOptionsPlist ${export_options_plist_path}

#  检查是否构建成功
#  xcarchive 实际是一个文件夹不是一个文件所以使用 -d 判断
if [ -d "$export_archive_path" ] ; then
echo "\033[32;1m项目构建成功 🚀 🚀 🚀  \033[0m"
else
echo "\033[31;1m项目构建失败 😢 😢 😢  \033[0m"
exit 1
fi

open $export_ipa_path
