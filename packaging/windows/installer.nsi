; SMard Agent Flow - harness-agnostic Windows installer (NSIS 3, Unicode).
; Built by packaging/build.ps1, which passes VERSION, SRCROOT, FILELIST, LICENSEFILE and OUTFILE.
; Per user, no administrator rights. Setup extracts the package into $INSTDIR and then calls
; packaging\install-harness.ps1 once per harness selected on the components page (detected
; harnesses come preselected; Claude Code is always offered). The same contract as
; plugin\install.ps1: copy, verify, never remove what is not ours, back up what differs.

Unicode true
!ifdef AMD64
  Target amd64-unicode
!endif

!include "MUI2.nsh"
!include "LogicLib.nsh"
!include "FileFunc.nsh"
; nsExec is unavailable in this machine's NSIS include set, so the installer uses the
; built-in ExecWait with a hidden window; each harness step appends to install.log.

!define PRODUCT "SMard Agent Flow"
!define UNKEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\SMardAgentFlow"

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

!define MUI_ABORTWARNING
!define MUI_WELCOMEPAGE_TEXT "$(TXT_WELCOME)"
!define MUI_FINISHPAGE_TEXT "$(TXT_FINISH)"
!define MUI_COMPONENTSPAGE_TEXT_TOP "$(TXT_COMPONENTS)"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "${LICENSEFILE}"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "PortugueseBR"

LangString TXT_WELCOME ${LANG_ENGLISH} "Setup installs ${PRODUCT} ${VERSION} on this computer.$\r$\n$\r$\nIt was created in Claude Code and today runs in coding harnesses of twelve vendors. On the next screen, choose the harnesses you use: Setup installs the plugin into each one you select. Harnesses found on this computer are already ticked.$\r$\n$\r$\nYou do not need an administrator password. Setup only copies files into your own settings folders."
LangString TXT_WELCOME ${LANG_PORTUGUESEBR} "Este instalador instala o ${PRODUCT} ${VERSION} neste computador.$\r$\n$\r$\nEle foi criado no Claude Code e hoje opera em harnesses de doze fabricantes. Na próxima tela, escolha os harnesses que você usa: o instalador configura o plugin em cada um selecionado. Os harnesses encontrados neste computador já vêm marcados.$\r$\n$\r$\nNão é preciso senha de administrador. O instalador apenas copia arquivos para as suas próprias pastas de configuração."
LangString TXT_COMPONENTS ${LANG_ENGLISH} "Choose the harnesses to set up. Detected ones are ticked; Claude Code is always available."
LangString TXT_COMPONENTS ${LANG_PORTUGUESEBR} "Escolha os harnesses para configurar. Os detectados vêm marcados; o Claude Code está sempre disponível."
LangString TXT_FINISH ${LANG_ENGLISH} "${PRODUCT} is installed in the selected harnesses.$\r$\n$\r$\nOpen a NEW session of a harness and invoke the smard-agent-flow skill (in Claude Code: /smard-agent-flow).$\r$\n$\r$\nTo remove it later, use Installed apps in the Windows Settings."
LangString TXT_FINISH ${LANG_PORTUGUESEBR} "O ${PRODUCT} está instalado nos harnesses selecionados.$\r$\n$\r$\nAbra uma NOVA sessão de um harness e invoque a skill smard-agent-flow (no Claude Code: /smard-agent-flow).$\r$\n$\r$\nPara remover depois, use Aplicativos instalados nas Configurações do Windows."
LangString TXT_NOHARNESS ${LANG_ENGLISH} "No harness was selected. Setup changed nothing."
LangString TXT_NOHARNESS ${LANG_PORTUGUESEBR} "Nenhum harness foi selecionado. O instalador não alterou nada."
LangString TXT_PWFAILED ${LANG_ENGLISH} "Install step failed for a harness. Read the log above; nothing was published."
LangString TXT_PWFAILED ${LANG_PORTUGUESEBR} "A etapa de instalação falhou em um harness. Leia o registro acima; nada foi publicado."

; --- sections: one per harness (order must match harnesses.json) ---------------------------

