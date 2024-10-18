Week 3
==

**Task**: Tìm hiểu về các kỹ thuật anti-debug

# I. Anti-debug
* Anti-debug là các kỹ thuật ngăn chặn quá trình debug nhằm gây khó khăn cho việc phân tích mã nguồn chương trình. Kỹ thuật này thường sử dụng phổ biến trong mã độc để tránh bị dịch ngược.

# II. Ưu điểm và nhược điểm của Anti-debug
* **Ưu điểm:**
  * Bảo vệ bản quyền mã nguồn: ngăn chặn crack bản quyền sở hữu trí tuệ
  * Bảo mật và ngăn ngừa bị tấn công: ngăn chặn kẻ xấu khai thác lỗ hổng, giảm khả năng dịch ngược chương trình.
* **Nhược điểm:**
  * Gây khó khăn cho các kỹ sư phân tích mã độc và kỹ sư dịch ngược khi đối phó với chương trình viruss.
  * Cản trở quá trình bảo trì hệ thống và sửa lỗi phần mềm.
* **Ví dụ kỹ thuật anti-debug:**
   * 1 chương trình đơn giản sử dụng kỹ thuật anti-debug.
   * Mở file bằng IDA
   ![](https://github.com/anpm2/Cybersecurity/blob/a28b4053de839c15a3745a3870e51849acb7573d/Reverse_Engineering/task/week3/image/1.png)
   ![](https://github.com/anpm2/Cybersecurity/blob/a28b4053de839c15a3745a3870e51849acb7573d/Reverse_Engineering/task/week3/image/2.png)
   * Nhìn vào mã giả của file ta có thể thấy chương trình yêu cầu nhập password và chạy lần lượt qua các hàm check debug: `IsDebuggerPresent()`, `CheckRemoteDebuggerPresent()`, ...
   * Debug thử chương trình thì bị thông báo như sau:
   ![](https://github.com/anpm2/Cybersecurity/blob/a28b4053de839c15a3745a3870e51849acb7573d/Reverse_Engineering/task/week3/image/3.png)
   * Chương trình trên đã sử dụng cơ bản kỹ thuật anti-debug.
   * Nếu người dùng nhập pass là `I have a pen.` thì chương trình in ra `Your password is correct.` và sẽ tiếp tục kiểm tra xem ta có đang sử dụng debugger nào hay không.
   * Nếu có thì in ra thông báo đã phát hiện trình gỡ lỗi, nếu không thì không in ra gì và kết thúc chương trình.

# III. Các kỹ thuật Anti-debug

## 1. Debug Flags
* Kiểm tra các cờ debug trong cấu hình của chương trình.
* Có 2 cách để xem chương trình có đang bị debug hay không là sử dụng hàm win32 API và kiểm tra thủ công qua system tables.
  
### 1.1 Sử dụng hàm win32 API (6 hàm)
  #### 1.1.1 IsDebuggerPresent()
  * Xác định xem tiến trình hiện tại có đang bị debug bởi trình debugger (ollyDbg, x64dbg, IDA, ghidra, ...) không bằng cách kiểm tra cờ `BeingDebugged` trong **PEB**. 
  * Hàm `IsDebuggerPresent()` trả về khác 0 thì dừng và thoát chương trình ngay lập tức.
    
  ```asm
  ; x86
      call IsDebuggerPresent    
      test al, al
      jne  being_debugged
      ...
  being_debugged:
      push 1
      call ExitProcess
  ```
  > Bypass: set BeingDebugged flag trong PEB thành 0
  
  * Ví dụ về cách hoạt động:
  ```c
  #include <stdio.h>
  #include <stdlib.h>
  #include <windows.h>
  
  int main(){
      int n;
      int a = 2, b = 4;
      int c = 0;
      scanf("%d", &n);
      if(n != 10){
          printf("Hello world!\n");
      }
      if (IsDebuggerPresent()){
          printf("Phat hien debug! Ket thuc chuong trinh!!\n");
          ExitProcess(-1);
      }
      c = a + b;
      printf("Tong 2 + 4 = %d\n", c);
      return 0;
  }
  ```
  #### 1.1.2 CheckRemoteDebuggerPresent()
  * Kiểm tra xem trình gỡ lỗi (trong một quy trình khác trên cùng một máy) có được gắn vào quy trình hiện tại hay không.
  * Hàm `CheckRemoteDebuggerPresent()` trả về một giá trị boolean (TRUE / FALSE) để xác định trạng thái của tiến trình.

  ```asm
  ; x86
      lea eax, [bDebuggerPresent]
      push eax
      push -1  ; GetCurrentProcess()
      call CheckRemoteDebuggerPresent
      cmp [bDebuggerPresent], 1
      jz being_debugged
      ...
  being_debugged:
      push -1
      call ExitProcess
  ```
  * Ví dụ về cách hoạt động:
  ```c
  #include <iostream>
  #include "windows.h"
  using namespace std;
  
  int main(){
      BOOL bDebuggerPresent = FALSE;
      cout << "Hello world!\n";
      if(TRUE == CheckRemoteDebuggerPresent(GetCurrentProcess(), &bDebuggerPresent) &&
         TRUE == bDebuggerPresent){
          cout << "Phat hien debug!!\nEnd program!!\n" << endl;
          ExitProcess(0);
      }
      return 0;
  }
  ```
  #### 1.1.3 NtQueryInformationProcess()
  * Được sử dụng để lấy nhiều loại thông tin từ một tiến trình tùy thuộc vào tham số `ProcessInformationClass`.
  * Hàm này được gọi bên trong của `CheckRemoteDebuggerPresent`.

### 1.2 Kiểm tra thủ công qua system tables
  #### 1.2.1 PEB!BeingDebugged Flag
  * Truy cập trực tiếp vào địa chỉ của PEB và đọc giá trị byte tại offset 0x02 (vị trí cờ của **BeingDebugged**).
  * Nếu giá trị khác 0 thì chương trình đang bị debug.
  ```asm
  ; x86
  mov eax, fs:[30h]
  cmp byte ptr [eax+2], 0
  jne being_debugged
  ```
  > bypass: set **BeingDebugged** flag trong PEB thành 0
  #### 1.2.2 NtGlobalFlag
  *  Truy cập trực tiếp vào địa chỉ của PEB và đọc giá trị byte tại offset `0x68` của PEB.
  *  Nếu giá trị set là `0x70` thì chương trình đang bị debug.
  ```asm
  ; x86
  mov eax, fs:[30h]
  mov al, [eax+68h]
  and al, 70h
  cmp al, 70h
  jz  being_debugged
  ```
  > bypass: tương tự như **BeingDebugged** set thành 0, bằng cách DLL injection hoặc sử dụng ScyllaHide plugin.

## 2. Object Handles
* Kỹ thuật phát hiện sự có mặt của debugger thông qua kiểm tra các handle của đối tượng kernel bằng cách sử dụng các hành vi đặc biệt của các hàm WinAPI.
  ### 2.1 OpenProcess()
  * Kiểm tra xem có thể mở tiến trình `csrss.exe` hay không để phát hiện trình debug.
  * Một process mặc định không bị debug sẽ không có quyền `SeDebugPrivilege` trong access token của nó.
  * Nếu process có thể mở tiến trình `csrss.exe`, cũng tức là có quyền `SeDebugPrivilege` trong access token ==> đang bị debug.
  ```c
  #include <stdio.h>
  #include <windows.h>
  
  // Định nghĩa một con trỏ hàm TCsrGetProcessId kiểu DWORD (32-bit unsigned integer) với quy ước gọi hàm WINAPI và ko có tham số đầu vào
  typedef DWORD (WINAPI *TCsrGetProcessId)(VOID);
  
  bool Check(){ // Phát hiện trình debug đang chạy bằng cách thử mở tiến trình csrss.exe
      HMODULE hNtdll = LoadLibraryA("ntdll.dll"); // Load thư viện ntdll.dll
      if (!hNtdll) //Nếu hNtdll là NULL
          return false;
      
      // 
      // Lấy con trỏ của hàm CsrGetProcessId từ thư viện ntdll.dll
      TCsrGetProcessId pfnCsrGetProcessId = (TCsrGetProcessId)GetProcAddress(hNtdll, "CsrGetProcessId");
      if (!pfnCsrGetProcessId)
          return false;
  
      // lấy Process Id của trình csrss.exe
      HANDLE hCsr = OpenProcess(PROCESS_ALL_ACCESS, FALSE, pfnCsrGetProcessId());
      if (hCsr != NULL){
          CloseHandle(hCsr);
          return true; // Process đang bị debug
      }        
      else
          return false;
  }
  int main() {
      if (Check()){
          printf("Phat hien Debug\n"); 
      }
      else{
          printf("Ko phat hien Debug\n");
      }
      return 0; 
  }
  ```
  ### 2.2 CreateFile()
  * Xác định sự hiện diện của trình debug thông qua kiểm tra quyền truy cập độc quyền vào tệp thực thi hiện tại.
  * Nếu `CreateFileA()` trả về ***INVALID_HANDLE_VALUE*** ==> process hiện tại đang bị debug.
  ```c
  bool Check(){
      CHAR szFileName[MAX_PATH];
      if (0 == GetModuleFileNameA(NULL, szFileName, sizeof(szFileName)))
          return false;
      
      return INVALID_HANDLE_VALUE == CreateFileA(szFileName, GENERIC_READ, 0, NULL, OPEN_EXISTING, 0, 0);
  }
  ```
  ### 2.3 CloseHandle()
  * Xác định debugger bằng cách kiểm tra xem exception có được xử lý bởi exception handler hay ko.
  * Nếu exception handler bắt được exception ***EXCEPTION_INVALID_HANDLE***(0xC0000008), ==> debugger đang hoạt động.
  ```c
  bool Check()
  {
      __try
      {
          CloseHandle((HANDLE)0xDEADBEEF); // Gọi hàm với handle không hợp lệ
          return false; // Không có debugger
      }
      __except (EXCEPTION_INVALID_HANDLE == GetExceptionCode()
                  ? EXCEPTION_EXECUTE_HANDLER 
                  : EXCEPTION_CONTINUE_SEARCH)
      {
          return true; // Có debugger
      }
  }
  ```

## 3. Exceptions
* Cố tình gây ra ngoại lệ để xác minh hành vi tiếp theo có phải là hành vi điển hình đối với một process đang chạy mà không có debugger hay không.

  ### 3.1 UnhandledExceptionFilter()
  * Khi xảy ra exception và không có `Exception Handlers()` được đăng kí, ***UnhandledExceptionFilter*** sẽ được gọi.
  * Nếu chương trình chạy dưởi một debugger, custom filter sẽ không được gọi và exception được truyền cho debugger.
  ```asm
  include 'win32ax.inc'
  
  .code
  
  start:
          jmp begin
  
  not_debugged:
          invoke  MessageBox,HWND_DESKTOP,"Not Debugged","",MB_OK
          invoke  ExitProcess,0
  
  begin:
          invoke SetUnhandledExceptionFilter, not_debugged
          int  3
          jmp  being_debugged
  
  being_debugged:
          invoke  MessageBox,HWND_DESKTOP,"Debugged","",MB_OK
          invoke  ExitProcess,0
  
  .end start
  ```
  
  ### 3.2 RaiseException()
  * Sử dụng phương thức `RaiseException()` để kiểm tra xem một quá trình có đang bị gỡ lỗi hay ko.
  * Các exception ***DBC_CONTROL_C*** (0x40010005) hay ***DBG_RIPEVENT*** (0x40010007) ko đc chuyển tiếp đến exception handlers của process hiện tại mà được xử lí bởi debugger.
  * Nếu exception handle ko đc gọi ==> có sự tồn tại của debugger.
  ```c
  bool Check()
  {
      __try
      {
          RaiseException(DBG_CONTROL_C, 0, 0, NULL);
          return true;
      }
      __except(DBG_CONTROL_C == GetExceptionCode()
          ? EXCEPTION_EXECUTE_HANDLER 
          : EXCEPTION_CONTINUE_SEARCH)
      {
          return false;
      }
  }
  ```

## 4. Timing
* Khi 1 process được theo dõi trong debugger, sẽ có độ trễ rất lớn giữa lệnh và quá trình thực thi. 

  ### 4.1 RDPMC/RDTSC
  * ***RDPMC*** (Read Performance-Monitoring Counters) và ***RDTSC*** (Read Time-Stamp Counter) sử dụng cờ PCE trong thanh ghi CR4.
  * ***RDPMC*** chỉ được dùng trong Kernel mode
  RDTSC được sử dụng trong user mode. (IDA, x96dbg)
  ```c
  bool IsDebugged(DWORD64 qwNativeElapsed)
  {
      ULARGE_INTEGER Start, End;
      __asm
      {
          xor  ecx, ecx
          rdpmc
          mov  Start.LowPart, eax
          mov  Start.HighPart, edx
      }
      // ... some work, functions...
      // Nếu debbuger step trace hoặc set breakpoint trong đoạn này -> large delay time -> debugger bẹhavior detected.
      __asm
      {
          xor  ecx, ecx
          rdpmc
          mov  End.LowPart, eax
          mov  End.HighPart, edx
      }
      return (End.QuadPart - Start.QuadPart) > qwNativeElapsed;
  }
  ```
  > NOTE: time counting bắt đầu count từ thời điểm gặp RDPMC.
  
  ### 4.2 GetLocalTime(), GetSystemTime(), GetTickCount(), QueryPerformanceCounter(), timeGetTime()
  * Tương tự như cách trên nhưng sử dụng Windows API ***GetLocalTime, GetSystemTime, GetTickCount, timeGetTime, QueryPerformanceCounter***.
  * `stStart`: Biến này lưu thời điểm bắt đầu của phần công việc cần đo thời gian thực thi. Nó được gán bằng thời gian hiện tại của hệ thống khi bắt đầu thực hiện công việc.
  * `stEnd`: Biến này lưu thời điểm kết thúc của phần công việc cần đo thời gian thực thi.
  * Cách phát hiện debug ở các tricks này cũng sẽ chỉ phát hiện độ trễ nếu debugger có đặt breakpoint hay steptrace.
  ```c
  SYSTEMTIME stStart, stEnd;
  GetLocalTime(&stStart);
  // ... some work functions...
  // Nếu debbuger step trace hoặc set breakpoint trong đoạn này -> large delay time -> debugger bẹhavior detected.
  GetLocalTime(&stEnd);
  ```
  ```c
  GetSystemTime(&stStart);
  // your code.
  GetSystemTime(&stEnd);
  ```
  
  ```c
  DWORD dwStart = GetTickCount();
  // your code
  return (GetTickCount() - dwStart) > dwNativeElapsed;
  ```
  
  ```c
  DWORD dwStart = timeGetTime();
  // some work
  return (timeGetTime() - dwStart) > dwNativeElapsed;
  ```
  
  ```c
  LARGE_INTEGER liStart, liEnd;
  QueryPerformanceCounter(&liStart);
  // your code
  QueryPerformanceCounter(&liEnd);
  return (liEnd.QuadPart - liStart.QuadPart) > qwNativeElapsed;
  ```
  > bypass: patch các hàm check time = NOPs hoặc set lại giá trị trả về.
## 5. Process Memory
* Gồm 2 kỹ thuật chính là detect breakpoints và 1 số memory check khác.

  ### 5.1 Breakpoints
  * Breakpoint tạo ra 1 điểm dừng trong quá trình thực thi chương trình tại 1 điểm nào đó trong quá trình thực hiện chương trình.
  
  #### 5.1.1 Software Breakpoints (INT3)
  * Tìm byte 0xCC hay (INT 3).
  * Cách detect có thể ko đúng trong nhiều trường hợp vì debugger đặt breakpoint để ngắt debug ở những vùng không nằm trong vùng nhớ test.
  ```c
  bool checkForSpecificByte(BYTE cByte, PVOID pMem, SIZE_T nMemSize=0) {
  	PBYTE pBytes = (PBYTE)pMem;
  	for (SIZE_T i = 0; ; i++) {
  		// Break on RET instruction when we scan the function
  		// and when we dont know the function's size
  		if ((nMemSize != 0 && nMemSize <= i) || ((nMemSize == 0) & pBytes[i] == 0xC3)) {
  			break;
  		}
  		if (pBytes[i] == cByte) {
  			return true;
  		}
  		return false;
  	}
  }
  bool ScanFucnt() {
      // funct list to scan
  	PVOID fucnt_list[] = {
  		&fucnt1,
  		&fucnt2,
  		&fucnt3,
  	};
  	for (auto funcAddr : fucnt_list) {
  		if (checkForSpecificByte(0xCC, funcAddr))
  			return true;
  
  		return false;
  	}
  }
  ```
  
  #### 5.1.2 Anti-Step-Over
  * Debugger cho phép step-over function call (button F8), vì thế sẽ ngầm đặt Software Breakpoint (0xCC) địa chỉ trả về của hàm được gọi.
  * Để phát hiện khi step over qua hàm, ta có thể xét byte đầu tiên của câu lệnh ngay lệnh call 1 function, xem có bị set breakpoint không.
  
  #### 5.1.3 Hardware breakpoint
  ![](https://github.com/anpm2/Cybersecurity/blob/d7be08393a9baedbc7c27779bde2ddd4a5c60b55/Reverse_Engineering/task/week3/image/4.png)
  * Có 4 thanh ghi debug: DR0, DR1, DR2, DR3, bốn thanh ghi này sẽ được sử dụng để lưu giữ những địa chỉ mà ta thiết lập hardware breakpoint.
  * Điều kiện của mỗi break points để cho dừng sự thực thi của chương trình lại được lưu trong một thanh ghi đặc biệt khác là CPU register, đó là thanh ghi DR7.
  * Khi bất kì một điều kiện nào thỏa mãn (TRUE) thì processor sẽ quăng một exception là INT1 và quyền điều khiển lúc này sẽ được trả về cho Debugger.
  * Hardware breapoint trong các thanh ghi DR0 -> DR3, có thể được lấy từ thread context. Nếu các giá trị này khác 0, tức là hardware breakpoint đã được set.
  ```c
  bool IsDebugged()
  {
      CONTEXT ctx;
      ZeroMemory(&ctx, sizeof(CONTEXT)); 
      ctx.ContextFlags = CONTEXT_DEBUG_REGISTERS; 
  
      if(!GetThreadContext(GetCurrentThread(), &ctx))
          return false;
  
      return ctx.Dr0 || ctx.Dr1 || ctx.Dr2 || ctx.Dr3;
  }
  ```
  > Bypass: Chèn API window GetCurrentThread và chỉnh giá trị của dr0->dr3.

## 6. Assembly instructions
>Bypass: Patch với lệnh NOP

  ### 6.1 INT 3
  * Tạo EXCEPTION_BREAKPOINT (0x80000003) và exception handler sẽ được gọi. Nếu không được gọi thì chương trình đang được debug.
  * Nếu có debugger, luồng điều khiển sẽ không được đưa tới exception handler để xử lí.
  ```c
  bool IsDebugged()
  {
      __try
      {
          __asm int 3;
          return true;
      }
      __except(EXCEPTION_EXECUTE_HANDLER)
      {
          return false;
      }
  }
  ```
  
  ### 6.2 INT 2D
  * Tương tự INT 3 nhưng với INT 2D, Windows sử dụng thanh ghi IP (instruction pointer) như một địa chỉ exception.Nếu EAX = 1, 3, 4; thanh gi IP sẽ tăng thêm 1.
  ```c
  bool IsDebugged()
  {
      __try
      {
          __asm xor eax, eax;
          __asm int 0x2d;
          __asm nop;
          return true;
      }
      __except(EXCEPTION_EXECUTE_HANDLER)
      {
          return false;
      }
  }
  ```
  
  ### 6.3 DebugBreak
  * Tạo ra một Exception Breakpoint xảy ra trong quy trình hiện tại. Điều này cho phép luồng gọi báo hiệu debugger xử lý Exception.
  * Nếu chương trình được thực thi mà không có debugger, điều khiển sẽ được chuyển tới trình xử lý ngoại lệ. Nếu không, việc thực thi sẽ bị debugger chặn lại.
  ```c
  bool IsDebugged()
  {
      __try
      {
          DebugBreak();
      }
      __except(EXCEPTION_BREAKPOINT)
      {
          return false;
      }
      
      return true;
  }
  ```

## 7. Direct debugger interaction

  ### 7.1 Self-Debugging
  * Có ít nhất ba hàm có thể được sử dụng để đính kèm dưới dạng trình gỡ lỗi vào một quy trình đang chạy:
  ```
  kernel32!DebugActiveProcess()
  ntdll!DbgUiDebugActiveProcess()
  ntdll!NtDebugActiveProcess()
  ```
  * Nếu 1 process đang bị debug thì không thể đính kèm 1 debugger khác vào nó. Để kiểm tra xem ứng dụng có bị debug hay không bằng cách bắt đầu một quy trình khác để cố gắng đính kèm vào ứng dụng.
  
  ```c
  #define EVENT_SELFDBG_EVENT_NAME L"SelfDebugging"
  
  bool IsDebugged()
  {
      WCHAR wszFilePath[MAX_PATH], wszCmdLine[MAX_PATH];
      STARTUPINFO si = { sizeof(si) };
      PROCESS_INFORMATION pi;
      HANDLE hDbgEvent;
  
      hDbgEvent = CreateEventW(NULL, FALSE, FALSE, EVENT_SELFDBG_EVENT_NAME);
      if (!hDbgEvent)
          return false;
  
      if (!GetModuleFileNameW(NULL, wszFilePath, _countof(wszFilePath)))
          return false;
  
      swprintf_s(wszCmdLine, L"%s %d", wszFilePath, GetCurrentProcessId());
      if (CreateProcessW(NULL, wszCmdLine, NULL, NULL, FALSE, 0, NULL, NULL, &si, &pi))
      {
          WaitForSingleObject(pi.hProcess, INFINITE);
          CloseHandle(pi.hProcess);
          CloseHandle(pi.hThread);
  
          return WAIT_OBJECT_0 == WaitForSingleObject(hDbgEvent, 0);
      }
  
      return false;
  }
  
  bool EnableDebugPrivilege() 
  {
      bool bResult = false;
      HANDLE hToken = NULL;
      DWORD ec = 0;
  
      do
      {
          if (!OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES, &hToken))
              break;
  
          TOKEN_PRIVILEGES tp; 
          tp.PrivilegeCount = 1;
          if (!LookupPrivilegeValue(NULL, SE_DEBUG_NAME, &tp.Privileges[0].Luid))
              break;
  
          tp.Privileges[0].Attributes = SE_PRIVILEGE_ENABLED;
          if( !AdjustTokenPrivileges( hToken, FALSE, &tp, sizeof(tp), NULL, NULL))
              break;
  
          bResult = true;
      }
      while (0);
  
      if (hToken) 
          CloseHandle(hToken);
  
      return bResult;
  }
  
  int main(int argc, char **argv)
  {
      if (argc < 2)
      {        
          if (IsDebugged())
              ExitProcess(0);
      }
      else
      {
          DWORD dwParentPid = atoi(argv[1]);
          HANDLE hEvent = OpenEventW(EVENT_MODIFY_STATE, FALSE, EVENT_SELFDBG_EVENT_NAME);
          if (hEvent && EnableDebugPrivilege())
          {
              if (FALSE == DebugActiveProcess(dwParentPid))
                  SetEvent(hEvent);
              else
                  DebugActiveProcessStop(dwParentPid);
          }
          ExitProcess(0);
      }
      
      // ...
      
      return 0;
  }
  ```
  
  ### 7.2 GenerateConsoleCtrlEvent()
  * Khi người dùng nhấn `Ctrl+C` hoặc `Ctrl+Break` và cửa sổ bảng điều khiển nằm trong tiêu điểm, Windows sẽ kiểm tra xem có trình xử lý nào cho sự kiện này hay không. Tất cả console process đều có hàm xử lý mặc định `kernel32!ExitProcess()`.
  * Tuy nhiên, nếu console process đang được debug và `CTRL+C` chưa bị tắt thì hệ thống sẽ tạo ra **exception DBG_Control_C** . Thông thường, exception này bị chặn bởi debugger, nếu đăng ký 1 **exception handler** sẽ có thể kiểm tra xem **DBG_Control_C** có được bật lên hay không. Nếu chặn **exception DBG_Control_C** trong trình **exception handler** của riêng mình thì có thể biết rằng process đang được debug.
  
  ```c
  bool g_bDebugged{ false };
  std::atomic<bool> g_bCtlCCatched{ false };
  
  static LONG WINAPI CtrlEventExeptionHandler(PEXCEPTION_POINTERS pExceptionInfo)
  {
      if (pExceptionInfo->ExceptionRecord->ExceptionCode == DBG_CONTROL_C)
      {
          g_bDebugged = true;
          g_bCtlCCatched.store(true);
      }
      return EXCEPTION_CONTINUE_EXECUTION;
  }
  
  static BOOL WINAPI CtrlHandler(DWORD fdwCtrlType)
  {
      switch (fdwCtrlType)
      {
      case CTRL_C_EVENT:
          g_bCtlCCatched.store(true);
          return TRUE;
      default:
          return FALSE;
      }
  }
  
  bool IsDebugged()
  {
      PVOID hVeh = nullptr;
      BOOL bCtrlHadnlerSet = FALSE;
  
      __try
      {
          hVeh = AddVectoredExceptionHandler(TRUE, CtrlEventExeptionHandler);
          if (!hVeh)
              __leave;
  
          bCtrlHadnlerSet = SetConsoleCtrlHandler(CtrlHandler, TRUE);
          if (!bCtrlHadnlerSet)
              __leave;
  
          GenerateConsoleCtrlEvent(CTRL_C_EVENT, 0);
          while (!g_bCtlCCatched.load())
              ;
      }
      __finally
      {
          if (bCtrlHadnlerSet)
              SetConsoleCtrlHandler(CtrlHandler, FALSE);
  
          if (hVeh)
              RemoveVectoredExceptionHandler(hVeh);
      }
  
      return g_bDebugged;
  }
  ```
  
  ### 7.3 NtSetInformationThread()
  * Hàm `ntdll!NtSetInformationThread()` có thể được sử dụng để ẩn một chuỗi khỏi debugger. Sau khi luồng bị ẩn khỏi debugger, nó sẽ tiếp tục chạy nhưng debugger sẽ không nhận được các event liên quan đến luồng này. Chuỗi này có thể thực hiện kiểm tra **anti_debug** như **checksum**, xác minh **debug flags**, v.v.
  * Tuy nhiên, nếu có 1 breakpoint trong luồng ẩn hoặc nếu chúng ta ẩn luồng chính khỏi debugger thì process sẽ gặp sự cố và debugger sẽ bị kẹt.
  ```c
  #define NtCurrentThread ((HANDLE)-2)
  
  bool AntiDebug()
  {
      NTSTATUS status = ntdll::NtSetInformationThread(
          NtCurrentThread, 
          ntdll::THREAD_INFORMATION_CLASS::ThreadHideFromDebugger, 
          NULL, 
          0);
      return status >= 0;
  }
  ```

## 8. MISC

  ### 8.1 FindWindow()
  * Liệt kê đơn giản các lớp cửa sổ trong hệ thống và so sánh chúng với các lớp debugger Windows đã biết.
  ```
      user32!FindWindowW()
      user32!FindWindowA()
      user32!FindWindowExW()
      user32!FindWindowExA()
  ```
  
  ```c
  const std::vector<std::string> vWindowClasses = {
      "antidbg",
      "ID",               // Immunity Debugger
      "ntdll.dll",        // peculiar name for a window class
      "ObsidianGUI",
      "OLLYDBG",
      "Rock Debugger",
      "SunAwtFrame",
      "Qt5QWindowIcon"
      "WinDbgFrameClass", // WinDbg
      "Zeta Debugger",
  };
  
  bool IsDebugged()
  {
      for (auto &sWndClass : vWindowClasses)
      {
          if (NULL != FindWindowA(sWndClass.c_str(), NULL))
              return true;
      }
      return false;
  }
  ```
  
  ### 8.2 DbgPrint()
  * Các hàm debug như `ntdll!DbgPrint()` và
  `kernel32!OutputDebugStringW()` gây ra **DBG_PRINTEXCEPTION_C (0x40010006)**. Nếu một chương trình được thực thi với debugger đính kèm thì debugger sẽ xử lý exception này. Nhưng nếu không có debugger và **exceptions handler** được bật, thì exceptions này sẽ bị exceptions handler bắt.
  ```c
  bool IsDebugged()
  {
      __try
      {
          RaiseException(DBG_PRINTEXCEPTION_C, 0, 0, 0);
      }
      __except(GetExceptionCode() == DBG_PRINTEXCEPTION_C)
      {
          return false;
      }
  
      return true;
  }
  ```
  
  ### 8.3  DbgSetDebugFilterState()
  * Các hàm `ntdll!DbgSetDebugFilterState()` và `ntdll!NtSetDebugFilterState()` chỉ đặt một cờ sẽ được kiểm tra là debugger chế độ kernel nếu có. Vì vậy, nếu một trình gỡ lỗi kernel được gắn vào hệ thống, các hàm này sẽ thành công. Tuy nhiên, các hàm này cũng có thể thành công do tác dụng phụ do một số debugger ở chế độ user gây ra.
  ```c
  bool IsDebugged()
  {
      return NT_SUCCESS(ntdll::NtSetDebugFilterState(0, 0, TRUE));
  }
  ```


>source tham khảo: 
>* https://anti-debug.checkpoint.com/
>* https://lttqstudy.wordpress.com/2011/08/31/anti-debug/
>* https://whitehat.vn/threads/re6-antidebug.3063/
>* https://kienmanowar.wordpress.com/r4ndoms-beginning-reverse-engineering-tutorials/tutorial-21-anti-debugging-techniques/
>* https://medium.com/@X3non_C0der/anti-debugging-techniques-eda1868e0503
>...
