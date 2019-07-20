#include "pch.h"
#include "framework.h"
#include "blade_dll.h"
#include <stdio.h>
#include <iostream>
#include <stdio.h>
#include <wtypes.h>
#include <winnt.h>
#include "../lib/input.h"
#include "../lib/kernel.h"
#include "../lib/module.h"
#include "../lib/slab.h"
#include "../lib/init.h"
#include "../lib/hid.h"
#include <Winusb.h>


#define USB_VENDOR_ID_RAZER 0x1532

#define USB_PRODUCT_ID_RAZER_BLADE_15_2018 0x233

/* Each USB report has 90 bytes*/
#define RAZER_USB_REPORT_LEN 0x5A

// LED STATE
#define OFF 0x00
#define ON  0x01

// LED STORAGE Options
#define NOSTORE          0x00
#define VARSTORE         0x01

// LED definitions
#define ZERO_LED      0x00
#define SCROLL_WHEEL_LED  0x01
#define BATTERY_LED       0x03
#define LOGO_LED          0x04
#define BACKLIGHT_LED     0x05
#define MACRO_LED         0x07
#define GAME_LED          0x08
#define RED_PROFILE_LED   0x0C
#define GREEN_PROFILE_LED 0x0D
#define BLUE_PROFILE_LED  0x0E

// LED Effect definitions
#define LED_STATIC           0x00
#define LED_BLINKING         0x01
#define LED_PULSATING        0x02
#define LED_SPECTRUM_CYCLING 0x04

// Report Responses
#define RAZER_CMD_BUSY          0x01
#define RAZER_CMD_SUCCESSFUL    0x02
#define RAZER_CMD_FAILURE       0x03
#define RAZER_CMD_TIMEOUT       0x04
#define RAZER_CMD_NOT_SUPPORTED 0x05

struct knife_color {
	unsigned char r, g, b;
};

struct knife_usb_report {
	unsigned char status;
	unsigned char id;
	unsigned short pck_len; 
	unsigned char proto;
	unsigned char data_size;
	unsigned char cmd_class;
	unsigned char cmd_id;
	unsigned char payload[80]; //80 byte payload max
	unsigned char crc; //simple checksum
	unsigned char reserved;
};

struct knife_device {
	struct usb_device* usbdev;
	struct hid_device* hiddev;
	unsigned int fn_on;
	char name[128];
	char phys[64];
	DECLARE_BITMAP(pressed_fn, KEY_CNT);
	unsigned char block_keys[3];
	unsigned char left_alt_on;
};

unsigned char clamp_u8(unsigned char value, unsigned char min, unsigned char max)
{
	if (value > max)
		return max;
	if (value < min)
		return min;
	return value;
}

static int razer_kbd_probe(struct hid_device* hdev, const struct hid_device_id* id)
{
	int retval = 0;
	struct usb_interface* intf = to_usb_interface(hdev->dev.parent);
	struct usb_device* usb_dev = interface_to_usbdev(intf);
	struct knife_device* dev = NULL;

	dev = (knife_device*)kzalloc(sizeof(knife_device), GFP_KERNEL);
	if (dev == NULL) {
		retval = -ENOMEM;
		goto exit;
	}
	hid_set_drvdata(hdev, dev);
	dev_set_drvdata(&hdev->dev, dev);

	if (hid_parse(hdev)) {
		goto exit_free;
	}

	if (hid_hw_start(hdev, HID_CONNECT_DEFAULT)) {
		goto exit_free;
	}

	return 0;
exit:
	return retval;
exit_free:
	kfree(dev);
	return retval;
}


/**
 * Unbind function
 */
static void razer_kbd_disconnect(struct hid_device* hdev)
{
	struct usb_interface* intf = to_usb_interface(hdev->dev.parent);
	struct usb_device* usb_dev = interface_to_usbdev(intf);

	struct razer_kbd_device* dev = (razer_kbd_device*)hid_get_drvdata(hdev); //hdev->dev.driver_data;//

	hid_hw_stop(hdev);
	kfree(dev);
}

