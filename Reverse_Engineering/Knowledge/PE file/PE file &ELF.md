

## **PE file**

**1. PE file là gì?**

PE( Portable Executable ) là định dạng file riêng của Win32. Tất cả các file có thể thực thi được trên Win32(ngoại trừ các tập VxDs và các file Dlls 16 bit ) đều sử dụng định dạng PE. Các file Dlls 32 bit , các file COM, các điều khiển 0CX, các chương trình ứng dụng nhỏ trong Control Pannel (.CPL files) và các ứng dụng .NET, tất cả đều là định dạng PE. Các chương trình điều khiển ở Kernel mode của các hệ điều hành NT cũng sử dụng định dạng PE.
___
**2. Tại sao cần tìm hiểu chi tiết về PE file**

Việc tìm hiểu PE file có một số  lý do chính :

 - Hiểu được cơ chế thực thi của một chương trình, tổ chức bộ nhớ, tài  
   nguyên sử dụng.
 - Chúng ta muốn thêm đoạn code  vào trong những file thực thi (Keygen
   Injection hoặc thêm các chức năng ).
 - Thực hiện công việc unpacking bằng tay  các file thực thi.

**Notes** : xét hai khái niệm mới *pack* và *unpack*

 - **Pack**:  là phương pháp sử dụng các thuật toán để nén một chương trình (hay thư viện, dữ liệu ..) lại . Hầu như các phần mềm hiện nay đều được “*pack*” với mục đích làm giảm kích thước của file đồng thời cung cấp thêm một lớp bảo vệ cho file.
 - **Unpack** : quá trình sử dụng các phương pháp loại bỏ việc pack và tìm lại chương trình gốc để có thể reverse và xem code.

 ___
 **3. **Cấu trúc cơ bản của PE file :****

