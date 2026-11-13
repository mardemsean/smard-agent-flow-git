; SMard Agent Flow - Windows installer (NSIS 3, Unicode).
; Built by packaging/build.ps1, which passes VERSION, SRCROOT, FILELIST, LICENSEFILE and OUTFILE.
; Same contract as plugin/install.ps1: per user, no administrator rights, it only copies into the
; Claude Code settings folder, refuses a folder that is not this plugin and backs up a different
; entry command. The uninstaller removes the plugin folder and the entry command.

Unicode true
!ifdef AMD64
  Target amd64-unicode
!endif

!include "MUI2.nsh"
!include "LogicLib.nsh"
!include "FileFunc.nsh"
!include "TextFunc.nsh"

!define PRODUCT "SMard Agent Flow"
!define UNKEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\SMardAgentFlow"
!define NEEDLE '"name": "smard-agent-flow"'

Name "${PRODUCT}"
OutFile "${OUTFILE}"
InstallDir "$LOCALAPPDATA\SMardAgentFlow"
RequestExecutionLevel user
SetCompressor /SOLID lzma
ManifestDPIAware true
BrandingText "SMard Labs"

VIProductVersion "${VERSION}.0"
VIAddVersionKey "ProductName" "${PRODUCT}"
VIAddVersionKey "CompanyName" "SMard Labs"
VIAddVersionKey "LegalCopyright" "Copyright (c) 2026 Sean Mardem (SMard Labs). Copyright GitHub, Inc. MIT License."
VIAddVersionKey "FileDescription" "${PRODUCT} Setup"
VIAddVersionKey "FileVersion" "${VERSION}"
VIAddVersionKey "ProductVersion" "${VERSION}"

Var ConfigDir
Var PluginDir
Var CommandFile
Var CmdChanged

!define MUI_ABORTWARNING
!define MUI_WELCOMEPAGE_TEXT "$(TXT_WELCOME)"
!define MUI_FINISHPAGE_TEXT "$(TXT_FINISH)"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "${LICENSEFILE}"
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "PortugueseBR"

LangString TXT_WELCOME ${LANG_ENGLISH} "Setup adds the ${PRODUCT} ${VERSION} plugin to Claude Code on this computer.$\r$\n$\r$\nYou need Claude Code already installed. You do not need an administrator password. Setup only copies files into your Claude Code settings folder.$\r$\n$\r$\nClick Next to continue."
LangString TXT_WELCOME ${LANG_PORTUGUESEBR} "Este instalador adiciona o plugin ${PRODUCT} ${VERSION} ao Claude Code neste computador.$\r$\n$\r$\nO Claude Code precisa estar instalado. Não é preciso senha de administrador. O instalador apenas copia arquivos para a pasta de configurações do Claude Code.$\r$\n$\r$\nClique em Próximo para continuar."
LangString TXT_FINISH ${LANG_ENGLISH} "${PRODUCT} is installed.$\r$\n$\r$\nOpen a NEW Claude Code session and type:$\r$\n$\r$\n        /smard-agent-flow$\r$\n$\r$\nTo remove it later, use Installed apps in the Windows Settings."
LangString TXT_FINISH ${LANG_PORTUGUESEBR} "O ${PRODUCT} está instalado.$\r$\n$\r$\nAbra uma NOVA sessão do Claude Code e digite:$\r$\n$\r$\n        /smard-agent-flow$\r$\n$\r$\nPara remover depois, use Aplicativos instalados nas Configurações do Windows."
LangString TXT_FOREIGN ${LANG_ENGLISH} "This folder already exists and it is not the ${PRODUCT} plugin. Setup changed nothing."
LangString TXT_FOREIGN ${LANG_PORTUGUESEBR} "Esta pasta já existe e não é o plugin ${PRODUCT}. O instalador não alterou nada."
LangString TXT_BACKUP ${LANG_ENGLISH} "A different /smard-agent-flow command was already there. Backup:"
LangString TXT_BACKUP ${LANG_PORTUGUESEBR} "Já existia um comando /smard-agent-flow diferente. Cópia de segurança:"
LangString TXT_UN_FOREIGN ${LANG_ENGLISH} "Not removed, because it is not the ${PRODUCT} plugin:"
LangString TXT_UN_FOREIGN ${LANG_PORTUGUESEBR} "Não removido, porque não é o plugin ${PRODUCT}:"

; $0 = "1" when $PluginDir holds this plugin (its manifest names smard-agent-flow).
!macro DefineIsOurPlugin UN
Function ${UN}IsOurPlugin
  StrCpy $0 "0"
  ClearErrors
  FileOpen $1 "$PluginDir\.claude-plugin\plugin.json" r
  ${If} ${Errors}
    Return
  ${EndIf}
  StrLen $4 '${NEEDLE}'
  ${Do}
    ClearErrors
    FileRead $1 $2
    ${If} ${Errors}
      ${ExitDo}
    ${EndIf}
    StrCpy $3 0
    ${Do}
      StrCpy $5 $2 $4 $3
      ${If} $5 == ""
        ${ExitDo}
      ${EndIf}
      ${If} $5 S== '${NEEDLE}'
        StrCpy $0 "1"
        ${ExitDo}
      ${EndIf}
      IntOp $3 $3 + 1
    ${Loop}
    ${If} $0 == "1"
      ${ExitDo}
    ${EndIf}
  ${Loop}
  FileClose $1