static int razer_event(struct hid_device* hdev, struct hid_field* field, struct hid_usage* usage, __s32 value)
{
	struct usb_interface* intf = to_usb_interface(hdev->dev.parent);
	struct usb_device* usb_dev = interface_to_usbdev(intf);
	struct knife_device* asc = (knife_device*)hid_get_drvdata(hdev);
	const struct razer_key_translation* translation;
	int do_translate = 0;

	return 0;

}

static int razer_raw_event(struct hid_device* hdev, struct hid_report* report, u8* data, int size)
{
	struct usb_interface* intf = to_usb_interface(hdev->dev.parent);
	struct knife_device* asc = (knife_device*)hid_get_drvdata(hdev);
	struct usb_device* usb_dev = interface_to_usbdev(intf);

	return 0;
}

struct knife_usb_report new_knife_usb_report(unsigned char command_class, unsigned char command_id, unsigned char data_size)
{
	struct knife_usb_report new_report;
	memset(&new_report, 0, sizeof(struct knife_usb_report));

	new_report.status = 0x00;
	new_report.id = 0xFF;
	new_report.pck_len = 0x00;
	new_report.proto = 0x00;
	new_report.cmd_class = command_class;
	new_report.cmd_id = command_id;
	new_report.data_size = data_size;

	return new_report;
}

unsigned char blade_calc_csum_crc(struct knife_usb_report* report)
{
	unsigned char res = 0;
	for (int i = 2; i < 88; i++) //from len to crc
	{
		res ^= ((unsigned char*)report)[i];
	}

	return res;
}

int razer_send_control_msg(struct usb_device* usb_dev, void const* data, uint report_index, ulong wait_min, ulong wait_max)
{
	uint request = HID_REQ_SET_REPORT; // 0x09
	uint request_type = USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_OUT; // 0x21
	uint value = 0x300;
	uint size = RAZER_USB_REPORT_LEN;
	unsigned char* buf;
	ULONG len;

	buf = (unsigned char*)kmemdup(data, size, GFP_KERNEL);
	if (buf == NULL)
		return -ENOMEM;

	WINUSB_SETUP_PACKET packet;
	packet.RequestType = request_type;
	packet.Request = request;
	packet.Value = value;
	packet.Index = report_index;
	packet.Length = size;
	WinUsb_ControlTransfer(usb_dev->dev->p, packet, buf, size, &len, 0);

	// Wait
	usleep_range(wait_min, wait_max);

	kfree(buf);
	return ((len < 0) ? len : ((len != size) ? -EIO : 0));
}

int razer_get_usb_response(struct usb_device* usb_dev, uint report_index, struct knife_usb_report* request_report, uint response_index, struct knife_usb_report* response_report, ulong wait_min, ulong wait_max)
{
	uint request = HID_REQ_GET_REPORT; // 0x01
	uint request_type = USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_IN; // 0xA1
	uint value = 0x300;

	uint size = RAZER_USB_REPORT_LEN; // 0x90
	int len;
	int retval;
	int result = 0;
	unsigned char* buf;

	buf = (unsigned char*)kzalloc(sizeof(struct knife_usb_report), GFP_KERNEL);
	if (buf == NULL)
		return -ENOMEM;

	//send USB control message first
	retval = razer_send_control_msg(usb_dev, request_report, report_index, wait_min, wait_max);

	WINUSB_SETUP_PACKET packet;
	packet.RequestType = request_type;
	packet.Request = request;
	packet.Value = value;
	packet.Index = report_index;
	packet.Length = size;
	ULONG cbSent = 0;
	WinUsb_ControlTransfer(usb_dev->dev->p, packet, buf, size, &cbSent, 0);

	usleep_range(wait_min, wait_max);

	memcpy(response_report, buf, sizeof(struct knife_usb_report));
	kfree(buf);

	return result;
}


static int razer_get_report(struct usb_device* usb_dev, struct knife_usb_report* request_report, struct knife_usb_report* response_report) {
	
}


static struct knife_usb_report razer_send_payload(struct usb_device* usb_dev, struct knife_usb_report* request_report)
{
	int retval = -1;
	struct knife_usb_report response_report;

