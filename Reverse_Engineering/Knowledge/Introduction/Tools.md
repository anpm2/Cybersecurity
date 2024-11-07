Author : Nguyễn Anh Tú

# Giới thiệu một số công cụ

## IDA 
*IDA* là một *disassembler* và *debugger* cung cấp rất nhiều tính năng và hoạt động hoàn hảo trên tất cả các nền tảng như Windows, Linux hoặc Mac OS X. IDA đã trở thành tiêu chuẩn để phân tích mã độc, nghiên cứu lỗ hổng.  </br></br>

**Website :** – https://www.hex-rays.com/products/ida/ </br>

Bạn có thể tải [IDA Freeware](https://www.hex-rays.com/products/ida/support/download_freeware.shtml) được cung cấp miễn phí tại website trên *(Đối với bản IDA Pro các bạn tìm bản crack trên google hoặc có thể inbox vùng kín)*.

![](https://i.imgur.com/6i9fSth.png)

Các bạn có thể tham khảo bộ tut dành cho IDA tại [đây](https://kienmanowar.wordpress.com/category/ida-pro-section/ida-tutorials/)
## OllyDbg

*OllyDbg* là một *debugger* chạy trên nền tảng Windows 32bit. OllyDbg được tập trung vào khả năng phân tích binary code rất mạnh và nó còn được hỗ trợ bởi rất nhiều các teams trên thế giới thông qua các plugin và các bản mod nhằm chống lại các cơ chế `anti-debug` cũng như `anti-ollydbg`. </br>

**Website :** http://www.ollydbg.de/ </br>

#### Một số tính năng của OllyDbg:
* Giao diện người dùng trực quan dễ hiểu.
* Phân tích code - traces register, procedures, loops, API calls, switches, tables, constants and strings.
* Loads và debugs DLLs.
* Quét các đối tượng liên quan.
* Cho phép người dùng define label, comments và mô tả function.
* Hiển thị thông tin debug ở dưới dạng Borland.
* Hỗ trợ lưu các bản vá và ghi chúng vào file thực thi.
* Là phần mềm mã nguồn mở - vì thế nên nó có rất nhiều flugins.

![](https://i.imgur.com/jctGq4T.png)

Các bạn có thể tham khảo bộ tut dành cho OllyDbg tại [đây](https://kienmanowar.wordpress.com/category/ollydbg-tutorials/) hoặc tại [đây](https://tuts4you.com/e107_plugins/download/download.php?list.17)

## x64Dbg

*x64Dbg* là một *x32/x64 debugger* mã nguồn mở dành cho Windows. Về cơ bản nó khá giống OllyDbg nên các bạn có thể tham khảo chức năng trên [trang chủ](https://x64dbg.com) của nó.

**Website :** https://x64dbg.com </br>
**Github :** https://github.com/x64dbg/x64dbg </br>

![](https://i.imgur.com/H5QYxE1.png)


## dex2jar

*dex2jar* là một bộ các cộng cụ làm việc với file **.dex** của android và file **.class** của java. Nó bao gồm một tập các thư viện của java có thể làm việc với các file **apk** của android. </br> </br>
**Github :** https://github.com/pxb1988/dex2jar </br>
**Sourceforge :**  https://sourceforge.net/projects/dex2jar/

**dex2jar** bao gồm các công cụ sau :
- `dex-reader` được thiết kế để đọc định dạng *.dex/.odex*, nó có API tương tự như ASM.
- `dex-translator` được thiết kế để đọc *dex instruction* sang định dạng *dex-ir*, sau khi tối ưu hóa nó sẽ chuyển đổi sang định dạng *ASM*.
- `dex-ir` được sử dụng bởi `dex-translator`, nó được thiết kế để thực hiện các `dex instruction`..
- `dex-tools` là công cụ làm việc với các file *.class*.
- `d2j-smali` phân tách dex thành các file smali và tập hợp dex từ các file smali.
- `dex-writer` viết dex giống như `dex-reader`.

![](https://i.imgur.com/JQWeRPG.png)

Để sử dụng công cụ, hãy làm theo cú pháp sau : 
> sh d2j-dex2jar.sh -f ~/path/to/apk_to_decompile.apk

## JD-GUI

*JD-GUI* là một tiện ích hiển thị mã nguồn Java của các file *.class*. </br>

**Website :** http://jd.benow.ca/ </br>
**Github :** https://github.com/java-decompiler/jd-gui

![](https://i.imgur.com/ZVBcQyL.png)

## Procyon

*Procyon* là một trong những *Java Decompiler* mã nguồn mở phố biến nhất. Procyon decompiler có hỗ trợ Java 5+, điều mà hầu hết các *Java Decompiler* hiện nay không còn hỗ trợ. </br>

**Website  :** https://bitbucket.org/mstrobel/procyon/wiki/Java%20Decompiler  </br>

#### Procyon đặc biệt làm tốt với :
- Khai báo enum
- Các câu lệnh chuyển đổi enum và string (từ java 1.7 về sau)
- Local classes (cả ẩn danh và có tên)
- Chú thích
- Java 8 Lambdas và các phương thức tham chiếu (i.e, :: operator)

![](https://i.imgur.com/YjZc9tH.png)

Để sử dụng Procyon hãy sử dụng cú pháp sau :
> procyon-decompiler.jar -java target.jar -o ~/path/to/decompiled

## Androguard

*Androguard* là một công cụ được viết bằng python dùng để làm việc với các file android như : 
* Dex/Odex (Dalvik virtual machine) (.dex) (disassemble, decompilation)
* APK (Android application) (.apk) 
* Android’s binary xml (.xml) 
* Android Resources (.arsc).

Nó hiện có sẵn cho Linux/Windows/OSX.

**Github :** https://github.com/androguard/androguard/

![](https://i.imgur.com/MK5CPFi.png)

#### Một số tính năng chính :
- Ánh xạ và định dạng các định dạng DEX/ODEX/APK/AXML/ARSC thành các đối tượng python.
- Dịch ngược và chuyển đổi các định dạng DEX/ODEX/APK.
- Dịch ngược trực tiếp từ dalvik bytecodes qua mã nguồn java. 
- Phân tích tĩnh code (các khối cơ bản, instructions, quyền (database ở http://www.android-permissions.org)) và tạo công cụ phân tích tĩnh của riêng bạn.
- Phân tích một loạt các ứng dụng android.
- Phân tích với ipython/sublime text.
- Xem xét sự khác biệt giữa các ứng dụng.
- Đo mức độ hiệu quả của obfuscators(proguard,...).
- Xác định xem ứng dụng của bạn có bị sao chép hay không.
- Database mã nguồn mở của android malware.
- Phát hiện các quảng cáo/thư viện mã nguồn mở(WIP).
- Chỉ số rủi ro của ứng dụng độc hại.
- Dịch ngược ứng dụng (goodware, malwares).
- Chuyển đổi `AndroidManifest.xml` qua xml cơ bản.
- Trực quan hoá ứng dụng của bạn với gephi (định dạng gexf), hoặc với cytoscape (định dạng xgmml) hoặc PNG/DOT.
- Được tích hợp với các decompiler khác (JAD+dex2jar/DED/fernflower/jd-gui…).

## ILSpy

*ILSpy* là một *decompiler* mã nguồn mở .NET. </br>
**Github :** https://github.com/icsharpcode/ILSpy/ 

![](https://i.imgur.com/J8g1Bev.png)

#### Một số tính năng chính:
- Dịch ngược qua C#.
- Dịch ngược toàn bộ projects.
- Tìm kiếm các kiểu/phương thức/thuộc tính (substring).
- Liên kết các kiểu/phương thức/navigation property.
- Dịch ngược từ BAML qua XAML.
- Mở rộng thông qua các plugins.

## DnSpy
*DnSpy* là một *debugger* và là một *.NET assembly editor*. Bạn có thể sử dụng nó để chỉnh sửa và debug ngay cả khi bạn không có sẵn mã nguồn. </br>

**Github :** https://github.com/0xd4d/dnSpy

![](https://i.imgur.com/Qu1nBBL.png)

#### Một số tính năng chính : 
- Debug .NET frameword, .NET Core và Unity game assemblies mà không cần source code.
- Chỉnh sửa assemblies trong C# hoặc Visual Basic hoặc IL và metadata.
- Extension.
- .....

## Radare2

*radare2* là một phiên bản được viết lại từ đầu của *radare* để cung cấp một bộ thư viện và các công cụ làm việc với các binary file. </br>
Radare project được bắt đầu như một công cụ forensic, một scriptable commandline hexadecimal editor, nhưng về sau nó lại được hỗ trợ để phân tích binary file, disassembling code, debug, remote dbg server.

**Github :** https://github.com/radare/radare2

**Official Website :** http://www.radare.org/

![](https://i.imgur.com/cHhIWA3.png)

#### Các tính năng của radare2
- **Hỗ trợ các kiến trúc :** 6502, 8051, CRIS, H8/300, LH5801, T8200, arc, arm, avr, bf, blackfin, xap, dalvik, dcpu16, gameboy, i386, i4004, i8080, m68k, malbolge, mips, msil, msp430, nios II, powerpc, rar, sh, snes, sparc, tms320 (c54x c55x c55+), V810, x86-64, zimg, risc-v.
- **Các định file :**  bios, CGC, dex, elf, elf64, filesystem, java, fatmach0, mach0, mach0-64, MZ, PE, PE+, TE, COFF, plan9, dyldcache, Commodore VICE emulator, Game Boy (Advance), Nintendo DS ROMs and Nintendo 3DS FIRMs.
- **Các hệ điều hành :** Android, GNU/Linux, [Net|Free|Open]BSD, iOS, OSX, QNX, w32, w64, Solaris, Haiku, FirefoxOS.
- **Bindings :** Vala/Genie, Python (2, 3), NodeJS, Lua, Go, Perl, Guile, php5, newlisp, Ruby, Java, OCaml, …

## Một số công cụ khác
- [Ghidra](https://ghidra-sre.org/)
- [Binary Ninja](https://binary.ninja/)
- [DotPeek](https://www.jetbrains.com/decompiler/)
- [Nudge4j](https://github.com/lorenzoongithub/nudge4j)
- [Plasma](https://github.com/plasma-disassembler/plasma)
- [Hopper](https://www.hopperapp.com/)
- [ScratchABit](https://github.com/pfalcon/ScratchABit)
- [Antinet](https://github.com/0xd4d/antinet)
- [De4dot](https://github.com/0xd4d/de4dot)
- [Apktool](https://ibotpeaches.github.io/Apktool/install/)
- ....