Section "!Claude Code" sec_claude
SectionEnd
Section "Kimi Code" sec_kimi
SectionEnd
Section "JetBrains Junie" sec_junie
SectionEnd
Section "IBM Bob" sec_ibm
SectionEnd
Section "Hermes Agent" sec_hermes
SectionEnd
Section "Grok (xAI)" sec_grok
SectionEnd
Section "Cursor" sec_cursor
SectionEnd
Section "Windsurf" sec_windsurf
SectionEnd
Section "OpenAI Codex" sec_codex
SectionEnd
Section "Antigravity (Gemini)" sec_antigrav
SectionEnd
Section "Kilo Code" sec_kilo
SectionEnd
Section "OpenCode" sec_opencode
SectionEnd
Section "GitHub Copilot" sec_copilot
SectionEnd

; Tick a section when its marker folder exists on this machine.
!macro SelectIfExists sect folder
  ${If} ${FileExists} "${folder}\*.*"
    SectionSetFlags ${sect} ${SF_SELECTED}
  ${EndIf}
!macroend

Function .onInit
  ReadEnvStr $0 CLAUDE_CONFIG_DIR
  ${If} $0 == ""
    StrCpy $0 "$PROFILE\.claude"
  ${EndIf}
  !insertmacro SelectIfExists ${sec_claude} "$0"
  !insertmacro SelectIfExists ${sec_kimi} "$PROFILE\.agents\skills"
  !insertmacro SelectIfExists ${sec_junie} "$PROFILE\.junie"
  !insertmacro SelectIfExists ${sec_ibm} "$PROFILE\.bob"
  !insertmacro SelectIfExists ${sec_hermes} "$PROFILE\.hermes"
  !insertmacro SelectIfExists ${sec_grok} "$PROFILE\.grok"
  !insertmacro SelectIfExists ${sec_cursor} "$PROFILE\.cursor"
  !insertmacro SelectIfExists ${sec_windsurf} "$PROFILE\.windsurf"
  !insertmacro SelectIfExists ${sec_codex} "$PROFILE\.codex"
  !insertmacro SelectIfExists ${sec_antigrav} "$PROFILE\.gemini"
  !insertmacro SelectIfExists ${sec_kilo} "$PROFILE\.config\kilo"
  !insertmacro SelectIfExists ${sec_opencode} "$PROFILE\.config\opencode"
  !insertmacro SelectIfExists ${sec_copilot} "$PROFILE\.copilot"
FunctionEnd

Function RunHarnessInstaller
  ; stack on entry: section index pushed first, harness id pushed last (top)
  Pop $1  ; harness id
  Pop $0  ; section index
  SectionGetFlags $0 $2
  IntOp $2 $2 & ${SF_SELECTED}
  ${If} $2 <> ${SF_SELECTED}
    Return
  ${EndIf}
  DetailPrint "SMard Agent Flow -> $1"
  ExecWait '"$SYSDIR\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "$INSTDIR\files\packaging\install-harness.ps1" -Harness $1 -Log "$INSTDIR\install.log"' $2
  ${If} $2 <> "0"
    MessageBox MB_OK|MB_ICONSTOP "$(TXT_PWFAILED)$\r$\n$\r$\n$1" /SD IDOK
    SetErrorLevel 3
    Quit
  ${EndIf}
  ; append "$1$\r$\n" to the record file
  FileOpen $2 "$INSTDIR\installed-harnesses.txt" a
  FileSeek $2 0 END
  FileWrite $2 "$1$\r$\n"
  FileClose $2
FunctionEnd

; $0 = section index, $1 = harness id (stack: sect pushed first, id second)
!macro RunForSect sect id
  Push "${sect}"
  Push "${id}"
  Call RunHarnessInstaller
!macroend

