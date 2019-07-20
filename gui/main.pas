unit main;

{$mode delphiunicode}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Menus, HSColorPicker, TplSliderUnit, TplColorPanelUnit, TplCheckBoxUnit,
  klabels, registry;

const
  DLL_NAME = 'BLADEDLL.dll';
  DEFAULT_BRIGHTNESS = 100;
  DEFAULT_SPEED = 2;
  DEFAULT_COLOR = clRed;
  DEFAULT_MODE = 5;

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
  end;


//dll  imports
procedure init_blade_dll(vid, pid: UInt16); cdecl; external DLL_NAME;
procedure set_keyboard_mode(mode: Uint8); cdecl; external DLL_NAME;
procedure set_keyboard_brightness(brightness: Uint8); cdecl; external DLL_NAME;
procedure set_keyboard_color(r, g, b: Uint8); cdecl; external DLL_NAME;


type

  { TformMain }

  TformMain = class(TForm)
    chkgrpSettings: TCheckGroup;
    ColorDialog: TColorDialog;
    grpbxColor: TGroupBox;
    controlPanelLeft: TPanel;
    grpbxSpeed: TGroupBox;
    colorPicker: THSColorPicker;
    grpbxBrightness: TGroupBox;
    KLinkLabel1: TKLinkLabel;
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
    procedure TrayIconClick(Sender: TObject);
  private
    _state: TknifeState;
    procedure apply_keyboard_effect();
    function mode_to_index(mode: Uint8): integer;
    procedure save_settings();
    procedure load_settings();

  public

    procedure keyboard_mode(mode: Uint8);
    procedure keyboard_brightness(brightness: Uint8);
    procedure keyboard_color(r, g, b: Uint8);

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
begin
  TrayIcon.Show;
  init_blade_dll($1532, $233);
  load_settings();



  self.keyboard_color(_state.r, _state.g, _state.b);
  self.keyboard_brightness(_state.brightness);
  self.keyboard_mode(_state.mode);

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

procedure TformMain.TrayIconClick(Sender: TObject);
begin

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


end.













