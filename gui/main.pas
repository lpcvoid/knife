unit main;

{$mode delphiunicode}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Menus, HSColorPicker, TplSliderUnit, TplColorPanelUnit,
  klabels, registry, strutils, Windows, Generics.Collections;

const
  DLL_NAME = 'BLADEDLL.dll';
  KNOWN_DEVICE_FILE_NAME = 'devices.csv';
  DEFAULT_BRIGHTNESS = 100;
  DEFAULT_SPEED = 2;
  DEFAULT_COLOR = clRed;
  DEFAULT_MODE = 5;

  RAZER_PID: Uint16 = $1532;

  RAZER_NOT_FOUND = 0;

  REG_KEY_CONFIG = 'Knifeconfig';
  REG_VALUE_NAME_CONFIG = 'config';


type
  TknifeState = packed record
    brightness: Uint8;
    mode: Uint8;
    speed: Uint8;
    r, g, b: Uint8;
    start_minimized: boolean;
    minimize_to_systray: boolean;
    autostart: boolean;
    current_vid: Uint16;
    current_pid: Uint16;
  end;

type
  TknifeKnownDevice = class
    dev_name: string;
    dev_vid: Uint16;
    dev_pid: Uint16;
  end;


//dll  imports
procedure init_blade_dll(vid, pid: UInt16); cdecl; external DLL_NAME;
procedure set_keyboard_mode(mode: Uint8); cdecl; external DLL_NAME;
procedure set_keyboard_brightness(brightness: Uint8); cdecl; external DLL_NAME;
procedure set_keyboard_color(r, g, b: Uint8); cdecl; external DLL_NAME;
procedure set_effect_speed(speed: Uint8); cdecl; external DLL_NAME;


type

  { TformMain }

  TformMain = class(TForm)
    chkgrpSettings: TCheckGroup;
    ColorDialog: TColorDialog;
    cmbbxKnownDevices: TComboBox;
    grpbxColor: TGroupBox;
    controlPanelLeft: TPanel;
    grpbxSpeed: TGroupBox;
    colorPicker: THSColorPicker;
    grpbxBrightness: TGroupBox;
    Label1: TLabel;
    linkLabelProject: TKLinkLabel;
    MenuItemQuit: TMenuItem;
    MenuItemShow: TMenuItem;
    panelSettings: TPanel;
    panelColorselector: TPanel;
    colPanelGreen: TplColorPanel;
    colPanelRed: TplColorPanel;
    colPanelBlue: TplColorPanel;
    PopupMenuTrayIcon: TPopupMenu;
    selectedColorPanel: TplColorPanel;
    sliderSpeed: TplSlider;
    rdgrpEffect: TRadioGroup;
    sliderBrightness: TplSlider;
    TrayIcon: TTrayIcon;
    procedure chkgrpSettingsClick(Sender: TObject);
    procedure chkgrpSettingsItemClick(Sender: TObject; Index: integer);
    procedure cmbbxKnownDevicesChange(Sender: TObject);
    procedure colorPickerChange(Sender: TObject);
    procedure colorPickerMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure colPanelBlueClick(Sender: TObject);
    procedure colPanelGreenClick(Sender: TObject);
    procedure colPanelRedClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure MenuItemQuitClick(Sender: TObject);
    procedure MenuItemShowClick(Sender: TObject);
    procedure panelColorselectorClick(Sender: TObject);
    procedure rdgrpEffectClick(Sender: TObject);
    procedure selectedColorPanelClick(Sender: TObject);
    procedure sliderBrightnessChange(Sender: TObject);
    procedure sliderSpeedChange(Sender: TObject);
    procedure TrayIconClick(Sender: TObject);
    procedure TrayIconDblClick(Sender: TObject);
  private
    _state: TknifeState;
    _known_devices: TList<TknifeKnownDevice>;
    _current_device: TknifeKnownDevice;
    procedure apply_keyboard_effect();
    function mode_to_index(mode: Uint8): integer;
    procedure save_settings();
    procedure load_settings();

  public

    procedure keyboard_mode(mode: Uint8);
    procedure keyboard_brightness(brightness: Uint8);
    procedure keyboard_color(r, g, b: Uint8);
    procedure effect_speed(speed: UINT8);

    //detect razer product
    //returns RAZER_NOT_FOUND if none found
    function detect_razer_pid(): uint16;
    //loads blades.csv
    function load_known_devices(): boolean;
    function get_device_by_pid(pid: UINT16): TknifeKnownDevice;


  end;

