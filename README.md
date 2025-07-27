# Exchanging By Delphi
Comparing Delphi project with GO
## ⚡️ Unit
```delphi
// Delphi
unit uMain;
```
```go
// GO
package main 
```
## ⚡️ Uses
```delphi
// Delphi
uses
System.JSON,
  REST.Types,
  REST.Client;
```
```go
// GO
import ( 
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"strconv"
)
```
## ⚡️ Record
```delphi
// Delphi
type
  TCurrencyResponse = record
    Name: String;
    Bid : Double;
  end;
```
```go
// GO
type CurrencyResponse struct { 
	USDBRL struct {
		Name string `json:"name"`
		Bid  string `json:"bid"`
	} `json:"USDBRL"`
}
```
## ⚡️ Procedure
```delphi
// Delphi
procedure TfrmMain.ConverterMoeda;
var
  json: TJSONObject;
  fromCurrency, toCurrency, url: string;
  CurrencyResponse: TCurrencyResponse;
begin
  fromCurrency := cbFrom.Text;
  toCurrency   := cbTo.Text;

  url := Format('https://economia.awesomeapi.com.br/last/%s-%s', [fromCurrency, toCurrency]);

  RESTClient.BaseURL := url;
  RESTRequest.Execute;

  json := TJSONObject.ParseJSONValue(RESTResponse.Content) as TJSONObject;
  try
    CurrencyResponse.Bid := StrToFloat(StringReplace(json.GetValue<string>(fromCurrency + toCurrency + '.bid'), '.', ',', [rfReplaceAll]));
    lblResult.Caption    := Format('%.2f', [StrToFloat(edtValue.Text) * CurrencyResponse.Bid]);
  finally
    json.Free;
  end;
```
```go
// GO
func main() { 
	from := "USD"
	to 	 := "BRL"
	url  := fmt.Sprintf("https://economia.awesomeapi.com.br/last/%s-%s", from, to)

	resp, err := http.Get(url)
	if err != nil {
		panic(err) 
	}
	defer resp.Body.Close() 

	body, err := ioutil.ReadAll(resp.Body) 
	if err != nil {
		panic(err)
	}

	var result CurrencyResponse
	err = json.Unmarshal(body, &result) 
	if err != nil {
		panic(err)
	}

	fmt.Println("Moeda:", result.USDBRL.Name)
	fmt.Println("Valor da cotação:", result.USDBRL.Bid) 
	
	bid, err := strconv.ParseFloat(result.USDBRL.Bid, 64)
	if err != nil {
		fmt.Println("Erro ao converter Bid:", err)
		return
	}
	
	var valorBase float64
	fmt.Print("Digite o valor em dólar: ")  
	fmt.Scanln(&valorBase)                  

	novoValor := bid * valorBase
	fmt.Printf("Valor em reais: R$ %.4f\n", novoValor)

}
```
See Go project in https://github.com/amancio10/ExchangingByGO
