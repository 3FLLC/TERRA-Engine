Unit TERRA_UILabel;

{$I terra.inc}

Interface
Uses TERRA_String, TERRA_UI, TERRA_UISkin, TERRA_Vector2D, TERRA_Color, TERRA_Font, TERRA_UICaption;

Type
  UILabel = Class(UICaption)
    Protected
      _Width:Single;
      _Height:Single;

    Public
      OnReveal:WidgetEventHandler;

      Constructor Create(Name:TERRAString; Parent:Widget; X,Y,Z:Single; Caption:TERRAString; TabIndex:Integer=-1);

      Procedure Render; Override;
      Procedure UpdateRects; Override;
  End;


Implementation
Uses TERRA_OS;

Constructor UILabel.Create(Name:TERRAString; Parent:Widget; X,Y,Z:Single; Caption:TERRAString; TabIndex:Integer);
Begin
  Inherited Create(Name, Parent, '');

  Self._TabIndex := TabIndex;

  Self.SetRelativePosition(VectorCreate2D(X,Y));
  Self._Layer := Z;
  Self._Width := 0;
  Self._Height := 0;

  Self.SetCaption(Caption);
  _NeedsUpdate := True;
End;

(*Function UILabel.OnMouseMove(X,Y:Integer):Boolean;
Var
  Pos:Vector2D;
  AO, OH:Boolean;
Begin
  Pos := Self.GetPosition;
  OH := _HighLight;
  AO := (Assigned(OnMouseClick));
  _HighLight := (AO) And (OnRegion(X,Y)) And (Not Self.HasTweens);
  Result := False;
  If _HighLight  Then
    Result := True;
  {$IFDEF IPHONE}
  If (_Highlight) And (Not OH) And (Not DisableSlideTouch) Then
    Self.OnMouseDown(X, Y, 99);
  {$ENDIF}
End;*)

{Procedure UILabel.Reveal(DurationPerLetter, Delay:Cardinal);
Begin
  Self._RevealTime := Delay + GetTime;

  If Not Assigned(Self.Font) Then
    Exit;

  Self._RevealDuration := Self.Font.GetLength(Caption);
  Self._RevealDuration := DurationPerLetter * Self._RevealDuration;
End;}

Procedure UILabel.UpdateRects();
Begin
  Inherited;
  _Size := _TextRect;
End;

Procedure UILabel.Render();
Var
  S:TERRAString;
  Time:Cardinal;
  Delta:Single;
  P:Vector2D;
Begin
  Self.ClearProperties();
  Self.UpdateRects;

  If (_Caption = '') Then
    Exit;

  Self.UpdateTransform();

  _Width := Self._TextRect.X;
  _Height := Self._TextRect.Y;

(*  {$IFDEF MOBILE}
  Color := Self.GetColor;
  {$ELSE}
  If (Not Assigned(OnMouseClick)) Or (_HighLight) Then
    Color := Self.GetColor
  Else
    Color := ColorGrey(200, Self.Color.A);
  {$ENDIF}*)

  If (Not DisableHighlights) Then
    Self.UpdateHighlight();

  Color := Self.GetColor;
  {Color.R := Self._Color.R;
  Color.G := Self._Color.G;
  Color.B := Self._Color.B ;}

{  If (_RevealTime = 0) Or (Self.Font = Nil) Then
    RevealCount := 9999
  Else
  Begin
    Time := GetTime;
    If (Time<_RevealTime) Then
      Delta := 0
    Else
    Begin
      Time := (Time - _RevealTime);
      Delta := Time / _RevealDuration;
      If Delta<0 Then
        Delta := 0.0;
    End;

    If (Delta>=1.0) Then
    Begin
      _RevealTime := 0;
      RevealCount := 9999;
      If Assigned(OnReveal) Then
        OnReveal(Self);
    End Else
      RevealCount := Trunc(Self.Font.GetLength(Caption) * Delta);
  End;}

  //RevealCount, {TODO}!!!

  Self.DrawText(_Caption, 0, 0, 0, _TextRect, Scale, 0, False);

  Inherited;
End;





End.