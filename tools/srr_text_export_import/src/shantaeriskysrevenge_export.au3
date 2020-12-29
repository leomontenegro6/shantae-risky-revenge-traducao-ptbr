$Path = FileOpenDialog("Select the LOCTEXT/LTB file", @ScriptDir, "loctext/ltb files (*.loctext;*.ltb)",1)
If @error = 1 Then Exit
$File = fileopen($Path,16)
$Name = CompGetFileName($Path)
$Ext = CompGetFileExt($Path)
Dim $Text
If $Ext = ".loctext" Then
	FileSetPos($File,28,0)
	FileSetPos($File,FileRead($File,4),0)
	$pos = FileGetPos($File)
	$End = FileRead($File,4)
	Do
		FileSetPos($File,$pos,0)
		$Offset = FileRead($File,4)
		$pos = FileGetPos($File)
		FileSetPos($File,$Offset,0)
		$S = ""
		$Str = ""
		Do
			$Str &= $S
			$S = FileRead($File, 1)
		Until $S = 0
		$Str = BinaryToString("0x" & StringRegExpReplace($Str,"0x",""),1)
		$Str = StringRegExpReplace($Str,@CRLF,"<cf>")
		$Str = StringRegExpReplace($Str,@LF,"<lf>")
		$Str = StringRegExpReplace($Str,@CR,"<cr>")
		$Text &= $Str & @CRLF
	Until $pos = $End
ElseIf $Ext = ".ltb" Then
	FileSetPos($File,8,0)
	$Files = FileRead($File,4)
	FileSetPos($File,16,0)
	FileSetPos($File,FileRead($File,4),0)
	For $i = 1 to $Files
		$Offset = FileRead($File,4)
		FileRead($File,4)
		$pos = FileGetPos($File)
		FileSetPos($File,$Offset,0)
		$S = ""
		$Str = ""
		Do
			$Str &= $S
			$S = FileRead($File, 1)
		Until $S = 0
		$Str = BinaryToString("0x" & StringRegExpReplace($Str,"0x",""),1)
		$Str = StringRegExpReplace($Str,@CRLF,"<cf>")
		$Str = StringRegExpReplace($Str,@LF,"<lf>")
		$Str = StringRegExpReplace($Str,@CR,"<cr>")
		$Text &= $Str & @CRLF
		FileSetPos($File,$pos,0)
	Next
EndIf
$hFile = FileOpen ($Name&".txt", 2+512)
FileWrite ($hFile, $Text)
FileClose ($hFile)
TrayTip ("Exporter", "Finish!", 3)
sleep (3000)
Func CompGetFileName($Path)
If StringLen($Path) < 4 Then Return -1
$ret = StringSplit($Path,"\",2)
If IsArray($ret) Then
Return $ret[UBound($ret)-1]
EndIf
If @error Then Return -1
EndFunc
Func CompGetFileExt($Path,$Dot=True)
If StringLen($Path) < 4 Then Return -1
$ret = StringSplit($Path,"\",2)
If IsArray($ret) Then
$ret = StringSplit($ret[UBound($ret)-1],".",2)
If IsArray($ret) Then
If $Dot Then
$Dot = "."
Else
$Dot = ""
EndIf
Return $Dot & $ret[UBound($ret)-1]
EndIf
EndIf
If @error Then Return -1
EndFunc