Section "-Payload"
  ; The package: one SetOutPath and one File per file, written by build.ps1.
  !include "${FILELIST}"

  Delete "$INSTDIR\installed-harnesses.txt"
  !insertmacro RunForSect ${sec_claude} "claude-code"
  !insertmacro RunForSect ${sec_kimi} "kimi-code"
  !insertmacro RunForSect ${sec_junie} "junie"
  !insertmacro RunForSect ${sec_ibm} "ibm-bob"
  !insertmacro RunForSect ${sec_hermes} "hermes"
  !insertmacro RunForSect ${sec_grok} "grok"
  !insertmacro RunForSect ${sec_cursor} "cursor"
  !insertmacro RunForSect ${sec_windsurf} "windsurf"
  !insertmacro RunForSect ${sec_codex} "codex"
  !insertmacro RunForSect ${sec_antigrav} "antigravity"
  !insertmacro RunForSect ${sec_kilo} "kilo"
  !insertmacro RunForSect ${sec_opencode} "opencode"
  !insertmacro RunForSect ${sec_copilot} "copilot"

  ; Fail when nothing was selected.
  ClearErrors
  FileOpen $2 "$INSTDIR\installed-harnesses.txt" r
  ${If} ${Errors}
    MessageBox MB_OK|MB_ICONEXCLAMATION "$(TXT_NOHARNESS)" /SD IDOK
    SetErrorLevel 4
    Quit
  ${EndIf}
  FileRead $2 $3
  FileClose $2
  StrCpy $3 $3 1
  ${If} $3 == ""
    MessageBox MB_OK|MB_ICONEXCLAMATION "$(TXT_NOHARNESS)" /SD IDOK
    SetErrorLevel 4
    Quit
  ${EndIf}

  ; The uninstaller and the entry in Installed apps (current user only).
  WriteUninstaller "$INSTDIR\Uninstall.exe"
  WriteRegStr HKCU "${UNKEY}" "DisplayName" "${PRODUCT}"
  WriteRegStr HKCU "${UNKEY}" "DisplayVersion" "${VERSION}"
  WriteRegStr HKCU "${UNKEY}" "Publisher" "SMard Labs"
  WriteRegStr HKCU "${UNKEY}" "URLInfoAbout" "https://github.com/mardemsean/smard-agent-flow-git"
  WriteRegStr HKCU "${UNKEY}" "InstallLocation" "$INSTDIR"
  WriteRegStr HKCU "${UNKEY}" "UninstallString" '"$INSTDIR\Uninstall.exe"'
  WriteRegStr HKCU "${UNKEY}" "QuietUninstallString" '"$INSTDIR\Uninstall.exe" /S'
  WriteRegDWORD HKCU "${UNKEY}" "NoModify" 1
  WriteRegDWORD HKCU "${UNKEY}" "NoRepair" 1
  ${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
  IntFmt $0 "0x%08X" $0
  WriteRegDWORD HKCU "${UNKEY}" "EstimatedSize" "$0"
SectionEnd

Function un.UninstallOneHarness
  ; $0 = harness id (one line, already trimmed)
  ${If} $0 == ""
    Return
  ${EndIf}
  DetailPrint "Removing SMard Agent Flow -> $0"
  ExecWait '"$SYSDIR\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "$INSTDIR\files\packaging\install-harness.ps1" -Uninstall -Harness $0 -Log "$INSTDIR\install.log"' $1
FunctionEnd

Section "Uninstall"
  ClearErrors
  FileOpen $2 "$INSTDIR\installed-harnesses.txt" r
  ${IfNot} ${Errors}
    ClearErrors
    ${Do}
      FileRead $2 $0
      ${If} ${Errors}
        ${ExitDo}
      ${EndIf}
      ; strip the trailing newline characters
      ${Do}
        StrCpy $3 $0 1 -1
        ${If} $3 == "$\r"
        ${OrIf} $3 == "$\n"
          StrCpy $0 $0 -1
        ${Else}
          ${ExitDo}
        ${EndIf}
      ${Loop}
      Push $0
      Call un.UninstallOneHarness
      Pop $0
    ${Loop}
    FileClose $2
  ${EndIf}
  Delete "$INSTDIR\installed-harnesses.txt"
  Delete "$INSTDIR\Uninstall.exe"
  RMDir /r "$INSTDIR\files"
  RMDir "$INSTDIR"
  DeleteRegKey HKCU "${UNKEY}"
SectionEnd