![](https://i.imgur.com/36V6qr0.png)

Ở mức tối thiểu nhất thì một PE file có 2 Sections : 1 cho đoạn mã và 1 cho phần dữ liệu. Một chương trình ứng dụng chay trên nền tảng WinNT  có 9 sections được xác định trước có tên `.text` , `.bss`, .`rdata`, `.data`, `.edata`, `.idata`, `.pdata`, và `.debug`. Một số chương trình ứng dụng lại không cần tất cả những sections này.
Những sections mà hiện nay đang tồn tại và xuất hiện thông dụng nhất trong một file thực thi là :

 - Executable code section , có tên `.text` hoặc CODE.
 - Data Sections, có những tên như `.data` , `.rdata` hoặc `.bss` hay DATA.
 - Resource section có tên `.rsrc`.
 - Export data section có tên `.edata`.
 - Import data section có tên `.idata`.
 - Debug information section có tên là `.debug`.

**DOS MZ Header**

Tất cả các file PE bắt đầu bằng DOS header, vùng này chiếm  64 bytes đầu tiên của file. 

![](https://i.imgur.com/kh6wyet.png)

Trong cấu trúc ở hình bên trên, chúng ta cần quan tâm tới hai trường:
-   e_magic: Chữ ký của PE file, giá trị: `4Dh`, `5Ah` (Ký tự “MZ”, tên của người sáng lập MS-DOS: Mark Zbikowsky). Giá trị này đánh dấu một DOS Header hợp lệ và được phép thực thi tiếp.
-   e_lfanew: là một DWORD nằm ở cuối cùng của DOS Header, là trường chứa offset của PE Header so với vị trí đầu file.

![](https://i.imgur.com/anBUJke.png)

**PE hearder** 

![](https://i.imgur.com/SKYxRwK.png)


*Cấu trúc PE Header bao gồm 3 phần* :

 - *Signature* là môt DWORD chưa giá trị như sau `50h`, `45h`, `00h`, `00h` (Các  kí tự "PE" được đi kèm bởi các giá trị tận cùng là 0).
 - *FileHeader* bao gồm 20 bytes tiếp theo của PE file, chứ thông tin về
   sơ đồ bố trí vật lý và đặc tính của file.
 - *OptionalHeader* :tạo thành bởi 224 bytes tiếp theo. Chứa thông tin về
   sơ đồ Logic bên trong của một file PE.

**The Section table** 
Là một mảng những cấu trúc `IMAGE_SECTION_HEADER`, mỗi phần tử chưa thông tin về Section trong PE file. Cấu trúc được định nghĩa trong file `windows.inc` như sau :

![](https://i.imgur.com/61XIBnU.png)

 - *Namel* : Tên này chỉ là một nhãn và có thể để trống.
 - *VirtualSize* : Kích thước thật sự của dữ liệu trên section tính theo.
   byte, giá trị này có thể nhỏ hơn kích thước trên ổ đĩa.
 -  *VirtualAddress*: RVA của section, trình PE loader sẽ phân tích và sử dụng. giá trị trong trường này khi ánh xạ section vào trong bộ nhớ.
 -   *SizeOfRawData*: Kích thước section data trên đĩa.
 -   *PointerToRawData*: là offset từ vị trí đầu file tới section data.
 -   *Characteristics*: bao gồm các cờ ví dụ như section này có thể chứa executable code, initialized data....
___
**4. **Công cụ**** 

  **Hxd(Hex edittor)**

   Website : [https://mh-nexus.de/en/hxd/](https://mh-nexus.de/en/hxd/)

 - giao diện dễ sử dụng
cung cấp các tính năng như tìm kiếm , thay thế, ghi đè, insert mode ...
Checksum-Generator : Checksum, CRCs, Custom CRC, SHA-1, SHA-512,MD5...
 - Export dữ liệu sang nhiều dịnh dạng
---
**PEid**

![](https://i.imgur.com/IM4hR8l.jpg)

Tải [tại đây](https://www.softpedia.com/get/Programming/Packers-Crypters-Protectors/PEiD-updated.shtml) 
Môt số chức năng chính :

 - Scan file thực thi và chỉ ra loại packer file sử dụng
 - TÌm kiếm OEP(original entry point)
 - PE disassembler
 - Đi kèm với PEiD có một Plugin quan trọng là Krypto ANAlyser. Plugin
   này giúp chúng ta biết file sử dụng những loại mật mã gì . Ví dụ CRC,
   MD4, MD5…

![](https://i.imgur.com/rCW8It0.png)

**Notes** :

 - **Entry point** (EP): để 1 chương trình được thực thi, nó cần được load
   lên memory, sau khi Windows hoàn thành công việc này ,sẽ sẽ chuyển
   quyền điều khiển cho file .exe. Địa chỉ trên bộ nhớ của câu lệnh đầu
   tiên của file .exe đươc thực thi chính là EP
 - Đối với 1 file đã bị pack, nói đến EP ta sẽ hiểu là Entry Point của
   file sau khi Pack. Còn **OEP** là EP của file gốc trước khi bị pack.
___
**LordPE**

![](https://i.imgur.com/BUVb3Op.jpg)

tải [tại đây](http://www.woodmann.com/collaborative/tools/images/Bin_LordPE_2010-6-29_3.9_LordPE_1.41_Deluxe_b.zip)
Một số tính năng :

 - Rebuild lại PE header  
 - Chỉnh sửa và so sánh các PE files
 - đọc thêm : [unpacking using Ollydbg](http://paulslaboratory.blogspot.com/2014/04/unpacking-using-ollydbg.html)

Công cụ khác :
 - [ImpREC](http://www.woodmann.com/collaborative/tools/images/Bin_ImpREC_2011-7-16_8.11_ImpREC_1.7e.rar)
 - [CFF Explorer](https://ntcore.com/?page_id=388)
_____________________
___
___

## ELF File

**1. **ELF file  là gì ?****
EFL (Executable and Linkable Format)  là định dạng file phổ biến cho các tệp thực thi, thư viện, ... trong môi trường Linux .Các file ELF thường là output của trình biên dịch (complier) hoặc trình liên kết (linker).

**2. Tại sao phải tìm hiểu chi tiết về ELF ?**

 - Hiểu cách mà hệ điều hành hoạt động.
 - Phát triển phần mềm.
 - Điều tra số và ứng phó sự cố  ( Digital Forensics and Incident
   Response).
 - Phân tích mã độc.

**3. Cấu trúc** 

![](https://i.imgur.com/v1r8b3y.png)

Cấu trúc ELF file bao gồm :

 - ELF  header.
 - File data.

Sử dụng lênh `readelf` , chúng ta có thể xem cấu trúc của 1 file như sau : 

![](https://i.imgur.com/y2QaX2f.png)

 - Trong phần *magic* , cung cấp thông tin về file. với tiền tố là 7f,
   theo sau là `45 4c 46` (45 =E , 4c =L, 46 = F) xác định đây là *ELF
   file* . ELF header này là bắt buộc. Đảm bảo dữ liệu được chính xác
   trong quá trình liên kết hoặc thực thi.
 - Sau *magic*  là trường *Class*. Giá trị này xác định kiến trúc của file.
   Có thể là kiến trúc  32 bit (=01) hoặc 64 bit (=02)
 - Tiếp theo là trường *Data* . Có hai option : 01 cho `LSB` (Least
   Significant Bit- bit có trọng số thấp) còn được gọi là Little-Endian.
   02 cho `MSB` (Most Significant Bit- bit có trọng số cao) còn được gọi là
   Big- Edian.
....
 - Type : trường Type cho biết một loại file. Một vài loại file phổ biến :
    -   CORE (giá trị là 4 ).
   - DYN (file  chia sẻ ) cho các thư viên (giá trị là 3).
   - EXEC (file thực thi)  cho file nhị phân (giá trị là 2).
   - REL (relocatable file ) trước khi liên kết thành tệp thực thi(giá trị 1).

**File DATA**
Bên cạnh ELF header , ELF bao gồm 3 phần :

 - Program Headers hoặc Segment.
 - Section Headers hoặc Section.
 - DATA.

**Program Header** 

![](https://i.imgur.com/HJ6enoI.png)

*GNU_EH_FRAME* :một hàng đợi được sử dụng bởi trình biên dịch GNU(gcc). Sử dụng xử lý ngoại lệ. 
*GNU_STACK*  :lưu trữ thông tin ngăn xếp. 

**ELF sections** 
Đối với file thực thi, có 4 phần chính :
 - .text : chứa mã thực thi. Chỉ được load một lần, do vậy nôi dung sẽ
   không thay đổi.
 - .data : dữ liệu được khởi tạo với quyền đọc/ghi.
 - .rodata: dữ liệu chỉ có quyền truy cập đọc.
 - .bss : dữ liệu chưa được khởi tạo, với quyền truy cập đọc ghi mỗi.
 
 Section được load với quyền truy cập khác nhau, có thể xem thông tin bằng cách sử dụng `readelf -S`.
 ___
**4. Một số tiện ích giúp phân tích file ELF**

`readelf` và `objdump` , cả hai tiện ích được cung cấp bởi **Cygwin**.
**[readelf](https://sourceware.org/binutils/docs/binutils/readelf.html)** hiển thị thông tin về một hoặc nhiều đối tượng có định dạng ELF.
**[objdump](https://linux.die.net/man/1/objdump)** có các tính năng tương tự như readelf, nhưng có thêm khả năng disasemble sections
Bên cạnh đó, còn có các packages hỗ trợ file ELF
**[elfutils](https://sourceware.org/elfutils/)** : tập hợp các tiện tích và thư viện để đọc, tạo và sửa đổi các file ELF..
**[elfkickers](https://github.com/BR903/ELFkickers)**
**[pax-utils](https://github.com/gentoo/pax-utils)**

---
---
References
[\[1\]](https://kienmanowar.wordpress.com/category/my-tutorials/pe-tutorials/) : PE file Format - [a.Kiênmanowar](https://kienmanowar.wordpress.com/)
[\[2\]](https://github.com/gentoo/pax-utils) : The 101 ELF files on Linux 

