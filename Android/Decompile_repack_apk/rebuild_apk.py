#!/usr/bin/python
# coding=utf-8
# 重打包

import os
import shutil

def main():
    keystore  = "your keystore"
    storepass = "your password"
    alianame  = "your alianame"
    output_apk_dir = "./output"

    if os.path.exists(output_apk_dir):
        shutil.rmtree(output_apk_dir)

    apk_name            = "android"
    unsign_apk          = r'./output/%s_unsigned.apk'% (apk_name)
    signed_unalignedjar = r'./output/%s_signed_unaligned.apk'% (apk_name)
    signed_alignedjar   = r'./output/%s_rebuild.apk'% (apk_name)
    cmd_pack            = r'java -jar apktool.jar b temp -o %s'% (unsign_apk)
    cmd_sign            = r'jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore %s -storepass %s -signedjar %s %s %s'% (keystore, storepass, signed_unalignedjar, unsign_apk, alianame)
    cmd_align           = r'zipalign -v 4 %s %s' % (signed_unalignedjar, signed_alignedjar)

    os.system(cmd_pack)
    os.system(cmd_sign)
    os.system(cmd_align)
    os.remove(unsign_apk)
    os.remove(signed_unalignedjar)
    print '-------------------- Done --------------------'

if __name__ == '__main__':
    main()
