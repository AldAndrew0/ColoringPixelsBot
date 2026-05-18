[Setup]
; Informazioni generali sull'app
AppName=PixelBot
AppVersion=1.3.1
AppPublisher=Andrea Alduino
AppSupportURL=https://github.com/IL_TUO_NOME_UTENTE/ColoringPixelsBot

; Zona dedicata in AppData
DefaultDirName={localappdata}\ColoringPixelsBot
DefaultGroupName=PixelBot

; Eseguibile di output
OutputDir=.
OutputBaseFilename=PixelBot_Installer_v1.3.1
SetupIconFile=PixelBot.ico

; Compressione
Compression=lzma2
SolidCompression=yes

; Nessun permesso di amministratore richiesto
PrivilegesRequired=lowest

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "PixelBot.exe"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\PixelBot"; Filename: "{app}\PixelBot.exe"; IconFilename: "{app}\PixelBot.exe"
Name: "{userdesktop}\PixelBot"; Filename: "{app}\PixelBot.exe"; IconFilename: "{app}\PixelBot.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\PixelBot.exe"; Description: "{cm:LaunchProgram,PixelBot}"; Flags: nowait postinstall skipifsilent