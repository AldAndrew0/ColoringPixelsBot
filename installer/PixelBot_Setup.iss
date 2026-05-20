[Setup]
AppName=PixelBot
AppVersion=1.7.0
AppPublisher=Andrea Alduino
AppSupportURL=https://github.com/AndreaAlduino/PixelBot

; Installazione in AppData (nessun permesso admin richiesto)
DefaultDirName={localappdata}\ColoringPixelsBot
DefaultGroupName=PixelBot

; Output
OutputDir=.
OutputBaseFilename=PixelBot_Installer_v1.7.0
SetupIconFile=..\assets\PixelBot.ico

; Compressione
Compression=lzma2
SolidCompression=yes

; Nessun permesso di amministratore richiesto
PrivilegesRequired=lowest

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "..\PixelBot.exe"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\PixelBot";    Filename: "{app}\PixelBot.exe"; IconFilename: "{app}\PixelBot.exe"
Name: "{userdesktop}\PixelBot"; Filename: "{app}\PixelBot.exe"; IconFilename: "{app}\PixelBot.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\PixelBot.exe"; Description: "{cm:LaunchProgram,PixelBot}"; Flags: nowait postinstall skipifsilent
