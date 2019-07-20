// The following ifdef block is the standard way of creating macros which make exporting
// from a DLL simpler. All files within this DLL are compiled with the BLADEDLL_EXPORTS
// symbol defined on the command line. This symbol should not be defined on any project
// that uses this DLL. This way any other project whose source files include this file see
// BLADEDLL_API functions as being imported from a DLL, whereas this DLL sees symbols
// defined with this macro as being exported.
#ifdef BLADEDLL_EXPORTS
#define BLADEDLL_API __declspec(dllexport)
#else
#define BLADEDLL_API __declspec(dllimport)
#endif

extern "C" {
	BLADEDLL_API void init_blade_dll(UINT16, UINT16);
	BLADEDLL_API void set_keyboard_color(UINT8, UINT8, UINT8);
	BLADEDLL_API void set_keyboard_brightness(UINT8);
	BLADEDLL_API void set_keyboard_mode(UINT8);
	BLADEDLL_API void set_effect_speed(UINT8);
}