var
  formMain: TformMain;


implementation

{$R *.frm}

{ TformMain }



procedure TformMain.colorPickerChange(Sender: TObject);
begin
  selectedColorPanel.Color := colorPicker.SelectedColor;
end;

procedure TformMain.chkgrpSettingsClick(Sender: TObject);
begin

end;

procedure TformMain.chkgrpSettingsItemClick(Sender: TObject; Index: integer);
begin
  _state.start_minimized := chkgrpSettings.Checked[0];
  _state.minimize_to_systray := chkgrpSettings.Checked[1];
  _state.autostart := chkgrpSettings.Checked[2];
  save_settings();

end;

procedure TformMain.cmbbxKnownDevicesChange(Sender: TObject);
begin
  //update wanted device
  if (cmbbxKnownDevices.ItemIndex >= 0) then
  begin
    _current_device := _known_devices[cmbbxKnownDevices.ItemIndex];
    _state.current_pid:=_current_device.dev_pid;
    _state.current_vid:=_current_device.dev_vid;
    init_blade_dll(_state.current_vid, _state.current_pid);
  end;
end;

procedure TformMain.colorPickerMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  //apply
  self.keyboard_color(Red(colorPicker.SelectedColor), Green(colorPicker.SelectedColor), Blue(colorPicker.SelectedColor));
end;

procedure TformMain.colPanelBlueClick(Sender: TObject);
begin
  self.keyboard_color(0, 0, 255);
  colorPicker.SelectedColor := clBlue;
end;

procedure TformMain.colPanelGreenClick(Sender: TObject);
begin
  self.keyboard_color(0, 255, 0);
  colorPicker.SelectedColor := clLime;
end;

procedure TformMain.colPanelRedClick(Sender: TObject);
begin
  self.keyboard_color(255, 0, 0);
  colorPicker.SelectedColor := clRed;
end;

procedure TformMain.FormCreate(Sender: TObject);
var
  product_names: TStringList;
  i: integer;
begin

  _known_devices := TList<TknifeKnownDevice>.Create;

  if (load_known_devices() = False) then
  begin
    ShowMessage('Could not load ' + KNOWN_DEVICE_FILE_NAME + ', aborting!');
    Application.Terminate;
  end;

  //get list of product names
  product_names := TStringList.Create;
  for i := 0 to _known_devices.Count - 1 do
    product_names.Add(_known_devices[i].dev_name);

  cmbbxKnownDevices.items.AddStrings(product_names);


  TrayIcon.Show;
  load_settings();



  if (_state.current_pid > 0) and (_state.current_vid > 0) then
  begin
    //we saved a device from previous run
    //use it
    init_blade_dll(_state.current_vid, _state.current_pid);
    _current_device := get_device_by_pid(_state.current_pid);
  end
  else
  begin
    //tell user he needs to select a device

    i := InputCombo('Select your razer device', 'Hello, please select the device you want to control. You can always change this afterwards.',
      product_names);

    if (i >= 0) then
    begin
      _current_device := _known_devices[i];
      _state.current_pid:=_current_device.dev_pid;
      _state.current_vid:=_current_device.dev_vid;
      init_blade_dll(_state.current_vid, _state.current_pid);
      save_settings();
    end
    else
        ShowMessage('Please make sure to select your device, otherwise this tool will not work!');


  end;

  if (assigned(_current_device)) then
    cmbbxKnownDevices.ItemIndex := cmbbxKnownDevices.Items.IndexOf(_current_device.dev_name)
  else
  begin
    //saved a pid, but cannot find it anymore. Use it silently anyhow, but tell user
    //Showmessage('You recently used Knife with a Product that does not exist within ' + KNOWN_DEVICE_FILE_NAME + ' anymore. Using what you last used, but please add it back.');
    cmbbxKnownDevices.Text := 'Unknown device!';
  end;


  self.keyboard_color(_state.r, _state.g, _state.b);
  self.keyboard_brightness(_state.brightness);
  self.keyboard_mode(_state.mode);

  if (_state.start_minimized) then
    Application.Minimize;

