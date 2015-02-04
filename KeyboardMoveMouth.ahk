mm=0
MMove=0
;無変換+Space＝マウス操作モード
sc07B & Space::
  if(mm)
    mm=0
  Else
    mm=1
  ;MMoveに初期値を設定
  if(!MMove){
    MMove=10
  }
  return


#If (mm)

;マウスモードOFF
ESC::mm=0

;マウス移動
;下
j::MouseM(0, MMove)
;上
k::MouseM(0, MMove-(MMove*2))
;左
h::MouseM(MMove-(MMove*2), 0)
;右
l::MouseM(MMove, 0)
;左上
u::MouseM(MMove-(MMove*2), MMove-(MMove*2))
;右上
i::MouseM(MMove, MMove-(MMove*2))
;左下
n::MouseM(MMove-(MMove*2), MMove)
;右下
m::MouseM(MMove, MMove)

;クリック&ドラッグドロップ
;*a::ShiftCtrlAltKey("LButton", "a")
;s::MouseClick, middle
;*d::ShiftCtrlAltKey("RButton", "d")

;*u::ShiftCtrlAltKey("RButton", "u")
;i::MouseClick, middle
;*o::ShiftCtrlAltKey("RButton", "o")

;;クリック
g::ShiftCtrlAltKey("LButton", "g")
;;ダブルクリック
d::
  Send,{LButton 2}
return
;;ドロップ＆ドラッグ
t::
  Send,{Shift Down}{LButton Down}
  KeyWait,t
  Send,{Shift Up}{LButton Up}
return
;;右クリック
o::ShiftCtrlAltKey("RButton", "o")

;;マウスクリック
p::MouseClick, middle

;マウスホイール
f::MouseClick, WheelUp, , , 5
v::MouseClick, WheelDown, , , 5
;n::MouseClick, WheelUp, , , 5
;m::MouseClick, WheelDown, , , 5

ShiftCtrlAltKey(keyName, stopkey){
  modifier:=""
  GetKeyState, state, Ctrl
  if(state="D") {
    modifier:="Ctrl"
  }
  GetKeyState, state, Alt
  if(state="D") {
    modifier:="Alt"
  }
  GetKeyState, state, Shift
  if(state="D") {
    modifier:="Shift"
  }
    ;キーを押している間マウスキーをダウン状態にする
  if(modifier="") {
    Send,{%KeyName% Down}
    KeyWait,%stopkey%
    Send,{%keyName% Up}
  } else {
  ;マウスキーとShift,Ctrl,Altキーを同時押しをする
    Send, {%modifier% Down}{%keyName% Down}
    KeyWait,%stopkey%
    Send, {%modifier% Up}{%keyName% Up}
  }
 return
}

;マウスカーソルの移動量変更
1::
  MMove:=10
  Mouse_OSD(round(MMove), 2000)
return
2::
  MMove:=40
  Mouse_OSD(round(MMove), 2000)
return
3::
  MMove:=80
  Mouse_OSD(round(MMove), 2000)
return
4::
  MMove:=120
  Mouse_OSD(round(MMove), 2000)
return
5::
  MMove:=160
  Mouse_OSD(round(MMove), 2000)
return
6::
  MMove:=200
  Mouse_OSD(round(MMove), 2000)
return
7::
  MMove:=240
  Mouse_OSD(round(MMove), 2000)
return
8::
  MMove:=280
  Mouse_OSD(round(MMove), 2000)
return
9::
  MMove:=320
  Mouse_OSD(round(MMove), 2000)
return
0::
  MMove:=1
  Mouse_OSD(round(MMove), 2000)
return

#If

;マウスをx,y間隔で移動
MouseM(x, y) {
  MouseGetPos, xpos, ypos
  MouseMove, xpos+x, ypos+y, 0
}

;アクティブウィンドウ内を格子状に区切って
;点間移動する
WinMouseM(x,y){
  b:=""
  r:=""
  WinGetPos,,, w, h, A
  b:=(h/3)*x
  r:=(w/4)*y
  CoordMode, Mouse, Relative
  MouseMove, r, b, 0
}

;マウス移動量を表示
;Max変数を追加する 2011/5/6
Mouse_OSD(value, dur, pos="BC", fc="Red", fs1=28, fs2=36){
  global Progress1
  static _fs1,_fs2,_fc,_pos, zh:=30

  if(pos != _pos || fc != _fc || f1 != _f1 || f2 != _f2)
    Progress1 := false
  if (!Progress1) {
    opt:=InStr(pos, "X") ? "C00" : "C10"
    w := Round(A_ScreenWidth / 2)
    h := fs2 + zh + 40
    x := InStr(pos, "L") ? 0 : InStr(pos, "R") ? (A_ScreenWidth - w) : Round((A_ScreenWidth - w) / 2)
    y := (InStr(pos, "B")) ? A_ScreenHeight - (h + 30) : 10
    Progress, 1:Hide b Range0-320 x%x% y%y% w%w% h%h% CW000001 CT%fc% CB%fc% ZH%zh% ZW0 ZX30 ZYO FS%fs2% WM1000 WS600 %opt%
    Progress1:=true
  }
  progress, 1:%value%, %value%
  progress, 1:Show
  _fc:=fc,_fs2:=fs2,_fs1:=fs1,_pos:=pos
  SetTimer, MouseOSD_Off, %dur%
  return
  MouseOSD_Off:
    Progress1:=false
    progress, off
    return

}
