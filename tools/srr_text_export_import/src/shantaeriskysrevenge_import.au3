#include<File.au3>
#include<Binary.au3>
Dim $NEWdata, $num = 1
$TxtPath = FileOpenDialog("Select the TXT file", @ScriptDir, "text files (*.txt)",1)
If @error = 1 Then Exit
If FileGetEncoding($TxtPath) = 512 Then
	$Encoding = 1
Else
	$Encoding = 4
EndIf
If @error = 1 Then Exit
_FileReadToArray($TxtPath,$NEWdata)
$Name = StringTrimRight(CompGetFileName($TxtPath),4)
$Ext = CompGetFileExt($Name)
$File = FileOpen ($Name, 0+16)
If $File = -1 Then
MsgBox(0,"Error","Can't open "&$Name&" file.")
Exit
EndIf
$Ext = CompGetFileExt($Name)
If $Ext = ".loctext" Then
	FileSetPos($File,28,0)
	FileSetPos($File,FileRead($File,4),0)
	$pos = FileGetPos($File)
	$End = _BinaryToInt32(FileRead($File,4))
	$Offset = $End
	FileSetPos($File,0,0)
	$Newfile = FileRead($File,$Offset)
	Do
		$NEWdata[$num] = StringRegExpReplace($NEWdata[$num],"<cf>",@CRLF)
		$NEWdata[$num] = StringRegExpReplace($NEWdata[$num],"<lf>",@LF)
		$NEWdata[$num] = StringRegExpReplace($NEWdata[$num],"<cr>",@CR)
		$NewText = StringToBinary($NEWdata[$num],$Encoding) & Binary("0x00")
		$Newfile &= $NewText
		$Newfile = _BinaryPoke($Newfile,$pos+1,$Offset,"dword")
		$Offset += BinaryLen($NewText)
		$pos += 4
		$num += 1
	Until $pos = $End
	$Newfile = _BinaryPoke($Newfile,33,BinaryLen($Newfile),"dword")
ElseIf $Ext = ".ltb" Then
	FileSetPos($File,8,0)
	$Files = FileRead($File,4)
	FileSetPos($File,16,0)
	$pos = _BinaryToInt32(FileRead($File,4))
	FileSetPos($File,$pos,0)
	$Offset = _BinaryToInt32(FileRead($File,4))
	FileSetPos($File,24,0)
	$Files2 = FileRead($File,4)
	FileRead($File,4)
	$pos2 = _BinaryToInt32(FileRead($File,4))
	FileSetPos($File,40,0)
	$Files3 = FileRead($File,4)
	FileRead($File,4)
	$pos3 = _BinaryToInt32(FileRead($File,4))
	$Size = $pos2 - $pos
	FileSetPos($File,0,0)
	$Newfile = FileRead($File,$Offset)
	For $i = 1 to $Files
		$NEWdata[$num] = StringRegExpReplace($NEWdata[$num],"<cf>",@CRLF)
		$NEWdata[$num] = StringRegExpReplace($NEWdata[$num],"<lf>",@LF)
		$NEWdata[$num] = StringRegExpReplace($NEWdata[$num],"<cr>",@CR)
		$NewText = StringToBinary($NEWdata[$num],$Encoding) & Binary("0x00")
		$pad = 8 - Mod(BinaryLen($NewText),8)
		If $pad > 0 and $pad < 8 Then $Newtext &= _BinaryRandom($Pad,0,0)
		$Newfile &= $NewText
		$Newfile = _BinaryPoke($Newfile,$pos+1,$Offset,"dword")
		$Offset += BinaryLen($NewText)
		$pos += 8
		$num += 1
	Next
	$Newsize = $Offset-64
	$pad = 128 - Mod($Newsize,128)
	If $pad > 0 and $pad < 128 Then
		$Newfile &= _BinaryRandom($Pad,0,0)
		$Newsize += $pad
	EndIf
	FileSetPos($File,$pos2,0)
	$Newfile &= FileRead($File)
	$Diff = $Newsize - $Size
	If $Diff <> 0 Then
		$Newfile = _BinaryPoke($Newfile,33,$pos2+$Diff,"dword")
		FileSetPos($File,$pos2,0)
		For $i = 1 to $Files2
			$Val = _BinaryToInt32(FileRead($File,4)) + $Diff
			$Newfile = _BinaryPoke($Newfile,$pos2+$Diff+1,$Val,"dword")
			$pos2 += 4
		Next
		$Newfile = _BinaryPoke($Newfile,49,$pos3+$Diff,"dword")
		FileSetPos($File,$pos3,0)
		For $i = 1 to $Files3
			$Val = _BinaryToInt32(FileRead($File,4)) + $Diff
			$Newfile = _BinaryPoke($Newfile,$pos3+$Diff+1,$Val,"dword")
			$pos3 += 4
		Next
	EndIf
EndIf
$hNewfile = FileOpen("NEW_"&$Name, 2+16)
FileWrite($hNewfile, $Newfile)
FileClose($hNewfile)
TrayTip("Importer", "Finish!", 3)
sleep(3000)
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