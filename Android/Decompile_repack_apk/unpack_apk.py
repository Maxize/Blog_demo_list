#!/usr/bin/python
# coding=utf-8
# 反编译 APK 包

import os
import shutil

def main():
    # 删除临时目录
    if os.path.exists('./temp'):
        shutil.rmtree('./temp')
    # 获取当前目录中所有的apk源包
    src_apks = []
    # python3 : os.listdir()即可，这里使用兼容 Python2 的 os.listdir('.')
    for file in os.listdir('.'):
        if os.path.isfile(file):
            extension = os.path.splitext(file)[1][1:]
            if extension in 'apk':
                src_apks.append(file)

    # 遍历所有 apk 并重新打包
    for src_apk in src_apks:
        src_apk_file_name = os.path.basename(src_apk)
        src_apk_name = src_apk_file_name.split('.apk')[0]
        # 反编译 apk 包
        cmd_extract = r'java -jar apktool.jar d -f -s %s -o temp/%s'% (src_apk_file_name, src_apk_name)
        os.system(cmd_extract)
    print '-------------------- Done --------------------'

if __name__ == '__main__':
    main()
