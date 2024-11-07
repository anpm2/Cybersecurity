
## Set up môi trường - Giới thiệu công cụ

## 1. **Sandbox**

- Sandbox là một cơ chế bảo mật để phân tách/ cô lập các ứng dụng, ngăn chặn các phần mềm độc hại để chúng không thể làm hỏng hệ thống máy tính, hay cài cắm các mã độc nhằm ăn cắp thông tin cá nhân của bạn.
Cài đặt Sandbox trên Windows 10 :
- Tại thanh tìm kiếm , tìm  “ **Turn Windows features on or off**”

![enter image description here](https://i.imgur.com/k5QbpDw.png)

![Chọn Windows Sanbox](https://i.imgur.com/rVCJtbl.png)


![enter image description here](https://i.imgur.com/umWLc2s.png)


![enter image description here](https://i.imgur.com/zQ4dJNe.png)

## 2. **Máy ảo và cài đặt máy ảo**

- Các máy ảo có vai trò như máy tính ảo. Cung cấp đầy đủ phần cứng ảo như CPU ảo , RAM ảo , ổ đĩa cứng , giao diện mạng và thiết bị khác
- Để cài đặt  các hệ điều hành lên máy ảo có thể sử dụng file ảnh đuôi ISO mà các bản phân phối Linux/Windows cho phép tải về
- Tải file ISO của hệ điều hành Windows [tại đây](https://www.microsoft.com/en-us/software-download/)
- Tải file ISO của hệ điều hành Linux [tại đây](https://www.linux.org/pages/download/)
- Một số phần mềm máy ảo :

 - [ ] **VirtualBox** : phần mềm mã nguồn mở, miễn phí, sử dụng trên môi trường Windows, Mac OS, Linux
![enter image description here](https://i.imgur.com/UX3NtlH.png)

- Tải VirtualBox  [tại đây](https://www.virtualbox.org/wiki/Downloads)
- Hướng dẫn cài đặt VirtualBox trên Windows [tại đây](https://o7planning.org/vi/11881/huong-dan-cai-dat-virtualbox-tren-windows)
- Hướng dẫn cài đặt VirtualBox trên Ubuntu [tại đây](https://o7planning.org/vi/11891/huong-dan-cai-dat-virtualbox-tren-ubuntu)
- Hướng dẫn cài đặt Unbuntu trên máy ảo VirtualBox [tai đây](https://quantrimang.com/huong-dan-cach-cai-dat-ubuntu-tren-may-ao-virtualbox-147351) . Với Windows chúng ta cũng thực hiện tương tự.

 - [ ] **VMware có hai phiên bản chính** : VMware Player(miễn phí) và VMware Workstation(trả phí)

![enter image description here](https://i.imgur.com/bp9bDVg.png)
- Tải VMware [tại đây](https://www.vmware.com/products/workstation-player/workstation-player-evaluation.html)
- Hướng dẫn cài đặt  Unbuntu trên Vmware [tại đây](https://o7planning.org/vi/11327/huong-dan-cai-dat-ubuntu-desktop-tren-vmware)

## 3. **Giới thiệu công cụ**

Trước khi giới thiệu một số công cụ, chúng ta làm rõ một số thuật ngữ cơ bản sau :

 - [ ] **Debuggers** : trình gỡ rối giúp kiểm tra và phát hiện lỗi hoặc đơn giản là hiểu cách chương trình hoạt động. Ví dụ khi phân tích một chương trình nào đó, chúng ta muốn hiểu luồng chương trình này ra sao, sử dụng thuật toán nào….
 - [ ] **Disassemblers**: giúp dịch các mã nhị phân sang các ngôn ngữ bậc thấp khó đọc hơn so với con người như ngôn ngữ assembly
![enter image description here](https://i.imgur.com/485GNYL.png)
>                             Disassembler output

 - [ ] **Decompiler** : dịch các mã nhị phân sang mã nguồn hoặc ngôn ngữ bậc cao, ngắn gọn và dễ đọc hơn nhiều so với Disasemblers

![enter image description here](https://i.imgur.com/SG5CduC.png)

>                    Decompiler ouput


Các công cụ giới thiệu sau đây được phân loại theo từng ngôn ngữ

## **C/C++**

## **IDA**
IDA (**I**nteractive **D**is**A**ssembler) : công cụ _diassembler_ và _debugger_ hỗ trợ trên hầu hết các nền tảng như Windows/Linux/MacOS,và nhiều kiến trúc như x86,x64,.. phân phối bởi [Hex-Rays](https://www.hex-rays.com/product/ida) . IDA hỗ trợ lưu tiến trình đang phân tích vào cơ sở dữ liêu của IDA(idb) để tiếp tục phân tích về sau. Ngoài ra còn có nhiều plugin hỗ trợ
Một số cửa sổ quan trọng như
 - Function windows: cửa sổ chứa danh sách tên các hàm
- IDA view : view mã assembly
- Pseudocode : chứa mã nguồn C, C++
- Hex View : chứa mã hex
- Imports : chứa danh sách các hàm được import
- Export : chứa danh sách các hàm export
- String windows : chứa các string

Tải IDA [tại đây](https://www.hex-rays.com/products/ida/support/download.shtml)

![enter image description here](https://i.imgur.com/iWsfQKX.png)

## **OllyDbg**

OllyDbg công cụ _disassembler_ và _debugger_ trên nền tảng 32-bit.
Trang chủ : [http://www.ollydbg.de/](http://www.ollydbg.de/)
Tải Ollydbg tại đây : [http://www.ollydbg.de/download.htm](http://www.ollydbg.de/download.htm)

Các đặc điểm nổi bật của OllyDbg 
- Giao diện người dùng trực quan
- Phân tích code – theo dõi thanh ghi, nhận dạng các thủ tục , vòng lặp, API calls …
- Loads và Debugs DLLs
- Cho phép người dùng đặt tên các nhãn, thêm comment , mô tả các hàm
- Hỗ trợ nhiều plugins
- Không cần cài đặt.

Bao gồm 5 cửa sổ con :

- Disasembler window : các đoạn mã dưới dang assembly và các comment tại dòng code đó
- Register window : các thanh ghi và giá trị của chúng
- Tip window : thông tin bổ dung cho 1 dòng code
- Dump Window : cho phép người sử dụng xem và chỉnh sửa các giá trị trong bộ nhớ
- Stack Window : thông tin stack(ngăn xếp) của chương trình

![enter image description here](https://i.imgur.com/NR58Rud.png)


Tham khảo tuts [tại đây](https://www.youtube.com/watch?v=wqzZB31zDSs&list=PLcFUp5WYCxVYeR7AgsmjzGW6PjamaY6JO) và [tại đây](https://kienmanowar.wordpress.com/category/ollydbg-tutorials/)



## WinDbg

WinDbg công cụ _debugger_ phân phối bởi Microsoft
Tải công cụ tại đây  : [https://docs.microsoft.com/en-us/windows-hardware/drivers/debugger/debugger-download-tools](https://docs.microsoft.com/en-us/windows-hardware/drivers/debugger/debugger-download-tools)


![enter image description here](https://i.imgur.com/SboCotx.png)

Tham khảo khóa học của Anand Geogre  : [tai đây](https://www.youtube.com/playlist?list=PLhx7-txsG6t6n_E2LgDGqgvJtCHPL7UFu)

## **x64Dbg**

x64Dbg  công cụ _debugger_  mã nguồn mở hỗ trợ cả 32-bit và 64 bit dành cho Windows.
Trang chủ : [https://x64dbg.com/#start](https://x64dbg.com/#start)
Tải x64Dbg  : [tại đây](https://sourceforge.net/projects/x64dbg/files/snapshots/)


![enter image description here](https://i.imgur.com/iAl3cFU.png)

## **.Net (C#)**

## **dnSpy**

dnSpy  công cụ _debugger_ . NET , decomplier và assembly editor
[https://github.com/0xd4d/dnSpy](https://github.com/0xd4d/dnSpy)

Một số tính năng :
- Debug .Net Framwork , .Net Core và Unity game assemblies mà không cần source code.
- Phân tích lớp và các phương thức sử dụng, tìm lời gọi hàm …
- Giao diện trực quan.
- Đi đến entry point và có command khởi tạo module.
- Sử dụng cửa sổ tương tác  để kiểm soát trình gỡ lỗi
- ….

![enter image description here](https://i.imgur.com/sJrYQ6T.png)


## **Java**

[](http://www.javadecompilers.com/apk)

## [Online decompiler]

Online decompiler (http://www.javadecompilers.com/apk) cho Apk and Dex Android files

## [ApkTool]

[ApkTool](https://ibotpeaches.github.io/Apktool/) : phân tách các tệp .apk thành các file source code. Khi tạo một ứng dụng, file .apk sẽ chứa 1 file .dex với binary Dalvik bytecode ở bên trong , platform có thể hiểu được được format, nhưng không thể đọc hay chỉnh sửa. Và apktool là công cụ convert file .dex sang định dạng khác mà con người có thể đọc được Cài đặt : [https://ibotpeaches.github.io/Apktool/install/](https://ibotpeaches.github.io/Apktool/install/)

Một số tính năng :
- Phân tách resources về dạng gần như ban đầu (bao gồm resources.arsc, classes.dex và XMLs)
- Dựng lại resource đã decoded trở lại binary APK/JAR
- …..

## **Python**

## **Uncompyle6**

Uncompyle6: dịch bytecode Python trở lại mã nguồn Python tương đương. Chấp nhận bytecodes các phiên bản 1.5 , 2.1 đến 3.7, bao gồm PyPy bytecode và Dropbox’s Python 2.5 bytecode

Cài đặt  : [https://pypi.org/project/uncompyle6/2.13.3/](https://pypi.org/project/uncompyle6/2.13.3/)

## **Một số công cụ khác :**

- [Procyon](https://bitbucket.org/mstrobel/procyon/wiki/Java%20Decompiler)
-  [Androguard](https://github.com/androguard/androguard/)
-  [Radare2](https://github.com/radare/radare2Radare2)
- [Ghidra](https://ghidra-sre.org/)
- [Binary Ninja](https://binary.ninja/)
- [DotPeek](https://www.jetbrains.com/decompiler/)
- [Hopper](https://www.hopperapp.com/)
- ...