FunctionEnd
!macroend
!insertmacro DefineIsOurPlugin ""
!insertmacro DefineIsOurPlugin "un."

!macro DefineResolvePaths UN
Function ${UN}ResolvePaths
  ReadEnvStr $ConfigDir CLAUDE_CONFIG_DIR
  ${If} $ConfigDir == ""
    StrCpy $ConfigDir "$PROFILE\.claude"
  ${EndIf}
  StrCpy $PluginDir "$ConfigDir\skills\smard-agent-flow"
  StrCpy $CommandFile "$ConfigDir\commands\smard-agent-flow.md"
FunctionEnd
!macroend
!insertmacro DefineResolvePaths ""
!insertmacro DefineResolvePaths "un."

Function CommandDiffers
  StrCpy $CmdChanged "1"
  StrCpy $0 StopTextCompare
  Push $0
FunctionEnd

Function .onInit
  Call ResolvePaths
  ${If} ${FileExists} "$PluginDir\*.*"
    Call IsOurPlugin
    ${If} $0 != "1"
      MessageBox MB_OK|MB_ICONSTOP "$(TXT_FOREIGN)$\r$\n$\r$\n$PluginDir" /SD IDOK
      SetErrorLevel 2
      Quit
    ${EndIf}
  ${EndIf}
FunctionEnd

Section "-Install"
  ; The plugin files: one SetOutPath and one File per file, written by build.ps1.
  !include "${FILELIST}"

  ; The entry command, with a backup when a different one is already there.
  InitPluginsDir
  File "/oname=$PLUGINSDIR\command.md" "${SRCROOT}/.claude/commands/smard-agent-flow.md"
  ${If} ${FileExists} "$CommandFile"
    StrCpy $CmdChanged "0"
    ${TextCompare} "$CommandFile" "$PLUGINSDIR\command.md" "FastDiff" "CommandDiffers"
    ${If} $CmdChanged == "1"
      ${GetTime} "" "L" $0 $1 $2 $3 $4 $5 $6
      CopyFiles /SILENT "$CommandFile" "$CommandFile.bak-$2$1$0-$4$5$6"
      DetailPrint "$(TXT_BACKUP) $CommandFile.bak-$2$1$0-$4$5$6"
    ${EndIf}
  ${EndIf}
  CreateDirectory "$ConfigDir\commands"
  CopyFiles /SILENT "$PLUGINSDIR\command.md" "$CommandFile"

  ; The uninstaller and its entry in the list of installed apps (current user only).
  SetOutPath "$INSTDIR"
  WriteUninstaller "$INSTDIR\Uninstall.exe"
  WriteRegStr HKCU "${UNKEY}" "DisplayName" "${PRODUCT}"
  WriteRegStr HKCU "${UNKEY}" "DisplayVersion" "${VERSION}"
  WriteRegStr HKCU "${UNKEY}" "Publisher" "SMard Labs"
  WriteRegStr HKCU "${UNKEY}" "URLInfoAbout" "https://github.com/mardemsean/smard-agent-flow-git"
  WriteRegStr HKCU "${UNKEY}" "InstallLocation" "$PluginDir"
  WriteRegStr HKCU "${UNKEY}" "UninstallString" '"$INSTDIR\Uninstall.exe"'
  WriteRegStr HKCU "${UNKEY}" "QuietUninstallString" '"$INSTDIR\Uninstall.exe" /S'
  WriteRegStr HKCU "${UNKEY}" "PluginDir" "$PluginDir"
  WriteRegStr HKCU "${UNKEY}" "CommandFile" "$CommandFile"
  WriteRegDWORD HKCU "${UNKEY}" "NoModify" 1
  WriteRegDWORD HKCU "${UNKEY}" "NoRepair" 1
  ${GetSize} "$PluginDir" "/S=0K" $0 $1 $2
  IntFmt $0 "0x%08X" $0
  WriteRegDWORD HKCU "${UNKEY}" "EstimatedSize" "$0"
SectionEnd

Function un.onInit
  ; Remove what the installer recorded; fall back to the default location.
  ReadRegStr $PluginDir HKCU "${UNKEY}" "PluginDir"
  ReadRegStr $CommandFile HKCU "${UNKEY}" "CommandFile"
  ${If} $PluginDir == ""
  ${OrIf} $CommandFile == ""
    Call un.ResolvePaths
  ${EndIf}
FunctionEnd

Section "Uninstall"
  ${If} ${FileExists} "$PluginDir\*.*"
    Call un.IsOurPlugin
    ${If} $0 == "1"
      RMDir /r "$PluginDir"
    ${Else}
      DetailPrint "$(TXT_UN_FOREIGN) $PluginDir"
    ${EndIf}
  ${EndIf}
  Delete "$CommandFile"
  Delete "$INSTDIR\Uninstall.exe"
  RMDir "$INSTDIR"
  DeleteRegKey HKCU "${UNKEY}"
SectionEnd
