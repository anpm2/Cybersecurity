# 1. Register (thanh ghi)
là 1 bộ nhớ có dung lượng nhỏ và nhanh được dùng để tăng khả năng  xử lý của các chương trình  của máy tính bằng cách cung cấp các dữ liệu truy cập trực tiếp đến các giá trị cần dùng.

***1.1 Thanh ghi dữ liệu:***
> ![2](https://github.com/user-attachments/assets/fd904860-5f86-4122-b161-fdb65d372721)
* Dùng lưu trữ số liệu để CPU xử lý vd cho số học,logic, ...
  - `AX` là bộ tích luỹ đầu tiên, nó được dùng trong nhập xuất và hầu hết các instruction số học. Ví dụ trong phép nhân, 1 toán hạng được lưu vào EAX hoặc AX hoặc AL tuỳ theo kích cỡ của toán hạng đó.
  - `BX` là thanh ghi cơ sở (base register) được dùng để đánh số địa chỉ
  - `CX` là thanh ghi đếm (count register) được dùng như để đếm số vòng lặp
  - `DX` là thanh ghi dữ liệu, nó cũng được sử dụng trong hoạt động nhập xuất tương tự như AX.

***1.2 Thanh ghi con trỏ:***
> ![3](https://github.com/user-attachments/assets/26edfe01-ef69-4d51-ace7-074540e02b86)
* Lưu trữ địa chỉ bộ nhớ của một vị trí dữ liệu nào đó.
  - `Instruction Pointer (IP)` - lưu trữ địa chỉ offset của instruction tiếp theo để thực thi.
  - `Stack pointer (SP)` - cung cấp giá trị offset nằm trong ngăn xếp chương trình. (trỏ tới đỉnh ngăn xếp)
  - `Base Pointer (BP)` - tham chiếu biến tham số truyền tới chương trình con. (biến cục bộ)


***1.3 Thanh ghi chỉ số***
* Dùng để đánh số địa chỉ và đôi lúc dùng trong phép cộng và trừ. Truy cập các phần tử trong mảng.
  - `Source Index (SI)` - được dùng đánh số của nguồn cho chuỗi operations.
  - `Destination Index (DI)` - ngược lại với source

# 2. Instruction (lệnh)
là một tập hợp các bit mã hóa, được CPU hiểu và thực hiện để thực hiện một thao tác cụ thể.
* Mã op-code: Đây là phần xác định loại hoạt động mà lệnh sẽ thực hiện (ví dụ: cộng, trừ, nhảy).
* Các toán hạng: Đây là dữ liệu mà lệnh sẽ hoạt động, có thể là các giá trị trực tiếp, địa chỉ bộ nhớ hoặc các thanh ghi.

# 3. Stack (ngăn xếp)
là một vùng nhớ được tổ chức theo nguyên tắc LIFO (Last In, First Out)
* Push: Đẩy một phần tử vào đỉnh của ngăn xếp.
* Pop: Lấy phần tử ở đỉnh của ngăn xếp ra.
* Peek: Xem phần tử ở đỉnh của ngăn xếp mà không lấy nó ra.

# 4. Endianess
* Chỉ cách thức các byte của một số đa byte (số có nhiều hơn 8 bit) được sắp xếp trong bộ nhớ máy tính. 
* Quyết định byte nào sẽ được đặt ở vị trí đầu tiên (địa chỉ thấp nhất) và byte nào sẽ được đặt ở vị trí cuối cùng (địa chỉ cao nhất).
>![Big-endian-and-Little-endian](https://github.com/user-attachments/assets/8cb14641-6b21-422e-89d6-64bab66f71b0)

# 5. Calling convention (quy tắc gọi hàm)
định nghĩa rõ ràng cách các hàm truyền tham số, trả về giá trị và quản lý ngăn xếp.
* Cách truyền tham số:
    - Pass by value: Truyền giá trị của biến vào hàm. Khi hàm thay đổi giá trị của tham số, nó chỉ ảnh hưởng đến bản sao của biến đó bên trong hàm, không ảnh hưởng đến biến gốc.
    - Pass by reference: Truyền địa chỉ của biến vào hàm. Khi hàm thay đổi giá trị của tham số, nó sẽ trực tiếp thay đổi giá trị của biến gốc.
* Cách trả về giá trị:
    - Trả về giá trị qua thanh ghi: Kết quả của hàm được lưu vào một thanh ghi cụ thể và sau đó được lấy ra để sử dụng.
    - Trả về giá trị qua ngăn xếp: Kết quả của hàm được đẩy vào ngăn xếp và sau đó được lấy ra để sử dụng.
Cách quản lý ngăn xếp: Quy định ai sẽ chịu trách nhiệm về việc dọn dẹp ngăn xếp sau khi gọi hàm (người gọi hay hàm được gọi)


