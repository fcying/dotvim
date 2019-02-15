@echo off

rem fork from https://github.com/Maximus5/ConEmu/blob/daily/Release/ConEmu/GitShowBranch.cmd

rem *** Usage ***
rem call 'GitShowBranch /i' for prompt initialization
rem you may change ConEmuGitPath variable, if git.exe/git.cmd is not in your %PATH%

rem Predefined dir where git binaries are stored

rem ConEmuGitPath must contain quoted path, if it has spaces for instance

rem set ConEmuPrompt1=$E[m$E[32m$E]9;8;"USERNAME"$E\@$E]9;8;"COMPUTERNAME"$E\$S$E[92m$P$E[90m$_$E[90m$$$E[m$S$E]9;12$E\
if NOT exist "%ConEmuPrompt1%" (
  set ConEmuPrompt1=$E[92m$P$E[m
)
if NOT exist "%ConEmuPrompt2%" (
  set ConEmuPrompt2=$E[32m$$$E[m$S
)
if NOT exist "%GIT_HIDE_DIRTY%" (
  set GIT_HIDE_DIRTY=false
)

if /I "%~1" == "/i" (
  call where git 1>nul 2>nul
  if errorlevel 1 (
    call echo GIT not found, add git path to your environment
    goto :EOF
  )
  PROMPT %ConEmuPrompt1%$E]9;7;"cmd -cur_console:R /c%~nx0"$e\$E]9;8;"gitbranch"$e\%ConEmuPrompt2%
  goto :EOF
) else if /I "%~1" == "/u" (
  PROMPT %ConEmuPrompt1%%ConEmuPrompt2%
  goto :EOF
)


if /I "%~1" == "/?" goto help
if /I "%~1" == "-?" goto help
if /I "%~1" == "-h" goto help
if /I "%~1" == "--help" goto help


goto run


:help
setlocal
call "%~dp0SetEscChar.cmd"
if "%ConEmuANSI%"=="ON" (
  set white=%ESC%[1;37;40m
  set red=%ESC%[1;31;40m
  set normal=%ESC%[0m
) else (
  set white=
  set red=
  set normal=
)
echo %white%%~nx0 description%normal%
echo You may see your current git branch in %white%cmd prompt%normal%
echo Just run `%red%%~nx0 /i%normal%` to setup it in the current cmd instance
echo And you will see smth like `%white%T:\ConEmu [daily +0 ~7 -0]^>%normal%`
echo If you see double `%red%^>^>%normal%` unset your `%white%FARHOME%normal%` env.variable
echo You may use it in %white%Far Manager%normal%,
echo set your Far %white%prompt%normal% to `%red%$p%%gitbranch%%%normal%` and call `%red%%~nx0%normal%`
echo after each command which can change your working directory state
echo Example: "%~dp0Addons\git.cmd"
goto :EOF


:run
rem let gitlogpath be folder to store git output
if "%TEMP:~-1%" == "\" (set "gitlogpath=%TEMP:~0,-1%") else (set "gitlogpath=%TEMP%")
set git_out=%gitlogpath%\conemu_git_%ConEmuServerPID%_1.log
set git_err=%gitlogpath%\conemu_git_%ConEmuServerPID%_2.log

rem Just to ensure that non-oem characters will not litter the prompt
set "ConEmu_SaveLang=%LANG%"
set LANG=en_US

rem Due to a bug(?) of cmd.exe we can't quote ConEmuGitPath variable
rem otherwise if it contains only unquoted "git" and matches "git.cmd" for example
rem the "%~dp0" macros in that cmd will return a crap.

call git rev-parse --abbrev-ref --short HEAD 1>"%git_out%" 2>"%git_err%"
if errorlevel 1 (
  rem  not a git repository
  set "LANG=%ConEmu_SaveLang%"
  set ConEmu_SaveLang=
  set gitbranch=
  goto prepare
)

rem check if use commitid
set /P gitbranch=<"%git_out%"
if "%gitbranch%" == "HEAD" (
  call git rev-parse --short HEAD 1>"%git_out%" 2>"%git_err%"
)

set "LANG=%ConEmu_SaveLang%"
set ConEmu_SaveLang=

rem Set "gitbranch" to full contents of %git_out% file
set /P gitbranch=<"%git_out%"
set "gitbranch= [%gitbranch%]"

:prepare
del "%git_out%">nul
del "%git_err%">nul

:export
rem Export to parent Far Manager or cmd.exe processes
"%ConEmuBaseDir%\ConEmuC.exe" /silent /export=CON gitbranch
