unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.JSON, REST.Types,
  Data.Bind.Components, Data.Bind.ObjectScope, REST.Client,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls;

type
  TfrmMain = class(TForm)
    RESTClient: TRESTClient;
    RESTRequest: TRESTRequest;
    RESTResponse: TRESTResponse;
    Image: TImage;
    lblFrom: TLabel;
    lblValue: TLabel;
    cbFrom: TComboBox;
    cbTo: TComboBox;
    edtValue: TEdit;
    btnConvert: TButton;
    lblResult: TLabel;
    lblTo: TLabel;
    procedure btnConvertClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtValueKeyPress(Sender: TObject; var Key: Char);
  private
    procedure ConverterMoeda;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.btnConvertClick(Sender: TObject);
begin
  ConverterMoeda;
end;

procedure TfrmMain.ConverterMoeda;
var
  json: TJSONObject;
  rate: Double;
  fromCurrency, toCurrency, url: string;
begin
  if edtValue.Text = '' then
  begin
    ShowMessage('Enter a value to continue');
    edtValue.SetFocus;
    Exit;
  end;

  if cbFrom.Text = cbTo.Text then
  begin
   lblResult.Caption := Format('%.2f', [StrToFloat(edtValue.Text)]);
   Exit;
  end;

  fromCurrency := cbFrom.Text;
  toCurrency   := cbTo.Text;

  url := Format('https://economia.awesomeapi.com.br/last/%s-%s', [fromCurrency, toCurrency]);

  RESTClient.BaseURL := url;
  RESTRequest.Execute;

  json := TJSONObject.ParseJSONValue(RESTResponse.Content) as TJSONObject;
  try
    rate := StrToFloat(StringReplace(json.GetValue<string>(fromCurrency + toCurrency + '.bid'), '.', ',', [rfReplaceAll]));
    lblResult.Caption := Format('%.2f', [StrToFloat(edtValue.Text) * rate]);
  finally
    json.Free;
  end;
end;

procedure TfrmMain.edtValueKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9', ',', #8, #13]) then
    Key := #0;

  if key = #13 then
  begin
    Key := #0;
    ConverterMoeda;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  cbFrom.Items.AddStrings([
    'BRL', // Real Brasileiro
    'USD', // Dólar Americano
    'EUR', // Euro
    'ARS', // Peso Argentino
    'BTC', // Bitcoin
    'ETH', // Ethereum
    'GBP', // Libra Esterlina
    'JPY', // Iene Japonês
    'CAD', // Dólar Canadense
    'AUD', // Dólar Australiano
    'CHF', // Franco Suíço
    'CNY', // Yuan Chinês
    'USDT' // Tether (cripto)
  ]);
  cbTo.Items.AddStrings(cbFrom.Items);
  cbFrom.Text := 'USD';
  cbTo.Text   := 'BRL';
end;

end.