end;

procedure TformMain.FormWindowStateChange(Sender: TObject);
begin
  if self.WindowState = wsMinimized then
  begin
    self.WindowState := wsNormal;
    self.Hide;
    self.ShowInTaskBar := stNever;

  end;
end;

procedure TformMain.MenuItemQuitClick(Sender: TObject);
begin
  self.save_settings();
  Application.terminate;
end;

procedure TformMain.MenuItemShowClick(Sender: TObject);
begin
  self.Show;
end;

procedure TformMain.panelColorselectorClick(Sender: TObject);
begin
  selectedColorPanel.Color := colorPicker.SelectedColor;
end;

procedure TformMain.rdgrpEffectClick(Sender: TObject);
begin
  apply_keyboard_effect();
  if (rdgrpEffect.ItemIndex > 0) then
    self.keyboard_brightness(sliderBrightness.Value); //set again, since NONE just sets brightness to 0
end;

procedure TformMain.selectedColorPanelClick(Sender: TObject);
begin
  ColorDialog.Execute;
  colorPicker.SelectedColor := ColorDialog.Color;
  selectedColorPanel.Color := ColorDialog.Color;
  self.keyboard_color(Red(colorPicker.SelectedColor), Green(colorPicker.SelectedColor), Blue(colorPicker.SelectedColor));
end;

procedure TformMain.sliderBrightnessChange(Sender: TObject);
begin
  Self.keyboard_brightness(sliderBrightness.Value);
end;

procedure TformMain.sliderSpeedChange(Sender: TObject);
begin
  effect_speed(sliderSpeed.Value);
end;

procedure TformMain.TrayIconClick(Sender: TObject);
begin
  self.Show;
  ;
end;

procedure TformMain.TrayIconDblClick(Sender: TObject);
begin
  self.Show();
end;




procedure TformMain.apply_keyboard_effect();
begin
  case rdgrpEffect.ItemIndex of
    0: keyboard_mode(0);
    1: keyboard_mode(1);
    2: keyboard_mode(2);
    3: keyboard_mode(3);
    4: keyboard_mode(4);
    5: keyboard_mode(6);  //no custom for now

  end;
end;

function TformMain.mode_to_index(mode: Uint8): integer;
begin
  case rdgrpEffect.ItemIndex of
    0: Result := (0);
    1: Result := (1);
    2: Result := (2);
    3: Result := (3);
    4: Result := (4);

    5, 6: Result := (5);  //no custom for now
  end;
end;

procedure TformMain.save_settings();
var
  reg: TRegistry;
