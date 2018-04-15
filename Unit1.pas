unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw, MsHtml;

type
  TForm1 = class(TForm)
    WebBrowser1: TWebBrowser;
    procedure FormShow(Sender: TObject);
    procedure WebBrowser1NavigateComplete2(Sender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormShow(Sender: TObject);
begin
  WebBrowser1.Navigate('https://www.facebook.com');
end;

procedure TForm1.WebBrowser1NavigateComplete2(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
var
  Doc2     : IHtmlDocument2;
  Script   : IHtmlDOMNode;
  HTMLWindow: IHTMLWindow2;
  jsloader : TStringList;
begin
  Doc2 := Webbrowser1.Document as IHtmlDocument2;
  if Assigned(Doc2.body) then
  begin
   Script := Doc2.createElement('script') as IHTMLDOMNode;
   jsloader := TStringList.Create();
   jsloader.Add('function loadScript(url, callback){');
   jsloader.Add('var script = document.createElement("script")');
   jsloader.Add('script.type = "text/javascript";');
   jsloader.Add('if (script.readyState){  //IE');
   jsloader.Add('  script.onreadystatechange = function(){');
   jsloader.Add('    if (script.readyState == "loaded" || ');
   jsloader.Add('        script.readyState == "complete"){');
   jsloader.Add('      script.onreadystatechange = null;');
   jsloader.Add('      callback();');
   jsloader.Add('    }');
   jsloader.Add('    };');
   jsloader.Add('    } else {  //Others');
   jsloader.Add('        script.onload = function(){');
   jsloader.Add('            callback();');
   jsloader.Add('        };');
   jsloader.Add('    }');
   jsloader.Add('    script.src = url;');
   jsloader.Add('    document.getElementsByTagName("head")[0].appendChild(script);');
   jsloader.Add('}');
   (Script as IHTMLScriptElement).text := jsloader.GetText();
   (Doc2.body as IHtmlDomNode).appendChild(Script);
   HTMLWindow := Doc2.parentWindow;
   if Assigned(HTMLWindow) then
    HTMLWindow.execScript('loadScript("https://code.jquery.com/jquery-2.2.4.min.js", function(){alert("jQuery version " +jQuery.fn.jquery);})', 'JavaScript')
  end;
end;

end.
