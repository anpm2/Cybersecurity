# instrs (Level 4)

>**Link: [chall]()**

![]()

![]()
* Load file vào IDA

* Mục tiêu của chall là nhập lệnh sao cho hàm **`vm_program()`** trả về giá trị > 99999 sẽ có được flag.

![]()
* Phân tích khái quát thì hàm **`vm_program()`** như 1 máy ảo đơn giản với các lệnh:
  * `a`: reset program_count = 0 nếu dải lệnh tại vị trí idx có giá trị khác 0
  * `e`: kết thúc chương trình
  * `l`: giảm idx để di chuyển dải lệnh, min = 0
  * `n`: jump tới LABEL_18
  * `r`: tăng idx để di chuyển dải lệnh, max = 7
  * `+`: tăng giá trị ô hiện tại lên 1
  * `-`: giảm giá trị ô hiện tại xuống 1
* Hàm sẽ dừng khi gặp lệnh e hoặc các giá trị không hợp lệ (> `r` hoặc < `+`)
* Cuối cùng trả về count (số lần thực thi của lệnh)
* Tóm lại có một "dải" (tape) gồm 8 ô nhớ
  * Chương trình nhập vào chỉ dài 8 ký tự
  * Con trỏ dải và con trỏ chương trình đều chỉ được di chuyển trong khoảng 0-7
  * Nếu số lần thực thi của lệnh > 99999 thì nhận flag