begin

  reg := TRegistry.Create();
  reg.RootKey := HKEY_CURRENT_USER;
  reg.OpenKey('Software\' + REG_KEY_CONFIG, True);
  reg.WriteBinaryData(REG_VALUE_NAME_CONFIG, _state, sizeof(TknifeState));
  reg.CloseKey;

  //autostart stuff
  reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run\', False);
  if _state.autostart then
    reg.WriteString('Knife', Application.ExeName)
  else
    reg.DeleteValue('Knife');

  reg.Free;

end;

procedure TformMain.load_settings();
var
  reg: TRegistry;
begin
  reg := TRegistry.Create();
  reg.RootKey := HKEY_CURRENT_USER;
  reg.OpenKey('Software\' + REG_KEY_CONFIG, True);

  Zeromemory(@_state, sizeof(TknifeState));

  if (reg.ValueExists(REG_VALUE_NAME_CONFIG)) then
    reg.ReadBinaryData(REG_VALUE_NAME_CONFIG, _state, sizeof(TknifeState))
  else
  begin
    //load defaults
    _state.brightness := DEFAULT_BRIGHTNESS;
    _state.mode := DEFAULT_MODE;
    _state.speed := DEFAULT_SPEED;
    _state.r := Red(DEFAULT_COLOR);
    _state.g := Green(DEFAULT_COLOR);
    _state.b := Blue(DEFAULT_COLOR);

    save_settings();
  end;
  reg.Free;


  rdgrpEffect.ItemIndex := mode_to_index(_state.mode);
  sliderBrightness.Value := _state.brightness;
  sliderSpeed.Value := _state.speed;
  colorPicker.SelectedColor := RGBToColor(_state.r, _state.g, _state.b);
  chkgrpSettings.Checked[0] := _state.start_minimized;
  chkgrpSettings.Checked[1] := _state.minimize_to_systray;
  chkgrpSettings.Checked[2] := _state.autostart;
end;

procedure TformMain.keyboard_mode(mode: Uint8);
begin
  _state.mode := mode;
  set_keyboard_mode(mode);
  save_settings();
end;

procedure TformMain.keyboard_brightness(brightness: Uint8);
begin
  _state.brightness := brightness;
  set_keyboard_brightness(brightness);
  save_settings();
end;

procedure TformMain.keyboard_color(r, g, b: Uint8);
begin
  _state.r := r;
  _state.g := g;
  _state.b := b;
  set_keyboard_color(r, g, b);
  apply_keyboard_effect;
  save_settings();
end;

procedure TformMain.effect_speed(speed: UINT8);
begin
  _state.speed := speed;
  set_effect_Speed(speed);
  save_settings();

end;


//Work in progress, needs administrator privs
function TformMain.detect_razer_pid(): uint16;
var
  reg: TRegistry;
  key_names: TStringList;
  i: integer;
begin
  reg := TRegistry.Create();
  reg.RootKey := HKEY_LOCAL_MACHINE;
  reg.OpenKey('SYSTEM\CurrentControlSet\Enum\USB', False);
  //if () then
  // begin
  key_names := TStringList.Create;
  reg.GetKeyNames(key_names);
  for i := 0 to key_names.Count - 1 do
  begin
    if (ContainsStr(key_names[i], 'VID_1532&')) then
    begin
      //razer device found
    end;
  end;
  //end;

  exit(0);
end;

function TformMain.load_known_devices(): boolean;
var
  known_filepath: string;
  known_sl: TStringList;
  delimited: TStringArray;
  i: integer;
  device: TknifeKnownDevice;
begin
  known_filepath := ExtractFilePath(Application.ExeName) + KNOWN_DEVICE_FILE_NAME;
  if (FileExists(known_filepath)) then
  begin
    known_Sl := TStringList.Create;
    known_Sl.LoadFromFile(known_filepath);

    for i := 0 to known_Sl.Count - 1 do
    begin
      if (known_sl[i].StartsWith('#') = False) and (known_sl[i].IsNullOrWhiteSpace(known_sl[i]) = False) then
      begin
        delimited := known_sl[i].Split([';']);
        if (length(delimited) = 3) then
        begin
          device := TknifeKnownDevice.Create;
          device.dev_name := delimited[0];
          device.dev_vid := delimited[1].ToInteger;
          device.dev_pid := delimited[2].ToInteger;
          _known_devices.Add(device);
        end
        else
          exit(False);
      end;
    end;
  end
  else
    exit(False);

  exit(True);
end;

function TformMain.get_device_by_pid(pid: UINT16): TknifeKnownDevice;
var
  d: TknifeKnownDevice;
begin
  Result := nil;
  for d in _known_devices do
    if (d.dev_pid = pid) then
      exit(d);
end;


end.














