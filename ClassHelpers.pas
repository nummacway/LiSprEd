unit ClassHelpers;

interface

uses
  StdCtrls, Classes;

type
  TEditHelper = class helper for TCustomEdit
    private
      procedure SetTextNoChange(const Value: string);
    public
      property TextNoChange: string write SetTextNoChange;
  end;

  TCheckBoxHelper = class helper for TCheckBox
    private
      procedure SetCheckedNoClick(const Value: Boolean);
    public
      property CheckedNoClick: Boolean write SetCheckedNoClick;
  end;

  TRadioButtonHelper = class helper for TRadioButton
    private
      procedure SetCheckedNoClick(const Value: Boolean);
    public
      property CheckedNoClick: Boolean write SetCheckedNoClick;
  end;

implementation

{ TEditHelper }

procedure TEditHelper.SetTextNoChange(const Value: string);
var
  Temp: TNotifyEvent;
begin
  Temp := OnChange;
  OnChange := nil;
  Text := Value;
  OnChange := Temp;
end;

{ TCheckBoxHelper }

procedure TCheckBoxHelper.SetCheckedNoClick(const Value: Boolean);
var
  Temp: TNotifyEvent;
begin
  Temp := OnClick;
  OnClick := nil;
  Checked := Value;
  OnClick := Temp;
end;

{ TRadioBUttonHelper }

procedure TRadioButtonHelper.SetCheckedNoClick(const Value: Boolean);
var
  Temp: TNotifyEvent;
begin
  Temp := OnClick;
  OnClick := nil;
  Checked := Value;
  OnClick := Temp;
end;

end.
