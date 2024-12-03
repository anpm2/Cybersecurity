#include <windows.h>
#include <iostream>

int main() {
    // Load prob_rev.dll
    HMODULE hProbRev = LoadLibraryA("prob_rev.dll");
    if (!hProbRev) {
        MessageBoxA(NULL, "Failed to load prob_rev.dll", "Error", MB_OK);
        return 1;
    }
    
    // Giải phóng DLL
    FreeLibrary(hProbRev);
    return 0;
}
