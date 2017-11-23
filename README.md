# Blog_demo_list

收录博客中涉及到的相关代码

# 已收录

## [iOS 自动打包脚本](./iOS/IPA_Packer)

已实现：MacOsX 下支持输出不同的版本包， Debug, AppStore, Enterprise 包，脚本目录放在项目目录下即可，代码不多简单易懂。

未实现：

* 自动上传到 ftp 用于在线下载
* 使用 Python 重写（如果能够在 window 下打包那么就更有必要）

## [Android 反编译重打包脚本](./Android/Decompile_repack_apk/)

已实现： Windows 下反编译当前目录下的 APK，并重新打包。分成两个脚本，原脚本是一个个打包输出的，这个版本因为做一些演示修改掉了。

未实现： MacOSX 下自行把 adb 相关的执行文件 copy 到当前目录，后续再整理一下关于自动化打包的最新脚本。