	request_report->crc = blade_calc_csum_crc(request_report);

	razer_get_usb_response(usb_dev, 0x02, request_report, 0x02, &response_report, 600, 800);

	return response_report;

}


struct hid_device* hdev = NULL;
struct hid_driver hdr;
//colors
knife_color current_rgb = { 255,0,0 };
//brightness
UINT8 current_brightness = 0x100;

//effects
UINT8 current_wave_direction = 0x01;
UINT8 current_speed = 0x02;





//EXPORTS
void init_blade_dll(UINT16 vid, UINT16 pid)
{


	unsigned int numHdevs = 0;

	hid_device_id razer_devices[2];
	razer_devices[0].vendor = vid;
	razer_devices[0].product = pid;
	razer_devices[1] = { 0 };

	hdr.name = "razerkbd";
	hdr.id_table = razer_devices;
	hdr.probe = razer_kbd_probe;
	hdr.remove = razer_kbd_disconnect;
	//hdr.event = razer_event;
	hdr.raw_event = razer_raw_event;

	openChromaDevice(&hdev, &numHdevs, hdr);

}

void set_keyboard_color(UINT8 r, UINT8 g, UINT8 b)
{
	if (hdev) {
		current_rgb.r = r;
		current_rgb.g = g;
		current_rgb.b = b;
	}

}



void set_keyboard_brightness(UINT8  brightness)
{
	if (hdev) {
		current_brightness = brightness;
		struct usb_interface* intf = to_usb_interface(hdev->dev.parent);
		struct usb_device* usb_dev = interface_to_usbdev(intf);
		struct knife_usb_report report = new_knife_usb_report(0x0E, 0x04, 0x02);
		report.payload[0] = 0x01;
		report.payload[1] = current_brightness;
		razer_send_payload(usb_dev, &report);
	}
}

void set_keyboard_mode(UINT8 mode)
{
	if (hdev) {
		struct usb_interface* intf = to_usb_interface(hdev->dev.parent);
		struct usb_device* usb_dev = interface_to_usbdev(intf);
		struct knife_usb_report report;
		switch (mode)
		{
		case 0:
			//set brightness to 0
			set_keyboard_brightness(0);
			break;
		case 1: //wave
			report = new_knife_usb_report(0x03, 0x0A, 0x02);
			report.payload[0] = 0x01; // Effect ID
			report.payload[1] = current_speed; //speed
			razer_send_payload(usb_dev, &report);
			break;
		case 2: //reactive
			report = new_knife_usb_report(0x03, 0x0A, 0x05);
			report.payload[0] = 0x02; // Effect ID
			report.payload[1] = current_speed; // speed
			report.payload[2] = current_rgb.r;
			report.payload[3] = current_rgb.g;
			report.payload[4] = current_rgb.b;
			razer_send_payload(usb_dev, &report);
			break;

		case 3://breathing
			report = new_knife_usb_report(0x03, 0x0A, 0x08);
			report.payload[0] = 0x03; // Effect ID
			report.payload[1] = 0x01; // Breathing type
			report.payload[2] = current_rgb.r;
			report.payload[3] = current_rgb.g;
			report.payload[4] = current_rgb.b;
			razer_send_payload(usb_dev, &report);
			break;

		case 4://Spectrum
			report = new_knife_usb_report(0x03, 0x0A, 0x01);
			report.payload[0] = 0x04; // Effect ID
			razer_send_payload(usb_dev, &report);
			break;

		case 5:
			//not supported for now
			break;

		case 6:
			report = new_knife_usb_report(0x03, 0x0A, 0x04);
			report.payload[0] = 0x06;
			report.payload[1] = current_rgb.r;
			report.payload[2] = current_rgb.g;
			report.payload[3] = current_rgb.b;
			razer_send_payload(usb_dev, &report);
			break;

		default:
			break;
		}
	}
}

void set_effect_speed(UINT8 speed)
{
	current_speed = clamp_u8(speed, 0x01, 0x04);
}
